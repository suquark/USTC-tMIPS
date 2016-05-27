# This file provides advanced operations 

.macro for_until_bgt0 (%regIterator, %from, %to, %cmp, %out)
	addu %regIterator, $zero, %from
Loop:
	# %bodyMacroName ()
	add %regIterator, %regIterator, 1
	ble %regIterator, %to, Loop
.end_macro

# untest
.macro locate_eq0 (%base, %offset, %src)
	addu $v0,$zero,0
	dec %offset # for bgtz
Loop:
	bge $v0,%offset,end
	addu $t0,%base,$v0
	lw $t0,($t0)
	beq $t0,%src,end
	inc %offset # restore it
	j Loop
end:
.end_macro


.macro locate_eq_other0 (%base, %offset, %src, %skip)
	addu $v0,$zero,0 # begin
	#dec %offset # for bgtz
Loop:
	bge $v0,%offset,end # check range
	beq $v0,%skip,skip0 # skip the same
	addu $t0,%base,$v0 # calc the offset
	lw $t0,($t0) # get offset
	beq $t0,%src,end
skip0:
	inc $v0 # restore it
	j Loop
end:
.end_macro


.macro locate_eq_other_rr0 (%base, %offset, %src, %skip)
# [%skip+1, %offset)
	addu $v0,%skip,4 # begin
Loop:
	bge $v0,%offset,step2 # check range
	addu $t0,%base,$v0 # calc the offset
	lw $t0,($t0) # get offset
	beq $t0,%src,end
	inc $v0 # restore it
	j Loop
step2:
# [0, %skip)
	addu $v0,$zero,0 # begin
Loop2:
	bge $v0,%skip,end # check range
	addu $t0,%base,$v0 # calc the offset
	lw $t0,($t0) # get offset
	beq $t0,%src,end
	inc $v0 # restore it
	j Loop2
end:
.end_macro


.macro max(%reg,%rega,%regb)

.end_macro

#print_str ("test1")	#"test1" will be labeled with name "myLabel_M0"
#print_str ("test2")	#"test2" will be labeled with name "myLabel_M1"
#Implementing a simple for-loop:
	
# generic looping mechanism
.macro for (%regIterator, %from, %to, %bodyMacroName)
	add %regIterator, $zero, %from
Loop:
	%bodyMacroName ()
	add %regIterator, %regIterator, 1
	ble %regIterator, %to, Loop
.end_macro