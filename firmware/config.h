// ═══════════════════════════════════════════════════════════
// config.h - ECG Monitor Configuration
// All hardware pins, timing constants, and tunable parameters
// ═══════════════════════════════════════════════════════════

#ifndef CONFIG_H
#define CONFIG_H

// ───────────────────────────────────────────────────────────
// HARDWARE PINS
// ───────────────────────────────────────────────────────────

#define ECG_PIN         32      // AD8232 OUTPUT → ESP32 ADC

// AD8232 Control Pins
#define LO_PLUS_PIN     25      // Lead-off detection (positive)
#define LO_MINUS_PIN    26      // Lead-off detection (negative)
#define SDN_PIN         27      // Shutdown control (LOW = enabled)

// ───────────────────────────────────────────────────────────
// SAMPLING CONFIGURATION
// ───────────────────────────────────────────────────────────

#define SAMPLE_RATE_HZ      500     // ADC sampling frequency
#define BUFFER_SIZE         1024    // Ring buffer size (must be power of 2)
#define BUFFER_MASK         (BUFFER_SIZE - 1)
#define SAMPLES_PER_PACKET  20      // Samples per BLE packet

// ───────────────────────────────────────────────────────────
// SIGNAL PROCESSING PARAMETERS
// ───────────────────────────────────────────────────────────

// DC Removal (High-pass filter)
#define DC_REMOVAL_ALPHA    0.995f  // HPF at ~0.16 Hz (higher = lower cutoff)

// Peak Detection
#define PEAK_THRESHOLD_INIT     100     // Initial threshold (adaptive)
#define PEAK_THRESHOLD_MIN      50      // Minimum allowed threshold
#define PEAK_THRESHOLD_MAX      500     // Maximum allowed threshold
#define PEAK_THRESHOLD_RATIO    0.5f    // Threshold = max_derivative * ratio

// R-R Interval Validation
#define REFRACTORY_PERIOD_MS    200     // Min time between beats (300 BPM max)
#define RR_INTERVAL_MIN_MS      200     // Minimum valid RR (300 BPM)
#define RR_INTERVAL_MAX_MS      2000    // Maximum valid RR (30 BPM)

// BPM Smoothing
#define RR_BUFFER_SIZE          8       // Number of RR intervals for averaging
#define EMA_ALPHA               0.25f   // Exponential moving average factor

// Signal Quality
#define SIGNAL_LOSS_THRESHOLD_MS 5000   // No peak for 5s = signal lost

// ───────────────────────────────────────────────────────────
// TIMING INTERVALS
// ───────────────────────────────────────────────────────────

#define BPM_UPDATE_INTERVAL_MS      1000    // Send BPM to app every 1s
#define STATUS_REPORT_INTERVAL_MS   5000    // Serial status every 5s
#define LEADS_CHECK_INTERVAL_MS     100     // Check electrode connection

// ───────────────────────────────────────────────────────────
// BLE CONFIGURATION
// ───────────────────────────────────────────────────────────

#define BLE_DEVICE_NAME     "ECG_Monitor"

// Service UUID
#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"

// Characteristic UUIDs
#define LIVE_CHAR_UUID      "beb5483e-36e1-4688-b7f5-ea07361b26a8"  // ECG data stream
#define CTRL_CHAR_UUID      "87654321-4321-4321-4321-210987654321"  // Commands & status
#define EVENT_CHAR_UUID     "12345678-1234-1234-1234-1234567890ab"  // History data

// ───────────────────────────────────────────────────────────
// BLE PROTOCOL COMMANDS
// ───────────────────────────────────────────────────────────

#define CMD_START_LIVE      0x11    // Start ECG streaming
#define CMD_STOP_LIVE       0x12    // Stop ECG streaming

// ───────────────────────────────────────────────────────────
// BLE PROTOCOL PACKET TYPES
// ───────────────────────────────────────────────────────────

#define PACKET_BPM          0x01    // BPM update packet
#define PACKET_SIGNAL_LOSS  0x02    // Signal status packet

// ───────────────────────────────────────────────────────────
// DEBUG CONFIGURATION
// ───────────────────────────────────────────────────────────

#define DEBUG_SERIAL_BAUD   115200
#define DEBUG_PEAK_PRINTS   10      // Print first N peaks, then every 20th

#endif // CONFIG_H
