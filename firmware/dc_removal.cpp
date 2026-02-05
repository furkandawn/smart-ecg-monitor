// ═══════════════════════════════════════════════════════════
// dc_removal.cpp - DC Offset Removal Filter Implementation
// ═══════════════════════════════════════════════════════════

#include "dc_removal.h"

// Global filter instance
DCRemovalFilter dcRemover;

DCRemovalFilter::DCRemovalFilter() 
    : dcOffset(2048.0f),        // Start at mid-scale for 12-bit ADC
      alpha(DC_REMOVAL_ALPHA),
      initialized(false) 
{
}

int16_t DCRemovalFilter::process(uint16_t rawSample) {
    if (!initialized) {
        // Initialize DC offset to first sample
        dcOffset = static_cast<float>(rawSample);
        initialized = true;
    }
    
    // Update DC estimate with exponential moving average
    dcOffset = alpha * dcOffset + (1.0f - alpha) * rawSample;
    
    // Remove DC offset and return as signed value
    return static_cast<int16_t>(rawSample - dcOffset);
}

void DCRemovalFilter::reset() {
    dcOffset = 2048.0f;  // Reset to mid-scale
    initialized = false;
}

float DCRemovalFilter::getDCOffset() const {
    return dcOffset;
}

bool DCRemovalFilter::isInitialized() const {
    return initialized;
}
