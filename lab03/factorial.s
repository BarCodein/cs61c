.globl factorial

.data
n: .word 7

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    #
    addi t0, x0, 1 # sum=1
    #Loop
Loop:
    beq a0, x0, exit
    mul t0, t0, a0 # sum=sum*k
    addi a0, a0, -1 #k--
    jal x0, Loop
exit:
    addi a0, t0, 0
    jr ra