.text
addi $t1,$zero,5
addi $t2,$zero,0
addi $t3,$zero,5
beq $t1,$t3,label1
loop1: j loop1
label1: beq $t1,$t2,loop1
bne $t1,$t2,label2
loop2: j loop2
label2: bne $t1,$t3,loop2
nop
nop
nop
nop
nop
nop
loop3: j loop3 