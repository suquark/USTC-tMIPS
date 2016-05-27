# This file is about schedule

.macro hard_schd
	_LookupRR
	beq $v0,0x80,schd_skip
	movr $a0,$v0
    	force_switchto($a0)
    schd_skip:
.end_macro

.macro force_switchto(%PID)
	sw %PID,PID
	# TODO: Here may be some problems. Disable the interrupt? 
	jal resume_routine
.end_macro

.macro locate_other_ready_rr0 (%base, %offset, %src, %skip)
# [%skip+1, %offset)
	addu $v0,%skip,4 # begin
Loop:
	bge $v0,%offset,step2 # check range
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
	addu $v0,$zero,0 # begin
Loop2:
	bge $v0,%skip,end # check range
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
	lw $a2,PST_HIGHEST
	lw $a3,PID
	locate_other_ready_rr0($a0,$a1,$a2,$a3) # v0
.end_macro




	

resume_routine:
	# _cls_int
	_resume  # Will cause it to go back 