func:
	lw $t0,PID
	print_int $t0
	print_str "\n"
	
	_jal SoftSchedule
	j func

test2:
	for ($t4, 1, 31, test) # [1,31]
	calli KillProcess,16
	
	GetPID $a0
	movi $a1,2
	_jal AdjustPriority
	
	movi $a0,12
	movi $a1,2
	_jal AdjustPriority
	
	movi $a0,20
	movi $a1,1
	_jal AdjustPriority
	
	lw $t0,PID
	print_int $t0
	print_str "\n"
	_jal SoftSchedule # hhhhhh
	
	lw $t0,PID
	print_int $t0
	print_str "\n"
	
	calli KillProcess,0
	calli KillProcess,12
	calli KillProcess,20
	_jal SoftSchedule
	lw $t0,PID
	print_int $t0
	print_str "\n"
	
	_jal ExitProcess
	_jal SoftSchedule
	j func
