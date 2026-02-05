// ═══════════════════════════════════════════════════════════
// ad8232.h - AD8232 ECG Module Interface
// Lead-off detection and module control
// ═══════════════════════════════════════════════════════════

#ifndef AD8232_H
#define AD8232_H

#include <Arduino.h>
#include "config.h"

// ───────────────────────────────────────────────────────────
// AD8232 ECG MODULE
// ───────────────────────────────────────────────────────────
// Pin functions:
//   OUTPUT - Analog ECG signal (connect to ADC)
//   LO+    - Lead-off detection positive (HIGH = disconnected)
//   LO-    - Lead-off detection negative (HIGH = disconnected)
//   SDN    - Shutdown control (LOW = enabled, HIGH = shutdown)
// ───────────────────────────────────────────────────────────

class AD8232Module {
public:
    AD8232Module();
    
    // Initialize pins and enable module
    void init();
    
    // Check if electrodes are disconnected
    // Returns true if any lead is off
    bool isLeadsOff() const;
    
    // Enable module (exit shutdown)
    void enable();
    
    // Disable module (enter shutdown for power saving)
    void disable();
    
    // Check if module is enabled
    bool isEnabled() const;
    
    // Print module status to Serial
    void printStatus() const;

private:
    bool moduleEnabled;
};

// Global AD8232 instance
extern AD8232Module ad8232;

#endif // AD8232_H
