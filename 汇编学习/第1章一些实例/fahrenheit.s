	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #64             ; =64
	stp	x29, x30, [sp, #48]     ; 16-byte Folded Spill
	add	x29, sp, #48            ; =48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16

	stur	wzr, [x29, #-4]		; x29-4=sp+44置为0  			return_value
	stur	wzr, [x29, #-16]	; x29-16=sp+32置为0 			lower(0)
	mov	w8, #300   				; w8存入300(upper)
	stur	w8, [x29, #-20]		; w8写入x29-20=sp+28中 		upper(300)
	mov	w8, #20   				; w8存入20
	str	w8, [sp, #24]			; w8写入sp+24  				step(20)
	ldur	w8, [x29, #-16]		; x29-16=sp+32写入w8			lower
	stur	w8, [x29, #-8]		; 读取w8，写入到x29-8=sp+40 	fahr

LBB0_1:                         ; =>This Inner Loop Header: Depth=1
	ldur	w8, [x29, #-8]		; x29-8=sp+40写入w8			fahr
	ldur	w9, [x29, #-20]		; x29-20=sp+28写入w9			upper
	cmp	w8, w9   				; 比较w8和w9
	b.gt	LBB0_3				; 如果大于就跳转到 LBB0_3

; %bb.2:                        ;   in Loop: Header=BB0_1 Depth=1
	ldur	w8, [x29, #-8]		; x29-8=sp+40(fahr)取出值放入w8
	subs	w8, w8, #32         ; =32  w8=w8-32=fahr-32
	mov	w9, #5					; 数字5放入寄存器w9
	mul	w8, w9, w8  			; w8=w8*w9=(fahr-32)*5
	mov	w9, #9    				; 数字9存入w9
	sdiv	w8, w8, w9  		; w8=w8/w9=(fahr-32)*5/9
	stur	w8, [x29, #-12]		; w8存入到x29-12=sp+36 		celsius
	ldur	w8, [x29, #-8]		; x29-8=sp+40写入w8	        取出fahr(放入w8)	
                                ; implicit-def: $x0
	mov	x0, x8   			 	; x8存入x0
	ldur	w8, [x29, #-12]		; x29-12=sp+36写入w8        取出celsius(放入w8)
                                ; implicit-def: $x1
	mov	x1, x8 					; x8存入x1
	adrp	x10, l_.str@PAGE 	; 接下来'adrp'和'add'两句取出printf的第一个参数（也就是format）放入x10中
	add	x10, x10, l_.str@PAGEOFF
	str	x0, [sp, #16]           ; 8-byte Folded Spill 把x0的值存入sp+16指向的内存中
	mov	x0, x10					; x10存入x0
	mov	x10, sp  				; sp存入x10
	ldr	x11, [sp, #16]          ; 8-byte Folded Reload 取出sp+16指向的内存中的值，存入x11
	str	x11, [x10]				; 把x11的值存入x10指向的内存中
	str	x1, [x10, #8]			; 把x1的值存入x10+8指向的内存中
	bl	_printf 				; 然后调用 _printf 方法
	ldur	w8, [x29, #-8]		; x29-8=sp+40写入w8 			取出fahr
	ldr	w9, [sp, #24]			; sp+24写入w9 				取出celsius
	add	w8, w8, w9  			; w8=w8+w9 
	stur	w8, [x29, #-8]		; w8存入到x29-8=sp+40   		放回fahr
	b	LBB0_1 					; 调回循环头'LBB0_1'处
LBB0_3:
	ldur	w0, [x29, #-4]		; 读取w0，写入到FP-4

	ldp	x29, x30, [sp, #48]     ; 16-byte Folded Reload
	add	sp, sp, #64             ; =64
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"%d\t%d\n"

.subsections_via_symbols
