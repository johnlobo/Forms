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



;; Include all CPCtelera constant definitions, macros and variables
;;.include "cpctelera.h.s"
;;.include "man/entity.h.s"

.module entity_manager

;;=================================================================
;; Manager Memeber Variables
;;=================================================================

player1::
    .db #0                    ;; Status of the Player
    .db #13                   ;; X location of the Player (bytes)
    .db #102                   ;; Y location of the Player (pixels)
    .dw #0xc000              ;; Previous screen address
    .db #16                   ;; Pointer to the player piece type

;;-----------------------------------------------------------------
;; Piece type Components
;;
piece_types::
    piece_00: .db #0x1F, #0x0,  #0x0,  #0x0, #0x0
    piece_01: .db #0xF, #0x0,  #0x0,  #0x0, #0x0
    piece_02: .db #0x7, #0x0,  #0x0,  #0x0, #0x0
    piece_03: .db #0x3, #0x0,  #0x0,  #0x0, #0x0
    piece_04: .db #0x1, #0x1,  #0x1,  #0x1, #0x1
    piece_05: .db #0x1, #0x1,  #0x1,  #0x1, #0x0
    piece_06: .db #0x1, #0x1,  #0x1,  #0x0, #0x0
    piece_07: .db #0x1, #0x1,  #0x0,  #0x0, #0x0
    piece_08: .db #0x7, #0x1,  #0x1,  #0x0, #0x0
    piece_09: .db #0x7, #0x1,  #0x1,  #0x0, #0x0
    piece_10: .db #0x0, #0x0,  #0x1,  #0x1, #0x7
    piece_11: .db #0x0, #0x0,  #0x1,  #0x1, #0x7
    piece_12: .db #0x3, #0x1,  #0x0,  #0x0, #0x0
    piece_13: .db #0x3, #0x1,  #0x0,  #0x0, #0x0
    piece_14: .db #0x0, #0x0,  #0x0,  #0x1, #0x3
    piece_15: .db #0x0, #0x0,  #0x0,  #0x1, #0x3
    piece_16: .db #0x7, #0x7,  #0x7,  #0x0, #0x0
    piece_17: .db #0x3, #0x3,  #0x0,  #0x0, #0x0
    piece_18: .db #0x1, #0x0,  #0x0,  #0x0, #0x0


;;-----------------------------------------------------------------
;;
;; Macro: struct Player offsets
;;
;;   Returns the address of the p1 entity in hl
;;  Input: 
;;  Output: hl 
;;
man_entity_get_hl::
    ld hl, #player1
    ret
