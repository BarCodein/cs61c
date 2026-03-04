.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    blt a1, zero, exit72
    blt a2, zero, exit72
    blt a4, zero, exit73
    blt a5, zero, exit73
    bne a2, a4, exit74
    # Prologue
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6
    addi t0, zero, 0 # t0 row
    addi t1, zero, 0 # t1 col



outer_loop_start:
    bge t0, s1, outer_loop_end
    addi t1, zero, 0
    
inner_loop_start:
    bge t1, s5, inner_loop_end
    mul t3, s5, t0
    add t3, t3, t1
    slli t3, t3, 2 
    add t3, t3, s6# relative pos d

    mul t4, s2, t0
    slli t4, t4, 2
    add t4, t4, s0 #r p s1

    add t5, zero, t1
    slli t5, t5, 2
    add t5, t5, s3 #r p s2 

    #precall
    addi sp, sp, -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    mv a0, t4
    mv a1, t5
    mv a2, s2
    addi a3, zero, 1
    mv a4, s5
    #call
    jal ra, dot
    #recall
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    addi sp, sp, 24
    sw a0,0(t3)

    addi t1, t1, 1
    j inner_loop_start

inner_loop_end:
    addi t0, t0, 1
    j outer_loop_start

outer_loop_end:


    # Epilogue
    
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)  
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 32
    addi a0, zero, 0
    ret

exit72:
    addi a0, zero, 72
    ret
exit73:
    addi a0, zero, 73
    ret
exit74:
    addi a0, zero, 74
    ret