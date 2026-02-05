// ═══════════════════════════════════════════════════════════
// ring_buffer.cpp - Lock-free Ring Buffer Implementation
// ═══════════════════════════════════════════════════════════

#include "ring_buffer.h"

// Global buffer instance
RingBuffer ecgBuffer;

void RingBuffer::init() {
    writeIndex = 0;
    readIndex = 0;
    overrunCount = 0;
    totalSamples = 0;
    memset(data, 0, sizeof(data));
}

bool IRAM_ATTR RingBuffer::write(uint16_t sample) {
    uint32_t nextWrite = (writeIndex + 1) & BUFFER_MASK;
    
    // Check for buffer full (would overwrite unread data)
    if (nextWrite == readIndex) {
        overrunCount++;
        totalSamples++;
        return false;
    }
    
    data[writeIndex] = sample;
    writeIndex = nextWrite;
    totalSamples++;
    return true;
}

uint16_t RingBuffer::read() {
    if (isEmpty()) {
        return 0;
    }
    
    uint16_t sample = data[readIndex];
    readIndex = (readIndex + 1) & BUFFER_MASK;
    return sample;
}

uint32_t RingBuffer::available() {
    return (writeIndex - readIndex) & BUFFER_MASK;
}

bool RingBuffer::isEmpty() {
    return writeIndex == readIndex;
}

bool RingBuffer::isFull() {
    return ((writeIndex + 1) & BUFFER_MASK) == readIndex;
}

float RingBuffer::fillPercent() {
    return (available() * 100.0f) / BUFFER_SIZE;
}

uint32_t RingBuffer::getTotalSamples() {
    return totalSamples;
}

uint32_t RingBuffer::getOverrunCount() {
    return overrunCount;
}

float RingBuffer::getOverrunRate() {
    if (totalSamples == 0) return 0.0f;
    return (overrunCount * 100.0f) / totalSamples;
}

void RingBuffer::reset() {
    writeIndex = 0;
    readIndex = 0;
    overrunCount = 0;
    totalSamples = 0;
}
