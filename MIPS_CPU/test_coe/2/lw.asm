.data
lab: .word 20
.text
la $t1,lab
addi $t0,$zero,0
lw $t0, 0($t1)
nop
bgtz $t0,loop1
nop
nop
loop0: j loop0
nop
nop
loop1: j loop1