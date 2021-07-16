	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16             ; =16
	.cfi_def_cfa_offset 16

	mov	w8, #1
	str	w8, [sp, #12]
	ldr	w8, [sp, #12]
	cmp	w8, #2                  ; =2
	cset	w8, gt				; 如果满足下一条指令cset的gt（greater than），就将w8的值设置为1
	and	w8, w8, #0x1			; 来确保w8的指令为1或者0
	str	w8, [sp, #12]

	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
