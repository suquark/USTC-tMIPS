all:__start
__start:
	mips-baremetal-elf-gcc -mips32  -c  __start.s -o __start.o
	mips-baremetal-elf-ld -mips32  -T __start.ld __start.o -o boot
	mips-baremetal-elf-objcopy -O binary boot boot.bin
	qemu-system-mips -kernel boot 
