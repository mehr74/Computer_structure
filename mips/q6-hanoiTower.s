.data

numberOfMoves:	.word		3

labelA:		.asciiz		"A"
labelB:		.asciiz		"C"
labelC:		.asciiz		"B"

from:		.asciiz		"Move From "
to:		.asciiz		" to "

newline:	.asciiz		".\n"
result:		.asciiz		"\nNumber of moves:"

tempSpace:	.word		0

.text
.globl	main
main:
	# store number of moves in $t0
	li	$t0, 0
	# call hanoi tower with initial parameters
	lw	$a0, numberOfMoves
	la	$a1, labelA
	la	$a2, labelB
	la	$a3, labelC
	jal	hanoiTowerRecursion
	
	li	$v0, 4		# print_string "Number of moves
	la	$a0, result
	syscall
	
	move	$a0, $t0	# print_int numberofmoves
	li	$v0, 1
	syscall

	# Return to os control point : 
	li	$v0, 10
	syscall
.end main


.globl	hanoiTowerRecursion
.ent	hanoiTowerRecursion
##########################################################
#
# HanoiTowerRecursion:
# ! set $a0 to numberofmoves
# ! set $a1 to source peg label
# ! set $a2 to extra peg label
# ! set $a3 to destination peg label
#
##########################################################
hanoiTowerRecursion:

	# store initial values of registers used in subroutine into stack
	addi	$sp,$sp,-4	# make stack pointer to point empty word
	sw	$ra,($sp)	# store ra ( the return address) in stack
	addi	$sp,$sp,-4	# make stack pointer to point empty word
	sw	$fp,($sp)	# store fp in stack
	addi	$sp,$sp,-4	# make stack pointer to point empty word	
	sw	$s0,($sp)	# store $s0 in stack
	addi	$sp,$sp,-4	# make stack pointer to point empty word
	sw	$s1,($sp)	# store $s1 in stack
	addi	$sp,$sp,-4	# make stack pointer to point empty word		
	sw	$s2,($sp)	# store $s2 in stack
	addi	$sp,$sp,-4	# make stack pointer to point empty word		
	sw	$s3,($sp)	# store $s3 in stack
	addi	$sp,$sp,-4	# make stack pointer to point empty word	
		
	addi	$fp, $sp, 32	
	beq	$a0, $zero, hanoiFinished	# if number of disk = 0 , finished hanoi tower
	
	# Save parameters before calling hanoiTowerAgain : 
	sw	$a0,($sp)	# push number of disk in stack
	addi	$sp,$sp,-4	# make stack pointer to point empty word

	sw	$a1,($sp)	# push source peg label	
	addi	$sp,$sp,-4	# make stack pointer to point empty word	
	
	sw	$a2,($sp)	# push extra peg label	
	addi	$sp,$sp,-4	# make stack pointer to point empty word	

	sw	$a3,($sp)	# push destination peg label	
	addi	$sp,$sp,-4	# make stack pointer to point empty word	

	addi	$a0,$a0,-1	# decrement number of moves	

	# exchange $a2 , $a3 values
	sw	$a2, tempSpace	# store $a2 in tempSpace
	move	$a2, $a3	# move $a3 value into $a2 vlaue
	lw	$a3, tempSpace	# load $a3 from memory

	jal	hanoiTowerRecursion # call hanoi tower again		

	addi	$sp,$sp,4	# make 	stack pointer to point the last word stored
	lw	$s0,($sp)	# restore $s0 value to its value before calling hanoiTowerRecursion
	addi	$sp,$sp,4	# make stack pointer to point the last word stored
	lw	$s1,($sp)	# restore $s1 value to its value before calling hanoiTowerRecursion
	addi	$sp,$sp,4	# make stack pointer to point the last word stored
	lw	$s2,($sp)	# restore $s2 value to its value before calling hanoiTowerRecursion
	addi	$sp,$sp,4	# make stack pointer to point the last word stored	
	lw	$s3,($sp)	# restore $s3 value to its value before calling hanoiTowerRecursion
	
	###################
	# print current move
	li	$v0, 4 		# print_string "move from "
	la	$a0, from    			
	syscall

	move	$a0, $s2    	# print_string source label
	syscall
  			
	la	$a0, to   	# print_string	" To "	
	syscall
     			
	move	$a0, $s1    	# print_string	destination label
	syscall
		
	la	$a0, newline    # print_string "\n"			
	syscall 
	#
	##################
	
	addi	$t0, $t0, 1	# add to number of moves

	# Initialize values of $a0, $a1, $a2, $a3 to call hanoi tower again
	addi 	$a0,$s3,-1
	move 	$a1, $s0
	move 	$a2, $s1
	move	$a3, $s2
	jal 	hanoiTowerRecursion

	

hanoiFinished:
	# restore initial values of registers before calling hanoi tower from stack
	addi	$sp,$sp,4	# make stack pointer to point last word pushed		
	lw	$s3,($sp)	# load $s3 initial value from stack
	addi	$sp,$sp,4	# make stack pointer to point last word pushed			
	lw	$s2,($sp)	# load $s2 initial value from stack		
	addi	$sp,$sp,4	# make stack pointer to point last word pushed	
	lw	$s1,($sp)	# load $s1 initial value from stack	
	addi	$sp,$sp,4	# make stack pointer to point last word pushed	
	lw	$s0,($sp)	# load $s0 initial value from stack	
	addi	$sp,$sp,4	# make stack pointer to point last word pushed	
	lw	$fp,($sp)	# load $fp initial value from stack	
	addi	$sp,$sp,4	# make stack pointer to point last word pushed	
	lw	$ra,($sp)	# load $ra ( return address ) initial value from stack	
	addi	$sp,$sp,4	# make stack pointer to point last word pushed	
	
	jr 		$ra

.end hanoiTowerRecursion	