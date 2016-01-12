.586
.model	flat,stdcall
.stack 4096

extern	ExitProcess@4	:	proc
extern	MessageBoxA@16	:	proc

.data
	msg_text		BYTE	"Move from "
	src_txt			BYTE	"A"
					BYTE	" to "
	dest_txt		BYTE	"C",0
	ext_txt			BYTE	"B"
	input_number	DWORD	3
	output_number	DWORD	0
	msg_caption		BYTE	"Movement",0

.code
	main:
	mov		edi,0						; set edi to zero to count number of levels

	movzx	eax,BYTE PTR dest_txt		; push destination peg label 
	push	eax

	movzx	eax,BYTE PTR ext_txt		; push external peg label 
	push	eax
	
	movzx	eax,BYTE PTR src_txt		; push source peg label
	push	eax

	mov		eax,input_number			; push number of disks 
	push	eax

	call	solveHanoiTower				; call solveHanoi(disks, src, ext, dest)

	mov		output_number,edi

finished:
	push	0							; return to os contorl point
	call	ExitProcess@4

;----------------------------------------------------------------------------------------------------
;
; solveHanoiTower
;
; prints levels of solving hanoi tower using messageBoxA and calculates number of these levels
; Receives: disk numbers, source peg label, external peg label and destination label from stack
;			in order. Set edi to zero for first calling the function.
; Returns:	EDI = number of levels
;
;----------------------------------------------------------------------------------------------------

solveHanoiTower		PROC
	; store initial value of register used in function
	push	eax							; store eax in stack
	push	ebx							; store ebx in stack
	push	ecx							; store ecx in stack
	push	edx							; store edx in stack

	mov		eax,[esp+20]				; eax set to number of disks to move
	mov		ebx,[esp+24]				; ebx set to source peg 
	mov		ecx,[esp+28]				; ecx set to external peg
	mov		edx,[esp+32]				; edx set to destination peg

	cmp		eax,0						; Compare number of disks to move with zero
	je		Return						; if number of disks is zero, return.

	;------------------------------------------------------------
	; Move n-1 disk from previous source(new source) to previous external(new destination)
	;------------------------------------------------------------
	push	ecx							; push destination peg label
	push	edx							; push external peg label
	push	ebx							; push source peg label
	dec		eax							; determine (n-1)
	push	eax							; push number of disk to move
	call	solveHanoiTower				; call solveHanoi(disks, src, ext, dest)
	;------------------------------------------------------------

	; set the msg_text to print
	mov		src_txt,bl
	mov		dest_txt,dl

	; add to number of levels of sovling hanoi tower
	inc		edi

	; store register values before calling MessageBoxA function
	push	eax							; store eax in stack
	push	ebx							; store ebx in stack
	push	ecx							; store ecx in stack
	push	edx							; store edx in stack
	push	edi							; store edi in stack

	;------------------------------------------------------------
	; print the result using MessageBoxA function
	;------------------------------------------------------------
	push	0							; set window type

	lea		edi,msg_caption				; set caption text
	push	edi

	lea		edi,msg_text				; set body text
	push	edi

	push	0							; set owner window to null

	call	MessageBoxA@16				; call the MessageBoxA to print current level
	;------------------------------------------------------------

	; restore register values to their initial value before calling MessageBoxA
	pop		edi							; restore edi from stack
	pop		edx							; restore edx from stack
	pop		ecx							; restore ecx from stack
	pop		ebx							; restore ebx from stack
	pop		eax							; restore eax from stack

	;------------------------------------------------------------
	; Move n-1 disk from external to destination
	;------------------------------------------------------------
	push	edx							; push destination peg label
	push	ebx							; push external peg label
	push	ecx							; push source peg label
	push	eax							; push number of disks
	call	solveHanoiTower				; call solveHanoi(disks, src, ext, dest)
	;------------------------------------------------------------

	Return:
	; restore register values to their initial value before calling function
	pop		edx							; restore edx from stack
	pop		ecx							; restore ecx from stack
	pop		ebx							; restore ebx from stack
	pop		eax							; restore eax from stack
	ret		16							; return and delete its argument from stack
solveHanoiTower		ENDP
	end main
