.macro ref_output # $t9
    addiu $t9,$zero,0
    addiu $t9,$zero,-32768
    addiu $t9,$zero,-32768
.end_macro

.macro ref_interrupt # $t9
    addiu $t9,$zero,0
    addiu $t9,$zero,-32768
    addiu $t9,$zero,-32768
    addiu $t9,$zero,0x80
.end_macro


.macro sendout(%reg,%offset)
	ref_output
	sw %reg,%offset($t9)
.end_macro

.macro disable_interrupt


.end_macro


.macro enable_interrupt


.end_macro


ioLED: # $a0=content
    enter
    sendout $a0,0
    ret
