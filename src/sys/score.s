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

.include "cpctelera.h.s"
.include "sys/text.h.s"
.include "../common.h.s"
.include "sys/score.h.s"
.include "sys/util.h.s"
.include "sys/input.h.s"
.include "sys/messages.h.s"

.module sys_score

;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA


hi_score::  .db #0x00, #0x00, #0x00, #0x00
hi_score_name_string:: .ds #11       ;; 10 bytes + 0

score_buffer::  .db #0x00, #0x00, #0x00, #0x00

score:: .db #0x00, #0x00, #0x00, #0x00
score_name_string:: .ds #11       ;; 10 bytes + 0
score_name_length:: .db #0

hi_score_table::    
    .db #0x00, #0x20, #0x00, #0x00 
    .asciz "MARIA     "
    .db #0x00, #0x10, #0x00, #0x00 
    .asciz "DIEGO     "
    .db #0x00, #0x05, #0x00, #0x00 
    .asciz "MARTIN    "
    .db #0x00, #0x03, #0x00, #0x00 
    .asciz "JOHN LOBO "
    .db #0x00, #0x01, #0x00, #0x00 
    .asciz "GLASNOST  "

_player_string: .asciz "PLAYER"                                 ;; 6 chars, 12 bytes
_hiscore_enter_string: .asciz "CONGRATULATIONS!! HIGH SCORE"    ;; 28 chars, 56 bytes
_hiscore_enter2_string: .asciz "ENTER YOUR NAME"                ;; 15 chars, 30 bytes
_hiscore_line1_string: .asciz "A  B  C  D  E  F  G  H  I"       ;; 25 chars, 50 bytes
_hiscore_line2_string: .asciz "J  K  L  M  N  O  P  Q  R"       ;; 25 chars, 50 bytes
_hiscore_line3_string: .asciz "S  T  U  V  W  X  Y  Z"          ;; 22 chars, 44 bytes
_hiscore_space_string: .asciz "SPACE"                           ;; 5 chars, 10 bytes
_hiscore_delete_string: .asciz "DELETE"                         ;; 6 chars, 12 bytes
_hiscore_done_string: .asciz "DONE"                             ;; 4 chars, 8 bytes


;; score marker struct
score_marker::
    .db #0              ;; moved
    .db #0, #0          ;; x, y
    .db #0, #0          ;; px, py
    .db #0              ;; ended

;;
;; Start of _CODE area
;; 
.area _CODE

;;-----------------------------------------------------------------
;;
;; sys_score_init
;;
;;  Initializes a score buffer
;;  Input: hl: buffer to reset
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_score_init::
    ld hl, #hi_score_table
    ld de, #hi_score
    ld bc, #15
    ldir
    
    ;; Reset score buffer
    ld hl, #score
    call sys_score_reset_score_buffer

    ;; Reset hiscore string
    ld hl, #first_start
    ld (sys_score_copy_score_2_hiscore+1), hl

    ret

;;-----------------------------------------------------------------
;;
;; sys_score_reset_score_buffer
;;
;;  Initializes a score buffer
;;  Input: hl: buffer to reset
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_score_reset_score_buffer::
    xor a
    ld (hl), a
    inc hl
    ld (hl), a
    inc hl
    ld (hl), a
    inc hl
    ld (hl), a
    ret

;-----------------------------------------------------------------
;;
;;  man_game_copy_score_2_hiscore
;;
;;  set piece in board
;;  Input: 
;;  Output:
;;  Modified:
;;
sys_score_copy_score_2_hiscore::
    jp first_start
first_start:
    ld hl, #_player_string
    ld de, #hi_score_name_string
    ld bc, #11
    ldir
    ld hl, #second_start
    ld (sys_score_copy_score_2_hiscore+1), hl
second_start:
    ld hl, #score
    ld de, #hi_score
    ld bc, #4
    ldir
    ret

;;-----------------------------------------------------------------
;;
;; sys_score_hiscore_reached
;;
;;  Checks if a high score has been reached
;;  Input: 
;;  Output: c: "0" if no high score has been reached, "1" otherwise
;;  Modified: af, de, hl, bc
;;
sys_score_hiscore_reached::
    ld hl, #score
    ld de, #(hi_score_table+(sizeof_sc*4))      ;; Compare start of fifth element in high score table
    call sys_util_BCD_Compare
    ret


;;-----------------------------------------------------------------
;;
;; sys_score_hiscore_name_print
;;
;;  Prints the hiscore name
;;  Input: 
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_score_hiscore_name_print::
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 30, 155  ;; screen address for 30, 155 in de
    ld bc, #0x0914
    ld a, #0xff
    call cpct_drawSolidBox_asm

    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 30, 155  ;; screen address for 30, 155 in de
    ld hl, #score_name_string    ;; message
    call sys_text_draw_string
    ret

;;-----------------------------------------------------------------
;;
;; sys_score_hiscore_entry_screen
;;
;;  Renders high score screen entry name
;;  Input: 
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_score_hiscore_entry_screen:
    ;; clear screen
    cpctm_clearScreen_asm 255           ;; Clear screen

    ;;cpctm_setBorder_asm HW_BLACK
    
    ld e, #8                            ;; x
    ld d, #32                           ;; y
    ld b, #139                          ;; h
    ld c, #63                           ;; w      
    call sys_messages_draw_window

    ;; print title
    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 12, 40  ;; screen address for 30, 120 in de
    ld hl, #_hiscore_enter_string    ;; message
    call sys_text_draw_string

    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 25, 60  ;; screen address for 30, 120 in de
    ld hl, #_hiscore_enter2_string    ;; message
    call sys_text_draw_string

    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 15, 80  ;; screen address for 30, 120 in de
    ld hl, #_hiscore_line1_string    ;; message
    call sys_text_draw_string

    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 15, 95  ;; screen address for 30, 120 in de
    ld hl, #_hiscore_line2_string    ;; message
    call sys_text_draw_string

    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 15, 110  ;; screen address for 30, 120 in de
    ld hl, #_hiscore_line3_string    ;; message
    call sys_text_draw_string

    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 15, 125  ;; screen address for 30, 120 in de
    ld hl, #_hiscore_space_string    ;; message
    call sys_text_draw_string

    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 15, 140  ;; screen address for 30, 120 in de
    ld hl, #_hiscore_delete_string    ;; message
    call sys_text_draw_string

    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 15, 155  ;; screen address for 30, 120 in de
    ld hl, #_hiscore_done_string    ;; message
    call sys_text_draw_string

    call sys_score_hiscore_name_print
    
    ret

;;-----------------------------------------------------------------
;;
;; sys_score_get_marker_width
;;
;;  Returns the width & height of the marker in BC
;;  Input:  ix: address to the marker strcut
;;          a: 1 -> current coordinates; 0 -> previous coordinates
;;  Output: bc: height & widht of the marker
;;  Modified: af, hl, de, bc
;;
sys_score_get_marker_width:
    or a                        ;; select current or previous coords
    jr nz, current_coords
    ld a, m_py(ix)              ;; a=0 -> previous coords
    jr start_marker_width
current_coords:
    ld a, m_y(ix)               ;; a<>0 -> current coords
start_marker_width:
    cp #3                   ;; check if marker is in the first 3 lines (letters)
    jr c, letter_lines
    jr z, third_row         ;; check if it's on the forth
    cp #4
    jr z, forth_row         ;; check if it's on the fifth
    ld b, #m_w5
    jr height
letter_lines:
    ld b, #m_w02
    jr height
third_row:
    ld b, #m_w3
    jr height
forth_row:
    ld b, #m_w4
height:
    ld c, #m_h
    ret

;;-----------------------------------------------------------------
;;
;; sys_score_entry_generic_print_marker
;;
;;  Render de marker
;;  Input:  ix: address to the marker strcut
;;          a: printing or erasing
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_score_entry_print_marker::

    ;; Erase
    ld h, m_py(ix)                    ;; B = y coordinate 
    ld e, #m_place_height
    call sys_util_h_times_e         ;; multiply by 11
    ld a, l
    add #entry_start_y              ;; add the staring position in screen
    ld b,a

    ld h, m_px(ix)                   ;; C = x coordinate 
    ld e, #m_place_width
    call sys_util_h_times_e         ;; multiply by 11
    ld a, l
    add #entry_start_x
    ld c, a

    ld de, #CPCT_VMEM_START_ASM     ;; DE = Pointer to start of the screen
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL
    ex de, hl                       ;; move screen address to de
    xor a                           ;; previous coords parameter
    call sys_score_get_marker_width ;; get market width
    ld a,#0xff                      ;; Patern of solid box
    call sys_messages_draw_box
    
    ;; Print
    ld h, m_y(ix)                    ;; B = y coordinate 
    ld e, #m_place_height
    call sys_util_h_times_e         ;; multiply by 11
    ld a, l
    add #entry_start_y              ;; add the staring position in screen
    ld b,a

    ld h, m_x(ix)                   ;; C = x coordinate 
    ld e, #m_place_width
    call sys_util_h_times_e         ;; multiply by 11
    ld a, l
    add #entry_start_x
    ld c, a

    ld de, #CPCT_VMEM_START_ASM     ;; DE = Pointer to start of the screen
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL
    ex de, hl                       ;; move screen address to de
    ld a, #1                        ;; current coords parameter
    call sys_score_get_marker_width ;; get market width
    ld a,#0xc0                      ;; Patern of solid box
    call sys_messages_draw_box
    
    ld m_moved(ix), #0
    ;; Update previous coordinates
    ld a, m_x(ix)
    ld m_px(ix), a
    ld a, m_y(ix)
    ld m_py(ix), a
    ret



;;-----------------------------------------------------------------
;;
;; sys_score_hiscore_entry
;;
;;   Renders high score screen
;;  Input: 
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_score_hiscore_entry::    
    ld hl, #score_name_string
    ld (hl), #0
    ld hl, #score_name_length
    ld (hl), #0
    call sys_score_hiscore_entry_screen
    ld ix, #score_marker
    ld m_moved(ix), #1
    ld m_ended(ix), #0
    ld m_x(ix), #0
    ld m_y(ix), #0
    ld m_px(ix), #0
    ld m_py(ix), #0
    call sys_score_entry_print_marker
entry_loop:
    ld b, #30
    call cpct_waitHalts_asm
    call sys_input_score_entry_update
    ld a, m_moved(ix)
    or a
    jr z, check_end
    call sys_score_entry_print_marker
check_end:
    ld a, m_ended(ix)
    or a
    jr z, entry_loop
    call sys_score_update_high_score_table
    ret

;;-----------------------------------------------------------------
;;
;; sys_score_update_high_score_table
;;
;;  Updates the high score table with the score and the score_name_string
;;  Input: 
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_score_update_high_score_table::
    ld b, #4
    ld hl, #score
    ld de, #hi_score_table
update_loop:
    cpctm_push hl, de, bc
    call sys_util_BCD_Compare
    cpctm_pop bc, de, hl
    jr c, move_data
    dec b
    ld a, #sizeof_sc
    add_de_a
    jr update_loop
move_data:
    ld a,e
    ld (_move_place_to_insert_row), a
    ld a,d
    ld (_move_place_to_insert_row+1), a         ;; save the place to insert new row
    ld a,b
    or a
    jr z, _move_new_row                         ;; if the row to insert is the last, just copy
    ld h, #sizeof_sc
    ld e, b
    call sys_util_h_times_e                         ;; calculate the amount of bytes to move
    ld a, l                     
    ld (_move_amount), a                        ;; keep the amount of bytes to copy (self modifying)
    ld hl, #(hi_score_table+(sizeof_sc * 4)-1)
    ld de, #(hi_score_table+sizeof_sc_tb-1)
_move_amount = .+1
    ld b, #0                                        ;; amount of data to copy data
_move_loop:
    ld a, (hl)
    ld (de), a
    dec de
    dec hl
    djnz _move_loop
_move_new_row:
_move_place_to_insert_row = .+1
    ld de, #0000
    ld hl, #score
    ld c,#sizeof_sc
    ld b, #0
    ldir                                            ;; move score and name in new place
    ret