	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16

	mov	w8, #1 				; w8=1
	str	w8, [sp, #12]		; w8存入sp+12   a
	mov	w8, #3				; w8=3
	str	w8, [sp, #8]		; w8存入sp+8    b
	mov	w8, #99				; w8=99
	strb	w8, [sp, #7]	; w8存入sp+7    c （char类型1个字节） 
	ldrsb	w8, [sp, #7]	; 取出sp+7地址的值，存入w8  	取出c
	str	w8, [sp, #12]		; w8存入sp+12   a=99
	ldr	w8, [sp, #8]		; 取出sp+8地址的值，存入w8 		取出b
	strb	w8, [sp, #7]	; w8存入sp+7 

	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
