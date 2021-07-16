	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	; 分配了32byte的栈空间   ARM64下对于使用SP作为地址基址寻址的时候，必须要16byte-alignment（对齐）
	sub	sp, sp, #32             ; =32
	.cfi_def_cfa_offset 32
	add	sp, sp, #32             ; =32
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
