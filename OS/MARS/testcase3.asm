# Test case 3
# This test is for testing process management & schedule
#button_rt:
#	_jal readSwitch  #v0
#	movr $t0,16
#	movr $t1,64
#	_bge $t0,$v0,set1
#	_bge $v0,$t1,set2
	
#  	call2i AdjustPriority,0,0
#  	call2i AdjustPriority,4,0
#	j resume_routine
#  set1:
#  	call2i AdjustPriority,0,1
#  	call2i AdjustPriority,4,0
#	j resume_routine
#  set2:
#  	call2i AdjustPriority,0,0
#  	call2i AdjustPriority,4,1
#	j resume_routine

listen_sw:
	get_clock
	movi $t0,100
	_bge $t0,$v0,listen_sw
	movi $t0,200
	_bge $v0,$t0,listen_sw
	_jal readSwitch  #v0
	sw $v0,SHM
	# beq $v0,$zero,button0
	addi $v0,$v0,1
	callr ioLED, $v0
	
	j listen_sw


listen_shm:
	get_clock
	movi $t0,300
	_bge $t0,$v0,listen_shm
	clear_clock
	lw $v0,SHM 
	addi $v0,$v0,-1
	callr ioLED $v0
	j listen_shm 



testcase3:
#	la $t0,button_rt  # ensure it it in low-space
#	sw $t0,Switch_ISR
	
	calla CreateProcess,listen_shm # 4
	callr StartProcess,$v0
	
	j listen_sw
