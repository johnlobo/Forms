;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.6.8 #9946 (Mac OS X x86_64)
;--------------------------------------------------------
	.module balls_small
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _s_balls_small_6
	.globl _s_balls_small_5
	.globl _s_balls_small_4
	.globl _s_balls_small_3
	.globl _s_balls_small_2
	.globl _s_balls_small_1
	.globl _s_balls_small_0
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
	.area _CODE
_s_balls_small_0:
	.db #0x0f	; 15
	.db #0x20	; 32
	.db #0x1a	; 26
	.db #0x20	; 32
	.db #0x30	; 48	'0'
	.db #0x20	; 32
	.db #0x30	; 48	'0'
	.db #0x20	; 32
	.db #0x30	; 48	'0'
	.db #0x20	; 32
_s_balls_small_1:
	.db #0xf3	; 243
	.db #0x82	; 130
	.db #0xe3	; 227
	.db #0x82	; 130
	.db #0xc3	; 195
	.db #0x82	; 130
	.db #0xc3	; 195
	.db #0x82	; 130
	.db #0xc3	; 195
	.db #0x82	; 130
_s_balls_small_2:
	.db #0xcc	; 204
	.db #0x08	; 8
	.db #0x8c	; 140
	.db #0x08	; 8
	.db #0x0c	; 12
	.db #0x08	; 8
	.db #0x0c	; 12
	.db #0x08	; 8
	.db #0x0c	; 12
	.db #0x08	; 8
_s_balls_small_3:
	.db #0xcf	; 207
	.db #0x02	; 2
	.db #0x8b	; 139
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x02	; 2
_s_balls_small_4:
	.db #0xf0	; 240
	.db #0x80	; 128
	.db #0xe0	; 224
	.db #0x80	; 128
	.db #0xc0	; 192
	.db #0x80	; 128
	.db #0xc0	; 192
	.db #0x80	; 128
	.db #0xc0	; 192
	.db #0x80	; 128
_s_balls_small_5:
	.db #0xcf	; 207
	.db #0x0a	; 10
	.db #0x8f	; 143
	.db #0x0a	; 10
	.db #0x0f	; 15
	.db #0x0a	; 10
	.db #0x0f	; 15
	.db #0x0a	; 10
	.db #0x0f	; 15
	.db #0x0a	; 10
_s_balls_small_6:
	.db #0xcf	; 207
	.db #0x88	; 136
	.db #0xce	; 206
	.db #0x88	; 136
	.db #0xcc	; 204
	.db #0x88	; 136
	.db #0xcc	; 204
	.db #0x88	; 136
	.db #0xcc	; 204
	.db #0x88	; 136
	.area _INITIALIZER
	.area _CABS (ABS)
