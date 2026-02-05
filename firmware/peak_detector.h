// ═══════════════════════════════════════════════════════════
// peak_detector.h - R-Peak Detection and BPM Calculation
// Derivative-based peak detection with adaptive threshold
// ═══════════════════════════════════════════════════════════

#ifndef PEAK_DETECTOR_H
#define PEAK_DETECTOR_H

#include <Arduino.h>
#include "config.h"

// ───────────────────────────────────────────────────────────
// PEAK DETECTOR
// ───────────────────────────────────────────────────────────
// Algorithm:
//   1. Compute derivative (sample - lastSample)
//   2. Detect positive threshold crossing
//   3. Apply refractory period to avoid multiple triggers
//   4. Validate RR interval (200-2000 ms)
//   5. Smooth BPM using exponential moving average
//   6. Adapt threshold based on observed signal amplitude
// ───────────────────────────────────────────────────────────

class PeakDetector {
public:
    PeakDetector();
    
    // Process a sample, return true if R-peak detected
    bool process(int16_t sample, uint32_t timestamp);
    
    // Get current BPM (0 if signal lost)
    uint16_t getBPM() const;
    
    // Check if signal is lost (no peaks for threshold period)
    bool isSignalLost() const;
    
    // Get current adaptive threshold
    int16_t getThreshold() const;
    
    // Get smoothed RR interval in ms
    float getSmoothedRR() const;
    
    // Get total peaks detected since reset
    uint32_t getPeakCount() const;
    
    // Reset detector state
    void reset();
    
    // Print debug statistics to Serial
    void printDebugStats();

private:
    // Sample state
    int16_t lastSample;
    int16_t threshold;
    uint32_t lastPeakTime;
    
    // BPM calculation
    uint16_t currentBPM;
    bool signalLost;
    float smoothedRR;
    
    // RR interval history (for debugging)
    uint32_t rrIntervals[RR_BUFFER_SIZE];
    uint8_t rrIndex;
    
    // Adaptive threshold
    int16_t maxDerivativeRecent;
    uint32_t derivativeSampleCount;
    
    // Debug statistics
    uint32_t debugPeakCount;
    int16_t debugMaxDerivative;
    int16_t debugMinDerivative;
    
    // Update adaptive threshold based on signal
    void updateAdaptiveThreshold();
};

// Global peak detector instance
extern PeakDetector peakDetector;

#endif // PEAK_DETECTOR_H
