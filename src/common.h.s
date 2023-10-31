;;-----------------------------LICENSE NOTICE------------------------------------
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
.globl _s_score_numbers_00
.globl _s_score_numbers_01
.globl _s_score_numbers_02
.globl _s_score_numbers_03
.globl _s_score_numbers_04
.globl _s_score_numbers_05
.globl _s_score_numbers_06
.globl _s_score_numbers_07
.globl _s_score_numbers_08
.globl _s_logo
.globl _g_font_chars
.globl _s_high_score_icon
.globl _s_star_icon
.globl _s_next_frame
.globl _g_glasnost
.globl _s_witch_0
.globl _s_witch_1
.globl _s_witch_2
.globl _s_hat
.globl _no_more_moves_string


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
.globl cpct_drawSpriteBlended_asm
.globl _cpct_keyboardStatusBuffer

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

S_HI_SCORE_ICON_W = 6
S_HI_SCORE_ICON_H = 19

S_STAR_ICON_W = 5
S_STAR_ICON_H = 14

S_SCORE_NUMBERS_W = 3
S_SCORE_NUMBERS_H = 15

S_LOGO_W = 34
S_LOGO_H = 64

S_NEXT_FRAME_W =12
S_NEXT_FRAME_H =33

G_GLASNOST_W = 27
G_GLASNOST_H = 16

S_WITCH_W  = 6
S_WITCH_H  = 34

S_HAT_W  = 6
S_HAT_H  = 8

BOARD_X_COORD = 1   ;; X 
BOARD_Y_COORD = 54  ;; Y 
BOARD_ROWS = 10     ;;
BOARD_COLS = 10     ;;

PIECE_HOR_SIZE = 5
PIECE_VER_SIZE = 5

MAX_PIECE = 18

NEXT_PIECE_MAX_HEIGHT = 30
NEXT_PIECE_MAX_WIDTH = 10

SCORE_NUM_BYTES = 4

;; Keyboard constants
BUFFER_SIZE = 10
ZERO_KEYS_ACTIVATED = #0xFF

;; WinAPE special BRK instruction
;; - more info at http://www.winape.net/help/debug.html
.mdelete BREAKPOINT
.macro BREAKPOINT
  .db #0xed, #0xff
.endm


