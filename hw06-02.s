# sum.s
.data
a: .word 2, 3, 5, 7, 11, 13, 17, 19, 23
a_length: .word 9

.text
main:
move $fp, $sp # Make $fp point to tos
addi $sp, $sp, -8 # Allocate room for locals i and sum
sw $zero, -8($fp) # sum = 0
sw $zero, -4($fp) # i = 0
j loop_cond # Evaluate loop condition

loop_body:
sll $t0, $t0, 2 # $t0 <- 4 * i
la $s0, a # $s0 <- &a
add $s0, $s0, $t0 # $s0 <- &a[i]
lw $t1, 0($s0) # $t1 <- a[i]
lw $t2, -8($fp) # $t2 <- sum
add $t3, $t2, $t1 # $t3 <- sum + a[i]
sw $t3, -8($fp) # sum = sum + a[i]
lw $t0, -4($fp) # $t0 <- i
addi $t0, $t0, 1 # $t0 <- ++i
sw $t0, -4($fp) # ++i

loop_cond:
lw $t0, -4($fp) # $t0 <- i
la $s0, a_length # $s0 <- &a_length
lw $t1, 0($s0) # $t1 <- a_length
blt $t0, $t1, loop_body # Loop if i < a_length
li $v0, 1 # $v0 <- PrintInt code
lw $a0, -8($fp) # $a0 <- sum

syscall
exit:
li $v0, 10
syscall
