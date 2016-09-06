#*******************************************************************************
# FILE: hw02-04.s
#
# HOMEWORK: 2
# EXERCISE: 4
#
# DESCRIPTION
# This program finds and prints the maximum value in an array.
#
# AUTHOR
#
#*******************************************************************************

#================================================================================
# Macro import
#================================================================================
.include "system.s"

#================================================================================
# DATA
#================================================================================
.data
aLen:	     .word    8  			# Define int var aLen to store the length of array a.
a:	     .word    10, 30, 15, 7, 12, 18, 100, 2	# Define int array a[6] = { 10, 30, 15, 7, 12, 18 }
maxValue:    .word    0				# Define int var maxValue to store the greatest entry
i:    	     .word    0				# Define int var i to store the index 
s_value:     .asciiz  "The max value in a is "  # Define string to print out the message

#================================================================================
# TEXT
#================================================================================
.text
main:	     
    la 	     $t0, a            # put address of a into $t0
    lw       $t1, 0($t0)       # get the value from the index 0
    sv($t1,maxValue) 	       # store the value in maxValue
    
    lv($t2,i)		       # i = 0
    lv($s0,aLen)	       # $s0 <- array length
    j check_cond	       # Go check the loop condition
    
begin_loop:		       # Come here when i < aLen
    move     $t3, $t2          # get the index from $t2  
    add      $t3, $t3, $t3     # double the index
    add      $t3, $t3, $t3     # double the index again (now 4x)
    add      $t4, $t3, $t0     # combine the two components of the address
    lw       $t5, 0($t4)       # get the value from the index
    slt	     $t6, $t5, $t1     # set $t6 to zero if new value is greater
    bnez     $t6, end_if       # skip the conditional if value is not greater
    move     $t1, $t5
    end_if:
    addi     $t2, $t2, 1       # Increment i
check_cond: 		       # Check the loop condition
    blt $t2, $s0, begin_loop   # If i < aLen execute the loop body

    prs(s_value)
    prn($t1)	
    exit      
    
    
