.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)#row
    sw s4, 20(sp)#col
    mv s0, a0
    mv s1, a1
    mv s2, a2
    #end

    #openfile
    mv a1, a0
    addi a2, zero, 0
    jal fopen
    mv s0, a0 #s0,filedesc
    #readfile
    addi a0, zero, 4
    jal malloc
    mv s3, a0 #s3 pos1
    addi a0, zero, 4
    jal malloc
    mv s4, a0 #a4,s4 pos2

    addi a3, zero, 4
    mv a1, s0
    mv a2, s3
    jal fread #read row
    mv a2, s4
    mv a1, s0
    addi a3, zero, 4
    jal fread #read  col
    lw s3, 0(s3)
    lw s4, 0(s4)
    sw s3, 0(s1)
    sw s4, 0(s2)#load into oup
    mul a0, s3, s4
    slli a0, a0, 2
    jal malloc
    mv s1, a0 #loc
    #loop input
    addi s2, zero, 0 
Loop:
    
    mul t0, s3, s4
    
    bge s2, t0, Loop_end
    slli a2, s2, 2
    add a2, a2, s1

    #read
    mv a1, s0
    addi a3, zero, 4
    jal fread

    addi s2, s2, 1




    j Loop

Loop_end:
    jal fclose
    mv a0, s1
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)#row
    lw s4, 20(sp)#col
    addi sp, sp, 24
    ret
