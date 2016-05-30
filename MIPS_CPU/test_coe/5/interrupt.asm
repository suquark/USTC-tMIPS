.data
int_e: .word 0xffff0100
.text
loop: j loop

addi $t0, $zero, 1
lw $t1, int_e
sw $t0, ($t1)
jr $k0
