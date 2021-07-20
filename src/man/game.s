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
.include "sys/render.h.s"


.module game_manager

;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA

next_pieces:: .db #00, #00, #00
next_pieces_count:: .db #00
selected_piece:: .db #00
score:: .db #00, #00, #00, #00
hi_score:: .db #00, #00, #00, #00


;;
;; Start of _CODE area
;; 
.area _CODE


;;-----------------------------------------------------------------
;;
;; get_random_piece
;;
;;   gets a random number between 0 and 18
;;  Input: 
;;  Output: a random piece
;;  Modified: AF, BC, DE, HL
;;
man_game_get_random_piece::
    call cpct_setSeed_mxor_asm
    call cpct_getRandom_mxor_u8_asm
    ld a, l
    srl a
    srl a
    srl a
    cp #19
    jr c, _get_random_piece_continue
    sub #18
_get_random_piece_continue:
    ret

;;-----------------------------------------------------------------
;;
;; man_game_init
;;
;;   Initializes render
;;  Input: 
;;  Output:
;;  Modified:
;;
man_game_init::
    ;; Generate radom pieces
    call man_game_get_random_piece
    ld (next_pieces), a
    call man_game_get_random_piece
    ld (next_pieces+1), a
    call man_game_get_random_piece
    ld (next_pieces+2), a
    ;; Initializate selected piece
    xor a
    ld (selected_piece),a
    ;; set player1 initial piece to next_piece
    ld ix, #player1
    ld a, (next_pieces)
    ld e_type(ix), a
    ;; get width and height from initial piece
    call man_entity_get_hl_from_piece
    ld a,(hl)
    ld e_w(ix), a
    inc hl
    ld a,(hl)
    ld e_h(ix), a

    call sys_render_score

    call sys_render_next_pieces     ;; Render next pieces on screen

    call sys_render_draw_player1

    ret