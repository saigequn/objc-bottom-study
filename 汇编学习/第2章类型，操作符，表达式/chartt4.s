	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16          ; =16
	.cfi_def_cfa_offset 16

	mov	x8, #-7378697629483820647	; 浮点数   w8=1.1
	movk	x8, #39322
	movk	x8, #16369, lsl #48
	fmov	d0, x8			; w8的值存入d0
	str	d0, [sp, #8]		; 取出d0存入sp+8 (double类型占8个字节)把栈顶向下8byte的空间赋值成1.1

	add	sp, sp, #16         ; =16
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
