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

.module board_system

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

sys_board_init::
    
    ld de, #board       ;; Set the board address
    ld a, #0x00         ;; Set the initilization value, 0
    ld bc, # (BOARD_ROWS * BOARD_COLS)         ;; Set the size to set 10x10
    call cpct_memset_asm

    ret