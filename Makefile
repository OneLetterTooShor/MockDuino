# Makefile for MockDuino project targeting RA4M1 MCU

# Project Configuration
PROJECT_NAME := MockduinoLib  # Name of your project (will be used for output files)
TARGET_MCU := ra4m1         # Target MCU (for informational purposes, adjust compiler flags if needed)

# Toolchain Configuration (Adapt these paths to your toolchain installation)
TOOLCHAIN_PREFIX := arm-none-eabi # Prefix for ARM toolchain commands (e.g., arm-none-eabi-gcc)
CC := $(TOOLCHAIN_PREFIX)-gcc
CXX := $(TOOLCHAIN_PREFIX)-g++
LD := $(TOOLCHAIN_PREFIX)-ld
AR := $(TOOLCHAIN_PREFIX)-ar
OBJCOPY := $(TOOLCHAIN_PREFIX)-objcopy
OBJDUMP := $(TOOLCHAIN_PREFIX)-objdump

# Define directories
BUILD_DIR := build
SRC_DIRS := src examples tests # Directories containing source files (.c, .cpp)
INC_DIRS := src             # Directories containing header files (.h) - Add more if needed (e.g., path to HAL headers, CMSIS)
LIB_DIRS :=                   # Directories containing libraries (.a, .lib) - Add if you use external libraries
LIBS :=                      # Libraries to link against (e.g., -lm -lstdc++) - Add if you use external libraries

# Source files - automatically find all .c and .cpp files in SRC_DIRS
C_SOURCES := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.c))
CPP_SOURCES := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.cpp))
SOURCES := $(C_SOURCES) $(CPP_SOURCES)

# Object files - replace source extension with .o and put in BUILD_DIR
OBJECTS := $(patsubst %.c,$(BUILD_DIR)/%.o,$(C_SOURCES))
OBJECTS += $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(CPP_SOURCES))

# Include Directories - Use -I flag for each directory in INC_DIRS
INCLUDE_FLAGS := $(foreach dir,$(INC_DIRS),-I$(dir))

# Compiler Flags (Customize these based on your RA4M1 and desired settings)
CFLAGS := -g -O0 -Wall -Wextra -Wno-missing-declarations # Debugging flags, warnings
CFLAGS += -mcpu=cortex-m4              # Specify Cortex-M4 architecture (adjust if RA4M1 uses a different core)
CFLAGS += -mthumb                     # Thumb instruction set
CFLAGS += -mfpu=fpv4-sp-d16           # Enable hardware floating point unit (if RA4M1 has FPU, adjust as needed)
CFLAGS += -mfloat-abi=hard            # Hard float ABI (if FPU enabled) - adjust to soft or softfp if no FPU or for compatibility
CFLAGS += -ffunction-sections        # Place each function in its own section (for linker optimization)
CFLAGS += -fdata-sections           # Place each data item in its own section (for linker optimization)
CFLAGS += $(INCLUDE_FLAGS)

CXXFLAGS := $(CFLAGS) # For now, use the same flags for C++ as C, adjust if needed

# Assembler Flags (if you have assembly files, add rules and flags)
ASFLAGS := -g -mcpu=cortex-m4 -mthumb # Example flags for assembler

# Linker Flags (Customize based on your memory map and libraries)
LDFLAGS := -specs=nosys.specs         # Minimal system environment
LDFLAGS += -T linker_script.ld        # Specify your linker script (you'll need to create/find one for RA4M1)
LDFLAGS += -Wl,-gc-sections           # Remove unused sections (for code size optimization)
LDFLAGS += $(LIB_DIRS:%=-L%)         # Add library directories using -L flag
LDFLAGS += $(LIBS)                    # Add libraries to link

# Define the output executable name
OUTPUT_ELF := $(BUILD_DIR)/$(PROJECT_NAME).elf
OUTPUT_BIN := $(BUILD_DIR)/$(PROJECT_NAME).bin
OUTPUT_HEX := $(BUILD_DIR)/$(PROJECT_NAME).hex

# Default target: build all
all: $(OUTPUT_ELF) $(OUTPUT_BIN) $(OUTPUT_HEX)

# Rule for compiling C source files
$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	@echo "  CC      $<"
	@$(CC) $(CFLAGS) -c $< -o $@

# Rule for compiling C++ source files
$(BUILD_DIR)/%.o: %.cpp | $(BUILD_DIR)
	@echo "  CXX     $<"
	@$(CXX) $(CXXFLAGS) -c $< -o $@

# Rule for assembling assembly files (if you have any) - Example, uncomment and adjust if needed
# $(BUILD_DIR)/%.o: %.s | $(BUILD_DIR)
# 	@echo "  AS      $<"
# 	@$(AS) $(ASFLAGS) -c $< -o $@

# Rule for creating the ELF executable
$(OUTPUT_ELF): $(OBJECTS) | $(BUILD_DIR) linker_script.ld # Add linker_script.ld as dependency
	@echo "  LD      $@"
	@$(LD) $(LDFLAGS) -o $@ $(OBJECTS)

# Rule for creating the binary (.bin) file from ELF
$(OUTPUT_BIN): $(OUTPUT_ELF)
	@echo "  OBJCOPY $@"
	@$(OBJCOPY) -O binary $< $@

# Rule for creating the hex (.hex) file from ELF
$(OUTPUT_HEX): $(OUTPUT_ELF)
	@echo "  OBJCOPY $@"
	@$(OBJCOPY) -O ihex $< $@

# Create build directory if it doesn't exist
$(BUILD_DIR):
	@mkdir -p $@

# Clean target - removes build artifacts
clean:
	@echo "  CLEAN"
	@rm -rf $(BUILD_DIR) $(OUTPUT_ELF) $(OUTPUT_BIN) $(OUTPUT_HEX)

# Flash target (Example - you'll need to adapt this to your flashing method and tools)
flash: $(OUTPUT_BIN)
	@echo "  FLASH   $@"
	# Add your flashing command here. Examples:
	# For USB flashing using a tool like 'stm32flash':
	# stm32flash -w $(OUTPUT_BIN) -v /dev/ttyACM0
	# For flashing with OpenOCD (adapt to your OpenOCD config and interface):
	# openocd -f interface/your_interface.cfg -f target/ra4m1.cfg -c "program $(OUTPUT_BIN) verify reset exit"
	@echo "  *** Flash command needs to be configured in the Makefile! ***"

# Debug target (Example - you'll need to adapt this to your debugger and launch commands)
debug: $(OUTPUT_ELF)
	@echo "  DEBUG   $@"
	# Example for starting GDB with OpenOCD (adapt paths and commands):
	# arm-none-eabi-gdb -x .gdbinit $(OUTPUT_ELF)
	@echo "  *** Debug command needs to be configured - see README and VSCode launch.json! ***"


.PHONY: all clean flash debug