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


;; 
;; Declare all function entry points as global symbols for the compiler.
;; (The linker will know what to do with them)
;; WARNING: Every global symbol declared will be linked, so DO NOT declare 
;; symbols for functions you do not use.
;;

.globl _s_balls_big_0
.globl _s_balls_big_1
.globl _s_balls_big_2
.globl _s_balls_big_3
.globl _s_balls_big_4
.globl _s_balls_big_5
.globl _s_balls_big_6
.globl _s_balls_big_7
.globl _s_balls_small_0
.globl _s_balls_small_1
.globl _s_balls_small_2
.globl _s_balls_small_3
.globl _s_balls_small_4
.globl _s_balls_small_5
.globl _s_balls_small_6
.globl _g_palette0
.globl _s_hi_score
.globl _s_score
.globl _s_uno
.globl _s_dos
.globl _s_tres
.globl _s_score_numbers_00
.globl _s_score_numbers_01
.globl _s_score_numbers_02
.globl _s_score_numbers_03
.globl _s_score_numbers_04
.globl _s_score_numbers_05
.globl _s_score_numbers_06
.globl _s_score_numbers_07
.globl _s_score_numbers_08
.globl _s_score_numbers_09

;;===============================================================================
;; CPCTELERA FUNCTIONS
;;===============================================================================
.globl cpct_disableFirmware_asm
.globl cpct_getScreenPtr_asm
.globl cpct_drawSprite_asm
.globl cpct_setVideoMode_asm
.globl cpct_setPalette_asm
.globl cpct_setPALColour_asm
.globl cpct_memset_asm
.globl cpct_getScreenToSprite_asm
.globl cpct_scanKeyboard_asm
.globl cpct_isKeyPressed_asm
.globl cpct_waitHalts_asm
.globl cpct_drawSolidBox_asm
.globl cpct_getRandom_mxor_u8_asm
.globl cpct_setSeed_mxor_asm

;;===============================================================================
;; DEFINED CONSTANTS
;;===============================================================================
S_BALLS_BIG_W = 4
S_BALLS_BIG_H = 11

S_BALLS_SMALL_W = 2
S_BALLS_SMALL_H = 5

S_HI_SCORE_W = 15
S_HI_SCORE_H = 7

S_SCORE_W = 10
S_SCORE_H = 7

S_UNO_W = 2
S_UNO_H = 16
S_DOS_W = 3
S_DOS_H = 16
S_TRES_W = 3
S_TRES_H = 16

S_SCORE_NUMBERS_W = 4
S_SCORE_NUMBERS_H = 15

BOARD_X_COORD = 1   ;; X 
BOARD_Y_COORD = 54  ;; Y 
BOARD_ROWS = 10     ;;
BOARD_COLS = 10     ;;

HIGH_SCORE_TITLE_X_COORD = 4        ;;
HIGH_SCORE_TITLE_Y_COORD = 6        ;;   
HIGH_SCORE_X_COORD = 4
HIGH_SCORE_Y_COORD = 20

SCORE_TITLE_X_COORD = 57       ;;
SCORE_TITLE_Y_COORD = 20       ;; 
SCORE_X_COORD = 57
SCORE_Y_COORD = 40

UNO_TITLE_X_COORD = 47       ;;
UNO_TITLE_Y_COORD = 80       ;;
DOS_TITLE_X_COORD = 60       ;;
DOS_TITLE_Y_COORD = 80       ;; 
TRES_TITLE_X_COORD = 71       ;;
TRES_TITLE_Y_COORD = 80       ;; 

PIECE_HOR_SIZE = 5
PIECE_VER_SIZE = 5

MAX_PIECE = 18

NEXT_PIECE_1_X = 46
NEXT_PIECE_1_Y = 110
NEXT_PIECE_2_X = 59
NEXT_PIECE_2_Y = 110
NEXT_PIECE_3_X = 70
NEXT_PIECE_3_Y = 110

SCORE_NUM_BYTES = 4

