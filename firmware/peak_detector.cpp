// ═══════════════════════════════════════════════════════════
// peak_detector.cpp - R-Peak Detection Implementation
// ═══════════════════════════════════════════════════════════

#include "peak_detector.h"

// Global peak detector instance
PeakDetector peakDetector;

PeakDetector::PeakDetector() 
    : lastSample(0),
      threshold(PEAK_THRESHOLD_INIT),
      lastPeakTime(0),
      currentBPM(0),
      signalLost(true),
      smoothedRR(0),
      rrIndex(0),
      maxDerivativeRecent(0),
      derivativeSampleCount(0),
      debugPeakCount(0),
      debugMaxDerivative(-32768),
      debugMinDerivative(32767)
{
    memset(rrIntervals, 0, sizeof(rrIntervals));
}

bool PeakDetector::process(int16_t sample, uint32_t timestamp) {
    // Calculate derivative (slope)
    int16_t derivative = sample - lastSample;
    lastSample = sample;
    
    // Track max derivative for adaptive threshold
    if (derivative > maxDerivativeRecent) {
        maxDerivativeRecent = derivative;
    }
    
    // Track debug statistics
    if (derivative > debugMaxDerivative) debugMaxDerivative = derivative;
    if (derivative < debugMinDerivative) debugMinDerivative = derivative;
    
    derivativeSampleCount++;
    
    // Update adaptive threshold every second
    if (derivativeSampleCount >= SAMPLE_RATE_HZ) {
        updateAdaptiveThreshold();
    }
    
    bool peakDetected = false;
    
    // Check for threshold crossing (potential R-peak)
    if (derivative > threshold) {
        uint32_t timeSinceLastPeak = timestamp - lastPeakTime;
        
        // Apply refractory period to avoid double-triggers
        if (timeSinceLastPeak > REFRACTORY_PERIOD_MS) {
            uint32_t rrInterval = timeSinceLastPeak;
            debugPeakCount++;
            
            // Validate RR interval (physiologically possible)
            if (rrInterval >= RR_INTERVAL_MIN_MS && rrInterval <= RR_INTERVAL_MAX_MS) {
                // Store in circular buffer for debugging
                rrIntervals[rrIndex] = rrInterval;
                rrIndex = (rrIndex + 1) % RR_BUFFER_SIZE;
                
                // Apply EMA smoothing to RR interval
                if (smoothedRR == 0) {
                    smoothedRR = static_cast<float>(rrInterval);
                } else {
                    smoothedRR = EMA_ALPHA * rrInterval + (1.0f - EMA_ALPHA) * smoothedRR;
                }
                
                // Calculate BPM from smoothed RR
                currentBPM = 60000 / static_cast<uint32_t>(smoothedRR);
                signalLost = false;
                peakDetected = true;
                
                // Debug output (first N peaks, then every 20th)
                if (debugPeakCount <= DEBUG_PEAK_PRINTS || debugPeakCount % 20 == 0) {
                    Serial.printf("[PEAK] #%u | RR=%ums | smoothed=%.0f | BPM=%u\n", 
                                  debugPeakCount, rrInterval, smoothedRR, currentBPM);
                }
            }
            
            lastPeakTime = timestamp;
        }
    }
    
    // Check for signal loss
    if (timestamp - lastPeakTime > SIGNAL_LOSS_THRESHOLD_MS) {
        if (!signalLost) {
            signalLost = true;
            currentBPM = 0;
            Serial.println("[PEAK] Signal lost - no peaks detected");
        }
    }
    
    return peakDetected;
}

void PeakDetector::updateAdaptiveThreshold() {
    if (maxDerivativeRecent > 50) {
        // Set threshold to percentage of max derivative
        threshold = static_cast<int16_t>(maxDerivativeRecent * PEAK_THRESHOLD_RATIO);
        
        // Clamp to valid range
        if (threshold < PEAK_THRESHOLD_MIN) threshold = PEAK_THRESHOLD_MIN;
        if (threshold > PEAK_THRESHOLD_MAX) threshold = PEAK_THRESHOLD_MAX;
    }
    
    // Reset for next period
    maxDerivativeRecent = 0;
    derivativeSampleCount = 0;
}

uint16_t PeakDetector::getBPM() const {
    return currentBPM;
}

bool PeakDetector::isSignalLost() const {
    return signalLost;
}

int16_t PeakDetector::getThreshold() const {
    return threshold;
}

float PeakDetector::getSmoothedRR() const {
    return smoothedRR;
}

uint32_t PeakDetector::getPeakCount() const {
    return debugPeakCount;
}

void PeakDetector::reset() {
    lastSample = 0;
    lastPeakTime = millis();
    currentBPM = 0;
    signalLost = true;
    smoothedRR = 0;
    threshold = PEAK_THRESHOLD_INIT;
    maxDerivativeRecent = 0;
    derivativeSampleCount = 0;
    rrIndex = 0;
    memset(rrIntervals, 0, sizeof(rrIntervals));
    debugPeakCount = 0;
    debugMaxDerivative = -32768;
    debugMinDerivative = 32767;
}

void PeakDetector::printDebugStats() {
    Serial.println("\n[PEAK DETECTOR DEBUG]");
    Serial.printf("  Threshold: %d\n", threshold);
    Serial.printf("  Peaks detected: %u\n", debugPeakCount);
    Serial.printf("  Smoothed RR: %.1f ms\n", smoothedRR);
    Serial.printf("  Current BPM: %u\n", currentBPM);
    Serial.printf("  Derivative range: %d to %d\n", debugMinDerivative, debugMaxDerivative);
    
    Serial.print("  Recent RR: ");
    for (int i = 0; i < RR_BUFFER_SIZE; i++) {
        if (rrIntervals[i] > 0) {
            Serial.printf("%u ", rrIntervals[i]);
        }
    }
    Serial.println("ms");
    
    // Reset debug stats for next period
    debugMaxDerivative = -32768;
    debugMinDerivative = 32767;
}
