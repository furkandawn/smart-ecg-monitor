// ═══════════════════════════════════════════════════════════
// dc_removal.h - DC Offset Removal Filter
// High-pass filter to remove baseline wander from ECG signal
// ═══════════════════════════════════════════════════════════

#ifndef DC_REMOVAL_H
#define DC_REMOVAL_H

#include <Arduino.h>
#include "config.h"

// ───────────────────────────────────────────────────────────
// DC REMOVAL FILTER
// ───────────────────────────────────────────────────────────
// Implements a simple IIR high-pass filter:
//   dcOffset = alpha * dcOffset + (1 - alpha) * sample
//   output = sample - dcOffset
//
// With alpha = 0.995 at 500 Hz:
//   Cutoff frequency ≈ 0.16 Hz
//   Removes DC offset and very slow baseline wander
//   Preserves ECG waveform (0.5 - 40 Hz content)
// ───────────────────────────────────────────────────────────

class DCRemovalFilter {
public:
    DCRemovalFilter();
    
    // Process a raw sample, return DC-removed sample
    int16_t process(uint16_t rawSample);
    
    // Reset filter state (call when electrodes reconnect)
    void reset();
    
    // Get current estimated DC offset
    float getDCOffset() const;
    
    // Check if filter is initialized
    bool isInitialized() const;

private:
    float dcOffset;
    const float alpha;
    bool initialized;
};

// Global filter instance
extern DCRemovalFilter dcRemover;

#endif // DC_REMOVAL_H
