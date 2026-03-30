.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
	addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp) #memloc
    sw s2, 12(sp) #row
    sw s3, 16(sp) #col
    sw s4, 20(sp) 
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    #end
    

    #openfile
    mv a1, a0
    addi a2, zero, 1
    jal fopen
    mv s0, a0 #s0,filedesc

    #prepare
    #row
    li a0, 4
    jal malloc
    sw s2, 0(a0)
    mv a1, s0
    mv a2, a0
    li a3, 1
    li a4, 4
    jal fwrite
    #col
    li a0, 4
    jal malloc
    sw s3, 0(a0)
    mv a1, s0
    mv a2, a0
    li a3, 1
    li a4, 4
    jal fwrite
    
    addi s4, zero, 0 #counter
    
Loop:
    mul t0, s2, s3
    bge s4, t0, Loop_end
    mv a1, s0
    mv a2, s1
    li a3, 1
    li a4, 4
    jal fwrite

    addi s4, s4, 1
    addi s1, s1, 4

    j Loop
Loop_end:



    mv a1, s0
    jal fclose
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24

    ret
