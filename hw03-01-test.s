# ************************************************************************************
# FILE: hw03-01.s
#
# HOMEWORK: 3
# EXERCISE: 11
#
# DESCRIPTION: 
# asks user to enter a 32 bit unsigned integer and 
# calculates the parity bit using even parity
#
# AUTHOR: 
#
# ************************************************************************************

# ====================================================================================
# GLOBALS
# ====================================================================================

.globl main

# ====================================================================================
# EQUIVALENTS
# ====================================================================================
.eqv SYS_EXIT	    10 #SYS_EXIT is replaced by 10
.eqv SYS_PRINT_INT  1 # SYS_PRINT_INT is replaced by 1
.eqv SYS_PRINT_STR  4 # SYS_PRINT_STR is replaced by 4
.eqv SYS_READ_INT   5 # SYS_READ_INT is replaced by 5

# ====================================================================================
# MACROS
# ====================================================================================

# exit
.macro exit
  li  	$v0, SYS_EXIT
  syscall
.end_macro 

# print int
.macro prn(%reg)
  li  	$v0, SYS_PRINT_INT
  move  $a0, %reg
  syscall 
.end_macro 

# print string
.macro prs(%label)
  li	$v0, SYS_PRINT_STR
  la  	$a0, %label
  syscall
.end_macro 

# read int
.macro rdn(%reg)
  li 	$v0, SYS_READ_INT
  syscall
  move 	%reg, $v0
.end_macro 

# ====================================================================================
# DATA
# ====================================================================================
.data
test:	.asciiz		"\nThe pbit is: "
testr:	.asciiz		"\nThe return value is: "
word:	.asciiz 	"\nThe word is: "
worda:	.asciiz 	"\nThe word & 1 is: "
enter: 	.asciiz		"Enter a 32-bit unsigned int: "		
paris: 	.asciiz		"\nThe parity bit is: "

# ====================================================================================
# TEXT
# ====================================================================================
.text

main:

# set up stack frame
move 	$fp, $sp 		# make $fp point to where $sp points
addi	$sp, $sp, -8		# allocate 2 word on the stack frame

# prompt and take user input
prs(enter) 			# PrintString("Enter a 32-bit unsigned int: ")
rdn($t0)			# Read integer and store in $t0
sw 	$t0, 4($sp)		# user input (word) is stored at 4($sp)

# pbit = parity(word)
lw	$a0, 4($sp)		# $a0 = word
jal 	parity			# call parity function
sw 	$v1, 0($sp)		# store pbit from $v1 in 0($sp)

# print the parity bit
prs(paris)			# PrintString("The parity bit is: ")
lw $t1, 0($sp)			# $t1 = pbit
prn($t1)			# PrintInt(pbit)

# exit program
exit				# calls exit macro

parity:

# set up stack frame, word & 1 is -16($fp), pbit is -12($fp), word is -8($fp)
addi	$sp, $sp, -20		# allocate 5 words on the stack
sw 	$ra, 16($sp)		# save $ra
sw	$fp, 12($sp)		# save $fp
addi	$fp, $sp, 16		# anchor $fp to top of stack frame (points to $ra)

# put word on the stack
sw	$a0, -8($fp)		# -8($fp) <- word 

# pbit = word & 1
lw	$t1, -8($fp)		# $t1 <- word
andi 	$t2, $t1, 1		# $t2 = word & 1
sw	$t2, -12($fp)		# pbit = word & 1

# word = word >> 1
lw 	$t1, -8($fp)		# $t1 <- word
srl	$t1, $t1, 1		# shift word right by 1 bit
sw	$t1, -8($fp)		# word = word >> 1

# while loop
begin_loop: 			# while loop starts here
lw 	$t1, -8($fp)		# $t1 <- word
slt 	$t8, $zero, $t1		# if (0 < word) $t8 = 1, else $t8 = 0
beq 	$t8, $zero, end_loop	# if $t8 == 0, exit loop.
lw	$t1, -8($fp)		# load word into $t1
andi 	$t3, $t1, 1		# $t3 = word & 1
sw	$t3, -16($fp)		# word & 1 = $t3
lw	$t2, -12($fp)		# load pbit into $t2
lw 	$t3, -16($fp)		# load word & 1 into $t3
xor 	$t4, $t2, $t3		# $t4 = pbit XOR (word & 1)
sw	$t4, -12($fp)		# pbit = $t4
lw	$t1, -8($fp)		# load word into $t1
srl	$t1, $t1, 1		# shift $t1 right by 1
sw	$t1, -8($fp)		# word = $t1
j	begin_loop		# link to the beginning of the while loop
end_loop:			# come here (if word <= 0)

# return pbit
lw	$t4, -12($fp)		# t4 = pbit
move	$v1, $t4		# v1 = $t4

# destroy the stack for parity
lw	$ra, 0($fp)		# restore $ra
lw 	$fp, -4($fp)		# restore $fp
addi	$sp, $sp, 20		# destroy stack frame
jr 	$ra			# return
