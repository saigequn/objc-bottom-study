	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16

	ldr	w8, [sp, #12]
	ldr	w9, [sp, #8]
	ldr	w10, [sp, #4]
	and	w9, w9, w10
	orr	w8, w8, w9
	str	w8, [sp, #12]
	mov	w8, #0
	mov	x0, x8
	
	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
