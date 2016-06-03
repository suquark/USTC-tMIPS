.include "const.asm"
.include "macro.asm"
.include "utils.asm"
.include "sysutil.asm"

# ^001001 -> ^001000
# 100001$ -> 100000$


j main
# For interrupt
j interrupt_routine # 0x80000180 in MIPS
j interrupt_routine # 0x80000180 in MIPS

.include "io.asm"


.include "intr.asm"
.include "sched.asm"

.include "proc.asm"


.macro initial_system
	movi $sp,STACK
	calli StartProcess,0
.end_macro


.macro test
	calla CreateProcess,test_led
	callr StartProcess,$v0
.end_macro

test_led:
	lw $a0,PID
	addiu $a0,$a0,1
	_jal ioLED
	
	# _jal SoftSchedule
	j test_led

main:
	initial_system
	test
	test
	test
	j test_led



	#deadloop()

