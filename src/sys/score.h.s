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

;;------------------------------------------------------------------------------
;; Global variables
;;------------------------------------------------------------------------------
.globl score
.globl hi_score
.globl hi_score_table
.globl score_buffer

;;------------------------------------------------------------------------------
;; Global routines
;;------------------------------------------------------------------------------

.globl sys_score_reset_score_buffer
.globl sys_score_hiscore_reached
.globl sys_score_hiscore_entry

