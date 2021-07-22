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
.include "../common.h.s"
.include "man/entity.h.s"


.module board_system

;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA

_piece_w: .db #00
_piece_h: .db #00
_current_row: .db #00

;;
;; Start of _CODE area
;; 
.area _CODE

board::
    .db #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00
    .db #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00
    .db #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00
    .db #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00
    .db #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00
    .db #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00
    .db #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00
    .db #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00
    .db #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00
    .db #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00, #0x00
    

;;-----------------------------------------------------------------
;;
;; sys_render_board
;;
;;   Renders board
;;  Input: 
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_board_init::
    
    ld de, #board       ;; Set the board address
    ld a, #0x00         ;; Set the initilization value, 0
    ld bc, # (BOARD_ROWS * BOARD_COLS)         ;; Set the size to set 10x10
    call cpct_memset_asm
    ret

;;-----------------------------------------------------------------
;;
;; sys_board_cell_content
;;
;;   Renders board
;;  Input:  c: col
;;          b: row
;;  Output: a: content of cell
;;  Modified: af, hl, de, bc
;;
sys_board_cell_content::
    ;; check if cell board is empty
    ld a, b
    sla a
    sla a
    sla a                                   ;; multiply by 8
    add b
    add b                                   ;; then add 2 times coord y and thats it.
    add c                                   ;; then add the x coord and we have the offset for the cell
    ld hl, #board
    add l
    ld l,a                                  ;; Then add the offset
    ld a, (hl)                      ;; load the content of the board in a
    ret

;;-----------------------------------------------------------------
;;
;; sys_board_cell_sprite
;;
;;   Renders board
;;  Input:  c: col
;;          b: row
;;  Output: hl : address fo the corresponding cell sprite
;;  Modified: af, hl, de, bc
;;
sys_board_cell_sprite::
    call sys_board_cell_content     ;; retrieve the content of the cell
    ld   hl, #_s_balls_big_7        ;; load in hl the default sprite
    or a                            ;; check if the content is 0
    ret z                           ;; if 0 just return with hl pointing to the default sprite
    ld hl, #_s_balls_big_0          ;; otherwise load in hl the occupied sprite
    ret

;;-----------------------------------------------------------------
;;
;; sys_board_cell_sprite
;;
;;   Renders board
;;  Input:  c: col
;;          b: row
;;  Output: 
;;  Modified: af, hl, bc
;;
sys_board_set_cell::
    ld a, b
    sla a
    sla a
    sla a                                   ;; multiply by 8
    add b
    add b                                   ;; then add 2 times coord y and thats it.
    add c                                   ;; then add the x coord and we have the offset for the cell
    ld hl, #board
    add l
    ld l,a                                  ;; Then add the offset
    ld (hl), #01                            ;; load 1 in the corresponding cell
    ret

;;-----------------------------------------------------------------
;;
;; sys_board_cell_sprite
;;
;;   Renders board
;;  Input:  c: col
;;          b: row
;;          a: piece
;;  Output: 
;;  Modified: af, hl, de, bc
;;
sys_board_set_piece::
    call man_entity_get_hl_from_piece   ;; get address for a type of piece in hl
    ld a, (hl)
    ld (_piece_w),a
    ld (sb_set_piece_condition_width + 1), a        ;; self modifying code for width condition
    inc (hl)
    ld a, (hl)
    ld (_piece_h),a
    ld (sb_set_piece_condition_height + 1), a        ;; self modifying code for height condition
    inc (hl)

    ld b, #0
sb_set_piece_loop0:

    ld c, #0
sb_set_piece_loop1:

    ld a, c
sb_set_piece_condition_width:
    cp #00
    jr c, sb_set_piece_loop1

sb_set_piece_condition_height:
    cp #00
    jr c, sb_set_piece_loop0
    
    ret