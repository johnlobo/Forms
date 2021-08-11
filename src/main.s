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
.include "sys/text.h.s"
.include "sys/messages.h.s"
.include "man/entity.h.s"
.include "man/game.h.s"
.include "sys/audio.h.s"
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

_no_more_moves_string: .asciz "NO MORE MOVES"
_game_cancelled_string: .asciz "GAME CANCELLED"
_game_over_sring: .asciz "GAME OVER"

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
	call cpct_scanKeyboard_if_asm


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
   exx
   ex af', af  
   push af
   push bc
   push de
   push hl
   call PLY_AKG_PLAY
   pop hl
   pop de
   pop bc
   pop af
   ex af', af  
   exx

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
	ld hl, #int_handler1
   call cpct_setInterruptHandler_asm
	ret

;;-----------------------------------------------------------------
;;
;; main_audio_init
;;   Draw player1
;;  Input:  
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
main_audio_init::

   ld a, #FEVER_MIX
   call sys_audio_init_song

   call sys_audio_init_soundEffects

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

   call main_audio_init

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

   ld hl, #hi_score                    ;; Init hiscore
   call man_game_clean_number          ;; clean number

start:
   call _main_init

   ;; Loop forever
loop:
   ld b,#12
   call cpct_waitHalts_asm
   
   call man_game_update

   ;; check if are ther more moves
   ld a, (man_game_no_more_moves)
   or a
   jr nz, end_of_game

   ;; check if the game has been cancelled
   ld a, (man_game_cancelled_game)
   or a
   jr nz, _game_cancelled

   jr    loop

end_of_game:

   ld a, #LOSE_SONG                 ;The Subsong to play (&gt;=0).
   call sys_audio_init_song

   ld e, #24                           ;; x
   ld d, #78                           ;; y
   ld b, #44                           ;; h
   ld c, #32                           ;; w
   ld hl, #_no_more_moves_string      ;; message
   call sys_messagees_show
   jr start

_game_cancelled:
   ld a, #LOSE_SONG                 ;The Subsong to play (&gt;=0).
   call sys_audio_init_song

   ld e, #24                           ;; x
   ld d, #78                           ;; y
   ld b, #44                           ;; h
   ld c, #34                           ;; w
   ld hl, #_game_cancelled_string      ;; message
   call sys_messagees_show
   jr start