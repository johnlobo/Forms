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


.include "man/entity.h.s"
.include "../common.h.s"
.include "sys/util.h.s"


.module entity_manager

;;=================================================================
;; Manager Memeber Variables
;;=================================================================

player1::
    .db #0                      ;; Status of the Player
    .db #0                      ;; X location of the Player (grid)
    .db #0                      ;; Y location of the Player (grid)
    .db #0                      ;; player piece type
    .db #0                      ;; Width of the player
    .db #0                      ;; Height of the player
    .dw #0x0000                 ;; Previous screen address
    .db #0                      ;; width of background buffer
    .db #0                      ;; height of background buffer
    .db #0                      ;; moved flag
    .db #0                      ;; set flag


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
    call h_times_e                  ;; Calculate offset for piece type in HL
    ld de, #piece_types
    add hl,de                       ;; hl points to start of the model of piece of the player
    ret



