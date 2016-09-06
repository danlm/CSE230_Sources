# ************************************************************************************
# FILE: hw02-01.s
#
# HOMEWORK: 2
# EXERCISE: 1
#
# DESCRIPTION: 
# prompts user for 4 signed integers  a, b, c, d
# computes (a + b) - (c + d) and displays the quantity
#
# AUTHOR: 
#
# ************************************************************************************

# ====================================================================================
# EQUIVALENTS
# ====================================================================================
.eqv SYS_PRINT_INT  1 # SYS_PRINT_INT is replaced by 1
.eqv SYS_PRINT_STR  4 # SYS_PRINT_STR is replaced by 4
.eqv SYS_READ_INT   5 # SYS_READ_INT is replaced by 5

# ====================================================================================
# DATA
# ====================================================================================
.data
int_a:	.word 	0
int_b:	.word	0
int_c:	.word	0
int_d: 	.word 	0
result:	.word	0
ent_a: 	.asciiz	"Enter a? "		
ent_b: 	.asciiz	"Enter b? "
ent_c: 	.asciiz	"Enter c? "
ent_d: 	.asciiz	"Enter d? "
print:	.asciiz "The answer is "

# ====================================================================================
# TEXT
# ====================================================================================
.text
main:
# PrintString("Enter a? ") 
li 	$v0, SYS_PRINT_STR	# $v0 = PrintString code
la	$a0, ent_a		# $a0 = address of string "Enter a? "
syscall				# call PrintString

# ReadInt()	
li	$v0, SYS_READ_INT	# $v0 = ReadInt code
syscall				# call ReadInt
la	$t0, int_a		# $t0 = address of int_a
sw	$v0, 0($t0)		# Read Int is assigned to int_a

# PrintString("Enter b? ") 
li 	$v0, SYS_PRINT_STR	# $v0 = PrintString code
la	$a0, ent_b		# $a0 = address of string "Enter b? "
syscall				# call PrintString

# ReadInt()	
li	$v0, SYS_READ_INT	# $v0 = ReadInt code
syscall				# call ReadInt
la	$t1, int_b		# $t1 = address of int_b
sw	$v0, 0($t1)		# Read Int is assigned to int_b

# PrintString("Enter c? ") 
li 	$v0, SYS_PRINT_STR	# $v0 = PrintString code
la	$a0, ent_c		# $a0 = address of string "Enter c? "
syscall				# call PrintString

# ReadInt()	
li	$v0, SYS_READ_INT	# $v0 = ReadInt code
syscall				# call ReadInt
la	$t2, int_c		# $t2 = address of int_c
sw	$v0, 0($t2)		# Read Int is assigned to int_c

# PrintString("Enter d? ") 
li 	$v0, SYS_PRINT_STR	# $v0 = PrintString code
la	$a0, ent_d		# $a0 = address of string "Enter d? "
syscall				# call PrintString

# ReadInt()	
li	$v0, SYS_READ_INT	# $v0 = ReadInt code
syscall				# call ReadInt
la	$t3, int_d		# $t3 = address of int_d
sw	$v0, 0($t3)		# Read Int is assigned to int_d

# Do some math
la 	$t0, int_a		# $t0 = address of int_a
lw	$t1, 0($t0)		# $t1 = int_a
la 	$t0, int_b		# $t0 = address of int_b
lw	$t2, 0($t0)		# $t2 = int_b
la 	$t0, int_c		# $t0 = address of int_c
lw	$t3, 0($t0)		# $t3 = int_c
la 	$t0, int_d		# $t0 = address of int_d
lw	$t4, 0($t0)		# $t4 = int_d
add 	$t5, $t1, $t2		# $t4 = (a + b)
add	$t6, $t3, $t4		# $t5 = (c + d)
sub	$t1, $t5, $t6		# $t1 = $t5 - $t6

# Store math into result
la 	$t0, result		# $t0 = address of result
sw	$t1, 0($t0)		# $t1 = result

# PrintString("The answer is") 
li 	$v0, SYS_PRINT_STR	# $v0 = PrintString code
la	$a0, print		# $a0 = address of string "The answer is "
syscall				# Calls PrintString

# PrintInt(result)
li 	$v0, SYS_PRINT_INT	# $v0 = PrintInt code
la	$t0, result		# $t0 =  address of result
lw	$t1, 0($t0)		# $t1 = result
move 	$a0, $t1		# $a0 = $t1
syscall				# Calls PrintInt

# exit
li	$v0, 10			# $v0 = exit code
syscall 			# call Exit()
