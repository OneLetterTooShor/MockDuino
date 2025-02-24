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
* **ESP32 Wifi + Bluetooth Mocking:**
    * Mock communication between the main RA4M1 MCU and the ESP32-S3-MINI-1-N8 secondary MCU
    * Mock wifi + bluetooth function calls
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

### Setting up the Development Environment

To simplify the initial setup process, the MockDuino project includes a `setup.sh` script. This script is designed to help you install the necessary development tools on your system, specifically the ARM toolchain (`arm-none-eabi-gcc` and related tools) and OpenOCD (for debugging).

**Please follow these steps to run the setup script:**

1.  **Open a Terminal:** Navigate to your terminal application (e.g., Bash, Zsh on Linux/macOS, or Git Bash on Windows if you are using it).
2.  **Navigate to the Project Root:** Use the `cd` command to change your current directory to the root directory of the MockDuino project where the `setup.sh` file is located. For example, if your project is in `~/Documents/Mockduino`, you would type:

    ```bash
    cd ~/Documents/Mockduino
    ```

3.  **Make the Script Executable:** Before you can run the `setup.sh` script, you need to ensure it has execute permissions. Use the `chmod` command to make it executable:

    ```bash
    chmod +x setup.sh
    ```

4.  **Run the Setup Script:** Now you can execute the `setup.sh` script by typing:

    ```bash
    ./setup.sh
    ```

5.  **Administrator Password (sudo):** During the execution of the `setup.sh` script, you may be prompted to enter your administrator (or `sudo`) password. This is because the script uses `sudo` to install software packages system-wide using your operating system's package manager (like `apt-get` on Debian/Ubuntu, `brew` on macOS).  **This is normal for software installation. Only proceed if you trust the script and understand what it is doing.**

6.  **Monitor the Script Output:** Carefully observe the output in your terminal while the script is running. The script will print messages indicating what it is doing, such as detecting your operating system and attempting to install packages.

7.  **Check for Errors or Warnings:** After the script has finished running, review the output for any error messages or warnings. If you encounter errors, the script will usually provide some guidance or indicate that manual installation steps might be required.

8.  **Verification (Important):** The script attempts to verify if the ARM toolchain and OpenOCD were installed successfully. Look for messages confirming that `arm-none-eabi-gcc` and `openocd` were found. If these verifications fail, or if you encountered errors during the script execution, please refer to the "**Manual Setup**" section of this README for instructions on how to install the dependencies manually.

9.  **Next Steps:** Once the script completes successfully (or you have manually installed the dependencies), you should be ready to build the MockDuino project. Proceed to the "**Building the Project**" section of this README for further instructions.

**Important Notes:**

*   The `setup.sh` script is designed to assist with the installation of common development tools on Linux and macOS. Windows support is currently limited and may require manual steps.
*   The script assumes you have a working internet connection to download packages.
*   If you encounter issues running the script or prefer manual installation, please refer to the "**Manual Setup**" section in this README for detailed instructions on installing the ARM toolchain and OpenOCD for your specific operating system.

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
```

### Instructions for Compiling, Building, and Debugging Code via VSCode

In order to have the ability to compile, build, and debug your code on VSCode, additional tools are required to interface with the RA4M1 MCU. It should be researched to see if there is support for USB programming and debugging. Otherwise it is assumed that an Atmel-ICE Hardware Debugger will be used to interface with the MCU, via the SWD pins.

## Development Roadmap and VS Code Integration

This project aims to not only provide a mocking library but also streamline the entire Arduino development workflow, particularly for Linux users.  The following features are planned for future development:

### VS Code Extension for Arduino Development

A key goal is to create a VS Code extension that simplifies building, running, debugging, and uploading Arduino code directly from the editor on Linux.  This extension will leverage the Arduino CLI or other suitable tools to provide a seamless development experience.

**Planned Features:**

* **Project Creation:**  Easily create new Arduino projects with the correct structure and dependencies.
* **Build System Integration:**  Integrate with the Arduino build system (or PlatformIO) to compile and link code.
* **Board Selection:**  Support selecting the target Arduino board from a list of available options.
* **Port Detection:**  Automatically detect connected Arduino boards and their corresponding serial ports.
* **Upload Functionality:**  Upload compiled code to the target board with a single click.
* **Debugging Support:**  Integrate with a debugger (e.g., GDB) to allow for step-through debugging of Arduino code on supported boards.  This will likely require some form of hardware debugging adapter.
* **Serial Monitor Integration:**  Embed a serial monitor within VS Code to view output from the Arduino board.
* **Mock Library Integration:**  Seamlessly integrate the Arduino Mock Library into the VS Code development workflow.  This will simplify running unit tests and simulations.
* **Configuration:**  Allow users to configure various settings, such as the Arduino IDE path, board type, and serial port.

### Cross-Platform Compatibility (Future)

While the initial focus is on Linux, future iterations of the VS Code extension will explore cross-platform compatibility to support Windows and macOS.
