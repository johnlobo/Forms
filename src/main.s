;;-----------------------------LICENSE NOTICE------------------------------------
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

_game_loaded_string: .asciz "GAME LOADED - PRESS ANY KEY"      ;;27 chars, 54 bytes
_updating_hiscore_string: .asciz "UPDATING HIGH SCORE"
_congratulations_string: .asciz "CONGRATS!! ITS A HIGH SCORE"
_enteryourname_string: .asciz "ENTER YOUR NAME"
_press_key_for_left: .asciz "PRESS KEY FOR LEFT"
_press_key_for_right: .asciz "PRESS KEY FOR RIGHT"
_press_key_for_up: .asciz "PRESS KEY FOR UP"
_press_key_for_down: .asciz "PRESS KEY FOR DOWN"
_press_key_for_change: .asciz "PRESS KEY FOR CHANGE PIECE"
_press_key_for_set: .asciz "PRESS KEY FOR SET PIECE"

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
_persist_hiscore:
   ld ix, #player1                     ;;

   call sys_score_hiscore_reached
   ret nc                               ;; return if not necessary to update the hi score on disk.
    
   call sys_score_hiscore_entry        ;; get name for the hiscore table

   ld e, #18                           ;; x
   ld d, #78                           ;; y
   ld b, #44                           ;; h
   ld c, #44                           ;; w
   ld hl, #_updating_hiscore_string    ;; message
   xor a                               ;; dont wait for a key
   call sys_messages_show

   ;; check if it's been loaded from disk
   ld a, (is_disk)
   or a
   ret z                               ;; if it's not disk return.

   call sys_system_activate_firmware
   call sys_files_save_file
   call sys_system_deactivate_firmware
   
   call sys_render_tribute_screen      ;; show tribute screen
   
   ret


;-----------------------------------------------------------------
;;
;; _update_hiscore
;;   Draw player1
;;  Input:  
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
_update_hiscore:
   ;; check if it's been loaded from disk
   ld a, (is_disk)
   or a
   ret z                               ;; if it's not disk return.

   call sys_render_init
   ld e, #18                           ;; x
   ld d, #78                           ;; y
   ld b, #44                           ;; h
   ld c, #44                           ;; w
   ld hl, #_updating_hiscore_string    ;; message
   xor a                               ;; don't wait for a key
   call sys_messages_show
   call sys_system_activate_firmware
   call sys_files_load_file
   ret


;;-----------------------------------------------------------------
;;
;; _show_redefine_one_key
;;   Draw main screen
;;  Input: hl message to show
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
_show_redefine_one_key:
   ld e, #11                           ;; x
   ld d, #78                           ;; y
   ld b, #44                           ;; h
   ld c, #58                           ;; w
   ;;ld hl, #_updating_hiscore_string    ;; message
   xor a                               ;; don't wait for a key
   call sys_messages_show
   ret

;;-----------------------------------------------------------------
;;
;; _redefine_keys
;;   Draw main screen
;;  Input:  
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
redefine_keys:
   ;; Redefine left key
   ld hl, #_press_key_for_left
   call _show_redefine_one_key
   call sys_input_waitKeyPressed
   ;; Update left key
   ld de, #sys_input_key_actions
   ex de, hl
   ld (hl), e
   inc hl
   ld (hl), d
   ;; Wait till key buffer is empty
   call sys_input_clean_buffer

   ;; Redefine right key
   ld hl, #_press_key_for_right
   call _show_redefine_one_key
   call sys_input_waitKeyPressed
   ;; Update right key
   ld de, #sys_input_key_actions+4
   ex de, hl
   ld (hl), e
   inc hl
   ld (hl), d
   ;; Wait till key buffer is empty
   call sys_input_clean_buffer

   ;; Redefine up key
   ld hl, #_press_key_for_up
   call _show_redefine_one_key
   call sys_input_waitKeyPressed
   ;; Update up key
   ld de, #sys_input_key_actions+8
   ex de, hl
   ld (hl), e
   inc hl
   ld (hl), d
   ;; Wait till key buffer is empty
   call sys_input_clean_buffer

   ;; Redefine down key
   ld hl, #_press_key_for_down
   call _show_redefine_one_key
   call sys_input_waitKeyPressed
   ;; Update down key
   ld de, #sys_input_key_actions+12
   ex de, hl
   ld (hl), e
   inc hl
   ld (hl), d
   ;; Wait till key buffer is empty
   call sys_input_clean_buffer

   ;; Redefine set piece
   ld hl, #_press_key_for_set
   call _show_redefine_one_key
   call sys_input_waitKeyPressed
   ;; Update set key
   ld de, #sys_input_key_actions+16
   ex de, hl
   ld (hl), e
   inc hl
   ld (hl), d
   ;; Wait till key buffer is empty
   call sys_input_clean_buffer

   ;; Redefine change piece
   ld hl, #_press_key_for_change
   call _show_redefine_one_key
   call sys_input_waitKeyPressed
   ;; Update change key
   ld de, #sys_input_key_actions+20
   ex de, hl
   ld (hl), e
   inc hl
   ld (hl), d
   ;; Wait till key buffer is empty
   ret

;;-----------------------------------------------------------------
;;
;; _show_main_screen
;;   Draw main screen
;;  Input:  
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
_show_main_screen:
   call sys_render_logo_screen  
   call sys_input_main_screen_keys
   or a                             ;; check if any key different from r has been pressed
   ret z                            ;; return ir any key was pressed
   call nz, redefine_keys          ;; if r was pressed, redefine keys
   jr _show_main_screen             ;; return to main screen

;;-----------------------------------------------------------------
;;
;; main_init
;;   Draw player1
;;  Input:  
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
_main_init:

   call sys_audio_init

   call sys_render_init

   ld e, #10                           ;; x
   ld d, #78                           ;; y
   ld b, #44                           ;; h
   ld c, #60                           ;; w
   ld hl, #_game_loaded_string    ;; message
   xor a                               ;; don't wait for a key
   call sys_messages_show

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
   pop af                                  ;; retrieve last a value to set the seed
   call cpct_setSeed_xsp40_u8_asm          ;; change seed

   call sys_render_hiscore_screen

   call _show_main_screen

   ret
;;-----------------------------------------------------------------
;;
;; MAIN function. This is the entry point of the application.
;;    _main:: global symbol is required for correctly compiling and linking
;;
_main::

   call cpct_disableFirmware_asm

   call sys_files_check_media                   ;; store info to check if it's loaded in a cdt or a disk

   call _update_hiscore

   call sys_system_deactivate_firmware
   
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
   jr nz, _end_of_game

   ;; check if the game has been cancelled
   ld a, (man_game_cancelled_game)
   or a
   jr nz, _game_cancelled
   jr    loop

_end_of_game:
   ld a, #LOSE_SONG                          ;The Subsong to play (&gt;=0).
   call sys_audio_init_song

   call sys_render_nomoremoves_screen

   jr _restart_game

_game_cancelled:
   ld a, #LOSE_SONG                          ;The Subsong to play (&gt;=0).
   call sys_audio_init_song

   call sys_render_game_cancelled_screen

_restart_game:
   call sys_audio_stop_music
   call _persist_hiscore
   call sys_render_init
   call sys_audio_init
   call sys_render_hiscore_screen
   call _show_main_screen
   jr start