# Makefile for clab_hello_world

CROSS_COMPILE=mips-linux-gnu-

CC=$(CROSS_COMPILE)gcc
LD=$(CROSS_COMPILE)ld
OBJCOPY=$(CROSS_COMPILE)objcopy

CFLAGS=-G 0 -march=mips3 -mabi=32 -nostdinc -fno-pic -mno-abicalls -Wall
LDFLAGS=-Ttext 80100000

QEMU=/opt/clab/bin/qemu-system-mips64

XTERM=xterm

all: clab_hello_world.bin
.PHONY: all

clean:
	@rm -f clab_hello_world *.o *.bin
.PHONY: clean

clab_hello_world.bin: clab_hello_world
	$(OBJCOPY) -S -j .text --output-target binary $< $@

clab_hello_world: clab_hello_world.o
	$(LD) -o $@ $(LDFLAGS) $<

clab_hello_world.o: clab_hello_world.S
	$(CC) -c $(CFLAGS) $<

run_xterm: clab_hello_world.bin
	$(XTERM) -e "$(QEMU) -nographic -M clab -bios ./clab_hello_world.bin 2>/dev/null"

run: clab_hello_world.bin
	$(QEMU) -nographic -M clab -bios ./clab_hello_world.bin 2>/dev/null
