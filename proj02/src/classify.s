.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    #Prologue
    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp) 
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp) #m1
    sw s7, 32(sp) #m2
    sw s8, 36(sp) #ip
    sw s9, 40(sp) #op
    sw s10, 44(sp) #oup
    mv s0, a0
    mv s1, a1
    mv s10, a2

    #pre
    lw s2, 4(s1) #&m1
    lw s3, 8(s1) #&m2
    lw s4, 12(s1) #&ip
    lw s9, 16(s1) #&op
    li a0, 32
    jal malloc
    mv s1, a0 #s1,array of rows and cols
    # mv a1, s2
    # jal print_str
    # mv a1, s3
    # jal print_str
    # mv a1, s4
    # jal print_str


	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0------
    mv a0, s2
    addi a1, s1, 0
    addi a2, s1, 4
    jal read_matrix
    mv s6, a0
    lw a1, 0(s1)
    lw a1, 4(s1)





    # Load pretrained m1
    mv a0, s3
    addi a1, s1, 8
    addi a2, s1, 12
    jal read_matrix
    mv s7, a0
    lw a1, 8(s1)
    lw a1, 12(s1)





    # Load input matrix
    mv a0, s4
    addi a1, s1, 16
    addi a2, s1, 20
    jal read_matrix
    mv s8, a0
    lw a1, 16(s1)
    lw a1, 20(s1)





    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    
    lw t0, 0(s1)
    lw t1, 20(s1)
    mul a0, t0, t1
    mv s3, a0 #s3 num of r1
    slli a0, a0, 2
    jal malloc

    mv a6, a0
    mv s2, a6 #s2 result1
    mv a0, s6
    lw a1, 0(s1)
    lw a2, 4(s1)
    mv a3, s8
    lw a4, 16(s1)
    lw a5, 20(s1)
    jal matmul

    mv a0, s2
    mv a1, s3
    jal relu #s2 result1 relu

    lw t0,8(s1)
    lw t1,20(s1)
    mul a0, t0, t1
    mv s5, a0
    slli a0, a0, 2
    jal malloc

    mv a6, a0
    mv s4, a6
    mv a0, s7
    lw a1, 8(s1)
    lw a2, 12(s1)
    mv a3, s2
    lw a4, 0(s1)
    lw a5, 20(s1)
    jal matmul













    


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    mv a0,s9
    mv a1, s4
    lw a2, 8(s1)
    lw a3, 20(s1)
    jal write_matrix





    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s4
    mv a1, s5
    jal argmax
    mv s0, a0
    mv a1, s0


    # Print classification
    bne s10, zero, ending
    mv a1, s0
    jal print_int
    li a1, '\n'
    jal print_char




    # Print newline afterwards for clarity

ending:
    #Relogue
    mv a0, s0
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)#row
    lw s4, 20(sp)#col
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    addi sp, sp, 48


    ret
