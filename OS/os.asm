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
	for ($t4, 1, 31, test) # [1,31]
	calli KillProcess,16
	
	GetPID $a0
	movi $a1,2
	jal AdjustPriority
	
	movi $a0,12
	movi $a1,2
	jal AdjustPriority
	
	movi $a0,20
	movi $a1,1
	jal AdjustPriority
	
	lw $t0,PID
	print_int $t0
	print_str "\n"
	jal SoftSchedule # hhhhhh
	
	lw $t0,PID
	print_int $t0
	print_str "\n"
	
	calli KillProcess,0
	calli KillProcess,12
	calli KillProcess,20
	jal SoftSchedule
	lw $t0,PID
	print_int $t0
	print_str "\n"
		
	
	jal ExitProcess
	jal SoftSchedule
	j func
	