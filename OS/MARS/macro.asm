# This file provide extended ISA 

.macro dec(%reg)
addiu %reg,%reg,-4
.end_macro

.macro inc(%reg)
addiu %reg,%reg,4
.end_macro

.macro push (%reg)
	sw %reg,($sp)
	dec $sp
.end_macro

.macro push (%reg1,%reg2)
	push %reg1
	push %reg2
.end_macro

.macro pop (%reg)
	inc $sp
	lw %reg,($sp)
.end_macro

.macro pop (%reg1,%reg2)
	pop %reg1
	push %reg2
.end_macro


.macro enter
	push $ra
.end_macro

.macro ret
	pop $ra
	jr $ra
.end_macro

.macro iret9
	pop $t9
	jr $t9
.end_macro

.macro _sub(%regd,%rega,%regb)
	not %regb,%regb
	addu %regd,%rega,%regb
	addiu %regd,%regd,1
	not %regb,%regb  # restore it
.end_macro

.macro _bge(%rega,%regb,%label)
	slt $at,%rega,%regb
	beq $at,$zero,%label
.end_macro

# will destory t0
.macro bgt0(%rega,%regb,%label)
	addu $t0,%rega,%regb
	bgtz $t0,%label
.end_macro

.macro movi(%reg,%imm)
	addiu %reg,$zero,%imm
.end_macro

.macro movr(%reg,%reg2)
	addu %reg,$zero,%reg2
.end_macro

.macro pushp(%pt)
	addiu $t0,$zero,%pt
	push %pt
.end_macro

.macro zero(%reg)
	addiu %reg,$zero,0
.end_macro

.macro _jal(%addr)
	la $ra,jump_back
	j %addr
jump_back:
.end_macro

.macro callr(%func,%arg0)
	movr $a0,%arg0
	_jal %func
.end_macro

.macro calli(%func,%arg0)
	movi $a0,%arg0
	_jal %func
.end_macro

.macro calla(%func,%addr)
	la $a0,%addr
	_jal %func
.end_macro

# mul $t0,%pid,STACK_SIZE_4
.macro _muli1(%dst,%a,%imm)
	zero %dst
	movr $t1,%a
loop:
	beq $t1,0,end
	addiu %dst,%dst,%imm
	addiu $t1,$t1,-1
	j loop
end:
.end_macro

.macro _nop
	addiu $zero,$zero,0
.end_macro

.macro _nop5
	addiu $zero,$zero,0	
	addiu $zero,$zero,0	
	addiu $zero,$zero,0	
	addiu $zero,$zero,0
	addiu $zero,$zero,0
.end_macro
