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

.include "system.s"	# include macros

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

prs(ent_a) 				# PrintString("Enter a? ")
rdn($t0)	 			# ReadInt and place word in $t0	
sv($t0, int_a)			# store word from $t0 under label int_a

prs(ent_b)				# PrintString("Enter b? ")
rdn($t0)	 			# ReadInt and place word in $t0	
sv($t0, int_b)			# store word from $t0 under label int_b

prs(ent_c)				# PrintString("Enter c? ") 
rdn($t0)	 			# ReadInt and place word in $t0	
sv($t0, int_c)			# store word from $t0 under label int_c

prs(ent_d) 				# PrintString("Enter d? ") 
rdn($t0)	 			# ReadInt and place word in $t0	
sv($t0, int_d)			# store word from $t0 under label int_d

lv($t1, int_a)			# loads int_a into $t1
lv($t2, int_b)			# loads int_b into $t2
lv($t3, int_c)			# loads int_c into $t3
lv($t4, int_d)			# loads int_d into $t4

add 	$t5, $t1, $t2	# $t5 = (a + b)
add	$t6, $t3, $t4		# $t6 = (c + d)
sub	$t1, $t5, $t6		# $t1 = $t5 - $t6

sv($t1, result)			# stores address of $t1 under label result
prs(print)				# prints "The answer is "
lv ($t0, result)		# loads result into $t0 
prn($t0)				# prints integer in $t0

exit					# calls exit macro