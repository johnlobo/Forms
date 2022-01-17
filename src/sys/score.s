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





.module score_system

;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA

score::                     .db #0x00, #0x00, #0x00, #0x00
hi_score::                  .db #0x00, #0x00, #0x00, #0x00
score_buffer::              .db #0x00, #0x00, #0x00, #0x00

hi_score_table::    
    .db #0x50, #0x00, #0x00, #0x00 
    .asciz "DAVID     "
    .db #0x40, #0x00, #0x00, #0x00 
    .asciz "MARIA     "
    .db #0x30, #0x00, #0x00, #0x00 
    .asciz "DIEGO     "
    .db #0x20, #0x00, #0x00, #0x00 
    .asciz "MARTIN    "
    .db #0x10, #0x00, #0x00, #0x00 
    .asciz "FIRST     "

_hiscore_enter_string: .asciz "HIGH SCORE ENTER YOUR NAME"  ;; 26 chars, 52 bytes
_hiscore_line1_string: .asciz "A  B  C  D  E  F  G  H  I"   ;; 25 chars, 50 bytes
_hiscore_line2_string: .asciz "J  K  L  M  N  O  P  Q  R"   ;; 25 chars, 50 bytes
_hiscore_line3_string: .asciz "S  T  U  V  W  X  Y  Z"      ;; 22 chars, 44 bytes
_hiscore_space_string: .asciz "SPACE"                        ;; 5 chars, 10 bytes
_hiscore_delete_string: .asciz "DELETE"                       ;; 6 chars, 12 bytes
_hiscore_done_string: .asciz "DONE"                         ;; 4 chars, 8 bytes
_hiscore_name_string: .asciz "__________"                   ;; 10 chars, 20 bytes


;;
;; Start of _CODE area
;; 
.area _CODE


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

;;-----------------------------------------------------------------
;;
;; sys_score_hiscore_reached
;;
;;  Checks if a high score has been reached
;;  Input: hl: address to Score to check
;;  Output: c: "0" if no high score has been reached, "1" otherwise
;;  Modified: af, de, hl, bc
;;
sys_score_hiscore_reached::
    ld hl, #score
    ld de, #(hi_score_table+(sizeof_sc*4))
    call sys_util_BCD_Compare
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

    cpctm_setBorder_asm HW_BLACK
    
    ld e, #8                            ;; x
    ld d, #32                           ;; y
    ld b, #138                          ;; h
    ld c, #62                           ;; w      
    call sys_messages_draw_window

    ;; print title
    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 14, 40  ;; screen address for 30, 120 in de
    ld hl, #_hiscore_enter_string    ;; message
    call sys_text_draw_string

    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 15, 60  ;; screen address for 30, 120 in de
    ld hl, #_hiscore_line1_string    ;; message
    call sys_text_draw_string

    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 15, 75  ;; screen address for 30, 120 in de
    ld hl, #_hiscore_line2_string    ;; message
    call sys_text_draw_string

    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 15, 90  ;; screen address for 30, 120 in de
    ld hl, #_hiscore_line3_string    ;; message
    call sys_text_draw_string

    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 15, 105  ;; screen address for 30, 120 in de
    ld hl, #_hiscore_space_string    ;; message
    call sys_text_draw_string

    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 15, 120  ;; screen address for 30, 120 in de
    ld hl, #_hiscore_delete_string    ;; message
    call sys_text_draw_string

    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 15, 135  ;; screen address for 30, 120 in de
    ld hl, #_hiscore_done_string    ;; message
    call sys_text_draw_string

    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 30, 155  ;; screen address for 30, 120 in de
    ld hl, #_hiscore_name_string    ;; message
    call sys_text_draw_string
    

    call sys_input_wait4anykey
    ret

;;-----------------------------------------------------------------
;;
;; sys_score_check_entry_keyboard
;;
;;   Renders high score screen
;;  Input: 
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_score_check_entry_keyboard:
    ret
;;-----------------------------------------------------------------
;;
;; sys_score_get_marker_width
;;
;;  Returns the width & height of the marker in BC
;;  Input:  ix: address to the marker strcut
;;  Output: bc: height & widht of the marker
;;  Modified: af, hl, de, bc
;;
sys_score_get_marker_width:
    ld a, m_y(ix)
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
    ld c, #11
    ret

;;-----------------------------------------------------------------
;;
;; sys_score_entry_print_marker
;;
;;  Render de marker
;;  Input:  ix: address to the marker strcut
;;          a: printing or erasing
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_score_entry_print_marker:

    ;; Draw Back window

    ld a, m_y(ix)                    ;; B = y coordinate 
    sla a
    sla a                             ;; multiply y coord by 4 
    add #entry_start_y              ;; add the staring position in screen
    ld b,a
    ld h, m_x(ix)                   ;; C = x coordinate 
    ld e, #11
    call sys_util_h_times_e         ;; multiply by 11
    ld a, l
    add #entry_start_x
    ld c, a
    ld de, #CPCT_VMEM_START_ASM     ;; DE = Pointer to start of the screen
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL
    ex de, hl                       ;; move screen address to de
    call sys_score_get_marker_width
    ld a,#33                        ;; Patern of solid box
    call sys_messages_draw_box
    ld m_moved(ix), #0
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
    
    call sys_score_hiscore_entry_screen
    ld ix, #marker
    ld m_moved(ix), #1
    ld m_x(ix), #0
    ld m_y(ix), #0
    call sys_score_entry_print_marker
loop:
    call sys_score_check_entry_keyboard
    ld a, m_moved(ix)
    or a
    jr z, loop
    ret
;; marker struct
marker:
    .db #0              ;; moved
    .db #0, #0          ;; x, y
    .db #0, #0          ;; px, py
;; Marker strcut constants
m_moved = 0
m_x = 1
m_y = 2
m_px = 3
m_py = 4
;; General use constants
m_w02 = 4
m_w3 = 10
m_w4 = 12
m_w5 = 8
m_h = 11
entry_start_x = 14
entry_start_y = 58
entry_width = 9
entry_letter_lines = 3