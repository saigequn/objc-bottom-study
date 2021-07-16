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
	adrp	x8, _a@PAGE
	add	x8, x8, _a@PAGEOFF
	ldr	w9, [x8] 				; 提取对应地址x8上的值  a=1
	add	w10, w9, #1             ; =1
	str	w10, [x8]
	mov	x0, x9
	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__DATA,__data
	.globl	_a                      ; @a
	.p2align	2
_a:
	.long	1                       ; 0x1

.subsections_via_symbols


; 全局变量a是放在了__DATA,__data节里。在我们使用该全局变量的时候，我们从对应a数据所属的地址上获取a的值，获取其值的方式，是将a的地址加载到寄存器中，然后通过ldr指令提取对应地址上的值。