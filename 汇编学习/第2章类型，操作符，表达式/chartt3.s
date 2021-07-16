	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16

	mov	w8, #52429				; 浮点数   w8=1.1
	movk	w8, #16268, lsl #16
	fmov	s0, w8				; w8的值存入s0
	str	s0, [sp, #12]			; 取出s0存入sp+12 (float类型占4个字节)把栈顶向下4byte的空间赋值成1.1
	
	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
