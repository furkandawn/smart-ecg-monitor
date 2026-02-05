// ═══════════════════════════════════════════════════════════
// ad8232.cpp - AD8232 ECG Module Implementation
// ═══════════════════════════════════════════════════════════

#include "ad8232.h"

// Global AD8232 instance
AD8232Module ad8232;

AD8232Module::AD8232Module()
    : moduleEnabled(false)
{
}

void AD8232Module::init() {
    // Configure lead-off detection pins as inputs
    pinMode(LO_PLUS_PIN, INPUT);
    pinMode(LO_MINUS_PIN, INPUT);
    
    // Configure shutdown pin as output
    pinMode(SDN_PIN, OUTPUT);
    
    // Enable module by default
    enable();
    
    Serial.println("[AD8232] Module Configuration:");
    Serial.printf("  OUTPUT:  GPIO%d\n", ECG_PIN);
    Serial.printf("  LO+:     GPIO%d\n", LO_PLUS_PIN);
    Serial.printf("  LO-:     GPIO%d\n", LO_MINUS_PIN);
    Serial.printf("  SDN:     GPIO%d (enabled)\n", SDN_PIN);
    Serial.println();
}

bool AD8232Module::isLeadsOff() const {
    // LO+ and LO- go HIGH when electrodes are disconnected
    bool loPlus = digitalRead(LO_PLUS_PIN);
    bool loMinus = digitalRead(LO_MINUS_PIN);
    return (loPlus || loMinus);
}

void AD8232Module::enable() {
    digitalWrite(SDN_PIN, LOW);  // LOW = module enabled
    moduleEnabled = true;
}

void AD8232Module::disable() {
    digitalWrite(SDN_PIN, HIGH);  // HIGH = shutdown mode
    moduleEnabled = false;
}

bool AD8232Module::isEnabled() const {
    return moduleEnabled;
}

void AD8232Module::printStatus() const {
    bool loPlus = digitalRead(LO_PLUS_PIN);
    bool loMinus = digitalRead(LO_MINUS_PIN);
    
    Serial.println("[AD8232] Status:");
    Serial.printf("  Module: %s\n", moduleEnabled ? "ENABLED" : "SHUTDOWN");
    Serial.printf("  LO+: %s\n", loPlus ? "DISCONNECTED" : "OK");
    Serial.printf("  LO-: %s\n", loMinus ? "DISCONNECTED" : "OK");
    Serial.printf("  Leads: %s\n", isLeadsOff() ? "⚠️  OFF" : "✅ Connected");
}
