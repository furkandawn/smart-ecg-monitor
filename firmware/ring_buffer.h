// ═══════════════════════════════════════════════════════════
// ring_buffer.h - Lock-free Ring Buffer for ECG Samples
// Thread-safe producer/consumer buffer for ISR → main loop
// ═══════════════════════════════════════════════════════════

#ifndef RING_BUFFER_H
#define RING_BUFFER_H

#include <Arduino.h>
#include "config.h"

// ───────────────────────────────────────────────────────────
// RING BUFFER STRUCTURE
// ───────────────────────────────────────────────────────────

struct RingBuffer {
    uint16_t data[BUFFER_SIZE];
    volatile uint32_t writeIndex;
    volatile uint32_t readIndex;
    volatile uint32_t overrunCount;
    volatile uint32_t totalSamples;
    
    // Initialize buffer
    void init();
    
    // Producer (ISR): Add sample to buffer
    // Returns false if buffer full (overrun)
    bool IRAM_ATTR write(uint16_t sample);
    
    // Consumer (main): Read sample from buffer
    // Returns 0 if buffer empty
    uint16_t read();
    
    // Get number of samples available to read
    uint32_t available();
    
    // Check if buffer is empty
    bool isEmpty();
    
    // Check if buffer is full
    bool isFull();
    
    // Get buffer fill percentage
    float fillPercent();
    
    // Get statistics
    uint32_t getTotalSamples();
    uint32_t getOverrunCount();
    float getOverrunRate();
    
    // Reset buffer and statistics
    void reset();
};

// Global buffer instance (declared in .cpp)
extern RingBuffer ecgBuffer;

#endif // RING_BUFFER_H
