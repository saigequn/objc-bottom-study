	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16
	str	wzr, [sp, #12]
	mov	w8, #1
	str	w8, [sp, #8]
	ldr	w8, [sp, #8]
	cmp	w8, #1                  ; =1
	b.ne	LBB0_2
; %bb.1:
	mov	w8, #11
	str	w8, [sp, #8]
	b	LBB0_6
LBB0_2:
	ldr	w8, [sp, #8]
	cmp	w8, #2                  ; =2
	b.ne	LBB0_4
; %bb.3:
	mov	w8, #12
	str	w8, [sp, #8]
	b	LBB0_5
LBB0_4:
	mov	w8, #13
	str	w8, [sp, #8]
LBB0_5:
LBB0_6:
	ldr	w0, [sp, #12]
	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
