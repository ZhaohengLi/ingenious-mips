__start:
addiu $1, $0, 0x1
addiu $2, $0, 0x1
addiu $3, $0, 0
addiu $4, $0, 10
addiu $5, $0, 0x8040
sll $5, $5, 16
sw $1, 0($5)
addiu $5, $5, 4
sw $2, 0($5)
loop:
addu $3, $2, $1
addiu $5, $5, 4
sw $3, 0(5)
addiu $1, $2, 0
addiu $2, $3, 0
addiu $4, 0xFFFF
bgtz $4, loop
nop
jr $31
nop
