// ═══════════════════════════════════════════════════════════
// ble_ecg.cpp - BLE Communication Implementation
// ═══════════════════════════════════════════════════════════

#include "ble_ecg.h"

// Global BLE manager instance
BLEECGManager bleManager;

// ───────────────────────────────────────────────────────────
// BLE CALLBACKS IMPLEMENTATION
// ───────────────────────────────────────────────────────────

void ECGServerCallbacks::onConnect(BLEServer* pServer) {
    bleManager.onConnect();
}

void ECGServerCallbacks::onDisconnect(BLEServer* pServer) {
    bleManager.onDisconnect();
}

void ECGCtrlCallbacks::onWrite(BLECharacteristic* pCharacteristic) {
    std::string value = pCharacteristic->getValue();
    
    Serial.println("\n╔════════════════════════════════════════╗");
    Serial.println("║   CTRL COMMAND RECEIVED                ║");
    Serial.println("╚════════════════════════════════════════╝");
    Serial.printf("Bytes: %d | Data: ", value.length());
    for (size_t i = 0; i < value.length(); i++) {
        Serial.printf("0x%02X ", (uint8_t)value[i]);
    }
    Serial.println("\n");
    
    if (value.length() > 0) {
        bleManager.onCommand((uint8_t)value[0]);
    } else {
        Serial.println("[CTRL] ⚠️  Empty write received\n");
    }
}

void ECGLiveCallbacks::onRead(BLECharacteristic* pCharacteristic) {
    Serial.println("[LIVE] 📤 Characteristic read");
}

// ───────────────────────────────────────────────────────────
// BLE MANAGER IMPLEMENTATION
// ───────────────────────────────────────────────────────────

BLEECGManager::BLEECGManager()
    : pServer(nullptr),
      pLiveChar(nullptr),
      pCtrlChar(nullptr),
      pEventChar(nullptr),
      deviceConnected(false),
      liveStreamActive(false),
      packetsTransmitted(0)
{
}

void BLEECGManager::init() {
    Serial.println("[BLE] Initializing...");
    
    // Create BLE Device
    BLEDevice::init(BLE_DEVICE_NAME);
    
    // Create BLE Server
    pServer = BLEDevice::createServer();
    pServer->setCallbacks(new ECGServerCallbacks());
    
    // Create BLE Service
    BLEService* pService = pServer->createService(SERVICE_UUID);
    
    // ─────────────────────────────────────────────────────
    // LIVE Characteristic - ECG data stream (NOTIFY)
    // ─────────────────────────────────────────────────────
    pLiveChar = pService->createCharacteristic(
        LIVE_CHAR_UUID,
        BLECharacteristic::PROPERTY_READ |
        BLECharacteristic::PROPERTY_NOTIFY
    );
    pLiveChar->addDescriptor(new BLE2902());
    pLiveChar->setCallbacks(new ECGLiveCallbacks());
    
    // ─────────────────────────────────────────────────────
    // CTRL Characteristic - Commands & status (WRITE + NOTIFY)
    // ─────────────────────────────────────────────────────
    pCtrlChar = pService->createCharacteristic(
        CTRL_CHAR_UUID,
        BLECharacteristic::PROPERTY_READ |
        BLECharacteristic::PROPERTY_NOTIFY |
        BLECharacteristic::PROPERTY_WRITE
    );
    pCtrlChar->addDescriptor(new BLE2902());
    pCtrlChar->setCallbacks(new ECGCtrlCallbacks());
    
    // ─────────────────────────────────────────────────────
    // EVENT Characteristic - History data (NOTIFY)
    // ─────────────────────────────────────────────────────
    pEventChar = pService->createCharacteristic(
        EVENT_CHAR_UUID,
        BLECharacteristic::PROPERTY_READ |
        BLECharacteristic::PROPERTY_NOTIFY
    );
    pEventChar->addDescriptor(new BLE2902());
    
    // Start service
    pService->start();
    
    // Start advertising
    BLEAdvertising* pAdvertising = BLEDevice::getAdvertising();
    pAdvertising->addServiceUUID(SERVICE_UUID);
    pAdvertising->setScanResponse(true);
    BLEDevice::startAdvertising();
    
    Serial.printf("[BLE] ✅ Advertising as '%s'\n", BLE_DEVICE_NAME);
    Serial.println();
    
    // Print protocol info
    Serial.println("╔════════════════════════════════════════╗");
    Serial.println("║   BLE PROTOCOL                         ║");
    Serial.println("╚════════════════════════════════════════╝");
    Serial.println("CTRL: Write commands, notify status");
    Serial.println("  Write: 0x11=START, 0x12=STOP");
    Serial.println("  Notify: BPM, signal loss");
    Serial.println();
    Serial.println("LIVE: Notify ECG samples only");
    Serial.printf("  %d int16 samples per packet (%d bytes)\n", 
                  SAMPLES_PER_PACKET, SAMPLES_PER_PACKET * sizeof(int16_t));
    Serial.println();
    Serial.println("EVENT: Notify history data");
    Serial.println("  Bulk transfer of saved ECG data");
    Serial.println();
}

bool BLEECGManager::isConnected() const {
    return deviceConnected;
}

bool BLEECGManager::isStreaming() const {
    return liveStreamActive;
}

void BLEECGManager::setStreaming(bool active) {
    liveStreamActive = active;
}

void BLEECGManager::sendECGData(int16_t* samples, uint8_t count) {
    if (!deviceConnected || !liveStreamActive || pLiveChar == nullptr) {
        return;
    }
    
    pLiveChar->setValue((uint8_t*)samples, count * sizeof(int16_t));
    pLiveChar->notify();
    
    packetsTransmitted++;
    
    // Debug output
    if (packetsTransmitted == 1) {
        Serial.println("\n[DEBUG] First packet transmitted:");
        Serial.print("  Samples: ");
        for (int i = 0; i < count; i++) {
            Serial.printf("%d ", samples[i]);
        }
        Serial.println();
        Serial.printf("  Bytes: %d\n\n", count * sizeof(int16_t));
    }
    
    if (packetsTransmitted % 100 == 0) {
        Serial.printf("[BLE] 📊 %u packets sent | Rate: %.1f Hz\n", 
                      packetsTransmitted, 
                      (packetsTransmitted * SAMPLES_PER_PACKET) / (millis() / 1000.0f));
    }
}

void BLEECGManager::sendBPM(uint16_t bpm) {
    if (!deviceConnected || pCtrlChar == nullptr) {
        return;
    }
    
    uint8_t data[3];
    data[0] = PACKET_BPM;
    data[1] = bpm & 0xFF;
    data[2] = (bpm >> 8) & 0xFF;
    
    pCtrlChar->setValue(data, 3);
    pCtrlChar->notify();
    
    Serial.printf("[BPM] 💓 %u BPM sent to app\n", bpm);
}

void BLEECGManager::sendSignalStatus(uint8_t status) {
    if (!deviceConnected || pCtrlChar == nullptr) {
        return;
    }
    
    uint8_t data[2];
    data[0] = PACKET_SIGNAL_LOSS;
    data[1] = status;
    
    pCtrlChar->setValue(data, 2);
    pCtrlChar->notify();
    
    Serial.printf("[SIGNAL] %s\n", status ? "⚠️  LOST" : "✅ OK");
}

uint32_t BLEECGManager::getPacketsSent() const {
    return packetsTransmitted;
}

void BLEECGManager::resetPacketCounter() {
    packetsTransmitted = 0;
}

void BLEECGManager::onConnect() {
    deviceConnected = true;
    Serial.println("\n[BLE] ✅ Client connected");
    Serial.println("[BLE] 💡 Write 0x11 to CTRL to start streaming");
}

void BLEECGManager::onDisconnect() {
    deviceConnected = false;
    liveStreamActive = false;
    Serial.println("\n[BLE] ❌ Client disconnected");
    BLEDevice::startAdvertising();
    Serial.println("[BLE] 📡 Advertising restarted");
}

void BLEECGManager::onCommand(uint8_t cmd) {
    switch (cmd) {
        case CMD_START_LIVE:
            liveStreamActive = true;
            packetsTransmitted = 0;
            Serial.println("[CTRL] ▶️  Live stream STARTED");
            Serial.println("[CTRL] 🫀 BPM detection active\n");
            break;
            
        case CMD_STOP_LIVE:
            liveStreamActive = false;
            Serial.println("[CTRL] ⏸️  Live stream STOPPED");
            Serial.printf("[CTRL] Packets sent: %u\n\n", packetsTransmitted);
            break;
            
        default:
            Serial.printf("[CTRL] ⚠️  Unknown command: 0x%02X\n", cmd);
            Serial.println("[CTRL] 💡 Expected: 0x11=START, 0x12=STOP\n");
            break;
    }
}
