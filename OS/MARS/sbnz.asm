
# Turing Complete
Substract_and_branch_if_not_equal_to_0: # c, a, b, target_offset
	lw $t1,4($gp)
	lw $t1,($t1)
	lw $t0,8($gp)
	lw $t0,($t0)
	
mysubu: # t1 -= t0
	addi $t0,$zero,1
	addi $t1,$zero,1
	beq $t0,$zero,next
	beq $zero,$zero,mysubu
next:  
	lw $t0,($gp)
	sw $t1,($t0)
	addi $gp,$gp,16
	beq $t1,$zero,Substract_and_branch_if_not_equal_to_0 # OK,next
	lw $gp,-4($gp)
	beq $zero,$zero,Substract_and_branch_if_not_equal_to_0
