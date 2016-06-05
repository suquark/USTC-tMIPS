test_prior:
	movi $a0,20
	movi $a1,1
	_jal AdjustPriority
	j test_led
test_create_and_kill:
	calla CreateProcess,test_prior #12
	callr StartProcess,$v0
	calli KillProcess,4
	j test_led
test_led:
	lw $a0,PID
	#addiu $a0,$a0,1
	_jal ioLED
	
	#_jal SoftSchedule
	j test_led
	
testcase1:
	calla CreateProcess,test_led # 4
	callr StartProcess,$v0
	
	calla CreateProcess,test_create_and_kill # 8 
	callr StartProcess,$v0
	
	j test_led