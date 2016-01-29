# Question 7 - Reverse string
# Programmer : Mehrshad Lotfi
.data

inputStr:	.asciiz		"This is a sample sentence for testing program "
outputStr:	.space		100
zero:		.byte		0
blank:		.asciiz		" "

.text

.globl main
main:

# This program is uses the LIFO ( last in first out ) ability of stack to reverse string 

	li		$t4, 0			# initialize $t4 to zero
	lb		$t3, zero		# set $t3 to zero for pushing into stack as byte
	addi		$sp, $sp, -1		# make stack pointer to point empty cell
	sb		$t3, ($sp)		# store zero in the beginning of stack

	la		$t0, inputStr		# load the address of input string
	lb		$t1, ($t0)		# load first char in $t1

scanChar:
	beq		$t1, 32, printWord	# 32 = blank character
	beq		$t1, 10, printWord	# 10 = new line character
	addi		$sp, $sp, -1		# make stack pointer to point empty cell
	sb		$t1, ($sp)		# store character in stack
	addi		$t0, $t0, 1		# add the source pointer by one
	lb		$t1, ($t0)		# load the next character in $t1
	b		scanChar		# loop to scan the next char	



nextWord:
	li		$v0, 4			# print_string
	la		$a0, blank
	syscall					

	addi		$t0, $t0, 1		# increment the source pointer
	lb		$t1, ($t0)		# scan the next character
	beq		$t4, 1, finished	# if there was no char it finished
	lb		$t3, zero		# initialize the beginning of stack with zero
	sb		$t3, ($sp)		# store character in stack
	b		scanChar		# scan the next character

printWord:
	li		$v0, 11			# initialize $v0 with 11
	lb		$a0, ($sp)		# get character from stack
	addi		$sp, $sp, 1		# pop from stack, increment stack pointer
	beq		$a0, 0, nextWord	# if we reached the end of stack scan the next word
	syscall
	b		printWord		# while the word in stack was not finished print word

	
finished:
	li		$v0, 10			# exit; $v0 = 1
	syscall

.end main