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


.module common

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
.globl _s_balls_big_8
.globl _s_balls_player_0
.globl _s_balls_player_1
.globl _s_balls_player_2
.globl _s_balls_player_3
.globl _s_balls_player_4
.globl _s_balls_player_5
.globl _s_balls_player_6
.globl _s_balls_player_7
.globl _s_balls_player_8
.globl _s_balls_small_0
.globl _s_balls_small_1
.globl _s_balls_small_2
.globl _s_balls_small_3
.globl _s_balls_small_4
.globl _s_balls_small_5
.globl _s_balls_small_6
.globl _s_balls_small_7
.globl _s_balls_small_8
.globl _s_sprites_0
.globl _s_sprites_1
.globl _s_sprites_2
.globl _s_sprites_3
.globl _s_sprites_4
.globl _g_palette0
.globl _s_hi_score
.globl _s_score
.globl _s_score_numbers_00
.globl _s_score_numbers_01
.globl _s_score_numbers_02
.globl _s_score_numbers_03
.globl _s_score_numbers_04
.globl _s_score_numbers_05
.globl _s_score_numbers_06
.globl _s_score_numbers_07
.globl _s_score_numbers_08
.globl _s_next
.globl _s_pieces
.globl _s_logo_1010
.globl _s_press_any_key
.globl _g_font_chars
.globl _s_high_score_icon
.globl _s_star_icon


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
.globl cpct_scanKeyboard_if_asm
.globl cpct_isKeyPressed_asm
.globl cpct_waitHalts_asm
.globl cpct_drawSolidBox_asm
.globl cpct_getRandom_xsp40_u8_asm
.globl cpct_setSeed_xsp40_u8_asm
.globl cpct_isAnyKeyPressed_asm
.globl cpct_setInterruptHandler_asm
.globl cpct_waitVSYNC_asm

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


S_SCORE_NUMBERS_W = 4
S_SCORE_NUMBERS_H = 15

S_PRESS_ANY_KEY_W = 25
S_PRESS_ANY_KEY_H = 8
S_LOGO_1010_W = 32
S_LOGO_1010_H = 32

BOARD_X_COORD = 1   ;; X 
BOARD_Y_COORD = 54  ;; Y 
BOARD_ROWS = 10     ;;
BOARD_COLS = 10     ;;

HIGH_SCORE_TITLE_X_COORD = 4        ;;
HIGH_SCORE_TITLE_Y_COORD = 6        ;;   
HIGH_SCORE_X_COORD = 1
HIGH_SCORE_Y_COORD = 20
HIGH_SCORE_SCREEN_ADDRESS = 0xE0A1

SCORE_TITLE_X_COORD = 57       ;;
SCORE_TITLE_Y_COORD = 20       ;; 
SCORE_X_COORD = 57
SCORE_Y_COORD = 40
SCORE_SCREEN_ADDRESS = 0xE16D

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
NEXT_PIECE_1_Y = 150
NEXT_PIECE_2_X = 59
NEXT_PIECE_2_Y = 150
NEXT_PIECE_3_X = 70
NEXT_PIECE_3_Y = 150
NEXT_PIECE_MAX_HEIGHT = 30
NEXT_PIECE_MAX_WIDTH = 10

SCORE_NUM_BYTES = 4

S_NEXT_W = 12
S_NEXT_H = 16
NEXT_TITLE_X_COORD = 45       ;;
NEXT_TITLE_Y_COORD = 120       ;;

S_PIECES_W = 18
S_PIECES_H = 16
PIECES_TITLE_X_COORD = 60       ;;
PIECES_TITLE_Y_COORD = 120       ;;



