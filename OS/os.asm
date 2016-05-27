.include "const.asm"
.include "macro.asm"
.include "utils.asm"
.include "sysutil.asm"

j main

.include "intr.asm"
.include "sched.asm"

.include "proc.asm"



.macro initial_system
	movi $sp,STACK
	calli StartProcess,0
.end_macro


SoftSchedule:
	_LookupRR
	beq $v0,0x80,schd_skip
	_u_save
	movr $a0,$v0	
    	force_switchto($a0)
    schd_skip:
	jr $ra

func:
	lw $t0,PID
	print_int $t0
	print_str "\n"
	
	jal SoftSchedule
	j func

.macro test
	calla CreateProcess,func
	callr StartProcess,$v0
.end_macro

main:
	initial_system
	for ($t4, 1, 31, test)
	calli KillProcess,16
	jal ExitProcess
	j func
	