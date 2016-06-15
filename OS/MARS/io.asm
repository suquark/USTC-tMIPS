.macro ref_output # $t9
    addi $t9,$zero,-32768 # split it
    addi $t9,$t9,-32768
.end_macro

# 0xFFFF0080
.macro ref_interrupt # $t9
    addi $t9,$zero,-32768
    addi $t9,$t9,-32768
    addi $t9,$t9,0x80
.end_macro

.macro ref_intr(%reg)
    addi %reg,$zero,-32768
    addi %reg,%reg,-32768
    addi %reg,%reg,0x80
.end_macro


.macro sendout(%reg,%offset)
	ref_output
	sw %reg,%offset($t9)
.end_macro


.macro readin(%reg,%offset)
	ref_output
	lw %reg,%offset($t9)
.end_macro

readSwitch:
	enter
	readin $v0,4 
	ret

ioSSEG: # $a0=content
    enter
    sendout $a0,8
    ret


ioLED: # $a0=content
    enter
    sendout $a0,0
    ret
