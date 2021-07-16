	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_empty                  ; -- Begin function empty
	.p2align	2
_empty:                                 ; @empty
	.cfi_startproc
; %bb.0:
	adrp	x8, _empty.a@PAGE
	add	x8, x8, _empty.a@PAGEOFF
	ldr	w9, [x8]
	add	w9, w9, #1              ; =1
	str	w9, [x8]
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__DATA,__data
	.p2align	2               ; @empty.a
_empty.a:
	.long	1                       ; 0x1

.subsections_via_symbols
