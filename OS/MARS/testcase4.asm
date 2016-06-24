# Test case 1
# This test is for testing process management & schedule
button_rt:
	_jal readSwitch  #v0
	beq $v0,$zero,button0
	movr $a1,$v0
	calla CreateProcess,test_param #adddd 
	callr StartProcess,$v0
  button0:
	j resume_routine
	
test_led:
	lw $a0,PID
	_jal ioLED
	_jal ioSSEG
	j test_led
test_param:
	#lw $a0,PID
	# $a0 is given
	_jal ioLED
	j test_param
testcase1:
	la $t0,button_rt  # ensure it it in low-space
	sw $t0,Switch_ISR
	
	#j SoftSchedule
	j test_led
