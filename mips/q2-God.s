# In the name of God
# Question 2 - String manipulation

.data
    inputString:         .space         100
    outputString:       .space         100

.text
.globl main
main:

    # Read string from input :
    la          $a0, inputString
    li          $a1, 100
    li		    $v0, 8
    syscall
    # $a0 = memory address of string input buffer
    # $a1 = length of string buffer (n)

    la          $t1, outputString       # $t1 set to destination address
    li          $t2, 0                  # $t2 set to counter
     
 scanCharLoop:
    lb          $t0, ($a0)              # load one character from input buffer to $t0
    beq         $t0, 71, suspected      # Compare buffer character to 'G' character
    
continueLabel:
    sb          $t0, ($t1)                # store character to outputString destination
    addi        $t1, $t1, 1             # increment destination index by one
    addi        $a0, $a0, 1             # increment source index by one
    addi        $t2, $t2, 1             # increment counter by one
    beq         $t2, $a1, finished      # if the counter reaches to length of string buffer jump to finished
    b           scanCharLoop            # scan the next char

suspected:
    lb          $t3, 1($a0)             # load the second character for detecting God word
    lb          $t4, 2($a0)             # load the third character for detecting God word
    bne         $t3, 111, continueLabel # compare the second character to 'o' character
    bne         $t4, 100, continueLabel # compare the third character to 'd' character

substitudeToAllah:

    li          $s0, 65                 # load 'A' character
    sb          $s0, ($t1)              # store 'A' character

    li          $s0, 108                # load 'l' character
    addi        $t1, $t1, 1             # increment destination index
    sb          $s0, ($t1)              # store 'l' character

    addi        $t1, $t1, 1             # increment destination index
    sb          $s0, ($t1)              # store 'l' character
    
    li          $s0, 97                 # load 'a' character
    addi        $t1, $t1, 1             # increment destination index
    sb          $s0, ($t1)              # store 'a' character

    li          $s0, 104                # load 'h' character
    addi        $t1, $t1, 1             # increment destination index
    sb          $s0, ($t1)              # store 'h' character

    addi        $t1, $t1, 1             # increment destination index

    addi        $a0, $a0, 3             # add 3 to source index to ignore God word
    addi        $t2, $t2, 3             # add 3 to counter 

    beq         $t2, $a1, finished      # if the counter reaches to length of string buffer jump to finished
    b           scanCharLoop

finished:
    li          $v0, 4
    la          $a0, outputString
    syscall 

    li          $v0, 10
    syscall

.end main
