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
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x00	; 0
_s_balls_small_1:
	.db #0x05	; 5
	.db #0xcf	; 207
	.db #0x00	; 0
	.db #0x4f	; 79	'O'
	.db #0xcf	; 207
	.db #0x8a	; 138
	.db #0x4f	; 79	'O'
	.db #0xcf	; 207
	.db #0x8a	; 138
	.db #0xcf	; 207
	.db #0xcf	; 207
	.db #0x8a	; 138
	.db #0xcf	; 207
	.db #0xcf	; 207
	.db #0x8a	; 138
	.db #0xcf	; 207
	.db #0xcf	; 207
	.db #0x8a	; 138
	.db #0xcf	; 207
	.db #0xcf	; 207
	.db #0x8a	; 138
	.db #0xcf	; 207
	.db #0xcf	; 207
	.db #0x8a	; 138
	.db #0x45	; 69	'E'
	.db #0xcf	; 207
	.db #0x00	; 0
_s_balls_small_2:
	.db #0x10	; 16
	.db #0xcc	; 204
	.db #0x00	; 0
	.db #0x64	; 100	'd'
	.db #0xcc	; 204
	.db #0x88	; 136
	.db #0x64	; 100	'd'
	.db #0xcc	; 204
	.db #0x88	; 136
	.db #0xcc	; 204
	.db #0xcc	; 204
	.db #0x88	; 136
	.db #0xcc	; 204
	.db #0xcc	; 204
	.db #0x88	; 136
	.db #0xcc	; 204
	.db #0xcc	; 204
	.db #0x88	; 136
	.db #0xcc	; 204
	.db #0xcc	; 204
	.db #0x88	; 136
	.db #0xcc	; 204
	.db #0xcc	; 204
	.db #0x88	; 136
	.db #0x44	; 68	'D'
	.db #0xcc	; 204
	.db #0x00	; 0
_s_balls_small_3:
	.db #0x14	; 20
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0xf0	; 240
	.db #0xa0	; 160
	.db #0x78	; 120	'x'
	.db #0xf0	; 240
	.db #0xa0	; 160
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xa0	; 160
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xa0	; 160
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xa0	; 160
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xa0	; 160
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xa0	; 160
	.db #0x50	; 80	'P'
	.db #0xf0	; 240
	.db #0x00	; 0
_s_balls_small_4:
	.db #0x05	; 5
	.db #0x33	; 51	'3'
	.db #0x00	; 0
	.db #0x1b	; 27
	.db #0x33	; 51	'3'
	.db #0x22	; 34
	.db #0x1b	; 27
	.db #0x33	; 51	'3'
	.db #0x22	; 34
	.db #0x33	; 51	'3'
	.db #0x33	; 51	'3'
	.db #0x22	; 34
	.db #0x33	; 51	'3'
	.db #0x33	; 51	'3'
	.db #0x22	; 34
	.db #0x33	; 51	'3'
	.db #0x33	; 51	'3'
	.db #0x22	; 34
	.db #0x33	; 51	'3'
	.db #0x33	; 51	'3'
	.db #0x22	; 34
	.db #0x33	; 51	'3'
	.db #0x33	; 51	'3'
	.db #0x22	; 34
	.db #0x11	; 17
	.db #0x33	; 51	'3'
	.db #0x00	; 0
_s_balls_small_5:
	.db #0x14	; 20
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x29	; 41
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x29	; 41
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x00	; 0
_s_balls_small_6:
	.db #0x14	; 20
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x30	; 48	'0'
	.db #0x20	; 32
	.db #0x38	; 56	'8'
	.db #0x30	; 48	'0'
	.db #0x20	; 32
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x20	; 32
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x20	; 32
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x20	; 32
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x20	; 32
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x20	; 32
	.db #0x10	; 16
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.area _INITIALIZER
	.area _CABS (ABS)
