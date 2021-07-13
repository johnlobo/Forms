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
.include "man/entity.h.s"
.include "util.h.s"

.module render_system


;;
;; INIT 
;;  Initialize video mode
;;
sys_render_init::
       ;; Set video mode
    ld c,#0
    call cpct_setVideoMode_asm
    ;; Set palette
    ld hl, #_g_palette0
    ld de, #16
    call cpct_setPalette_asm
    ;; Set Border
    cpctm_setBorder_asm HW_WHITE

    ;; Clean up the screen 
    ld de, #CPCT_VMEM_START_ASM
    ld a, #0x00
    ld bc, #4000
    call cpct_memset_asm

    ret

sys_render_game_screen::
    ;; Draw Hi Score Title
    ld de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld b, #HIGH_SCORE_TITLE_Y_COORD                     ;; B = y coordinate (24 = 0x18)
    ld c, #HIGH_SCORE_TITLE_X_COORD        ;; C = x coordinate (16 = 0x10)
    call cpct_getScreenPtr_asm  ;; Calculate video memory location and return it in HL
    ex de, hl                   ;; move screen address to de
    ld hl, #_s_hi_score      ;; load in HL the address of the sprite
    ld c, #S_HI_SCORE_W        ;; load in c the sprite width 
    ld b, #S_HI_SCORE_H        ;; load in b sprite height
    call cpct_drawSprite_asm    ;; draw sprite

    ;; Draw Score Title
    ld de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld b, #SCORE_TITLE_Y_COORD                     ;; B = y coordinate (24 = 0x18)
    ld c, #SCORE_TITLE_X_COORD        ;; C = x coordinate (16 = 0x10)
    call cpct_getScreenPtr_asm  ;; Calculate video memory location and return it in HL
    ex de, hl                   ;; move screen address to de
    ld hl, #_s_score      ;; load in HL the address of the sprite
    ld c, #S_SCORE_W        ;; load in c the sprite width 
    ld b, #S_SCORE_H        ;; load in b sprite height
    call cpct_drawSprite_asm    ;; draw sprite

    call sys_render_board

    ;; Draw One
    ld de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld b, #UNO_TITLE_Y_COORD                     ;; B = y coordinate (24 = 0x18)
    ld c, #UNO_TITLE_X_COORD        ;; C = x coordinate (16 = 0x10)
    call cpct_getScreenPtr_asm  ;; Calculate video memory location and return it in HL
    ex de, hl                   ;; move screen address to de
    ld hl, #_s_uno      ;; load in HL the address of the sprite
    ld c, #S_UNO_W        ;; load in c the sprite width 
    ld b, #S_UNO_H        ;; load in b sprite height
    call cpct_drawSprite_asm    ;; draw sprite

    ;; Draw Two
    ld de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld b, #DOS_TITLE_Y_COORD                     ;; B = y coordinate (24 = 0x18)
    ld c, #DOS_TITLE_X_COORD        ;; C = x coordinate (16 = 0x10)
    call cpct_getScreenPtr_asm  ;; Calculate video memory location and return it in HL
    ex de, hl                   ;; move screen address to de
    ld hl, #_s_dos      ;; load in HL the address of the sprite
    ld c, #S_DOS_W        ;; load in c the sprite width 
    ld b, #S_DOS_H        ;; load in b sprite height
    call cpct_drawSprite_asm    ;; draw sprite

    ;; Draw Three
    ld de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld b, #TRES_TITLE_Y_COORD                     ;; B = y coordinate (24 = 0x18)
    ld c, #TRES_TITLE_X_COORD        ;; C = x coordinate (16 = 0x10)
    call cpct_getScreenPtr_asm  ;; Calculate video memory location and return it in HL
    ex de, hl                   ;; move screen address to de
    ld hl, #_s_tres      ;; load in HL the address of the sprite
    ld c, #S_TRES_W        ;; load in c the sprite width 
    ld b, #S_TRES_H        ;; load in b sprite height
    call cpct_drawSprite_asm    ;; draw sprite

    ret

sys_render_board::  
    ld b, #BOARD_ROWS                 ;; Number of rows
_render_board_loop02:
    push bc
    ld a, #BOARD_ROWS           ;; Initial number of times
    sub b                       ;; Minus the number of rows drawn
    ld h, a                     ;; Move to h
    ld e, #S_BALLS_BIG_H + 1    ;; Cell height + 1
    call h_times_e              ;; Number of rows drawn x cell height + 1
    ld a, #BOARD_Y_COORD        ;; store in a the initial y coord
    add l                       ;; plus the number of rows x intial y coord 
    ;; Calculate screen address
    ld de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld b, a                     ;; B = y coordinate (24 = 0x18)
    ld c, #BOARD_X_COORD        ;; C = x coordinate (16 = 0x10)
    call cpct_getScreenPtr_asm  ;; Calculate video memory location and return it in HL
    ex de, hl                   ;; load in DE the screen adreess kept in HL
    ld b, #BOARD_COLS           ;; Number of columns
_render_board_loop01:
    push bc                     ;; store number of columns in the stack
    push de                     ;; store screen address in the stack
    ld hl, #_s_balls_big_7      ;; load in HL the address of the sprite
    ld c, #S_BALLS_BIG_W        ;; load in c the sprite width 
    ld b, #S_BALLS_BIG_H        ;; load in b sprite height
    call cpct_drawSprite_asm    ;; draw sprite
    pop hl                      ;; retrieve the destiny screen adress from the stack in hl
    ld a, #S_BALLS_BIG_W        ;;--
    add l                       ;;
    ld l, a                     ;; add hl and S_BALLS_BIG_W
    ld a, #0                    ;;
    adc h                       ;;
    ld h, a                     ;;--
    ex de, hl                   ;; load screen address in de
    pop bc                      ;; retrieve b from the stack
    djnz _render_board_loop01
    pop bc                      ;; retrieve number of columns from stack
    djnz _render_board_loop02
    ret

;;-----------------------------------------------
;; Draw a player tile
;;    hl: screen address
;;-----------------------------------------------
sys_render_increment_hl::
    ld c, a                     ;; save piece row in c   
    ld a, #S_BALLS_BIG_W
    add_hl_a                    ;; increment hl with sprite width
    ld a, c                     ;; retrive piece row
    ret

;;-----------------------------------------------
;; Draw a player tile
;;    hl: screen address
;;-----------------------------------------------
sys_render_draw_player_tile::
    ;; Draw tile
    ex  de, hl                          ;; DE = Pointer to Video Memory (X,Y) location
    ld   hl, #_s_balls_big_0
    ld c, #S_BALLS_BIG_W            ;; load in c the sprite width 
    ld b, #S_BALLS_BIG_H            ;; load in b sprite height
    call cpct_drawSprite_asm        ;; draw sprite
    ret

;;-----------------------------------------------
;; Draw a player
;;    IX = player struct pointer
;;-----------------------------------------------
sys_render_draw_player::
    ld ix, #p1

    ld h, player_type_off(ix)   ;; Type of piece
    ld e, #PIECE_SIZE           ;; Piece size in bytes
    call h_times_e              ;; Calculate offset for piece type in HL
    ld de, #piece_type
    add hl,de                   ;; hl points to start of piece

_dp_loop_0:

    push hl                     ;; store hl in stack

    ;; Get Screen Pointer
    ld  de, #CPCT_VMEM_START      ;; DE = Pointer to video memory start
    ld  c, player_x_off(ix)   ;; C  = Player X Position
    ld  b, player_y_off(ix)   ;; B  = Player Y Position
    call cpct_getScreenPtr_asm    ;; Get Screen Pointer
    ;; Return value: HL = Screen Pointer to (X, Y) byte
    ex de, hl                   ;; store screen address in de

    pop hl                      ;; retrieve piece address

    ld a, (hl)                  ;; load first row (byte) in a
    ex de, hl                   ;; load in hl the screen to draw

    bit 0,a                     ;; first bit
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position

    bit 1,a                     ;; second bit
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position    

    bit 2,a                     ;; third bit
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position    

    bit 3,a                         ;; forth bit
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position 

    bit 4,a                         ;; forth bit
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position 

    bit 5,a                         ;; forth bit
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position 

    bit 6,a                         ;; forth bit
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position  

    bit 7,a                         ;; forth bit
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position  

    ex de, hl                       ;; move piece address to hl and screen address to de

    djnz _dp_loop_0
    ret