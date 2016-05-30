### Interrupt Module

# WARNING: do not interrupt it!!!!!
.macro _k_save
	push $k0  # Must save PC first!!!!!!!
	saveall
	lw $t9,PID
	sw $sp,SSTACK($t9)	
.end_macro

.macro _u_save
	push $ra  # Must save PC first!!!!!!!
	saveall
	lw $t9,PID
	sw $sp,SSTACK($t9)
.end_macro


# it is asked to be called by the process itself
.macro saveall
sw $1,($sp)
sw $2,-4($sp)
sw $3,-8($sp)
sw $4,-12($sp)
sw $5,-16($sp)
sw $6,-20($sp)
sw $7,-24($sp)
sw $8,-28($sp)
sw $9,-32($sp)
sw $10,-36($sp)
sw $11,-40($sp)
sw $12,-44($sp)
sw $13,-48($sp)
sw $14,-52($sp)
sw $15,-56($sp)
sw $16,-60($sp)
sw $17,-64($sp)
sw $18,-68($sp)
sw $19,-72($sp)
sw $20,-76($sp)
sw $21,-80($sp)
sw $22,-84($sp)
sw $23,-88($sp)
sw $24,-92($sp)
sw $25,-96($sp)
sw $26,-100($sp)
sw $27,-104($sp)
sw $28,-108($sp)
# sw $29,-112($sp) # will be overrided later
sw $30,-116($sp)
sw $31,-120($sp)
addiu $sp,$sp,-124  # -4 for 
.end_macro

# %PID is asked to be reg 
.macro loadall
lw $1, 124($sp)
lw $2, 120($sp)
lw $3, 116($sp)
lw $4, 112($sp)
lw $5, 108($sp)
lw $6, 104($sp)
lw $7, 100($sp)
lw $8, 96($sp)
lw $9, 92($sp)
lw $10,88($sp)
lw $11, 84($sp)
lw $12, 80($sp)
lw $13, 76($sp)
lw $14, 72($sp)
lw $15, 68($sp)
lw $16, 64($sp)
lw $17, 60($sp)
lw $18, 56($sp)
lw $19, 52($sp)
lw $20, 48($sp)
lw $21, 44($sp)
lw $22, 40($sp)
lw $23, 36($sp)
lw $24, 32($sp)
lw $25, 28($sp)
lw $26, 24($sp)
lw $27, 20($sp)
lw $28, 16($sp)
# lw $29, 12($sp)  # do not destroy it !!!
lw $30, 8($sp)
lw $31, 4($sp)
addi $sp,$sp,124
.end_macro

.macro _resume	
	# resume the stack first for restore
	lw $t9,PID
	lw $sp,SSTACK($t9)
	loadall
	# Ok, last we branch to origin
	### TODO: disable interrupt, to protect $t9 (it will be destoryed in another resume)
	pop $t9
	jr $t9
	### TODO: enable interrupt
.end_macro

interrupt_routine:
	_k_save
	# _en_int