.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    add t0, x0, x0#count=0
    addi t1, a1, 0


loop_start:
    bge t0, t1, loop_end # if t0 >= t1loop_endtarget
    lw t2, 0(a0)
    bge t2, zero, loop_continue
    addi t2, zero, 0
    

loop_continue:
    sw t2, 0(a0)
    addi a0, a0, 4
    addi t0, t0, 1
    j loop_start

loop_end:


    # Epilogue

    
	ret
