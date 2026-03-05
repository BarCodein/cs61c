.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    addi t0, zero, 0
    lw t1, 0(a0)
    addi t2, a1, 0
    addi t3, zero, 1
    addi t4, a0, 4

loop_start:
    bge t3, t2, loop_end
    lw t5, 0(t4)
    blt t5, t1, loop_continue
    mv t1, t5
    mv t0, t3
loop_continue:
    addi t3, t3, 1
    addi t4, t4, 4
    j loop_start
loop_end:
    mv a0,t0

    # Epilogue


    ret
