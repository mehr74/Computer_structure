.586
.model	flat,stdcall
.stack 4096

extern	ExitProcess@4	:	proc
extern	MessageBoxA@16	:	proc

.data
	input_txt		BYTE	"salam . ! test test 2 ro anjam midim test",0
	inputTxt_len = ($ - input_txt)
	msg_caption		BYTE	"Word counter",0
	answer			DWORD	0

.code
	main:nop
	space_char			= 20h
	dot_char			= 2eh
	semicolon_char		= 3bh
	comma_char			= 2ch
	exclamation_char	= 21h	
	enter_char			= 0ah

	mov		ebp,offset input_txt		; Pointer to the word not counted
	mov		esi,0						; Source index
	mov		eax,0						; word counter

; scanChar loop will scan character from input_txt and compare it
; with characters that are considered as separator characters 
scanChar:
	mov		cl,input_txt[esi]
	inc		esi							; increment source index

	cmp		cl,0	
	je		countLastWord				; if the string was finished count the last word

	cmp		cl,space_char
	je		countWord					; if the character is space break to count the word 

	cmp		cl,dot_char
	je		countWord					; if the character is dot break to count the word

	cmp		cl,comma_char
	je		countWord					; if the character is comma break to count the word

	cmp		cl,semicolon_char
	je		countWord					; if the character is semicolon break to count the word

	cmp		cl,exclamation_char
	je		countWord					; if the character is exclamation break to count the word

	cmp		cl,enter_char
	je		countWord					; if the character is enter break to count the word

	jmp		scanChar					; if the character is not a separator one, loop.


countWord:
	inc		eax							; increment word counter
	dec		esi							; decrement source index

skipSeparatorChar:
	inc		esi							; increment source index character

	mov		cl,input_txt[esi]

	cmp		cl,0	
	je		finished					; check weather the string was finished or not

	cmp		cl,space_char
	je		skipSeparatorChar			; if the next character is also separator one, loop to skip it

	cmp		cl,dot_char
	je		skipSeparatorChar			; if the next character is also separator one, loop to skip it

	cmp		cl,comma_char
	je		skipSeparatorChar			; if the next character is also separator one, loop to skip it

	cmp		cl,semicolon_char
	je		skipSeparatorChar			; if the next character is also separator one, loop to skip it

	cmp		cl,exclamation_char
	je		skipSeparatorChar			; if the next character is also separator one, loop to skip it

	cmp		cl,enter_char
	je		skipSeparatorChar			; if the next character is also separator one, loop to skip it 

	jmp		scanChar					; if the next character is not a separator one, scan the next word

; reverseLastWord will check weather we had reversed the last word or not
countLastWord:
	inc		eax

finished:
	mov		answer,eax					; store the answer in memory

	push	0
	call	ExitProcess@4

	end main
