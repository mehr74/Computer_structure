.586
.model	flat,stdcall
.stack	4096

extern	ExitProcess@4	:	proc

.data
	Array	WORD	2
			WORD	1
			WORD	3
			WORD	5
			WORD	6
			WORD	4
			WORD	7	
			WORD	8
	arr_len = ($ - Array) - 2
	Temp	WORD	0

.code
	main:
	mov		eax, arr_len
	push	eax							; push ending index
	push	0							; push starting index
	lea		eax,Array
	push	eax							; push address of array
	call	quickSort					; call quickSort(array, start, end)

finished:
	push	0
	call	ExitProcess@4				; return to os control point

;----------------------------------------------------------------------------------------------------
;
; quickSort
;
; Sort array of full-words starting, using quick sort algorithm.
; Receives: array address, starting index, ending index
; Returns:	-
;
;----------------------------------------------------------------------------------------------------
quickSort		PROC
	push	ebp							; store ebp in stack
	push	esi							; store esi in stack
	push	edi							; store edi in stack
	push	eax							; store eax in stack

	mov		ebp,[esp+20]				; set ebp to address of array
	mov		esi,[esp+24]				; set esi to starting index
	mov		edi,[esp+28]				; set edi to ending index
	cmp		edi,esi	
	jle		quickSortReturn				; if ending index is less than or equal to starting index return

	push	edi							; push ending index
	push	esi							; push starting index
	push	ebp							; push address of array
	call	partition					; call partition(array, start, end)

	; set eax to q - 1
	dec		eax
	dec		eax

	push	eax							; push ending index ( q - 1 )
	push	esi							; push starting index ( start )
	push	ebp							; push address of array
	call	quickSort					; call quickSort(array, start, end)

	; set eax to q + 1
	add		eax,4

	push	edi							; push ending index ( end )
	push	eax							; push starting index ( q + 1 )
	push	ebp							; push address of array
	call	quickSort					; call quickSort(array, start, end)

	quickSortReturn:
	pop		eax							; restore eax from stack
	pop		edi							; restore edi from stack
	pop		esi							; restore esi from stack
	pop		ebp							; restore ebp from stack
	ret		12

quickSort		ENDP
;----------------------------------------------------------------------------------------------------


;----------------------------------------------------------------------------------------------------
;
; Partition
;
; Partitions the array A[p..r] into two (possibly empty) subarrays A[p..q-1] and A[q+1..r] such that
;	each element of A[p..q-1] is less than or equal to A[q], which is, in turn, less than or equal to
;	each element of A[q+1..r]. And computes the index q as part of this partitioning procedure.
; Receives:  array address, starting index, ending index
; Returns: EAX = index q
;
;----------------------------------------------------------------------------------------------------
partition		PROC
	; store initial value of registers used in function
	push	ebp							; store ebp in stack
	push	edi							; store edi in stack
	push	ebx							; store ebx in stack
	push	ecx							; store ecx in stack
	push	edx							; store edx in stack
	push	esi							; store esi in stack

	mov		ebp,[esp+28]				; ebp set to address of array
	mov		esi,[esp+32]				; esi set to starting index
	mov		edi,[esp+36]				; edi set to ending index

	movzx	ecx,WORD PTR [ebp][edi]		; Array[q] = Array[ending index]

	mov		ebx,esi						; set ebx to j index

	; set esi to i index, i = start - 1
	dec		esi	
	dec		esi

	L1:
	movzx	eax,WORD PTR [ebp][ebx]		; eax = Array[j]
	cmp		eax,ecx						; compare Array[j] and Array[q]
	jnl		partitionContinue	
	; increment i index
	inc		esi
	inc		esi
	;exchange Array[i] and Array[j]
	movzx	edx,WORD PTR [ebp][esi]		; use edx as a temporary register
	mov		[ebp][esi],ax
	mov		[ebp][ebx],dx
	
	partitionContinue:
	; increment j index
	inc		ebx	
	inc		ebx
	cmp		ebx,edi						; loop while j index is less than ending index
	jl		L1

	inc		esi
	inc		esi
	; exchange Array[i] and Array[ending point]
	movzx	edx,WORD PTR[ebp][esi]		; use edx as a temporary register
	mov		[ebp][esi],cx
	mov		[ebp][edi],dx

	mov		eax,esi						; use eax a return value

	partitionReturn:
	pop		esi							; restore esi from stack
	pop		edx							; restore edx from stack
	pop		ecx							; restore ecx from stack
	pop		ebx							; restore ebx from stack
	pop		edi							; restore edi from stack
	pop		ebp							; restore ebp from stack
	ret		12
partition		ENDP	
;----------------------------------------------------------------------------------------------------

	end main