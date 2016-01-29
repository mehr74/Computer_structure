# In the name of God
# Question 5 - Maxtrix multiplication

.data
    matrix1:        .space      200
    matrix2:        .space      200
    matrix3:        .space      200
    newline:        .asciiz     "\n"


.text
.globl  main

main:
    # get number of rows for matrix
    li          $v0, 5                      # read_int 
    syscall                                 # input integer is in $v0

    move        $t7, $v0                    # save number of rows in $t7
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
    
    addi        $t2, $t2, 1                 # increment matrix counter by one
    la          $t1, matrix2                # config our storage pointer
    li          $t0, 0                      # reset our element counter
    li          $t3, 0
    bne         $t2, $t6, ReadMatrixElement # read the other matrix


    li          $t0, 0                      # counter of columns
    li          $t1, 0                      # counter of rows
    li          $t2, 0                      # counter of computations
    li          $a2, 0                      # accumulator for computations

    la          $t3, matrix1                # set $t2 to matrix1 address
    la          $t4, matrix2                # set $t3 to matrix2 address

    la          $t0, matrix1
    jal         showMatrix


    NextRow:

    mult        $t1, $t7
    mflo        $s2
    add         $t5, $s2, $t3

    NextCol:
    add         $t6, $t4, $t0

    ComputingLoop:

    lw          $a0, ($t5)
    lw          $a1, ($t6)

    mult        $a0, $a1
    mflo        $a0

    add         $a2, $a2, $a0

    addi        $t2, $t2, 1
    addi        $t5, $t5, 4
    add         $t6, $t6, $t7

    bne         $t2, $t7, ComputingLoop

    la          $s1, matrix3
    add         $s1, $s1, $t0
    mult        $t1, $t7
    mflo        $s2
    add         $s1, $s2, $s1
    sw          $a2, ($s1)

    add         $t4, $t4, 4
    li          $a2, 0 

    addi        $t0, $t0, 1
    bne         $t0, $t7, NextCol
    
    add         $t3, $t3, $t7
    addi        $t1, $t1, 1
    bne         $t1, $t7, NextRow

    li          $v0, 10
    syscall

.end main

.globl showMatrix
.ent showMatrix
showMatrix:
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

    li          $s0, 0
    li          $s1, 0

    showMatrixLoop:

    mult        $s0, $t7
    mflo        $a0
     
    add         $a1, $t0, $a0
    li          $v0, 1
    syscall

    addi        $s1, $s1, 1
    bne         $s1, $t7, showMatrixLoop
    
    li          $s1, 0
    addi        $s0, $s0, 1
    bne         $s0, $t7, showMatrixLoop

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

    jr          $ra
.end showMatrix
        
