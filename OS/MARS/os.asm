.include "const.asm"
.include "macro.asm"
.include "utils.asm"
.include "sysutil.asm"

# ^001001 -> ^001000
# 100001$ -> 100000$

j main 
j interrupt_routine # Interrpt routine, 0x80000180 in MIPS

.include "io.asm"
.include "intr.asm"
.include "sched.asm"
.include "proc.asm"

# programs
.include "testcase2.asm"
.include "testcase1.asm"
.include "sbnz.asm"


# -> entrypoint
main:
	initial_system
	j testcase1

