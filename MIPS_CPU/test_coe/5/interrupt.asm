.data
int_e: .word 0xffff0100
tick_int: .word 0xffff0084
.text
loop: j loop

lw $t1, tick_int
sw $zero, ($t1)
addi $t0, $zero, 1
lw $t1, int_e
sw $t0, ($t1)
jr $k0
