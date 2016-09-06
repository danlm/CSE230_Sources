#*******************************************************************************
# FILE: hw03-02.s
#
# HOMEWORK: 3
# EXERCISE: 12
#
# DESCRIPTION
# The program asks the user to enter an integer n that is greater than or equal to 2. 
# It determines if n is prime or composite (not prime) and displays a message to that effect. 
# To test an odd number for primality, we only need to test the odd divisors from 3 up to the square root of n.
#
# AUTHOR
#
#*******************************************************************************

# ====================================================================================
# GLOBALS
# ====================================================================================
.globl main

#===============================================================================
# EQUIVALENTS
#===============================================================================

.eqv SYS_EXIT           10
.eqv SYS_PRINT_INT       1
.eqv SYS_PRINT_STR       4
.eqv SYS_READ_INT        5
.eqv SYS_READ_STR        8

#================================================================================
# DATA
#================================================================================
.data
s_prompt:  .asciiz  "Enter an integer (>= 2)? "
s_prime:   .asciiz  " is prime.\n"
s_comp:    .asciiz  " is composite.\n"

#================================================================================
# TEXT
#================================================================================
.text
main:
# set up stack frame
    move 	$fp, $sp 		# make $fp point to where $sp points
    addi	$sp, $sp, -8		# allocate 2 word on the stack frame
    
# printf("Enter an integer (>= 2)? ")
    li      	$v0, SYS_PRINT_STR      # $v0 <- PrintString code
    la      	$a0, s_prompt           # $a0 <- addr of s_prompt
    syscall                             # Call PrintString()

# scanf("%d", &n)
    li      	$v0, SYS_READ_INT       # $v0 <- ReadInt code
    syscall                             # Call ReadInt()
    move    	$s0, $v0                # n <- ReadInt
    sw		$s0, 4($sp)		# $s0 = n
    
# isPrime(n)
    jal 	isPrime
    sw		$s1, 0($sp)		# 8($sp) <- $s1
    
# PrintInt(n)
    li      	$v0, SYS_PRINT_INT      # $v0 <- PrintInt code
    move    	$a0, $s0                # $a0 <- n
    syscall                             # PrintInt(n)

# if is_prime == 0 goto false clause 
    beq     	$s1, $zero, false_clause # If is_prime is 0 go to false 

# PrintString(" is prime.\n")
    li      	$v0, SYS_PRINT_STR       # $v0 <- PrintString code
    la      	$a0, s_prime            # $a0 <- addr of s_prime
    syscall                             # Call PrintString()
    j       	end_if2                     # Skip over false clause

# PrintString(" is prime.\n")
false_clause:
    li      	$v0, SYS_PRINT_STR      # $v0 <- PrintString code
    la      	$a0, s_comp             # $a0 <- addr of s_comp
    syscall                             # Call PrintString()
end_if2:

# Terminate the program.
    li      	$v0, SYS_EXIT           # $v0 <- Exit code
    syscall                             # Call Exit()
    
isPrime:
    # set up stack frame, word & 1 is -16($fp), pbit is -12($fp), word is -8($fp)
    addi	$sp, $sp, -20		# allocate 5 words on the stack
    sw 		$ra, 16($sp)		# save $ra
    sw		$fp, 12($sp)		# save $fp
    addi	$fp, $sp, 16		# anchor $fp to top of stack frame (points to $ra)

    # put n on the stack
    sw		$s0, -8($fp)		# -8($fp) <- n
    lw		$t1, -8($fp)		# $t1 <- -8($fp)
    li      	$t0, 2                  # save 2
    
    # if n == 2, return true
    li		$s1, 1			# boolean isPrime = 1
    beq		$t1, $t0, return_isPrime# jump to return statement
    
    # if n % 2 = 0, return false
    div		$t1, $t0		# HI <- n % 2
    mfhi	$t2
    beqz	$t2, isPrime_false	# jump to return statement
    
    # Test the odd divisors from 3 to sqrt(n)
    jal		sqrt
    sw		$v1, -12($fp)		# -12($fp) <- $v1
    lw		$t2, -12($fp)		# $t2 <- -12($fp)
    lw		$t1, -8($fp)		# $t1 <- -8($fp)
    li		$t3, 3			# div = 3
    
test_loop:
    bgt		$t3, $t2, return_isPrime# if div > sqrt(n), exit loop
    div		$t1, $t3		# HI <- n % div
    mfhi	$t4
    beqz 	$t4, isPrime_false	
    add		$t3, $t3, $t0		# div += 2
    j		test_loop

isPrime_false:
    li		$s1, 0			# isPrime = false
    
return_isPrime:
    # Destroy stack frame
    lw     $ra, 0($fp)   # Restore $ra
    lw     $fp, -4($fp)  # Restore $fp
    addi   $sp, $sp, 20  # Destroy stack frame 
    jr     $ra           # Return
 
sqrt:
    # No stack frame necessary for a leaf procedure
    
    # xprev = n / 2
    move 	$t1, $s0		# $t1 <- n
    div     	$t1, $t0                # LO <- n / 2
    mflo    	$t2                     # $t2 <- xprev
    
    # subtractor = (xprev * xprev - n) / (2 * xprev)
    mul		$t3, $t2, $t2		# $t3 <- xprev * xprev
    sub		$t3, $t3, $t1		# $t3 <- (xprev * xprev) - n
    div		$t3, $t2		# LO <- ((xprev * xprev) - n) / xprev
    mflo	$t3			# $t3 <- LO
    div		$t3, $t0		# LO <- $t3 / 2
    mflo	$t3			# $t3 <- LO
    
    # xnext = xprev - subtractor
    sub		$t4, $t2, $t3		# t4 <- xnext
    
loop_entry:
    # abs(xnext - xprev)
    sub		$t5, $t4, $t2		# $t5 <- (xnext - xprev)
    abs		$t5, $t5		# abs($t5)
    blez 	$t5, xnext_return	# If $t5 is less than or equal to 0 go to return
    
    # set xprev = xnext
    move	$t2, $t4
    
    # recalculate xnext
    # subtractor = (xprev * xprev - n) / (2 * xprev)
    mul		$t3, $t2, $t2		# $t3 <- xprev * xprev
    sub		$t3, $t3, $t1		# $t3 <- (xprev * xprev) - n
    div		$t3, $t2		# LO <- ((xprev * xprev) - n) / xprev
    mflo	$t3			# $t3 <- LO
    div		$t3, $t0		# LO <- $t3 / 2
    mflo	$t3			# $t3 <- LO
    
    # xnext = xprev - subtractor
    sub		$t4, $t2, $t3		# t4 <- xnext
    j		loop_entry
    
xnext_return:
    move	$v1, $t4		# v1 = $t4
    jr		$ra
    
    
    
    

    
    

    
  
   
    