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
.include "sys/score.h.s"
.include "sys/system.h.s"
.include "sys/files.h.s"
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
_updating_hiscore_string: .asciz "UPDATING HIGH SCORE"

;;
;; Start of _CODE area
;; 
.area _CODE




;-----------------------------------------------------------------
;;
;; _persist_hiscore
;;   Draw player1
;;  Input:  
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
_persist_hiscore::
   ld ix, #player1                     ;;
   ld a, e_hiscore(ix)                 ;; Persist high score
   or a                                ;;
   ret z                               ;; return if not necessary to update the hi score on disk.
   ld e, #18                           ;; x
   ld d, #78                           ;; y
   ld b, #44                           ;; h
   ld c, #44                           ;; w
   ld hl, #_updating_hiscore_string    ;; message
   xor a                               ;; dont wait for a key
   call sys_messagees_show
   call activate_firmware
   call sys_files_save_file
   call deactivate_firmware
   ret


;-----------------------------------------------------------------
;;
;; _update_hiscore
;;   Draw player1
;;  Input:  
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
_update_hiscore::
   call sys_render_init
   ld e, #18                           ;; x
   ld d, #78                           ;; y
   ld b, #44                           ;; h
   ld c, #44                           ;; w
   ld hl, #_updating_hiscore_string    ;; message
   xor a                               ;; don't wait for a key
   call sys_messagees_show
   call activate_firmware
   call sys_files_load_file
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

   call sys_audio_init

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

   ret
;;-----------------------------------------------------------------
;;
;; MAIN function. This is the entry point of the application.
;;    _main:: global symbol is required for correctly compiling and linking
;;
_main::

   call cpct_disableFirmware_asm

   call _update_hiscore

   call deactivate_firmware
   
   call _main_init

start:
   call man_game_init

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
   ld hl, #_no_more_moves_string       ;; message
   ld a, #1                            ;; wait for a key
   call sys_messagees_show
   call sys_audio_stop_music
   call _persist_hiscore
   call sys_render_init
   call sys_audio_init
   call sys_render_logo_screen
   jr start

_game_cancelled:
   ld a, #LOSE_SONG                 ;The Subsong to play (&gt;=0).
   call sys_audio_init_song

   ld e, #24                           ;; x
   ld d, #78                           ;; y
   ld b, #44                           ;; h
   ld c, #34                           ;; w
   ld hl, #_game_cancelled_string      ;; message
   ld a, #1                            ;; wait for a key
   call sys_messagees_show
   call sys_audio_stop_music
   call _persist_hiscore
   call sys_render_init
   call sys_audio_init
   call sys_render_logo_screen
   jr start