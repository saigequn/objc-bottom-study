	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_logArray               ; -- Begin function logArray
	.p2align	2
_logArray:                      ; @logArray
	.cfi_startproc
; %bb.0:
// 方法头
	sub	sp, sp, #64             ; =64
	stp	x29, x30, [sp, #48]     ; 16-byte Folded Spill
	add	x29, sp, #48            ; =48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16

	stur	x0, [x29, #-8]		; 数组指针intArray写到FP-8Byte
	stur	x1, [x29, #-16]		; 数组长度length写到FP-16
	stur	wzr, [x29, #-20]	; FP-20存入0
LBB0_1:                         ; =>This Inner Loop Header: Depth=1
	ldursw	x8, [x29, #-20] 	; 变量i写入x8
	ldur	x9, [x29, #-16]		; FP-16写入x9
	cmp	x8, x9 					; 比较x8和x9
	b.hs	LBB0_4				; 如果大于，那么直接跳转LBB0_4。方法返回
; %bb.2:                                ;   in Loop: Header=BB0_1 Depth=1
	ldur	x8, [x29, #-8]		; 数组指针intArray写入x8
	ldursw	x9, [x29, #-20]		; 变量i写入x9
	ldr	w10, [x8, x9, lsl #2]
                                        ; implicit-def: $x0
	mov	x0, x10
	adrp	x8, l_.str@PAGE     ; 这两行作用：把字符串地址写入到x8中
	add	x8, x8, l_.str@PAGEOFF
	str	x0, [sp, #16]           ; 8-byte Folded Spill x0写入到FP+16
	mov	x0, x8  				;	
	mov	x8, sp     			 	;
	ldr	x9, [sp, #16]           ; 8-byte Folded Reload
	str	x9, [x8]
	bl	_printf
; %bb.3:                                ;   in Loop: Header=BB0_1 Depth=1
	ldur	w8, [x29, #-20]
	add	w8, w8, #1              ; =1
	stur	w8, [x29, #-20]
	b	LBB0_1
LBB0_4:
// 方法尾
	ldp	x29, x30, [sp, #48]     ; 16-byte Folded Reload
	add	sp, sp, #64             ; =64
	ret
	.cfi_endproc
                                ; -- End function



	.globl	_main               ; -- Begin function main
	.p2align	2
_main:                          ; @main
	.cfi_startproc
; %bb.0:
// 方法头
	sub	sp, sp, #48             ; =48
	stp	x29, x30, [sp, #32]     ; 16-byte Folded Spill
	add	x29, sp, #32            ; =32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16

	adrp	x8, ___stack_chk_guard@GOTPAGE   		; 接下来两行作用：读取数组初始化数据{1,2,3}所在地址，写入x8
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]  				; ___stack_chk_guard 符号内容写入x8
	stur	x8, [x29, #-8]		; x8写入SP-8Byte
	str	wzr, [sp, #4]    		; SP+4存入0
	adrp	x8, l___const.main.arr@PAGE
	add	x8, x8, l___const.main.arr@PAGEOFF
	ldr	x9, [x8]				; x8内容写入x9
	add	x0, sp, #8              ; =8 sp+8写入x0
	str	x9, [sp, #8] 			; x9写入SP+8
	ldr	w10, [x8, #8]			; x8
	str	w10, [sp, #16]
	mov	x1, #3
	bl	_logArray				; 调用 _logArray
	adrp	x8, ___stack_chk_guard@GOTPAGE 			;  读取 ___stack_chk_guard 标签所在页的地址写入x8
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]				; ___stack_chk_guard 符号内容写入 x8
	ldur	x9, [x29, #-8]		; 之前保存的 ___stack_chk_guard 写入x9
	cmp	x8, x9   				; 比较x8和x9
	b.ne	LBB1_2   			; 如果不想等，说明数组越界，跳转到LBB1_2
; %bb.1:
	mov	w8, #0       			;
	mov	x0, x8   				;
// 方法尾
	ldp	x29, x30, [sp, #32]     ; 16-byte Folded Reload
	add	sp, sp, #48             ; =48
	ret
LBB1_2:
	bl	___stack_chk_fail
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"%d"

// 初始化数组的变量是存储在代码段的常量区
	.section	__TEXT,__const
	.p2align	2               ; @__const.main.arr
l___const.main.arr:
	.long	1                       ; 0x1
	.long	2                       ; 0x2
	.long	3                       ; 0x3

.subsections_via_symbols
