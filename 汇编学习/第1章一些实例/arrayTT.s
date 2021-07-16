	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
// 空间开辟：栈上开辟了64个byte的空间，48byte给局部变量
	sub	sp, sp, #64             ; =64
	stp	x29, x30, [sp, #48]     ; 16-byte Folded Spill
	add	x29, sp, #48            ; =48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16

	adrp	x8, ___stack_chk_guard@GOTPAGE   	; 取了一个'___stack_chk_guard'的标签里的内容分别放入了x8
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	stur	x8, [x29, #-8]   	; x29-8=sp+56=___stack_chk_guard, 存入x8
	adrp	x8, ___stack_chk_guard@GOTPAGE  	; 又取了一次'___stack_chk_guard'到x8
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	ldur	x9, [x29, #-8]		; 再从'x29-8'里面取出之前存进去的'___stack_chk_guard'值，存入x9
	cmp	x8, x9 					; 做对比，如果不相等，则跳转到'LBB0_2'：
	b.ne	LBB0_2
; %bb.1:
	mov	w8, #0
	mov	x0, x8
	ldp	x29, x30, [sp, #48]     ; 16-byte Folded Reload
	add	sp, sp, #64             ; =64
	ret
LBB0_2:
	bl	___stack_chk_fail 		; 调到'___stack_chk_fail'方法，然后挂掉了
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
