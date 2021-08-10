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
.include "man/entity.h.s"
.include "../common.h.s"
.include "sys/util.h.s"


.module entity_manager

;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA

;;=================================================================
;; Manager Memeber Variables
;;=================================================================

player1::
    .db #0                      ;; Status of the Player
    .db #3                      ;; X location of the Player (grid)
    .db #3                      ;; Y location of the Player (grid)
    .db #0                      ;; player piece type
    .db #0                      ;; Width of the player
    .db #0                      ;; Height of the player
    .dw #0x0000                 ;; Previous screen address
    .db #0                      ;; width of background buffer
    .db #0                      ;; height of background buffer
    .dw #0x0000                 ;; sprite big pointer
    .dw #0x0000                 ;; sprite player pointer
    .db #0                      ;; moved flag
    .db #0                      ;; set flag
    .db #0                      ;; cancel flag


;;-----------------------------------------------------------------
;; Piece type Component
;;
piece_types::
    piece_00: .db #0x5, #0x1, #0x1F, #0x0,  #0x0,  #0x0, #0x0
    piece_01: .db #0x4, #0x1, #0x1E, #0x0,  #0x0,  #0x0, #0x0
    piece_02: .db #0x3, #0x1, #0x1C, #0x0,  #0x0,  #0x0, #0x0
    piece_03: .db #0x2, #0x1, #0x18, #0x0,  #0x0,  #0x0, #0x0
    piece_04: .db #0x1, #0x5, #0x10, #0x10,  #0x10,  #0x10, #0x10
    piece_05: .db #0x1, #0x4, #0x10, #0x10,  #0x10,  #0x10, #0x0
    piece_06: .db #0x1, #0x3, #0x10, #0x10,  #0x10,  #0x0, #0x0
    piece_07: .db #0x1, #0x2, #0x10, #0x10,  #0x0,  #0x0, #0x0
    piece_08: .db #0x3, #0x3, #0x1C, #0x10,  #0x10,  #0x0, #0x0
    piece_09: .db #0x3, #0x3, #0x1C, #0x4,  #0x4,  #0x0, #0x0
    piece_10: .db #0x3, #0x3, #0x4, #0x4,  #0x1C,  #0x0, #0x0
    piece_11: .db #0x3, #0x3, #0x10, #0x10,  #0x1C,  #0x0, #0x0
    piece_12: .db #0x2, #0x2, #0x18, #0x10,  #0x0,  #0x0, #0x0
    piece_13: .db #0x2, #0x2, #0x18, #0x8,  #0x0,  #0x0, #0x0
    piece_14: .db #0x2, #0x2, #0x8, #0x18,  #0x0,  #0x0, #0x0
    piece_15: .db #0x2, #0x2, #0x10, #0x18,  #0x0,  #0x0, #0x0
    piece_16: .db #0x3, #0x3, #0x1C, #0x1C,  #0x1C,  #0x0, #0x0
    piece_17: .db #0x2, #0x2, #0x18, #0x18,  #0x0,  #0x0, #0x0
    piece_18: .db #0x1, #0x1, #0x10, #0x0,  #0x0,  #0x0, #0x0

player_buffer:: .ds 5 * S_BALLS_BIG_W * 5 * S_BALLS_BIG_H ;; Bufer to store background

piece_sprites_big:: 
    .dw #_s_balls_big_0, #_s_balls_big_1, #_s_balls_big_2, #_s_balls_big_3, #_s_balls_big_0
    .dw #_s_balls_big_1, #_s_balls_big_2, #_s_balls_big_3, #_s_balls_big_4, #_s_balls_big_4
    .dw #_s_balls_big_4, #_s_balls_big_4, #_s_balls_big_5, #_s_balls_big_5, #_s_balls_big_5
    .dw #_s_balls_big_5, #_s_balls_big_6, #_s_balls_big_7, #_s_balls_big_8

piece_sprites_player:: 
    .dw #_s_balls_player_0, #_s_balls_player_1, #_s_balls_player_2, #_s_balls_player_3, #_s_balls_player_0
    .dw #_s_balls_player_1, #_s_balls_player_2, #_s_balls_player_3, #_s_balls_player_4, #_s_balls_player_4
    .dw #_s_balls_player_4, #_s_balls_player_4, #_s_balls_player_5, #_s_balls_player_5, #_s_balls_player_5
    .dw #_s_balls_player_5, #_s_balls_player_6, #_s_balls_player_7, #_s_balls_player_8

piece_sprites_small:: 
    .dw #_s_balls_small_0, #_s_balls_small_1, #_s_balls_small_2, #_s_balls_small_3, #_s_balls_small_0
    .dw #_s_balls_small_1, #_s_balls_small_2, #_s_balls_small_3, #_s_balls_small_4, #_s_balls_small_4
    .dw #_s_balls_small_4, #_s_balls_small_4, #_s_balls_small_5, #_s_balls_small_5, #_s_balls_small_5
    .dw #_s_balls_small_5, #_s_balls_small_6, #_s_balls_small_7, #_s_balls_small_8

piece_scoring::
    .db #0x05, #0x04, #0x03, #0x02, #0x05, #0x04, #0x03, #0x02, #0x05, #0x05
    .db #0x05, #0x05, #0x03, #0x03, #0x03, #0x03, #0x09, #0x04, #0x01
line_scoring:: 
    .db #0x00, #0x01
;;
;; Start of _CODE area
;; 
.area _CODE
      



;;-----------------------------------------------------------------
;;
;; man_entity_get_hl_from_piece
;;
;;   Draw player1
;;  Input: a: piece
;;  Output: 
;;  Destroyed: af, hl, de
;;
man_entity_init::
    ld ix, #player1
    ld e_x(ix),#3
    ld e_y(ix),#3
    ld e_p_screen_p(ix), #0
    ld e_p_screen_p+1(ix), #0
    ret


;;-----------------------------------------------------------------
;;
;; man_entity_get_hl_from_piece
;;
;;   Draw player1
;;  Input: a: piece
;;  Output: 
;;  Destroyed: af, hl, de
;;
man_entity_get_hl_from_piece::
    ld h, a                         ;; Type of piece
    ld e, #PIECE_SIZE               ;; Piece size in bytes
    call sys_util_h_times_e                  ;; Calculate offset for piece type in HL
    ld de, #piece_types
    add hl,de                       ;; hl points to start of the model of piece of the player
    ret

;;-----------------------------------------------------------------
;;
;;  get_piece_sprite_big
;;
;;  Get in hl a pointer to the sprite a
;;  Input: a: number of type
;;  Output: hl a pointer to the sprite
;;  Destroyed: af, hl, de
;;
man_entity_get_piece_sprite_big::
    sla a                   ;; duplicate a in order to offset
    ld hl, #piece_sprites_big   ;; load begining of the piece sprite list in hl
    add_hl_a                ;; add offset
    ld e, (hl)
    inc hl
    ld d, (hl)
    ex de, hl
    ret

    ;;-----------------------------------------------------------------
;;
;;  get_piece_sprite_player
;;
;;  Get in hl a pointer to the sprite a
;;  Input: a: number of type
;;  Output: hl a pointer to the sprite
;;  Destroyed: af, hl, de
;;
man_entity_get_piece_sprite_player::
    sla a                   ;; duplicate a in order to offset
    ld hl, #piece_sprites_player   ;; load begining of the piece sprite list in hl
    add_hl_a                ;; add offset
    ld e, (hl)
    inc hl
    ld d, (hl)
    ex de, hl
    ret

;;-----------------------------------------------------------------
;;
;;  get_piece_sprite_small
;;
;;  Get in hl a pointer to the sprite a
;;  Input: a: number of type
;;  Output: hl a pointer to the sprite
;;  Destroyed: af, hl, de
;;
man_entity_get_piece_sprite_small::
    sla a                           ;; duplicate a in order to offset
    ld hl, #piece_sprites_small     ;; load begining of the piece sprite list in hl
    add_hl_a                        ;; add offset
    ld e, (hl)
    inc hl
    ld d, (hl)
    ex de, hl
    ret
