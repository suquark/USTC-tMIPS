### The entry file for OS

# please replace the following in the dump file (convert.py):
# ^001001 -> ^001000
# 100001$ -> 100000$

# low-level support
.include "const.asm"
.include "macro.asm"
.include "utils.asm"
.include "sysutil.asm"

# This should be the first instruction
j main

# 0x0004
j interrupt_routine # Interrpt routine, 0x80000180 in MIPS

# system
.include "io.asm"
.include "intr.asm"
.include "sched.asm"
.include "proc.asm"

# programs
.include "testcase2.asm"
.include "testcase1.asm"
.include "sbnz.asm"

.macro initial_system
	movi $sp,STACK
	calli StartProcess,0 # The main process
	
	la $t0,resume_routine  # ensure it it in low-space
	sw $t0,PST
	# Setup timer interrupt
	la $t0,hard_schd
	sw $t0,Timer_ISR
.end_macro

# -> entrypoint
main:
	# disable_interrupt: There isn't enough time for first timer interrupt. 
	# So there's no need to close it.
	initial_system
	j testcase1

