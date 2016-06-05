# Test case 1
# This test is for testing process management & schedule

test_prior:
	call2i AdjustPriority,12,1
	# call2i AdjustPriority,0,1
	call2i AdjustPriority,4,2 # examine that a killed process will be ignored
	movi $a1,123
	calla CreateProcess,test_param #0 
	callr StartProcess,$v0 #  test Prior Inherit // call2i AdjustPriority,0,1
	
	j test_led
test_create_and_kill:
	calla CreateProcess,test_prior #12
	callr StartProcess,$v0
	calli KillProcess,0
	calli KillProcess,4
	j test_led
test_led:
	lw $a0,PID
	_jal ioLED
	j test_led
test_param:
	#lw $a0,PID
	# $a0 is given
	_jal ioLED
	j test_param
testcase1:
	calla CreateProcess,test_led # 4
	callr StartProcess,$v0
	
	calla CreateProcess,test_create_and_kill # 8 
	callr StartProcess,$v0
	
	j test_led
