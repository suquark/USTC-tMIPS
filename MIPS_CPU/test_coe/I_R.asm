.data
a: .word 3
b: .word 3
.text
lw $t0,a
lw $t1,b
add $t2,$t0,$t1