.586
.model	flat,stdcall
.stack 4096

extern	ExitProcess@4	:	proc
extern	MessageBoxA@16	:	proc

.data
	input_txt		BYTE	"salam test is a good time, \n ! with"
					BYTE	0ah
					BYTE	0ah
					BYTE	" another lkj yes .... ali !",0
	inputTxt_len = ($ - input_txt)
	msg_caption		BYTE	"String reversed",0
	output_txt		BYTE	inputTxt_len DUP(?),0

.code
	main:nop
	space_char			= 20h
	dot_char			= 2eh
	semicolon_char		= 3bh
	comma_char			= 2ch
	exclamation_char	= 21h	
	enter_char			= 0ah

	mov		ebp,offset input_txt		; Pointer to the word not reversed 
	mov		ebx,0						; Counter to estimate each word length
	mov		esi,0						; Source index
	mov		edi,0						; Destination index

; scanChar loop will scan character from input_txt and compare it
; with characters that are considered as separator characters 
scanChar:
	mov		cl,input_txt[esi]
	inc		esi							; increment source index
	inc		ebx							; increment word length not reversed yet

	cmp		cl,0	
	je		reverseLastWord				; if the string was finished reverse the last word

	cmp		cl,space_char
	je		reverseWord					; if the character is space break to reverse the word 

	cmp		cl,dot_char
	je		reverseWord					; if the character is dot break to reverse the word

	cmp		cl,comma_char
	je		reverseWord					; if the character is comma break to reverse the word

	cmp		cl,semicolon_char
	je		reverseWord					; if the character is semicolon break to reverse the word

	cmp		cl,exclamation_char
	je		reverseWord					; if the character is exclamation break to reverse the word

	cmp		cl,enter_char
	je		reverseWord					; if the character is enter break to reverse the word

	jmp		scanChar					; if the character is not a separator one, loop.

reverseWord:
	dec		ebx

; insertChar loop will insert character of the last word not reversed,
; from input_txt to the output_txt reversely.
insertChar:
	mov		cl,byte ptr [ebp][ebx-1]
	mov		output_txt[edi],cl
	inc		edi							; increment destination index
	dec		ebx							; decrement counter of the loop
	jnz		insertChar					; Continue to insertChar if the word length counter is not zero
	lea		ebp,input_txt[esi-1]		; store address of the first word not reversed in ebp reg.
	dec		esi

; insertSeparatorChar will loop through the separator character after a 
; word and insert it to output_txt
insertSeparatorChar:
	inc		esi							; increment source index character
	mov		cl,input_txt[esi-1] 

	cmp		cl,0	
	je		finished					; check weather the string was finished or not

	mov		output_txt[edi],cl			; insert separator character in output_txt
	inc		edi							; increment destination index
	inc		ebp							; increment address of the first word not reversed
	mov		cl,input_txt[esi]

	cmp		cl,space_char
	je		insertSeparatorChar			; if the next character is also separator one, loop to insert it

	cmp		cl,dot_char
	je		insertSeparatorChar			; if the next character is also separator one, loop to insert it

	cmp		cl,comma_char
	je		insertSeparatorChar			; if the next character is also separator one, loop to insert it

	cmp		cl,semicolon_char
	je		insertSeparatorChar			; if the next character is also separator one, loop to insert it

	cmp		cl,exclamation_char
	je		insertSeparatorChar			; if the next character is also separator one, loop to insert it

	cmp		cl,enter_char
	je		insertSeparatorChar			; if the next character is also separator one, loop to insert it 

	jmp		scanChar					; if the next character is no a separator one, Scan the next word

; reverseLastWord will check weather we had reversed the last word or not
reverseLastWord:
	mov		cl,byte ptr[ebp]
	cmp		cl,0
	jne		reverseWord					; if we had not reverse the last word, jump to reverse it

	push	0
	call	ExitProcess@4

	end main
