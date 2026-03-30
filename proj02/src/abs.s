.globl abs

.text
# =================================================================
# FUNCTION: Given an int return its absolute value.
# Arguments:
# 	a0 (int) is input integer
# Returns:
#	a0 (int) the absolute value of the input
# =================================================================
abs:
    # Prologue

    # return 0
	bge a0, zero, end
	sub a0, a0, zero
    # Epilogue
end:
    ret
