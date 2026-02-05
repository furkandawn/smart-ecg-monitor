// ═══════════════════════════════════════════════════════════
// ble_ecg.h - BLE Communication for ECG Monitor
// GATT server with LIVE, CTRL, and EVENT characteristics
// ═══════════════════════════════════════════════════════════

#ifndef BLE_ECG_H
#define BLE_ECG_H

#include <Arduino.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include "config.h"

// ───────────────────────────────────────────────────────────
// BLE ECG MANAGER
// ───────────────────────────────────────────────────────────
// Handles:
//   - BLE server initialization and advertising
//   - Connection/disconnection callbacks
//   - Command processing (START/STOP streaming)
//   - ECG data transmission
//   - BPM and signal status notifications
// ───────────────────────────────────────────────────────────

class BLEECGManager {
public:
    BLEECGManager();
    
    // Initialize BLE server and start advertising
    void init();
    
    // Check connection status
    bool isConnected() const;
    
    // Check if live streaming is active
    bool isStreaming() const;
    
    // Set streaming state (called by command callback)
    void setStreaming(bool active);
    
    // Send ECG data packet (array of int16_t samples)
    void sendECGData(int16_t* samples, uint8_t count);
    
    // Send BPM update
    void sendBPM(uint16_t bpm);
    
    // Send signal loss status (0 = OK, 1 = lost)
    void sendSignalStatus(uint8_t status);
    
    // Get transmission statistics
    uint32_t getPacketsSent() const;
    void resetPacketCounter();
    
    // Called by connection callback
    void onConnect();
    void onDisconnect();
    
    // Called by command callback
    void onCommand(uint8_t cmd);

private:
    BLEServer* pServer;
    BLECharacteristic* pLiveChar;   // ECG data stream
    BLECharacteristic* pCtrlChar;   // Commands & status
    BLECharacteristic* pEventChar;  // History data
    
    bool deviceConnected;
    bool liveStreamActive;
    uint32_t packetsTransmitted;
};

// Global BLE manager instance
extern BLEECGManager bleManager;

// ───────────────────────────────────────────────────────────
// BLE CALLBACKS (must be accessible to ESP32 BLE library)
// ───────────────────────────────────────────────────────────

class ECGServerCallbacks : public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) override;
    void onDisconnect(BLEServer* pServer) override;
};

class ECGCtrlCallbacks : public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic* pCharacteristic) override;
};

class ECGLiveCallbacks : public BLECharacteristicCallbacks {
    void onRead(BLECharacteristic* pCharacteristic) override;
};

#endif // BLE_ECG_H
