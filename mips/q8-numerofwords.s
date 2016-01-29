.data
filename:	.asciiz		"/home/mehrshad/test"
prompt:		.asciiz		"\nwords: "
zero:		.byte		0
inputString:	.space		2000

.text
.globl main
main:

	#**************************************************************************
	# Read from file
	li		$v0, 13			# system call for openning file
	la		$a0, filename		# filename
	li		$a1, 0			# open for reading
	li		$a2, 0
	syscall

	move		$s1, $v0		# save the file descriptor 
	li		$v0, 14			# system call for read from file
	
	move		$a0, $s1		# file descriptor
	la		$a1, inputString	# the address of buffer to which read

	li		$a2, 2000		# hardcoded buffer length
	syscall					# read from file
	
	move	$s2, $v0			# set s2 to length of buffer
	sb	$zero, inputString($v0)		# attach zero to the end of string
	
	li		$v0, 16			#system call for closing the file
	move		$a0, $s1		# file descriptor for closing
	syscall					# close the file
	#
	#**************************************************************************
	
	li		$s0, 0				# set s0 to the result
	li		$t0, 0				# set t0 to the counter

scanchar:
	lb		$t2, inputString($t0)
	addi		$t1, $t1, 1

continue:
	beq		$t0, $s2, end1
	jal		checkIsSpaceChar
	beq		$t7, 1, counter
	b		scanchar
	
loop3:
	lb		$t2, inputString($t0)
	add		$t0, $t0, 1
	beq		$t0, $s2, end2
	jal		checkIsSpaceChar
	beq		$t7, 1, loop3
	b		continue


	counter:
	addi	$s0, $s0, 1
	b		loop3

	end1:
	li		$v0, 4				#display the result
	la		$a0, prompt
	syscall
	
	li		$v0, 1
	addi		$a0, $s0, 1
	syscall
	b		end

	end2:
	li		$v0, 4				#display the result
	la		$a0, prompt
	syscall
	li		$v0, 1
	move	$a0, $s0
	syscall
	b		end

	end:
	li		$v0, 10
	syscall
	
.end main

.globl	checkIsSpaceChar

.ent	checkIsSpaceChar
####################################################################
#
# CheckIsSpaceChar : 
# Get $t2 as input
# Set $t7 to one if it is a space char otherwise set it to zero
#
####################################################################
checkIsSpaceChar:
	li		$t7, 0
	
	beq		$t2, 10, yesItIs		# 10 => enter
	beq		$t2, 32, yesItIs		# 32 => space
	beq		$t2, 33, yesItIs		# 33 => '!'
	beq		$t2, 46, yesItIs		# 46 => '.'
	beq		$t2, 44, yesItIs		# 44 => ','
	beq		$t2, 59, yesItIs		# 59 => ';'
	jr		$ra
yesItIs:
	li		$t7, 1
	jr		$ra
	

.end checkIsSpaceChar

