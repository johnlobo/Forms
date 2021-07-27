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

.module render_system

;;------------------------------------------------------------------------------
;; Global routines
;;------------------------------------------------------------------------------
.globl sys_render_init
.globl sys_render_board
.globl sys_render_game_screen
.globl sys_render_draw_player1
.globl sys_render_erase_player
.globl sys_render_update
.globl sys_render_draw_piece_small
.globl sys_render_next_pieces
.globl sys_render_score
.globl sys_render_hi_score
.globl sys_render_cell
.globl sys_render_erase_next_piece
.globl sys_render_logo_screen
.globl sys_render_render_row
