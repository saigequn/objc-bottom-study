	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_empty                  ; -- Begin function empty
	.p2align	2
_empty:                                 ; @empty
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16

	add	x8, sp, #12         ; =12  x8=sp+12
	mov	w9, #1 				; w9=1
	str	w9, [sp, #12]    	; 将地址从w9放入sp+12中
	str	x8, [sp]			; 将地址从x8放入sp中

	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
