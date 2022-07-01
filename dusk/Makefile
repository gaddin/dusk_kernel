# tools
ASM=nasm
CC86=`head -1 conf`/i686-elf-gcc
LD86=`head -1 conf`/i686-elf-ld

# flags
STAGE_0_ASM_FLAGS=-f elf
STAGE_1_C_FLAGS=-ffreestanding -mgeneral-regs-only -nostdlib -std=gnu99
STAGE_1_LD_FLAGS=-Tlinker_scripts/link.ld

QEMU_ARCH=i386
QEMU_ADAPTER=vga std
QEMU_MEMORY=4096
QEMU_CPU=pentium
QEMU_SETTINGS=-cpu $(QEMU_CPU) -enable-kvm -m $(QEMU_MEMORY) -$(QEMU_ADAPTER)

# sources
BOOT_SRC=bootloader/stage0.asm
INIT_SRC=bootloader/stage1.c
KERNEL_SRC=kernel/*.c # TODO fix dis shit

# directories
BUILD_DIR=build
OUTPUT_DIR=$(BUILD_DIR)/out
DISK_DIR=$(OUTPUT_DIR)/disk

# script

all: kernel.iso

setup:
	mkdir $(BUILD_DIR)
	mkdir $(OUTPUT_DIR)

run: kernel.iso
	qemu-system-$(QEMU_ARCH) $(QEMU_SETTINGS) $^

kernel.iso: kernel.elf
	dd if=/dev/zero of=$@ bs=512 count=1440
	dd if=$(BUILD_DIR)/$^ conv=notrunc bs=512 count=1440

kernel.elf: $(OUTPUT_DIR)/stage0.o $(OUTPUT_DIR)/stage1.o
	$(LD86) $(STAGE_1_LD_FLAGS) $^ -o $@

$(OUTPUT_DIR)/stage0.o: $(BOOT_SRC)
	$(ASM) $(STAGE_0_ASM_FLAGS) $^ -o $@

$(OUTPUT_DIR)/stage1.o: $(INIT_SRC)
	$(CC86) $(STAGE_1_C_FLAGS) -c $^ -o $@
	
