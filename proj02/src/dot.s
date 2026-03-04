.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue
    addi sp, sp, -4
    sw s0, 0(sp)
    addi s0, zero, 0
    addi t3, zero, 0
    slli a3, a3, 2
    slli a4, a4, 2

loop_start:
    bge t3, a2, loop_end
    lw t0, 0(a0)
    lw t1, 0(a1)
    mul t2, t1, t0
    add s0, s0, t2
    add a0, a0, a3
    add a1, a1, a4
    addi t3, t3, 1
    j loop_start

loop_end:
    mv a0,s0

    lw s0, 0(sp)
    addi sp, sp, 4

    # Epilogue

    
    ret
