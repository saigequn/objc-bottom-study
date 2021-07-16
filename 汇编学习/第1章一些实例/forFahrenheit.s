	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
//方法头
	sub	sp, sp, #48             ; =48
	stp	x29, x30, [sp, #32]     ; 16-byte Folded Spill
	add	x29, sp, #32            ; =32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16

	stur	wzr, [x29, #-4]		; x29-4置0
	stur	wzr, [x29, #-8]		; x29-8置0   fahr
LBB0_1:                         ; =>This Inner Loop Header: Depth=1
	ldur	w8, [x29, #-8]		; 取出x29-8的值，存入w8中 		取出fahr
	cmp	w8, #300                ; =300  w8和300比较
	b.gt	LBB0_4				; 如果大于，跳出到 LBB0_4
; %bb.2:                        ;   in Loop: Header=BB0_1 Depth=1
	ldur	w8, [x29, #-8]		; 取出x29-8的值，存入w8中 		取出fahr
                                ; implicit-def: $x0
	mov	x0, x8 					; x8写入x0
	ldur	w8, [x29, #-8]		; 取出x29-8的值，存入w8中
	subs	w8, w8, #32         ; =32  w8=w8-32
	scvtf	d0, w8  			
	mov	x9, #7282				; 常数运算'5.0/9.0'
	movk	x9, #29127, lsl #16
	movk	x9, #50972, lsl #32
	movk	x9, #16353, lsl #48
	fmov	d1, x9
	fmul	d0, d1, d0
	adrp	x9, l_.str@PAGE 	; 这两行作用是找到字符串所在内存地址
	add	x9, x9, l_.str@PAGEOFF
	str	x0, [sp, #16]           ; 8-byte Folded Spill
	mov	x0, x9
	mov	x9, sp
	ldr	x10, [sp, #16]          ; 8-byte Folded Reload
	str	x10, [x9]
	str	d0, [x9, #8]
	bl	_printf					; 打印 _printf
; %bb.3:                        ; in Loop: Header=BB0_1 Depth=1
	ldur	w8, [x29, #-8]		; 取出x29-8的值，存入w8中
	add	w8, w8, #20             ; =20  fahr=fahr+20
	stur	w8, [x29, #-8]		; 读取w8的值，存入x29-8
	b	LBB0_1
LBB0_4:
//方法尾
	ldur	w0, [x29, #-4]
	ldp	x29, x30, [sp, #32]     ; 16-byte Folded Reload
	add	sp, sp, #48             ; =48
	ret
	.cfi_endproc
                                        ; -- End function

	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"%3d %6.1f\n"

.subsections_via_symbols
