/*
BLE Protocol Summary:

CTRL characteristic (Control & Status):
  - WRITE:
    - 0x11 → Start live stream
    - 0x12 → Stop live stream
  - NOTIFY:
    - 0x01 [lo hi] → BPM update
    - 0x02 [status] → Signal loss (0=OK, 1=LOST)

LIVE characteristic (Data Stream):
  - NOTIFY only:
    - Int16 LE ECG samples (20 samples per packet = 40 bytes)
    - Centered around 0 (DC removed)
    - 500 Hz sample rate = 25 packets/sec

EVENT characteristic (History Transfer):
  - NOTIFY only:
    - 0xAA 0x01 → Start history transfer
    - 0xDD [...] → Data chunk
    - 0xAA 0x02 → End transfer
*/

// ───────── UUIDs (MATCH FIRMWARE) ─────────
const String serviceUuid = '4fafc201-1fb5-459e-8fcc-c5c9c331914b';
const String liveCharUuid = 'beb5483e-36e1-4688-b7f5-ea07361b26a8';
const String eventCharUuid = '12345678-1234-1234-1234-1234567890ab';
const String ctrlCharUuid = '87654321-4321-4321-4321-210987654321';

// ───────── COMMANDS (Write to CTRL) ─────────
const int cmdStartLive = 0x11;  // Start ECG streaming
const int cmdStopLive  = 0x12;  // Stop ECG streaming

// ───────── CTRL PACKETS (Notify from CTRL) ─────────
const int packetBpm   = 0x01;   // BPM: [0x01, lo, hi]
const int packetLoss  = 0x02;   // Signal: [0x02, status] (0=OK, 1=LOST)

// ───────── EVENT PACKETS (Notify from EVENT) ─────────
const int packetHeader = 0xAA;  // History transfer header
const int packetData   = 0xDD;  // History data chunk
const int eventStart   = 0x01;  // Start marker: [0xAA, 0x01]
const int eventEnd     = 0x02;  // End marker: [0xAA, 0x02]

// ───────── LIVE STREAM ─────────
// No constants needed - just raw int16 samples
// Format: [sample1_lo, sample1_hi, sample2_lo, sample2_hi, ...]
// Each packet: 20 samples × 2 bytes = 40 bytes