	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_empty                  ; -- Begin function empty
	.p2align	2
_empty:                                 ; @empty
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16
	mov	w8, #1
	str	w8, [sp, #12]
	ldr	w8, [sp, #12]
	add	w8, w8, #1              ; =1
	str	w8, [sp, #12]
	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_empty_register         ; -- Begin function empty_register
	.p2align	2
_empty_register:                        ; @empty_register
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16
	mov	w8, #1
	str	w8, [sp, #12]
	ldr	w8, [sp, #12]
	add	w8, w8, #1              ; =1
	str	w8, [sp, #12]
	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
