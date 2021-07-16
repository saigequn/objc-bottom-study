	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16

	mov	w8, #97					; w8 = 97
	strb	w8, [sp, #15]		; w8存入sp+15 (char类型占1个字节)把栈顶向下1byte的空间赋值为97(注意'a'的ASCII码为97)

	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols ;可以将汇编中整块代码根据符号拆分成不同的区块。这些区块可以根据是否被其他代码引用而被剔除
