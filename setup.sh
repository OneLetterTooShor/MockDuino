#!/bin/bash

echo "Setting up development environment for MockDuino project..."

# 1. Detect Operating System
OS=$(uname -s)

echo "Detected OS: $OS"

# 2. Install ARM Toolchain (arm-none-eabi-gcc)
echo "Installing ARM Toolchain..."

if [[ "$OS" == "Linux" ]]; then
  if command -v apt-get &> /dev/null; then
    echo "Using apt-get (Debian/Ubuntu-like)"
    sudo apt-get update
    sudo apt-get install -y binutils-arm-none-eabi gcc-arm-none-eabi g++-arm-none-eabi
  elif command -v yum &> /dev/null || command -v dnf &> /dev/null; then
    echo "Using yum or dnf (Fedora/Red Hat-like)"
    sudo yum install -y arm-none-eabi-gcc arm-none-eabi-binutils # Or dnf install ...
  else
    echo "Error: Linux distribution not detected as Debian/Ubuntu or Fedora/Red Hat."
    echo "Please install the ARM toolchain manually. See README for instructions."
    exit 1
  fi
elif [[ "$OS" == "Darwin" ]]; then # macOS
  if command -v brew &> /dev/null; then
    echo "Using Homebrew (macOS)"
    brew install arm-none-eabi-gcc
  else
    echo "Error: Homebrew not found on macOS."
    echo "Please install Homebrew (https://brew.sh/) and then run this script again."
    exit 1
  fi
elif [[ "$OS" == "Windows" ]]; then
  echo "Windows detected."
  echo "ARM Toolchain installation on Windows is usually manual."
  echo "Please download and install the ARM GNU Toolchain from Arm Developer website:"
  echo "https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads"
  echo "Make sure to add the toolchain's 'bin' directory to your system's PATH environment variable."
  TOOLCHAIN_WINDOWS_MANUAL=true # Flag to indicate manual Windows toolchain setup
else
  echo "Unsupported operating system: $OS"
  echo "Please refer to the README for manual setup instructions."
  exit 1
fi

# 3. Install OpenOCD
echo "Installing OpenOCD..."

if [[ "$OS" == "Linux" ]]; then
  if command -v apt-get &> /dev/null; then
    sudo apt-get install -y openocd
  elif command -v yum &> /dev/null || command -v dnf &> /dev/null; then
    sudo yum install -y openocd # Or dnf install ...
  else
    echo "OpenOCD installation for your Linux distro may require manual steps. See README."
  fi
elif [[ "$OS" == "Darwin" ]]; then # macOS
  if command -v brew &> /dev/null; then
    brew install openocd
  else
    echo "OpenOCD installation on macOS may require manual steps if Homebrew is not used."
  fi
elif [[ "$OS" == "Windows" ]]; then
  echo "OpenOCD installation on Windows is usually manual or via Chocolatey."
  echo "Consider using Chocolatey (https://chocolatey.org/) and run: choco install openocd"
  echo "Alternatively, download and install OpenOCD manually. See README."
  OPENOCD_WINDOWS_MANUAL=true # Flag for manual Windows OpenOCD setup
fi


# 4. Verify Installations
echo "Verifying installations..."

if ! command -v arm-none-eabi-gcc &> /dev/null; then
  echo "Error: ARM toolchain (arm-none-eabi-gcc) not found after installation."
  if [[ "$TOOLCHAIN_WINDOWS_MANUAL" == "true" ]]; then
    echo "Make sure you have installed it and added its 'bin' directory to your PATH."
  else
    echo "Check for errors during installation or consult the README for troubleshooting."
  fi
  exit 1
fi
echo "ARM toolchain (arm-none-eabi-gcc) found."

if ! command -v openocd &> /dev/null; then
  echo "Warning: OpenOCD (openocd) not found after installation."
  if [[ "$OPENOCD_WINDOWS_MANUAL" == "true" ]]; then
    echo "Make sure you have installed it and added its directory to your PATH (if necessary for your installation method)."
  else
     echo "OpenOCD might be needed for debugging. Check for installation errors or consult the README."
  fi
  # Non-fatal warning for OpenOCD, as it's mainly for debugging
else
  echo "OpenOCD (openocd) found."
fi


echo " "
echo "Development environment setup complete!"
echo " "
echo "Next steps:"
echo "1. Review the README.md for detailed project instructions."
echo "2. Build the project using: make"
echo "3. (Optional) Configure debugging in VSCode (see README)."
echo " "

exit 0