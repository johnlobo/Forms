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
;;-------------------------------------------------------------------------------6


;;------------------------------------------------------------------------------
;; Global constants
;;------------------------------------------------------------------------------
sc_score = 0
sc_name = 4
sizeof_sc = 15
sizeof_sc_tb = sizeof_sc * 5

;; Marker strcut constants
m_moved = 0
m_x = 1
m_y = 2
m_px = 3
m_py = 4
m_ended = 5

;; General use constants
m_w02 = 5
m_w3 = 13
m_w4 = 15
m_w5 = 11
m_h = 12
m_place_width = 6
m_place_height = 15
entry_start_x = 13
entry_start_y = 78
entry_width = 10
entry_letter_lines = 3
max_score_x = 8
max_score_y = 5

;;------------------------------------------------------------------------------
;; Global variables
;;------------------------------------------------------------------------------
.globl score
.globl hi_score
.globl hi_score_table
.globl score_buffer
.globl score_marker
.globl score_name_string
.globl score_name_length

;;------------------------------------------------------------------------------
;; Global routines
;;------------------------------------------------------------------------------

.globl sys_score_init
.globl sys_score_reset_score_buffer
.globl sys_score_copy_score_2_hiscore
.globl sys_score_hiscore_reached
.globl sys_score_hiscore_name_print
.globl sys_score_hiscore_entry
.globl sys_score_update_high_score_table

