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

.include "../common.h.s"
.include "sys/score.h.s"
.include "sys/util.h.s"



.module score_system

;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA

score::                     .db #0x00, #0x00, #0x00, #0x00
hi_score::                  .db #0x00, #0x00, #0x00, #0x00
score_buffer::              .db #0x00, #0x00, #0x00, #0x00

hi_score_table::    
    .db #0x50, #0x00, #0x00, #0x00 
    .asciz "DAVID     "
    .db #0x40, #0x00, #0x00, #0x00 
    .asciz "MARIA     "
    .db #0x30, #0x00, #0x00, #0x00 
    .asciz "DIEGO     "
    .db #0x20, #0x00, #0x00, #0x00 
    .asciz "MARTIN    "
    .db #0x10, #0x00, #0x00, #0x00 
    .asciz "FIRST     "

;;
;; Start of _CODE area
;; 
.area _CODE


;;-----------------------------------------------------------------
;;
;; sys_score_reset_score_buffer
;;
;;  Initializes a score buffer
;;  Input: hl: buffer to reset
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_score_reset_score_buffer::
    xor a
    ld (hl), a
    inc hl
    ld (hl), a
    inc hl
    ld (hl), a
    inc hl
    ld (hl), a
    ret

;;-----------------------------------------------------------------
;;
;; sys_score_hiscore_reached
;;
;;  Checks if a high score has been reached
;;  Input: hl: address to Score to check
;;  Output: c: "0" if no high score has been reached, "1" otherwise
;;  Modified: af, de, hl, bc
;;
sys_score_hiscore_reached::
    ld hl, #score
    ld de, #(hi_score_table+(sizeof_sc*4))
    call sys_util_BCD_Compare
    ret
