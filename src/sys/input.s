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
.include "sys/util.h.s"


.module input_system

;;-----------------------------------------------------------------
;;
;; sys_input_init
;;
;;   Initializes input
;;  Input: 
;;  Output:
;;  Modified: 
;;
sys_input_init::
    ret 


;;-----------------------------------------------------------------
;;
;; sys_input_update
;;
;;   Reads input
;;  Input: 
;;  Output:
;;  Modified: 
;;
sys_input_update::
    ld ix, #player1                 ;; get player1 struct
    call cpct_scanKeyboard_asm      ;; scan keyboard
    ld hl, #Key_O                   ;;    
    call cpct_isKeyPressed_asm      ;; check key O
    jp nz, _move_left               ;; if press O move left
    ld hl, #Key_P                   ;; 
    call cpct_isKeyPressed_asm      ;; check key P
    jp nz, _move_right              ;; if press P move right    
    ld hl, #Key_Q
    call cpct_isKeyPressed_asm
    jp nz, _move_up
    ld hl, #Key_A
    call cpct_isKeyPressed_asm
    jp nz, _move_down
    ld hl, #Key_I
    call cpct_isKeyPressed_asm
    jp nz, _change_piece
    jp _end_input_update
_move_right:
    ld b, e_w(ix)               ;; load b with the width of th piece
    ld a, #BOARD_COLS           ;; load a with the width of the board
    sub b                       ;; substract w of piece from width of board
    ld b, a                     ;; store that calculus in b
    ld a, e_x(ix)               ;; load a with the x position
    cp b                        ;; compare with b
    jr z, #_end_input_update    ;; if zero return
    inc a                       ;; inc x position stored in a
    ld e_x(ix), a               ;; store it in player1 struct
    jr #_input_update_moved     ;; jump to return moved
_move_left:
    ld a, e_x(ix)
    or a
    jp z, _end_input_update
    dec a
    ld e_x(ix), a
    jr #_input_update_moved     ;; jump to return moved
_move_up:
    ld a, e_y(ix)
    or a
    jp z, _end_input_update
    dec a
    ld e_y(ix), a
    jr #_input_update_moved     ;; jump to return moved
_move_down:
    ld b, e_h(ix)               ;; load b with the width of th piece
    ld a, #BOARD_ROWS           ;; load a with the width of the board
    sub b                       ;; substract w of piece from width of board
    ld b, a                     ;; store that calculus in b
    ld a, e_y(ix)               ;; load a with the x position
    cp b                        ;; compare with b
    jr z, #_end_input_update    ;; if zero return
    inc a                       ;; inc x position stored in a
    ld e_y(ix), a               ;; store it in player1 struct
    jr #_input_update_moved     ;; jump to return moved
_change_piece:
    ld a, e_type(ix)            ;; read current piece
    inc a                       ;; increment piece type
    cp #MAX_PIECE + 1           ;; check if piece number is in the range of the valid pieces
    jr nz, _valid_piece
    xor a                       ;; reset piece number 
_valid_piece:
    ld e_type(ix), a
    ld h, a                     ;; Type of piece
    ld e, #PIECE_SIZE           ;; Piece size in bytes
    call h_times_e              ;; Calculate offset for piece type in HL
    ld de, #piece_types         ;; add pieces address
    add hl,de                   ;; hl points to start of the model of piece of the player
_check_width:
    ld a, (hl)                  ;; read width of piece
    ld e_w(ix), a               ;; store width of piece in player1 struct
    ld b, e_x(ix)               ;; read x position in b
    add b                       ;; add x position and width
    cp #BOARD_COLS - 1          ;; Compare with number of cols in board
    jp m, _check_height        ;; If overflow check height because it's correct
    ld b, e_w(ix)
    ld a, #BOARD_COLS           ;; load in a the width of the board
    sub b                       ;; substract the width of the piece as new coord
    ld e_x(ix), a               ;; load in player struct the new x coord
_check_height:
    inc hl                      ;; read next byte of piece

    ld a, (hl)                  ;; read width of piece
    ld e_h(ix), a               ;; store height of piece in player1 struct
    ld b, e_y(ix)               ;; read y position in b
    add b                       ;; add y position and width
    cp #BOARD_ROWS - 1          ;; Compare with number of cols in board
    jp m, _input_update_moved   ;; If no overflow check height
    ld a, #BOARD_ROWS           ;; load in a the width of the board
    ld b, e_h(ix)
    sub b                       ;; substract the width of the piece as new coord
    ld e_y(ix), a               ;; load in player struct the new x coord
_input_update_moved:
    ld a, #1
    ld e_moved(ix), a
_end_input_update:
    ret