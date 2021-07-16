	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 14, 4	sdk_version 14, 4
	.globl	_add                    ; -- Begin function add
	.p2align	2
_add:                                   ; @add
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48             ; =48
	.cfi_def_cfa_offset 48
	ldr	w8, [sp, #48]
	ldr	w9, [sp, #52]
	str	w0, [sp, #44]		; w0=1 		参数 a   w0写入sp+44内存地址
	str	w1, [sp, #40]		; w1=2 		参数 b 	w1写入sp+40内存地址
	str	w2, [sp, #36]		; w2=3 		参数 c 	w2写入sp+36内存地址
	str	w3, [sp, #32]		; w3=4 		参数 d 	w3写入sp+32内存地址
	str	w4, [sp, #28]		; w4=5 		参数 e 	w4写入sp+28内存地址
	str	w5, [sp, #24]		; w5=6 		参数 f 	w5写入sp+24内存地址
	str	w6, [sp, #20]		; w6=7 		参数 g 	w6写入sp+20内存地址
	str	w7, [sp, #16]		; w7=8 		参数 h 	w7写入sp+16内存地址
	str	w8, [sp, #12]		; w8=9 		参数 i 	w8写入sp+12内存地址
	str	w9, [sp, #8]		; w9=10		参数 j 	w9写入sp+8内存地址
	ldr	w8, [sp, #44]		; 取出a
	ldr	w9, [sp, #40]		; 取出b
	add	w8, w8, w9 			; w8=w8+w9
	ldr	w9, [sp, #36] 		; 取出c
	add	w8, w8, w9
	ldr	w9, [sp, #32] 		; 取出d
	add	w8, w8, w9
	ldr	w9, [sp, #28]		; 取出e
	add	w8, w8, w9
	ldr	w9, [sp, #24]		; 取出f
	add	w8, w8, w9
	ldr	w9, [sp, #20]		; 取出g
	add	w8, w8, w9
	ldr	w9, [sp, #16]		; 取出h
	add	w8, w8, w9
	ldr	w9, [sp, #12]		; 取出i
	add	w8, w8, w9
	ldr	w9, [sp, #8]		; 取出j
	add	w0, w8, w9
	add	sp, sp, #48             ; =48
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48             ; =48
	stp	x29, x30, [sp, #32]     ; 16-byte Folded Spill
	add	x29, sp, #32            ; =32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16

	stur	wzr, [x29, #-4]
	stur	w0, [x29, #-8]		;x 
	str	x1, [sp, #16] 	; x1 写入 sp+16内存地址
	; w0-w7中顺序存第1~8个参数, 后面的参数存在[sp]和[sp, #4]对应的地址处，也就是栈上
	mov	w0, #1 			; w0=1 		参数 a  
	mov	w1, #2 			; w1=2 		参数 b
	mov	w2, #3 			; w2=3 		参数 c
	mov	w3, #4 			; w3=4 		参数 d
	mov	w4, #5 			; w4=5 		参数 e
	mov	w5, #6 			; w5=6 		参数 f
	mov	w6, #7 			; w6=7 		参数 g
	mov	w7, #8 			; w7=8 		参数 h
	mov	x8, sp 			; x8=sp 	
	mov	w9, #9 			; w9=9 		参数 i
	str	w9, [x8] 		; w9 写入 sp内存地址
	mov	w9, #10 		; w9=10 	参数 j
	str	w9, [x8, #4] 	; w9 写入 sp+4内存地址
	bl	_add
	ldp	x29, x30, [sp, #32]     ; 16-byte Folded Reload
	add	sp, sp, #48             ; =48
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
