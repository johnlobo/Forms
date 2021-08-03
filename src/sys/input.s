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
.include "man/game.h.s"
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
;; _input_update_moved
;;
;;   Initializes input
;;  Input: 
;;  Output:
;;  Modified: 
;;
_input_update_moved:
    ld a, #1
    ld e_moved(ix), a
    ret

;;-----------------------------------------------------------------
;;
;; _move_left
;;
;;   Move left
;;  Input: 
;;  Output:
;;  Modified: 
;;
_move_left:
    ld a, e_x(ix)
    or a
    jp z, sys_input_vertical_check
    dec a
    ld e_x(ix), a
    call #_input_update_moved             ;; jump to return moved
    jp sys_input_vertical_check


;;-----------------------------------------------------------------
;;
;; _move_right
;;
;;   Move right
;;  Input: 
;;  Output:
;;  Modified: 
;;
_move_right:
    ld b, e_w(ix)                       ;; load b with the width of th piece
    ld a, #BOARD_COLS                   ;; load a with the width of the board
    sub b                               ;; substract w of piece from width of board
    ld b, a                             ;; store that calculus in b
    ld a, e_x(ix)                       ;; load a with the x position
    cp b                                ;; compare with b
    ret z                               ;; if zero return
    inc a                               ;; inc x position stored in a
    ld e_x(ix), a                       ;; store it in player1 struct
    call _input_update_moved            ;; jump to return moved
    ret

;;-----------------------------------------------------------------
;;
;; _move_up
;;
;;   Move up
;;  Input: 
;;  Output:
;;  Modified: 
;;
_move_up:
    ld a, e_y(ix)
    or a
    jp z, sys_input_actions_check
    dec a
    ld e_y(ix), a
    call _input_update_moved             ;; jump to return moved
    jp sys_input_actions_check

;;-----------------------------------------------------------------
;;
;; _move_down
;;
;;   Move down
;;  Input: 
;;  Output:
;;  Modified: 
;;
_move_down:     
    ld b, e_h(ix)                       ;; load b with the width of th piece
    ld a, #BOARD_ROWS                   ;; load a with the width of the board
    sub b                               ;; substract w of piece from width of board
    ld b, a                             ;; store that calculus in b
    ld a, e_y(ix)                       ;; load a with the x position
    cp b                                ;; compare with b
    ret z                               ;; if zero return
    inc a                               ;; inc x position stored in a
    ld e_y(ix), a                       ;; store it in player1 struct
    call _input_update_moved            ;; jump to return moved
    ret

;;-----------------------------------------------------------------
;;
;; _change_piece
;;
;;   Change piece
;;  Input: 
;;  Output:
;;  Modified: 
;;
_change_piece::      
    ld a, (selected_piece)              ;; read selected piece
    inc a                               ;; increment piece type
    cp #3       
    jr nz, _valid_piece_0     
    xor a       
_valid_piece_0:
    ld (selected_piece), a
    ld hl, #next_pieces
    add_hl_a
    ld a, (hl)
    cp #0xff
    jr z, _change_piece
    ;; New piece ok       
    ld e_type(ix), a                    ;; Update piece in Player1 struct
    call man_entity_get_hl_from_piece   ;; get address of the piece type in hl
_check_width:
    ld a, (hl)                          ;; read width of piece
    ld e_w(ix), a                       ;; store width of piece in player1 struct
    dec a                               ;; width minus 1 to add it to the x coord
    ld b, e_x(ix)                       ;; read x position in b
    add b                               ;; add x position and width
    cp #BOARD_COLS - 1                  ;; Compare with number of cols in board
    jp m, _check_height                 ;; If overflow check height because it's correct
    ld b, e_w(ix)       
    ld a, #BOARD_COLS                   ;; load in a the width of the board
    sub b                               ;; substract the width of the piece as new coord
    ld e_x(ix), a                       ;; load in player struct the new x coord
_check_height:      
    inc hl                              ;; read next byte of piece
    ld a, (hl)                          ;; read height of piece
    ld e_h(ix), a                       ;; store height of piece in player1 struct
    dec a                               ;; height minus 1 to add it to the y coord
    ld b, e_y(ix)                       ;; read y position in b
    add b                               ;; add y position and width
    cp #BOARD_ROWS - 1                  ;; Compare with number of cols in board
    jp m, _end_check                    ;; If no overflow check height
    ld a, #BOARD_ROWS                   ;; load in a the width of the board
    ld b, e_h(ix)       
    sub b                               ;; substract the width of the piece as new coord
    ld e_y(ix), a                       ;; load in player struct the new x coord
_end_check:
;; Get the sprite pointer to render the piece
    ld a, e_type(ix)
    call man_entity_get_piece_sprite_big
    ld e_sprite_big_ptr(ix), l
    ld e_sprite_big_ptr+1(ix), h

    call _input_update_moved
    jp _end_input_update

;;-----------------------------------------------------------------
;;
;; _set_piece
;;
;;   Move left
;;  Input: 
;;  Output:
;;  Modified: 
;;
_set_piece:
    ;; loop to wait until keyup
    call cpct_scanKeyboard_asm
    ld hl, #Key_Space                   ;; check key Space
    call cpct_isKeyPressed_asm          ;; 
    jp nz, _set_piece                   ;; if press Space loop

    ld e_set(ix), #1
    call _input_update_moved
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
    ld ix, #player1                     ;; get player1 struct

    ld hl, #Key_O                       ;; check key O   
    call cpct_isKeyPressed_asm          ;; 
    jp nz, _move_left                   ;; if press O move left
    
    ld hl, #Key_P                       ;; check key P
    call cpct_isKeyPressed_asm          ;; 
    call nz, _move_right                  ;; if press P move right  

sys_input_vertical_check:   
    
    ld hl, #Key_Q                       ;; check key Q
    call cpct_isKeyPressed_asm          ;;
    jp nz, _move_up                     ;; if press Q move up
    
    ld hl, #Key_A                       ;; check key A
    call cpct_isKeyPressed_asm          ;;
    call nz, _move_down                   ;; if press A move down

sys_input_actions_check:

    ld hl, #Key_I                       ;; check key I
    call cpct_isKeyPressed_asm          ;;
    jp nz, _change_piece                ;; if press I change piece

    ld hl, #Key_Space                   ;; check key Space
    call cpct_isKeyPressed_asm          ;;
    call nz, _set_piece                ;; if press Space set piece in board
    
_end_input_update:
    ret