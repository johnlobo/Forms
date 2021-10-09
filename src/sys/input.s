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
.include "sys/render.h.s"


.module input_system


;;-----------------------------------------------------------------
;;
;; sys_input_clean_buffer
;;
;;  Waits until de key buffer is clean
;;  Input: 
;;  Output:
;;  Modified: 
;;
sys_input_clean_buffer::
    call cpct_isAnyKeyPressed_asm
    jr nz, sys_input_clean_buffer
    ret

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

sys_input_key_actions:
    .dw Key_O,      _move_left
    .dw Joy0_Left,  _move_left
    .dw Key_P,      _move_right
    .dw Joy0_Right, _move_right
    .dw Key_Q,      _move_up
    .dw Joy0_Up,    _move_up
    .dw Key_A,      _move_down
    .dw Joy0_Down,  _move_down
    .dw Key_I,      _change_piece
    .dw Joy0_Fire2, _change_piece
    .dw Key_Space,  _set_piece
    .dw Joy0_Fire1, _set_piece
    .dw Key_Esc,    _cancel_game
    .dw 0



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
;; _cancel_game
;;
;;   Initializes input
;;  Input: 
;;  Output:
;;  Modified: 
;;
_cancel_game:
    ld a, #1
    ld (man_game_cancelled_game), a
    call sys_input_clean_buffer
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
    ;;jp z, sys_input_vertical_check
    ret z
    dec a
    ld e_x(ix), a
    call #_input_update_moved             ;; jump to return moved
    ;;jp sys_input_vertical_check
    ret


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
    ;;jp z, sys_input_actions_check
    ret z
    dec a
    ld e_y(ix), a
    call _input_update_moved             ;; jump to return moved
    ;;jp sys_input_actions_check
    ret

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
    ld (_erase_previous_piece+1), a     ;; keep current selected piece frame for erase later
_renew_piece:
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
    jr z, _renew_piece
    ;; New piece ok       
    ld e_type(ix), a                    ;; Update piece in Player1 struct
_erase_previous_piece:
    ld a, #00
    call sys_render_draw_next_frame     ;; erase previous selected piece frame
    ld a, (selected_piece)              ;; select current selected piece
    call sys_render_draw_next_frame     ;; draw current selected piece frame
   
    ld a, e_type(ix)
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
    call man_entity_get_piece_sprite_player
    ld e_sprite_player_ptr(ix), l
    ld e_sprite_player_ptr+1(ix), h

;; Get the sprite pointer to render the piece
    ld a, e_type(ix)
    call man_entity_get_piece_sprite_big
    ld e_sprite_big_ptr(ix), l
    ld e_sprite_big_ptr+1(ix), h

    call _input_update_moved
    
    call sys_input_clean_buffer         ;; wait until keyboard buffer is empty
    
    ;;jp _end_input_update
    ret

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
;;sys_input_update::
;;    ld ix, #player1                     ;; get player1 struct
;;
;;    ld hl, #Key_O                       ;; check key O   
;;    call cpct_isKeyPressed_asm          ;; 
;;    jp nz, _move_left                   ;; if press O move left
;;    
;;    ld hl, #Key_P                       ;; check key P
;;    call cpct_isKeyPressed_asm          ;; 
;;    call nz, _move_right                  ;; if press P move right  
;;
;;sys_input_vertical_check:   
;;    
;;    ld hl, #Key_Q                       ;; check key Q
;;    call cpct_isKeyPressed_asm          ;;
;;    jp nz, _move_up                     ;; if press Q move up
;;    
;;    ld hl, #Key_A                       ;; check key A
;;    call cpct_isKeyPressed_asm          ;;
;;    call nz, _move_down                   ;; if press A move down
;;
;;sys_input_actions_check:
;;
;;    ld hl, #Key_I                       ;; check key I
;;    call cpct_isKeyPressed_asm          ;;
;;    jp nz, _change_piece                ;; if press I change piece
;;
;;    ld hl, #Key_Space                   ;; check key Space
;;    call cpct_isKeyPressed_asm          ;;
;;    call nz, _set_piece                 ;; if press Space set piece in board
;;
;;    ld hl, #Key_Esc                     ;; check key Space
;;    call cpct_isKeyPressed_asm          ;;
;;    call nz, _cancel_game               ;; if press Space set piece in board
;;
;;_end_input_update:
;;    ret

;;-----------------------------------------------------------------
;;
;; sys_input_update
;;
;;   Initializes input
;;  Input: 
;;  Output:
;;  Modified: iy, bc
;;
;;sys_input_check_keys_action::
sys_input_update::
    ld ix, #player1                     ;; get player1 struct
    ld iy, #sys_input_key_actions
    jr first_key
keys_loop:
    ld bc, #4
    add iy, bc
first_key:
    ld l, 0(iy)                     ;; Lower part of the pointer
    ld h, 1(iy)                     ;; Lower part of the pointer
    ;; Check if key is null
    ld a, l
    or h
    ret z                           ;; Return if key is null
    ;; Check if key is pressed
    call cpct_isKeyPressed_asm      ;;
    jr z, keys_loop
    ;; Key pressed execute action
    ld hl, #keys_loop               ;;
    push hl                         ;; return addres from executed function
    ld l, 2(iy)                     ;;
    ld h, 3(iy)                     ;; retrieve function address    
    jp (hl)                         ;; jump to function


;;-----------------------------------------------------------------
;;
;; sys_input_wait4anykey
;;
;;   Reads input and wait for any key press
;;  Input: 
;;  Output:
;;  Modified: 
;;
sys_input_wait4anykey::
    call cpct_isAnyKeyPressed_asm
    or a
    jr z, sys_input_wait4anykey
    ret