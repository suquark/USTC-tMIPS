# This file is about schedule



.macro force_switchto(%PID)
	sw %PID,PID # PID is most important
	# TODO: Here may be some problems. Disable the interrupt? 
	_jal resume_routine
.end_macro

.macro locate_other_ready_rr0 (%base, %offset, %src, %skip)
# [%skip+1, %offset)
	addiu $v0,%skip,4 # begin ....
Loop:
	_bge $v0,%offset,step2 # check range
	lw $t0,PCB($v0)
	bne $t0,PSTATE_READY,skip1 # process ready?
	addu $t0,%base,$v0 # calc the offset
	lw $t0,($t0) # get offset
	beq $t0,%src,end
skip1:
	inc $v0
	j Loop
step2:
# [0, %skip)
	addiu $v0,$zero,0 # begin
Loop2:
	_bge $v0,%skip,end # check range
	lw $t0,PCB($v0)
	bne $t0,PSTATE_READY,skip2 # process ready?
	addu $t0,%base,$v0 # calc the offset
	lw $t0,($t0) # get offset
	beq $t0,%src,end
skip2:
	inc $v0
	j Loop2
end:
.end_macro

.macro _LookupRR
	movi $a0,PST
	movi $a1,0x80
	lw $a2,PST_HIGHEST # get the current priority
	lw $a3,PID
	locate_other_ready_rr0($a0,$a1,$a2,$a3) # v0
.end_macro

resume_routine:
	# _cls_int
	_resume  # Will cause it to go back 
	
hard_schd:
	_LookupRR
	#_k_save
	#beq $v0,0x80,schd_skip # we will comeback
	movr $a0,$v0 # get next process
    	force_switchto($a0)
    

SoftSchedule:
	_LookupRR
	beq $v0,0x80,schd_skip
	_u_save
	movr $a0,$v0	
    	force_switchto($a0)
    schd_skip:
	jr $ra
