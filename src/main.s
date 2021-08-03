;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of CPCtelera: An Amstrad CPC Game Engine 
;;  Copyright (C) 2018 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
;;
;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU Lesser General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.
;;
;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU Lesser General Public License for more details.
;;
;;  You should have received a copy of the GNU Lesser General Public License
;;  along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;-------------------------------------------------------------------------------

;; Include all CPCtelera constant definitions, macros and variables
.include "cpctelera.h.s"
.include "sys/render.h.s"
.include "sys/board.h.s"
.include "sys/input.h.s"
.include "man/entity.h.s"
.include "man/game.h.s"
.include "common.h.s"

.module main

;;-----------------------------------------------------------------
;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA

;;
;; Start of _CODE area
;; 
.area _CODE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;DESCRIPTION
;; Called every interruption
;;
;;DESTROYS: AF, BC, DE
;;
set_int_handler:
	ld hl, #0x38
	ld (hl), #0xc3
	inc hl
	ld (hl), #<int_handler1
	inc hl
	ld (hl), #>int_handler1
	inc hl
	ld (hl), #0xc9
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;DESCRIPTION
;; Called on the first interruption
;;
;;DESTROYS: AF, BC, DE
;;
int_handler1::

; 	ld a, (uncontador)
; 	xor #1
; 	ld (uncontador), a

; 	ld h, #0
; 	ld l, #16
; 	call cpct_setPALColour_asm

; 	ld h, #6
; 	ld l, #16
; 	call cpct_setPALColour_asm
	
;;	ld a, (song_playing)
;;	or a
;;	call nz, cpct_akp_musicPlay_asm
;;
;;	ld a, #01
;;	ld (render_interrupt), a
;;
	ld hl, #int_handler2
 	call cpct_setInterruptHandler_asm	
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;DESCRIPTION
;; Called every interruption
;;
;;DESTROYS: AF, BC, DE
;;
int_handler2::
; 	ld a, (uncontador)
; 	xor #1
; 	ld (uncontador), a

; 	ld h, #1
; 	ld l, #16
; 	call cpct_setPALColour_asm
	call cpct_scanKeyboard_if_asm

	;;ld a, #00
	;;ld (render_interrupt), a

	ld hl, #int_handler3
   call cpct_setInterruptHandler_asm
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;DESCRIPTION
;; Called every interruption
;;
;;DESTROYS: AF, BC, DE
;;
int_handler3::
; 	ld a, (uncontador)
; 	xor #2
; 	ld (uncontador), a

; 	ld h, #2
; 	ld l, #16
; 	call cpct_setPALColour_asm
	

	ld hl, #int_handler4
   call cpct_setInterruptHandler_asm
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;DESCRIPTION
;; Called every interruption
;;
;;DESTROYS: AF, BC, DE
;;
int_handler4::
; 	ld a, (uncontador)
; 	xor #1
; 	ld (uncontador), a

; 	ld h, #3
; 	ld l, #16
; 	call cpct_setPALColour_asm

; 	ld a, (starscreen_bool)
; 	ld b, a
; 	ld a, (gameoverscreen_bool)
; 	or b
; 	call z, rendersys_drawintfc
	
	ld hl, #int_handler5
   call cpct_setInterruptHandler_asm
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;DESCRIPTION
;; Called every interruption
;;
;;DESTROYS: AF, BC, DE
;;
int_handler5::
; 	ld a, (uncontador)
; 	xor #1
; 	ld (uncontador), a

; 	ld h, #4
; 	ld l, #16
; 	call cpct_setPALColour_asm
	ld hl, #int_handler6
   call cpct_setInterruptHandler_asm
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;DESCRIPTION
;; Called every interruption
;;
;;DESTROYS: AF, BC, DE
;;
int_handler6::
; 	ld a, (uncontador)
; 	xor #1
; 	ld (uncontador), a

; 	ld h, #5
; 	ld l, #16
; 	call cpct_setPALColour_asm
	ld hl, #int_handler1
   call cpct_setInterruptHandler_asm
	ret


;;-----------------------------------------------------------------
;;
;; main_init
;;   Draw player1
;;  Input:  
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
_main_init::
   call sys_render_init

   call sys_render_logo_screen

   ;; set random seed
   xor a
   push af                             ;; store a=0 in the stack
_main_init_keypress:
   pop af                              ;; retrive a value form stack
   inc a                               ;; inc a value
   push af                             ;; store a value in stack
   
   inc hl
   call cpct_isAnyKeyPressed_asm
   or a
   jr z, _main_init_keypress

   ld hl, #0xbc00
   ld de, #0xac00
   pop af                              ;; retrieve last a value to set the seed
   call cpct_setSeed_xsp40_u8_asm          ;; change seed

   cpctm_clearScreen_asm 255
   
   call sys_input_init

   call man_game_init

   ret
;;-----------------------------------------------------------------
;;
;; MAIN function. This is the entry point of the application.
;;    _main:: global symbol is required for correctly compiling and linking
;;
_main::
   call cpct_disableFirmware_asm
   ld hl, #int_handler1
   call cpct_waitVSYNC_asm
   halt
   halt
   call cpct_waitVSYNC_asm
   call cpct_setInterruptHandler_asm

   call _main_init

   ;; Loop forever
loop:
   ld b,#18
   call cpct_waitHalts_asm
   
   call man_game_update

   jr    loop