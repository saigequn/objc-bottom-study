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
	mov	w8, #10   				// 10存入w8
	str	w8, [sp, #8]			// w8写入sp+8Byte
	ldr	w8, [sp, #8]			// sp+8Byte写入w8
	cmp	w8, #8                  ; =8   	// w8与8比较
	b.le	LBB0_2				// w8>8 直接继续执行
; %bb.1:
	ldr	w8, [sp, #8]			// sp+8Byte写入w8
	add	w8, w8, #1              ; =1  // w8+1
	str	w8, [sp, #8]			// w8写入sp+8Byte
LBB0_2:
	mov	w8, #0
	mov	x0, x8
	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
