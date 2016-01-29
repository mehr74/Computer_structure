# In the name of God
# Question 5 - Maxtrix multiplication

.data
    matrix1:        .space      200
    matrix2:        .space      200
    matrix3:        .space      200
    newline:        .asciiz     "\n"
    spaceChar:	    .asciiz	" "
    prompt1:	    .asciiz	"Enter number of rows: "
    prompt2:	    .asciiz	"Enter matrix1 elements: "
    prompt3:	    .asciiz	"Enter matrix2 elements: "
    prompt4:	    .asciiz	"Matrix 1: \n"
    prompt5:	    .asciiz	"matrix 2: \n"
    prompt6:	    .asciiz	"Result : \n"


.text
.globl  main

main:
    la		$a0, prompt1
    li		$v0, 4
    syscall

    # get number of rows for matrix
    li          $v0, 5                      # read_int 
    syscall                                 # input integer is in $v0

    move        $t7, $v0                    # save number of rows in $t7
    
    la		$a0, prompt2
    li		$v0, 4
    syscall
    
    li          $t6, 2                      # set $t6 to constant 2 for comparison
    li          $t3, 0                      # set $t3 to our row counter
    li          $t2, 0                      # set $t2 to matrix counter
    li          $t0, 0                      # set $t0 to our column counter
    la          $t1, matrix1                # set $t1 to our storage pointer

ReadMatrixElement:
    li          $v0, 5                      # read_int
    syscall                                 # input integer is in $v0
    sw          $v0, ($t1)                  # save matrix element in memory
    addi        $t1, $t1, 4                 # increment our storage pointer
    addi        $t0, $t0, 1                 # increment our counter
    bne         $t0, $t7, ReadMatrixElement # loop until we get enough row elements

    li          $t0, 0
    addi        $t3, $t3, 1
    bne         $t3, $t7, ReadMatrixElement # loop until we get enough rows
    
    la		$a0, prompt3
    li		$v0, 4
    syscall
    
    addi        $t2, $t2, 1                 # increment matrix counter by one
    la          $t1, matrix2                # config our storage pointer
    li          $t0, 0                      # reset our element counter
    li          $t3, 0
    bne         $t2, $t6, ReadMatrixElement # read the other matrix
    
    la		$a0, prompt4
    li		$v0, 4
    syscall
        
    la		$t4, matrix1
    jal		showMatrix
    
    la		$a0, prompt5
    li		$v0, 4
    syscall
    
    la		$t4, matrix2
    jal		showMatrix
    
    li		$t0, 4
    mul		$t6, $t0, $t7


	li 	$t0, 0
nextRow:
	li 	$t1, 0
nextCol:
	mul 	$t2, $t0, $t7
	add 	$t2, $t2, $t1

		
	li 	$s6, 0
	li 	$t5, 0
# Calculatring result[t0][t1]
innerLoop:
	mul 	$t3, $t0, $t7
	add 	$t3, $t3, $t5
	lw 	$s1, matrix1($t3)
	mul 	$t4, $t5, $t7
	add 	$t4, $t4, $t1
	lw 	$s2, matrix2($t4)
	mul 	$s2, $s2, $s1
	add 	$s6, $s6, $s2

	addi 	$t5, $t5, 4
	bne 	$t5, $t6, innerLoop
	
	sw 	$s6, matrix3($t2)
	
	addi 	$t1, $t1, 4
	bne 	$t1, $t5, nextCol
	
	addi 	$t0, $t0, 4
	bne 	$t0, $t5, nextRow
	
	la		$a0, prompt6
    	li		$v0, 4
    	syscall
    
	la	$t4, matrix3
	jal	showMatrix

    li          $v0, 10
    syscall

.end main

.globl showMatrix
showMatrix:
    # store initial values of registers -------------
    addi        $sp, $sp, -4
    sw          $ra, ($sp)

    addi        $sp, $sp, -4
    sw          $s0, ($sp)
    
    addi        $sp, $sp, -4
    sw          $s1, ($sp)

    addi        $sp, $sp, -4
    sw          $a0, ($sp)

    addi        $sp, $sp, -4
    sw          $a1, ($sp)
    
    addi	$sp, $sp, -4
    sw		$t0, ($sp)
    
    addi	$sp, $sp, -4
    sw		$t1, ($sp)
    
    #------------------------------------------------

    li          $s0, 0
    li          $s1, 0
    li		$t0, 0
    li		$t1, 0

    showMatrixLoop:

    mult        $s0, $t7
    mflo        $a1
     
    add         $a0, $t4, $a1
    add		$a0, $a0, $s1
    lw		$a0, ($a0)
    li          $v0, 1
    syscall

    li		$v0, 4
    la		$a0, spaceChar
    syscall

    addi        $s1, $s1, 4
    addi	$t1, $t1, 1
    bne         $t1, $t7, showMatrixLoop
    
    li		$v0, 4
    la		$a0, newline
    syscall
    
    li          $s1, 0
    li		$t1, 0
    addi        $s0, $s0, 4
    addi	$t0, $t0, 1
    bne         $t0, $t7, showMatrixLoop

    # Load initial values of registers ---------------
    
    lw		$t1, ($sp)
    addi	$sp, $sp, 4
    
    lw		$t0, ($sp)
    addi	$sp, $sp, 4    
    
    lw          $a1, ($sp)
    addi        $sp, $sp, 4

    lw          $a0, ($sp)
    addi        $sp, $sp, 4

    lw          $s1, ($sp)
    addi        $sp, $sp, 4

    lw          $s0, ($sp)
    addi        $sp, $sp, 4

    lw          $ra, ($sp)
    addi        $sp, $sp, 4
    #------------------------------------------------

    jr          $ra
.end showMatrix
        
