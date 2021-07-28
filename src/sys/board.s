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
.include "sys/render.h.s"
.include "util.h.s"



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
_piece_byte: .db #00

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

board_addresses::
    .dw #0x0000, #0x0000, #0x0000, #0x0000, #0x0000, #0x0000, #0x0000, #0x0000, #0x00000, #0x0000, #0x0000
;;
;; Start of _CODE area
;; 
.area _CODE


;;-----------------------------------------------------------------
;;
;; sys_board_generate_addresses
;;
;;  Generates a list with the address of the first cell in each row of the board   
;;  Input: 
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_board_generate_addresses::
    ld b, #0
    ld c, #BOARD_X_COORD
s_b_generate_addresses_loop:
    push bc                         ;; save row and col for latter loop
    ld e, #S_BALLS_BIG_H +1         ;; 
    ld h, b                         ;; calculate row x sprite height
    call sys_util_h_times_e                  ;;
    ld a, l                         ;;
    add #BOARD_Y_COORD              ;; add y coord of the Board
    ld b,a                          ;; load in b the result
    ld  de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to video memory start
    call cpct_getScreenPtr_asm      ;; Get Screen Pointer to upper left corner of next piece

    ex de, hl                       ;; save row address in de
    pop bc                          ;; retrieve row and col
    ld a, b                         ;; copy the row in a
    sla a                           ;; multiply a by 2 two obtain the offset of the address list
    ld hl, #board_addresses         ;; load in hl the address of the address list
    add l                           ;; add a to l
    ld l, a                         ;; and return the sum to l
    ld (hl), e                      ;; stores the calculated address in the address list
    inc hl
    ld (hl), d                      ;; stores the calculated address in the address list

    inc b                           ;; inc and check if already at the end of the loop
    ld a, b                         ;;
    cp #10                          ;;
    jr nz, s_b_generate_addresses_loop
    ret


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

    call sys_board_generate_addresses        ;; Generate the address list with the first cell of each row

    ret

;;-----------------------------------------------------------------
;;
;; sys_board_cell_content
;;
;;   Returns the content of a board cell
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
    add_hl_a
    ld a, (hl)                      ;; load the content of the board in a
    ret

;;-----------------------------------------------------------------
;;
;; sys_board_cell_sprite
;;
;;   Returns the address of the corresponding cell sprite
;;  Input:  c: col
;;          b: row
;;  Output: hl : address fo the corresponding cell sprite
;;  Modified: af, hl, de, bc
;;
sys_board_cell_sprite::
    call sys_board_cell_content     ;; retrieve the content of the cell
    ld   hl, #_s_balls_big_07       ;; load in hl the default sprite
    or a                            ;; check if the content is 0
    ret z                           ;; if 0 just return with hl pointing to the default sprite
    ;;ld hl, #_s_balls_big_00         ;; otherwise load in hl the occupied sprite
    ld ix, #player1                 ;; return the sprite od the color of the player
    ld l, e_sprite_ptr(ix)          ;; 
    ld h, e_sprite_ptr+1(ix)
    ret

;;-----------------------------------------------------------------
;;
;; sys_board_set_cell
;;
;;   Renders board
;;  Input:  c: col
;;          b: row
;;  Output: 
;;  Modified: af, hl
;;
sys_board_set_cell::
    push hl
    ld a, b
    call sys_util_ten_times_a                         ;; multiply a by 10
    add c                                   ;; then add the x coord and we have the offset for the cell
    ld hl, #board
    add_hl_a
    ld (hl), #01                            ;; load 1 in the corresponding cell
    push bc
    call sys_render_cell                    ;; draw cell
    pop bc
    pop hl
    ret

;;-----------------------------------------------------------------
;;
;; sys_board_set_piece
;;
;;   Renders board
;;  Input:  c: col
;;          b: row
;;          a: piece
;;  Output: 
;;  Modified: af, hl, de, bc
;;
sys_board_set_piece::
    call man_entity_get_hl_from_piece               ;; get address for a type of piece in hl
    inc hl                                          ;; skip first byte, don't need width of piece
    ld a, (hl)                                      ;; read height
    ld (sb_set_piece_condition_height + 1), a       ;; self modifying code for height condition
    inc hl

    ld bc, #00                                      ;; reset counters

sb_set_piece_loop0:
    push bc
    ;; add x coord of piece
    ld a, e_x(ix)
    add c
    ld c, a
    ;; add y coord of piece
    ld a, e_y(ix)
    add b
    ld b, a
    ;; check if piece byte is #0 to skip processing
    ld a, (hl)                      ;; load first row (byte) in a
    or a                            ;; check if piece byte is 00
    jr z, sb_set_piece_continue_0            ;; jump to next byte if so

    ld (_piece_byte),a
 
    bit 4,a                         ;; first bit
    call nz, sys_board_set_cell
    inc c

    ld a, (_piece_byte)
    bit 3,a                         ;; first bit
    call nz, sys_board_set_cell
    inc c

    ld a, (_piece_byte)
    bit 2,a                         ;; first bit
    call nz, sys_board_set_cell
    inc c

    ld a, (_piece_byte)
    bit 1,a                         ;; first bit
    call nz, sys_board_set_cell
    inc c

    ld a, (_piece_byte)
    bit 0,a                         ;; first bit
    call nz, sys_board_set_cell
    
sb_set_piece_continue_0:
    inc hl                          ;; and go to th6e next byte of the piece
    pop bc                          ;; retrive number of rows
    inc b
    ld a, b
sb_set_piece_condition_height:
    cp #00
    jr c, sb_set_piece_loop0
    
    ret


;;-----------------------------------------------------------------
;;
;; sys_board_get_hl_from_cell
;;
;;  Check if a prticular line is complete
;;  Input:  b: row
;;          c: col
;;  Output: hl: point to the address of the first element od the a row
;;  Modified: af, hl 
;;
sys_board_get_hl_from_cell::
    ld a,b
    ld (by_nine+1),a
    ld (by_ten+1),a
    sla a
    sla a
    sla a
by_nine:   
    add #0
by_ten:
    add #0
    add c
    ld hl, #board
    add_hl_a
    ret

;;-----------------------------------------------------------------
;;
;; sys_board_check_row
;;
;;  Check if a prticular line is complete
;;  Input:  b: row
;;  Output: a: 1 if its complete, 0 in other case
;;  Modified: af, hl, bc
;;
sys_board_check_row::
    ld c, #0                            ;; point first cell of the row
    call sys_board_get_hl_from_cell
    ld b, #0
    ld (check_row_loop+1), hl          ;; self modifying code to se hl every roud of the loop
check_row_loop:
    ld hl, #0000
    ld a, b
    add_hl_a
    ld a,(hl)
    or a
    jr z, row_not_complete
    inc b
    ld a,b
    cp #BOARD_ROWS
    jr nz, check_row_loop
    ld a, #1
    ret
row_not_complete:
    xor a
    ret

;;-----------------------------------------------------------------
;;
;; sys_board_check_col
;;
;;  Check if a prticular column is complete
;;  Input:  b: col
;;  Output: a: 1 if its complete, 0 in other case
;;  Modified: af, hl, bc
;;
sys_board_check_col::
    call sys_board_get_hl_from_cell
    ld (check_col_loop+1), hl          ;; self modifying code to se hl every roud of the loop
    ld b, #0
check_col_loop:
    ld hl, #0000
    ld a, b
    add_hl_a
    ld a,(hl)
    or a
    jr z, col_not_complete
    inc b
    ld a,b
    cp #BOARD_ROWS
    jr nz, check_col_loop
    ld a, #1
    ret
col_not_complete:
    xor a
    ret

;;-----------------------------------------------------------------
;;
;; sys_board_check_partial_rows
;;
;;  Check if there is a complete line on lines specified, and returns inmediatly when find a complete line
;;  Input:  b: initial line to check
;;          c: final line to check
;;  Output: a: 0xff in no line is complete, otherwise the number of the first complete line
;;  Modified: af, hl, bc
;;
sys_board_check_partial_rows::
    push bc
    call sys_board_check_row
    or a
    jr nz, partial_board_line_is_complete
    pop bc                              ;; Retrieve bc from stack
    inc b                               ;; inc row
    ld a, b                             ;;
    cp c                                ;; chec if row is last row
    jr nz, sys_board_check_partial_rows;; back to the beinging of the loop
    ld a, #0xff                         ;; Return if checked boards are complete and no line found
    ret
partial_board_line_is_complete:
    pop bc
    ld a, b
    ret

;;-----------------------------------------------------------------
;;
;; sys_board_check_rows
;;
;;  Check if there is a complete line on lines specified, and returns inmediatly when find a complete line
;;  Input:  b: initial line to check
;;          c: final line to check
;;  Output: a: 0xff in no line is complete, otherwise the number of the first complete line
;;  Modified: af, hl, bc
;;
sys_board_check_partial_cols::
    push bc
    call sys_board_check_col
    or a
    jr nz, partial_board_col_is_complete
    pop bc                              ;; Retrieve bc from stack
    inc b                               ;; inc row
    ld a, b                             ;;
    cp c                                ;; chec if row is last row
    jr nz, sys_board_check_partial_cols;; back to the beinging of the loop
    ld a, #0xff                         ;; Return if checked boards are complete and no line found
    ret
partial_board_col_is_complete:
    pop bc
    ld a, b
    ret

;;-----------------------------------------------------------------
;;
;; sys_board_erase_row
;;
;;  erases a complete line of the board
;;  Input:  a: line to erase
;;  Output: 
;;  Modified: af, hl, bc
;;
sys_board_erase_row::
    ld b, a                             ;; load line to erase in b
    ld c, #0                            ;; point to the first cell of the line
    call sys_board_get_hl_from_cell
    ld (erase_row_loop+1), hl          ;; self modifying code to se hl every roud of the loop
    ld b, #0
erase_row_loop:
    ld hl, #0000
    ld a, b
    add_hl_a
    ld (hl), #0
    inc b
    ld a,b
    cp #BOARD_ROWS
    jr nz, erase_row_loop
    ret

;;-----------------------------------------------------------------
;;
;; sys_board_erase_col
;;
;;  erases a complete line of the board
;;  Input:  a: line to erase
;;  Output: 
;;  Modified: af, hl, bc
;;
sys_board_erase_col::
    ld c, a                             ;; load line to erase in b
    ld b, #0                            ;; point to the first cell of the line
    call sys_board_get_hl_from_cell
    ld (erase_col_loop+1), hl          ;; self modifying code to se hl every roud of the loop
    ld b, #0
erase_col_loop:
    ld hl, #0000
    ld a, b
    add_hl_a
    ld (hl), #0
    inc b
    ld a,b
    cp #BOARD_ROWS
    jr nz, erase_col_loop
    ret