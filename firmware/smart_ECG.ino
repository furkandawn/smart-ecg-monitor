// ═══════════════════════════════════════════════════════════
// ECG MONITOR FIRMWARE v1.0
// ESP32 Core v2.0.14
// 
// Architecture: ADC → Ring Buffer → Signal Processing → BLE
// Features: DC Removal, R-Peak Detection, BPM Calculation
// ═══════════════════════════════════════════════════════════

#include <Arduino.h>
#include "config.h"
#include "ring_buffer.h"
#include "dc_removal.h"
#include "peak_detector.h"
#include "ble_ecg.h"
#include "ad8232.h"

// ───────────────────────────────────────────────────────────
// HARDWARE TIMER
// ───────────────────────────────────────────────────────────

hw_timer_t* adcTimer = NULL;

// ───────────────────────────────────────────────────────────
// ISR - ADC SAMPLING (Producer)
// ───────────────────────────────────────────────────────────

void IRAM_ATTR onAdcTimer() {
    uint16_t sample = analogRead(ECG_PIN);
    ecgBuffer.write(sample);
}

// ───────────────────────────────────────────────────────────
// SIGNAL PROCESSING
// ───────────────────────────────────────────────────────────

uint32_t samplesDiscarded = 0;

void processAndTransmitLiveData() {
    if (!bleManager.isConnected() || !bleManager.isStreaming()) {
        return;
    }
    
    if (ecgBuffer.available() < SAMPLES_PER_PACKET) {
        return;
    }
    
    int16_t packet[SAMPLES_PER_PACKET];
    uint32_t baseTimestamp = millis();
    const uint32_t MS_PER_SAMPLE = 1000 / SAMPLE_RATE_HZ;
    
    for (int i = 0; i < SAMPLES_PER_PACKET; i++) {
        uint16_t rawSample = ecgBuffer.read();
        int16_t cleanSample = dcRemover.process(rawSample);
        
        // Calculate timestamp for this sample
        uint32_t sampleTimestamp = baseTimestamp - ((SAMPLES_PER_PACKET - 1 - i) * MS_PER_SAMPLE);
        
        peakDetector.process(cleanSample, sampleTimestamp);
        packet[i] = cleanSample;
    }
    
    bleManager.sendECGData(packet, SAMPLES_PER_PACKET);
}

void drainBufferWhenIdle() {
    // Process samples even when not streaming (for BPM detection)
    uint32_t now = millis();
    
    while (ecgBuffer.available() > 10) {
        uint16_t rawSample = ecgBuffer.read();
        int16_t cleanSample = dcRemover.process(rawSample);
        
        // Estimate timestamp
        uint32_t estimatedTimestamp = now - ((ecgBuffer.available() * 1000) / SAMPLE_RATE_HZ);
        
        peakDetector.process(cleanSample, estimatedTimestamp);
        samplesDiscarded++;
    }
}

// ───────────────────────────────────────────────────────────
// SERIAL COMMANDS
// ───────────────────────────────────────────────────────────

void processSerialCommands() {
    if (!Serial.available()) {
        return;
    }
    
    char cmd = Serial.read();
    
    switch (cmd) {
        case 's':
        case 'S':
            bleManager.setStreaming(true);
            bleManager.resetPacketCounter();
            samplesDiscarded = 0;
            dcRemover.reset();
            peakDetector.reset();
            Serial.println("\n[CMD] Stream STARTED");
            break;
            
        case 'x':
        case 'X':
            bleManager.setStreaming(false);
            Serial.println("\n[CMD] Stream STOPPED");
            break;
            
        case '?':
            Serial.println("\n[HELP] Commands: S=Start, X=Stop, ?=Help");
            break;
            
        default:
            break;
    }
}

// ───────────────────────────────────────────────────────────
// LEADS-OFF DETECTION
// ───────────────────────────────────────────────────────────

bool lastLeadsOffState = false;

void checkLeadsOffStatus() {
    bool currentLeadsOff = ad8232.isLeadsOff();
    
    if (currentLeadsOff != lastLeadsOffState) {
        lastLeadsOffState = currentLeadsOff;
        
        if (currentLeadsOff) {
            Serial.println("\n[AD8232] ELECTRODES DISCONNECTED!");
            bleManager.sendSignalStatus(1);
            peakDetector.reset();
        } else {
            Serial.println("\n[AD8232] Electrodes connected");
            bleManager.sendSignalStatus(0);
            dcRemover.reset();
            peakDetector.reset();
        }
    }
}

// ───────────────────────────────────────────────────────────
// BPM REPORTING
// ───────────────────────────────────────────────────────────

uint16_t lastReportedBPM = 0;
bool lastSignalStatus = true;

void reportBPMUpdate() {
    uint16_t currentBPM = peakDetector.getBPM();
    bool signalLost = peakDetector.isSignalLost();
    
    if (currentBPM != lastReportedBPM && bleManager.isConnected()) {
        bleManager.sendBPM(currentBPM);
        lastReportedBPM = currentBPM;
    }
    
    if (signalLost != lastSignalStatus && bleManager.isConnected()) {
        bleManager.sendSignalStatus(signalLost ? 1 : 0);
        lastSignalStatus = signalLost;
    }
}

// ───────────────────────────────────────────────────────────
// STATUS REPORT
// ───────────────────────────────────────────────────────────

void printStatusReport() {
    uint16_t bpm = peakDetector.getBPM();
    bool signalLost = peakDetector.isSignalLost();
    bool leadsOff = ad8232.isLeadsOff();
    
    Serial.println("╔════════════════════════════════════════╗");
    Serial.println("║          SYSTEM STATUS                 ║");
    Serial.println("╚════════════════════════════════════════╝");
    Serial.printf("BLE Connected:     %s\n", bleManager.isConnected() ? "YES" : "NO");
    Serial.printf("Live streaming:    %s\n", bleManager.isStreaming() ? "ACTIVE" : "STOPPED");
    Serial.printf("Heart Rate:        %s%u BPM\n", signalLost ? "SIGNAL LOST" : bpm);
    Serial.printf("Signal Status:     %s\n", signalLost ? "LOST" : "OK");
    Serial.printf("Electrodes:        %s\n", leadsOff ? "DISCONNECTED" : "CONNECTED");
    Serial.printf("Peak Threshold:    %d (adaptive)\n", peakDetector.getThreshold());
    Serial.printf("Packets sent:      %u\n", bleManager.getPacketsSent());
    Serial.printf("Samples discarded: %u\n", samplesDiscarded);
    Serial.printf("Buffered:          %u (%.1f%% full)\n", 
                  ecgBuffer.available(), ecgBuffer.fillPercent());
    Serial.printf("Overruns:          %u (%.3f%% loss)\n", 
                  ecgBuffer.getOverrunCount(), ecgBuffer.getOverrunRate());
    Serial.printf("Free heap:         %u bytes\n", ESP.getFreeHeap());
    
    if (ecgBuffer.getOverrunCount() > 0) {
        Serial.println("\nWARNING: Buffer overruns!");
    } else {
        Serial.println("\nNo sample loss");
    }
    
    peakDetector.printDebugStats();
    
    Serial.println("────────────────────────────────────────\n");
}

// ═══════════════════════════════════════════════════════════
// SETUP
// ═══════════════════════════════════════════════════════════

void setup() {
    // ─────────────────────────────────────────────────────
    // Serial
    // ─────────────────────────────────────────────────────
    Serial.begin(DEBUG_SERIAL_BAUD);
    delay(100);
    
    Serial.println("\n\n╔════════════════════════════════════════╗");
    Serial.println("║   ECG MONITOR FIRMWARE v1.0            ║");
    Serial.println("╚════════════════════════════════════════╝\n");
    
    Serial.printf("Chip: %s Rev %d\n", ESP.getChipModel(), ESP.getChipRevision());
    Serial.printf("CPU: %d MHz\n", ESP.getCpuFreqMHz());
    Serial.printf("Free heap: %d bytes\n\n", ESP.getFreeHeap());
    
    // ─────────────────────────────────────────────────────
    // AD8232 Module
    // ─────────────────────────────────────────────────────
    ad8232.init();
    
    // ─────────────────────────────────────────────────────
    // ADC Configuration
    // ─────────────────────────────────────────────────────
    analogReadResolution(12);
    analogSetAttenuation(ADC_11db);
    
    Serial.printf("[ADC] Pin: GPIO%d\n", ECG_PIN);
    Serial.print("[ADC] Warming up");
    for (int i = 0; i < 20; i++) {
        analogRead(ECG_PIN);
        Serial.print(".");
        delay(10);
    }
    Serial.println(" done\n");
    
    // ─────────────────────────────────────────────────────
    // Ring Buffer
    // ─────────────────────────────────────────────────────
    ecgBuffer.init();
    Serial.printf("[BUFFER] Size: %d samples\n\n", BUFFER_SIZE);
    
    // ─────────────────────────────────────────────────────
    // Signal Processing
    // ─────────────────────────────────────────────────────
    Serial.println("[SIGNAL PROCESSING]");
    Serial.printf("  DC Removal: Alpha = %.3f\n", DC_REMOVAL_ALPHA);
    Serial.printf("  Peak threshold: %d-%d (adaptive)\n", PEAK_THRESHOLD_MIN, PEAK_THRESHOLD_MAX);
    Serial.printf("  Refractory period: %d ms\n", REFRACTORY_PERIOD_MS);
    Serial.printf("  BPM smoothing: EMA alpha = %.2f\n", EMA_ALPHA);
    Serial.printf("  RR buffer size: %d intervals\n", RR_BUFFER_SIZE);
    Serial.println();
    
    // ─────────────────────────────────────────────────────
    // BLE
    // ─────────────────────────────────────────────────────
    bleManager.init();
    
    // ─────────────────────────────────────────────────────
    // Hardware Timer for ADC Sampling
    // ─────────────────────────────────────────────────────
    adcTimer = timerBegin(1, 80, true);  // Timer 1, prescaler 80 (1 MHz)
    timerAttachInterrupt(adcTimer, &onAdcTimer, true);
    timerAlarmWrite(adcTimer, 1000000 / SAMPLE_RATE_HZ, true);  // Auto-reload
    timerAlarmEnable(adcTimer);
    
    Serial.printf("[TIMER] Sampling at %d Hz\n\n", SAMPLE_RATE_HZ);
    
    // ─────────────────────────────────────────────────────
    // Serial Commands Help
    // ─────────────────────────────────────────────────────
    Serial.println("╔════════════════════════════════════════╗");
    Serial.println("║   SERIAL COMMANDS                      ║");
    Serial.println("╚════════════════════════════════════════╝");
    Serial.println("  S - Start streaming");
    Serial.println("  X - Stop streaming");
    Serial.println("  ? - Help");
    Serial.println();
    
    Serial.println("─────────────────────────────────────────");
    Serial.println("System ready! Waiting for connection...");
    Serial.println("─────────────────────────────────────────\n");
}

// ═══════════════════════════════════════════════════════════
// MAIN LOOP
// ═══════════════════════════════════════════════════════════

void loop() {
    static uint32_t lastStatusReport = 0;
    static uint32_t lastBPMUpdate = 0;
    static uint32_t lastLeadsCheck = 0;
    
    uint32_t now = millis();
    
    // ───────────────────────────────────────────────────
    // Process Serial Commands
    // ───────────────────────────────────────────────────
    processSerialCommands();
    
    // ───────────────────────────────────────────────────
    // Check Electrode Connection (every 100ms)
    // ───────────────────────────────────────────────────
    if (now - lastLeadsCheck >= LEADS_CHECK_INTERVAL_MS) {
        checkLeadsOffStatus();
        lastLeadsCheck = now;
    }
    
    // ───────────────────────────────────────────────────
    // Process ECG Data
    // ───────────────────────────────────────────────────
    if (bleManager.isStreaming() && bleManager.isConnected()) {
        processAndTransmitLiveData();
    } else {
        drainBufferWhenIdle();
    }
    
    // ───────────────────────────────────────────────────
    // BPM Update (every 1 second)
    // ───────────────────────────────────────────────────
    if (now - lastBPMUpdate >= BPM_UPDATE_INTERVAL_MS) {
        reportBPMUpdate();
        lastBPMUpdate = now;
    }
    
    // ───────────────────────────────────────────────────
    // Status Report (every 5 seconds)
    // ───────────────────────────────────────────────────
    if (now - lastStatusReport >= STATUS_REPORT_INTERVAL_MS) {
        printStatusReport();
        lastStatusReport = now;
    }
    
    delay(1);
}
