
.macro SetPriority(%pid,%pri) # PID, Priority
	addiu $t0, %pid, PST # use PID as offset
	sw %pri,($t0)
	
	# TODO: update the highest priority
.end_macro

# t0 t1
.macro InheritPriority(%pid) # PID
	lw $t0,PST_HIGHEST
	sw $t0,PST(%pid)  # use PID as offset
	# do not need to update the highest priority
.end_macro


.macro initial_process(%pid,%entry)
	mul $t0,%pid,STACK_SIZE_4
	addiu $t0,$t0,STACK
	sw %entry,($t0) # Construct the entry
	addiu $t0,$t0,-128  # ???
	sw $t0,SSTACK(%pid) # Save the stack
.end_macro

CreateProcess: # entry($a0) : PID
	# use $t0,$t2
	enter
	movi $t2,PCB
  create_process_loop:
	lw $t3,($t2)
	beqz $t3,create_process_done
	inc $t2
	j create_process_loop
  create_process_done:
  	movi $t3,PSTATE_NEW
  	sw $t3,($t2)
  	subiu $t2,$t2,PCB
  	InheritPriority($t2) # use t0 t1
  	initial_process($t2,$a0)
	movr $v0,$t2 # return PID
	ret

StartProcess: # PID($a0)
	enter
	movi $t9,PSTATE_READY
	sw $t9,PCB($a0)
	ret

KillProcess: # $a0 - PID
	enter
	sw $zero, PCB($a0) # PSTATE_DEAD
	ret
	
ExitProcess:
	enter # may be unnecessary
	lw $t0,PID
	callr KillProcess,$t0
	jal SoftSchedule # Never return
	ret
