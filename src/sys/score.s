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

.include "sys/fdc.h.s"
.include "../common.h.s"


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

_track: .db #0
_sector0: .db #0xc2
_sector1: .db #0xc2


;;
;; Start of _CODE area
;; 
.area _CODE

;;-----------------------------------------------------------------
;;
;; sys_score_read_hiscore
;;
;;   Initializes render
;;  Input: 
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_score_read_hiscore::
    call FDC_MotorOn
    call FDC_DriveWaitReady
    
    ld a, (_track)
    call FDC_track
    
    ld HL,#hi_score
    ld DE,#SCORE_NUM_BYTES ;(512 bytes per sector)
    ld a, (_sector0)
    ld b, a  ;(e.g #C1)
    ld a, (_sector1)
    ld c, a  ;(e.g #C1)
    call FDC_read
    ;check here if you have errors
    call FDC_CheckErrors
 
    call FDC_MotorOff
    ret

;;-----------------------------------------------------------------
;;
;; sys_score_write_score
;;
;;   Initializes render
;;  Input: 
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_score_write_hiscore::
    call FDC_MotorOn
    call FDC_DriveWaitReady

    ld a,(_track)
    call FDC_track

    ld HL,#hi_score
    ld DE,#SCORE_NUM_BYTES ;(512 bytes per sector)
    ld a, (_sector0)
    ld b, a  ;(e.g #C1)
    ld a, (_sector1)
    ld c, a  ;(e.g #C1)
    call FDC_write
    ;check here if you have errors
    call FDC_CheckErrors
 
    call FDC_MotorOff
    ret

;;-----------------------------------------------------------------
;;
;; sys_score_reset_score
;;
;;   Initializes render
;;  Input: 
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_score_reset_hiscore::
    call FDC_MotorOn
    call FDC_DriveWaitReady

    ld a,(_track)
    call FDC_track

    ld HL,#hi_score
    ld DE,#SCORE_NUM_BYTES ;(512 bytes per sector)
    ld a, (_sector0)
    ld b, a  ;(e.g #C1)
    ld a, (_sector1)
    ld c, a  ;(e.g #C1)
    call FDC_write
    ;check here if you have errors
    call FDC_CheckErrors
 
    call FDC_MotorOff
    ret

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
;; sys_score_reset_score_buffer
;;
;;   Initializes render
;;  Input: de: buffer to reset
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_score_update_hiscore::
    call sys_score_read_hiscore
    ld a, (hi_score)
    cp #0xE5
    jr z, _clear_hiscore
    ret
_clear_hiscore:
    ld hl,#hi_score
    call sys_score_reset_score_buffer
    ret