.macro ref_output # $t9
    addiu $t9,$zero,-32768 # split it
    addiu $t9,$t9,-32768
.end_macro

# 0xFFFF0080
.macro ref_interrupt # $t9
    addiu $t9,$zero,-32768
    addiu $t9,$t9,-32768
    addiu $t9,$t9,0x80
.end_macro




.macro sendout(%reg,%offset)
	ref_output
	sw %reg,%offset($t9)
.end_macro




ioLED: # $a0=content
    enter
    sendout $a0,0
    ret
