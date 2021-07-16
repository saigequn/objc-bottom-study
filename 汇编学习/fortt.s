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
	mov	w8, #3     				// 3写入w8
	str	w8, [sp, #8]    		// w8写到sp+8
LBB0_1:                         ; =>This Inner Loop Header: Depth=1 循环体
	ldr	w8, [sp, #8]			// sp+8写入w8
	cmp	w8, #10                 ; =10  比较w8和10
	b.ge	LBB0_3				; 进入循环体
; %bb.2:                        ;   in Loop: Header=BB0_1 Depth=1 循环体
	ldr	w8, [sp, #8]			// sp+8写入w8
	add	w8, w8, #1              ; =1 w8 = w8 + 1
	str	w8, [sp, #8]			; w8写入sp+8
	b	LBB0_1					; 回到循环体判断部分
LBB0_3:
	mov	w8, #0                  // 准备方法返回
	mov	x0, x8					
	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
