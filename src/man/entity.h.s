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
;; ENTITY MANAGER CONSTANTS
;;

PIECE_SIZE = 7

e_status = 0 
e_x = 1
e_y = 2
e_p_screen_p = 4
e_buffer_width = 5
e_buffer_height = 6
e_type = 7

sizeof_e = 8


;;=============================================================================
;; ENTITY MANAGER GLOBAL ROUTINES
;;
.globl player1
.globl piece_types
.globl player_buffer