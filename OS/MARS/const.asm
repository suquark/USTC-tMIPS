# interrupt service routine
.eqv ISR 0x2000
.eqv Switch_ISR 0x2000
.eqv Timer_ISR 0x2004
.eqv Soft_ISR 0x2008


# process schedule table
.eqv PST 0x2040
# 32 items, 4*32
.eqv PST_LEN 0x80
#(SB+SB_LEN) 0x120
.eqv PST_HIGHEST 0x20C0 


# PCB
## pid:4 status:4
.eqv PCB 0x2100
# (PCB * PCB_ITEM_LEN)
.eqv PCB_LEN 0x80
# Current Process,0x1C0;; 0 4 8 12 16...(PCB+PCB_LEN)
.eqv PID  0x2180

.eqv PSTATE_DEAD 0
.eqv PSTATE_READY 1
.eqv PSTATE_NEW 2
# .eqv PSTATE_RUNNING 2


# Saved stack
.eqv SSTACK 0x2200
.eqv SSTACK_LEN 0x80


.eqv STACK 0x2300
.eqv STACK_SIZE 0x80
.eqv STACK_SIZE_4 0x20

