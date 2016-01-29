# Quick sort

.data
	array : 	.word 		0:1000
	inputmsg : 	.asciiz 	"Enter input numbers (zero to finish): "
	outputmsg1 : 	.asciiz 	"Before quick sort : \n"
	outputmsg2 : 	.asciiz 	"After quick sort : \n"
	outputmsg3 : 	.asciiz 	"Median is : \n"
	space : 	.asciiz 	" " 
	newLine : 	.asciiz 	"\n"

.globl main
.text
main:
	la 	$s0, array

  	la 	$a0, inputmsg
  	li 	$v0, 4	
  	syscall

  	li 	$t0, 0   
  	li 	$t2, 0

Input :            
  	li 	$v0, 5
  	syscall

  	sll 	$t4, $t0, 2 
  	add 	$t4, $s0, $t4 
  	sw  	$v0, 0($t4)  
  	addi  	$t0, $t0, 1  
  	addi  	$t2, $t2, 1    
  	bne   	$v0, $zero, Input 

  	addi  	$t2, $t2, -1

  	la 	$a0, outputmsg1
  	li 	$v0, 4
  	syscall
  
  	jal 	PrintArray

  	li 	$a0, 0
 	addi 	$a1, $t2, -1
  	jal 	Qsort

  	la 	$a0, outputmsg2
  	li 	$v0, 4
  	syscall

  	jal 	PrintArray

  	la 	$a0, outputmsg3
  	li 	$v0, 4
  	syscall

  	srl 	$t0, $t2, 1
  	sll 	$t0, $t0, 2
  	add 	$t0, $s0, $t0
  	andi 	$t1, $t2, 1
  	beq 	$t1, $zero, Even
Odd :
  	j 	PrintMedian
Even :
  	lw 	$t1, 0($t0)
  	lw 	$t2, -4($t0) 
  	add 	$t1, $t1, $t2
  	srl 	$t1, $t1, 1 
  	sw 	$t1, 0($t0)
PrintMedian :
  	lw 	$a0, 0($t0)
  	li 	$v0, 1
  	syscall

  	li 	$v0, 10
  	syscall

PrintArray :
    	li 	$t0, 0 
Print :
    	sll 	$t1, $t0, 2 
    	add 	$t1, $s0, $t1

    	lw 	$a0, 0($t1)
    	li 	$v0, 1
    	syscall 

    	la 	$a0, space
    	li 	$v0, 4
    	syscall 

    	addi 	$t0, $t0, 1
    	bne 	$t0, $t2, Print

    	la 	$a0, newLine
    	li 	$v0, 4
    	syscall
  	jr 	$ra

Qsort :
  	slt 	$t8, $a0, $a1
  	beq 	$t8, $zero, Return
  	j Keep
Return :
    	jr 	$ra
Keep :
  	addi 	$sp, $sp, -12 
  	sw 	$ra, 8($sp)
  	sw 	$a1, 4($sp) 
  
  	sll 	$t3, $a0, 2 
  	add 	$t3, $t3, $s0 
  	lw 	$t3, 0($t3)

  	addi 	$t0, $a0, 1
  	addi 	$t1, $a1, 0 
Loop :
LoopI :
      	sll 	$t4, $t0, 2 
      	add 	$t4, $s0, $t4 
      	lw 	$t5, 0($t4)
      	slt 	$t8, $t3, $t5   
      	bne 	$t8, $zero, BreakI
      	addi 	$t0, $t0, 1  
      	slt 	$t8, $a1, $t0
      	bne 	$t8, $zero, BreakI
BreakI :

LoopJ :
      	sll 	$t6, $t1, 2 
      	add 	$t6, $s0, $t6
      	lw 	$t7, 0($t6)
      	slt 	$t8, $t7, $t3
      	bne 	$t8, $zero, BreakJ
      	addi 	$t1, $t1, -1
      	slt 	$t8, $a0, $t1
      	beq	$t8, $zero, BreakJ
BreakJ :
    	slt 	$t8, $t1, $t0
    	bne 	$t8, $zero, EndLoop

    	sll 	$t4, $t0, 2 
    	add 	$t4, $s0, $t4
    	lw 	$t5, 0($t4)
    	sll 	$t6, $t1, 2 
    	add 	$t6, $s0, $t6
    	lw 	$t7, 0($t6)
    	sw 	$t7, 0($t4)
    	sw 	$t5, 0($t6)

    	j 	Loop
  EndLoop :
  
  	sll 	$t4, $a0, 2
  	add 	$t4, $s0, $t4
  	sll 	$t6, $t1, 2
  	add 	$t6, $s0, $t6
  	lw 	$t7, 0($t6)
  	sw 	$t7, 0($t4)
  	sw 	$t3, 0($t6) 
  
  	sw 	$t1, 0($sp)
  	addi 	$a1, $t1, 0
  	jal 	Qsort
  	lw 	$t1, 0($sp)
  	addi 	$a0, $t1, 1
  	lw 	$a1, 4($sp)
  	jal 	Qsort

  	lw 	$ra, 8($sp)
  	addi 	$sp, $sp, 12
  	jr 	$ra 