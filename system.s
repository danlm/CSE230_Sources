#*******************************************************************************
# FILE: system.s
#
# HOMEWORK: 2
# EXERCISE: 2
#
# DESCRIPTION
# Declares several useful macros for print strings and integers and reading
# strings and integers. Also contains macros to load the value of a variable
# into a register and to store the value in a register to a variable.
#
# AUTHOR
#
#*******************************************************************************

#===============================================================================
# EQUIVALENTS
#===============================================================================

.eqv SYS_EXIT           10
.eqv SYS_PRINT_INT       1
.eqv SYS_PRINT_STR       4
.eqv SYS_READ_INT        5
.eqv SYS_READ_STR        8

#===============================================================================
# MACROS
#===============================================================================

#-------------------------------------------------------------------------------
# MACRO: exit
#
# DESCRIPTION
# Immediately terminates the program.
#
# PARAMETERS
# None
#
# MODIFIES
# $v0 - Contains Exit system call code
#-------------------------------------------------------------------------------
.macro exit
  li  $v0, SYS_EXIT
  syscall
.end_macro 

#-------------------------------------------------------------------------------
# MACRO: lv
#
# DESCRIPTION
# Load variable from memory.
#
# PARAMETERS
# %reg   - Register to store the variable in.
# %label - Label associated with the variable.
#
# MODIFIES
# $at - Stores the address of %label.
#-------------------------------------------------------------------------------
.macro lv(%reg,%label)
  la $at, %label
  lw %reg, 0($at)
.end_macro 

#-------------------------------------------------------------------------------
# MACRO: prn
#
# DESCRIPTION
# Print integer stored in register.
#
# PARAMETERS
# %reg - Register containing the int to be printed.
#
# MODIFIES
# $a0 - Stores the integer to be printed.
# $v0 - Stores the Print Integer system call code.
#-------------------------------------------------------------------------------
.macro prn(%reg)
  li  $v0, SYS_PRINT_INT
  move  $a0, %reg
  syscall 
.end_macro 

#-------------------------------------------------------------------------------
# MACRO: prs
#
# DESCRIPTION
# Print string.
#
# ARGS
# %label - The label associated with the string to be printed.
#
# MODIFIES
# $a0 - Contains the address of the string to be printed (%label).
# $v0 - Contains the Print String system call code.
#-------------------------------------------------------------------------------
.macro prs(%label)
  li  $v0, SYS_PRINT_STR
  la  $a0, %label
  syscall
.end_macro 

#-------------------------------------------------------------------------------
# MACRO: rdn
#
# DESCRIPTION
# Read integer from console and store in register.
#
# PARAMETERS
# %reg - Register to store the integer in.
#
# MODIFIES
# $v0 - Stores the Read Int system call code before the syscall. After the
#       syscall stores the integer that Read Int returns. This value needs to
#       be moved from $v0 to %reg.
#-------------------------------------------------------------------------------
.macro rdn(%reg)
  li  $v0, SYS_READ_INT
  syscall
  move %reg, $v0
.end_macro 

#-------------------------------------------------------------------------------
# MACRO: sv
#
# DESCRIPTION
# Store value in register into variable in memory.
#
# PARAMETERS
# %reg   - Register containing the int to be stored.
# %label - Label associated with the variable.
#
# MODIFIES
# $at - Stores the address of the variable (%label).
#-------------------------------------------------------------------------------
.macro sv(%reg,%label)
  la $at, %label
  sw %reg, 0($at)
.end_macro 