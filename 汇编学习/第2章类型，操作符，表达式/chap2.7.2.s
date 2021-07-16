	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16

	mov	w8, #1     			; w8=1
	str	w8, [sp, #12]		; w8存入sp+12   	a
	mov	w8, #3				; w8=3
	str	w8, [sp, #8]		; w8存入sp+8    	b
	mov	w8, #52429			; w8=1.1 浮点型 	c
	movk	w8, #16268, lsl #16
	fmov	s0, w8 		
	str	s0, [sp, #4]		; s0=1.1存入sp+4
	ldr	s0, [sp, #4]		; 取出sp+4，存入s0=1.1  	取出c

	fcvtzs	w8, s0 			; w8=1.0 fcvtzs会将浮点寄存器 rounding to zero的数值存入整数寄存器。
	str	w8, [sp, #12]		; w8存入sp+12   a
	ldr	w8, [sp, #12]		; 取出sp+12,存入w8=1   	取出a
	scvtf	s0, w8 			; s0=1.0  scvtf会将整数转换浮点数
	str	s0, [sp, #4] 		; s0存入sp+4

	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
