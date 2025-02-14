# MockDuino

# Arduino Mock Library

This library provides a comprehensive framework for mocking Arduino hardware and functionality during unit testing.  It allows developers to simulate the behavior of various Arduino boards (starting with the Uno) and their peripherals, enabling thorough testing of Arduino code without requiring physical hardware.

## Introduction

Testing Arduino code that interacts with hardware can be challenging.  Traditional unit testing frameworks often struggle to simulate the behavior of physical components like GPIO pins, analog sensors, and communication interfaces.  This library addresses this issue by providing a mock environment that mimics the Arduino platform, allowing developers to write and execute tests for their Arduino code in a controlled setting.

## Features

* **GPIO Mocking:**
    * Mock the state (HIGH/LOW, INPUT/OUTPUT) of all GPIO pins for supported boards (initially Arduino Uno).
    * Set pin values programmatically to simulate different input conditions.
    * Verify the expected state of pins after function calls.
    * Support for different Arduino Uno revisions and potential pin variations.
* **Analog Input Mocking:**
    * Provide mock ADC values (raw readings) to simulate analog sensor inputs.
    * Convert raw ADC values to voltage or other units using configurable mappings.
    * Simulate changes in analog readings over time.
* **Timing Mocking:**
    * Mock `delay()` and `millis()` functions to control the passage of simulated time.
    * Allow tests to "fast-forward" time to specific points.
    * Implement custom time-based event triggers.
* **Serial Communication Mocking:**
    * Redirect `Serial.print()` and `Serial.println()` output to a terminal or a string buffer for verification.
    * Simulate incoming serial data for testing serial communication protocols.
* **Other Functionality Mocking:**
    * Mock other relevant Arduino functions (e.g., `analogWrite()`, `tone()`, interrupts).
    * Extensible design to allow for mocking additional functionalities as needed.
* **Board Support:**
    * Initial support for Arduino Uno (various revisions).
    * Plan to expand support to other Arduino boards (Mega, Nano, etc.).
* **Easy Integration:**
    * Simple to include in Arduino projects and unit test frameworks.
* **Comprehensive Examples:**
    * Provide clear and concise examples demonstrating how to use the library for different testing scenarios.

## Getting Started

### Installation

1.  Download the library from the GitHub repository.
2.  Include the library in your Arduino project.

### Usage

1.  Include the `ArduinoMock.h` header file in your test code.
2.  Initialize the mock environment for the target board (e.g., Arduino Uno).
3.  Use the provided functions to set mock pin states, analog values, and other parameters.
4.  Run your Arduino code under test.
5.  Use the library's verification functions to check the expected behavior (e.g., pin states, serial output).

## Example

```c++
#include "ArduinoMock.h"
#include <Arduino.h> // Include the actual Arduino.h for the real functions to be stubbed

void setup() {
  // Initialize the mock environment for Arduino Uno
  ArduinoMock::init(ARDUINO_UNO);
  // Set pin 2 as output
  pinMode(2, OUTPUT);
}

void loop() {
  // Set pin 2 HIGH
  digitalWrite(2, HIGH);
  // Simulate a delay of 1000ms
  delay(1000);
  // Set pin 2 LOW
  digitalWrite(2, LOW);
  // Simulate a delay of 500ms
  delay(500);

  // You can then use an assert library to check the state of the pin
  // For example, if you were using a testing framework:
  // ASSERT_EQ(digitalRead(2), LOW); // After the 500ms delay, the pin should be low
}

// In your actual test file, you would include your arduino code and this test file
// and run it using a unit testing framework.
