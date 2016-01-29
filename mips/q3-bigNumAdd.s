# Question 3 - Big number addition
# programmer : Mehrshad Lotfi

.data
    firstInput:         .space      400
    secondInput:        .space      400
    overFlowFlag:       .word       0
    results:            .space      400

.text

main:
    li      $s0, 396                    # set $s0 index of last word of number
    li      $t0, 0                      # set $t0 overflow flag in each level


mainLoop:
    lw      $t1, firstInput($s0)        # set $t1 temp word of first input
    lw      $t2, secondInput($s0)       # set $t2 temp word of second input

    add     $t3, $t1, $t2               # add two temp word together
    add     $t3, $t3, $t0               # add sum with the previous overflow flag

    sltu    $t0, $t3, $t1               # sum of two temp word is less than first one : overflow
    beq     $t0, 1, Overflow            # if $t0 was set to one in previous instruction, jump to overflow label
    
    sltu    $t0, $t3, $t2               # sum of two temp word is less than second one : overflow
    beq     $t0, 1, Overflow            # if $t0 was set to one in previous instruction, jump to overflow label

    j       noOverflow                  # if we reached this instruction, no overflow has occured

Overflow:
    
noOverflow:

    sw      $t3, results($s0)           # store the result in memory
    addi    $s0, $s0, -4                # decrement the index
    bne     $s0, -4, mainLoop           # jump to mainLoop


    sw      $t0, overFlowFlag           # store the voerFlowFlag

    # return to os control point
    li          $v0, 10
    syscall

.end main

