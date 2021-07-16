	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16

	mov	w8, #2 			; w8=2
	str	w8, [sp, #8]	; w8存入sp+8
	mov	w8, #1 			; w8=1
	str	w8, [sp, #4]	; w8存入sp+4
	ldr	w8, [sp, #8]	; 取出sp+8内存地址的值，存入w8=2
	ldr	w9, [sp, #4]	; 取出sp+4内存地址的值，存入w9=1
	cmp	w8, w9			;比较w8和w9
	b.le	LBB0_2
; %bb.1:
	ldr	w8, [sp, #8]	; 取出sp+8内存地址的值，存入w8
	str	w8, [sp, #12]	; w8存入sp+12
	b	LBB0_3
LBB0_2:
	ldr	w8, [sp, #4]	; 取出sp+4内存地址的值，存入w8
	str	w8, [sp, #12]	; w8存入sp+12
LBB0_3:
	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
