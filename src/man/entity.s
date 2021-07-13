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

;;=============================================================================
;;  Entity Manager
;;

.module entity_manager

;; Include all CPCtelera constant definitions, macros and variables
.include "cpctelera.h.s"
.include "man/entity.h.s"


;;=================================================================
;; Manager Memeber Variables
;;=================================================================

;; Definition of Player
definePlayer p1, 0, 58, 60, 0x0000, 1
definePlayerOffsets player, p1 

;;-----------------------------------------------------------------
;; Piece type Components
piece_type::
    piece_01: .db #0x1F, #0x0,  #0x0,  #0x0, #0x0
    piece_02: .db #0xF, #0x0,  #0x0,  #0x0, #0x0
    piece_03: .db #0x7, #0x0,  #0x0,  #0x0, #0x0
    piece_04: .db #0x1, #0x1,  #0x1,  #0x1, #0x1
    piece_05: .db #0x1, #0x1,  #0x1,  #0x1, #0x1
    piece_06: .db #0xF, #0x1,  #0x1,  #0x1, #0x0
    piece_07: .db #0xF, #0x1,  #0x1,  #0x1, #0x0
    piece_08: .db #0x0, #0x0,  #0x1,  #0x1, #0x1
    piece_09: .db #0x0, #0x0,  #0x1,  #0x1, #0x1
    piece_10: .db #0x7, #0x1,  #0x1,  #0x0, #0x0
    piece_11: .db #0x7, #0x1,  #0x1,  #0x0, #0x0
    piece_12: .db #0x0, #0x0,  #0x0,  #0x1, #0x1
    piece_13: .db #0x0, #0x0,  #0x0,  #0x1, #0x1
    piece_14: .db #0x3, #0x1,  #0x0,  #0x0, #0x0
    piece_15: .db #0x3, #0x1,  #0x0,  #0x0, #0x0
    piece_16: .db #0x0, #0x0,  #0x0,  #0x0, #0x1
    piece_17: .db #0x0, #0x0,  #0x0,  #0x0, #0x1
    piece_18: .db #0x0, #0x7,  #0x7,  #0x7, #0x0
    piece_19: .db #0x0, #0x3,  #0x3,  #0x0, #0x0
    piece_20: .db #0x0, #0x0,  #0x0,  #0x0, #0x0

