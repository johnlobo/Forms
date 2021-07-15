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


;;-----------------------------------------------------------------
;;
;; sys_render_init
;;
;;   Initializes render
;;  Input: 
;;  Output:
;;  Modified: af, hl, de, bc
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

;-----------------------------------------------------------------
;;
;; sys_render_game_screen
;;
;;   Renders game screen
;;  Input: 
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_render_game_screen::
    ;; Draw Hi Score Title
    ld de, #CPCT_VMEM_START_ASM     ;; DE = Pointer to start of the screen
    ld b, #HIGH_SCORE_TITLE_Y_COORD ;; B = y coordinate (24 = 0x18)
    ld c, #HIGH_SCORE_TITLE_X_COORD ;; C = x coordinate (16 = 0x10)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL
    ex de, hl                       ;; move screen address to de
    ld hl, #_s_hi_score             ;; load in HL the address of the sprite
    ld c, #S_HI_SCORE_W             ;; load in c the sprite width 
    ld b, #S_HI_SCORE_H             ;; load in b sprite height
    call cpct_drawSprite_asm        ;; draw sprite

    ;; Draw Score Title
    ld de, #CPCT_VMEM_START_ASM     ;; DE = Pointer to start of the screen
    ld b, #SCORE_TITLE_Y_COORD      ;; B = y coordinate (24 = 0x18)
    ld c, #SCORE_TITLE_X_COORD      ;; C = x coordinate (16 = 0x10)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL
    ex de, hl                       ;; move screen address to de
    ld hl, #_s_score                ;; load in HL the address of the sprite
    ld c, #S_SCORE_W                ;; load in c the sprite width 
    ld b, #S_SCORE_H                ;; load in b sprite height
    call cpct_drawSprite_asm        ;; draw sprite

    call sys_render_board

    ;; Draw One
    ld de, #CPCT_VMEM_START_ASM     ;; DE = Pointer to start of the screen
    ld b, #UNO_TITLE_Y_COORD        ;; B = y coordinate (24 = 0x18)
    ld c, #UNO_TITLE_X_COORD        ;; C = x coordinate (16 = 0x10)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL
    ex de, hl                       ;; move screen address to de
    ld hl, #_s_uno                  ;; load in HL the address of the sprite
    ld c, #S_UNO_W                  ;; load in c the sprite width 
    ld b, #S_UNO_H                  ;; load in b sprite height
    call cpct_drawSprite_asm        ;; draw sprite

    ;; Draw Two
    ld de, #CPCT_VMEM_START_ASM     ;; DE = Pointer to start of the screen
    ld b, #DOS_TITLE_Y_COORD        ;; B = y coordinate (24 = 0x18)
    ld c, #DOS_TITLE_X_COORD        ;; C = x coordinate (16 = 0x10)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL
    ex de, hl                       ;; move screen address to de
    ld hl, #_s_dos                  ;; load in HL the address of the sprite
    ld c, #S_DOS_W                  ;; load in c the sprite width 
    ld b, #S_DOS_H                  ;; load in b sprite height
    call cpct_drawSprite_asm        ;; draw sprite

    ;; Draw Three
    ld de, #CPCT_VMEM_START_ASM     ;; DE = Pointer to start of the screen
    ld b, #TRES_TITLE_Y_COORD       ;; B = y coordinate (24 = 0x18)
    ld c, #TRES_TITLE_X_COORD       ;; C = x coordinate (16 = 0x10)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL
    ex de, hl                       ;; move screen address to de
    ld hl, #_s_tres                 ;; load in HL the address of the sprite
    ld c, #S_TRES_W                 ;; load in c the sprite width 
    ld b, #S_TRES_H                 ;; load in b sprite height
    call cpct_drawSprite_asm        ;; draw sprite

    ret

;-----------------------------------------------------------------
;;
;; sys_render_board
;;
;;   Renders board
;;  Input: 
;;  Output:
;;  Modified: af, hl, de, bc
;;
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

;-----------------------------------------------------------------
;;
;; sys_render_capture_background
;;
;;   Draw player1
;;  Input:  ix : player address
;;          hl : screen address
;;          c : width to capture
;;          b : height to capture
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
sys_render_capture_background::
    push hl
    push de
    push bc

    ld e_p_screen_p(ix), l
    ld e_p_screen_p+1(ix), h        ;; Screen address to restore

    ld h, b                         ;; Height of the piece
    ld e, #PIECE_SIZE               ;; Piece size in bytes
    call h_times_e                  ;; Calculate offset for piece type in HL
    ld a, l                         ;; store buffer height in player
    ld e_buffer_height(ix), a       ;; store height in player1
    
    ld h, c                         ;; Width of the piece
    ld e, #PIECE_SIZE               ;; Piece size in bytes
    call h_times_e                  ;; Calculate offset for piece type in HL
    ld a, l                         ;; store buffer width in player
    ld e_buffer_width(ix), a        ;; store width in player1

    ld de, #player_buffer           ;; Buffer address
    ld l, e_p_screen_p(ix)
    ld h, e_p_screen_p+1(ix)        ;; Screen address to restore

    call cpct_getScreenToSprite_asm

    pop bc
    pop de
    pop hl
    ret

;-----------------------------------------------------------------
;;
;; sys_render_increment_hl
;;
;;   Increments hl with the width of a ball
;;  Input: 
;;  Output: hl
;;  Modified: 
;;
sys_render_increment_hl::
    ld c, a                     ;; save piece row in c   
    ld a, #S_BALLS_BIG_W
    add_hl_a                    ;; increment hl with sprite width
    ld a, c                     ;; retrive piece row
    ret

;-----------------------------------------------------------------
;;
;; sys_render_draw_player_tile
;;
;;   Draw player tile
;;  Input:  de screen address to draw the tile 
;;  Output: 
;;  Destroyed: AF, BC, DE, HL
;;
sys_render_draw_player_tile::
    ;; Draw tile
    push hl
    push de
    push bc
    ex de, hl
    ld   hl, #_s_balls_big_5
    ld c, #S_BALLS_BIG_W            ;; load in c the sprite width 
    ld b, #S_BALLS_BIG_H            ;; load in b sprite height
    call cpct_drawSprite_asm        ;; draw sprite
    pop bc
    pop de
    pop hl
    ret

;-----------------------------------------------------------------
;;
;; sys_render_draw_player
;;
;;   Draw player1
;;  Input: 
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
sys_render_draw_player1::
    ld hl, #player1
    push hl
    pop ix                          ;; move the address of p1 to ix


    ld h, e_type(ix)                ;; Type of piece
    ld e, #PIECE_SIZE               ;; Piece size in bytes
    call h_times_e                  ;; Calculate offset for piece type in HL
    ld de, #piece_types
    add hl,de                       ;; hl points to start of the model of piece of the player
    ld a, (hl)
    ld (_piece_width), a            ;; store piece width 

    inc hl
    ld a, (hl)
    ld (_piece_height), a           ;; store piece height
    inc hl                          ;; advance to the first byte of the piece

    ld b, a                         ;; Number of rows to loop (piece_height)

_render_dp_loop_0:
    push bc                         ;; save number of rows in the stack
    push hl                         ;; store the start of the model of the piece in the stack

    ld a, (_piece_height)               ;; Calculate the y coord and store in in a
    sub b        
    ld e, a                         ;; player1.y + PIECE_SIZE - ROWS drawn
    ld h, #S_BALLS_BIG_H + 1 
    call h_times_e                  ;; hl has PIECE_SIZE x ROWS drawn
    ld a, e_y(ix)                   ;; load the initial y coord of player
    add l                           ;; and add PIECE_SIZE x ROWS

    ;; Get Screen Pointer
    ld  de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to video memory start
    ld  c, e_x(ix)                  ;; C  = Player X Position
    ld  b, a                        ;; B  = Player Y Position
    call cpct_getScreenPtr_asm      ;; Get Screen Pointer
    ;; Return value: HL = Screen Pointer to (X, Y) byte

    ld a, (_piece_width)            ;; retrive width to capture
    ld c, a
    ld a, (_piece_height)            ;; retrieve height to capture
    ld b, a
    call sys_render_capture_background  ;; capture background

    ex de, hl                       ;; store screen address in de

    pop hl                          ;; retrieve piece address

    ld a, (hl)                      ;; load first row (byte) in a
    or a                            ;; check if piece byte is 00
    jr z, _dp_continue_0            ;; jump to next byte if so

    ld (_piece_byte),a
    ex de, hl                       ;; load in hl the screen to draw
 
    bit 0,a                         ;; first bit
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position
    
    ld a, (_piece_byte)
    bit 1,a                         ;; second bit
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position    

    ld a, (_piece_byte)
    bit 2,a                         ;; third bit
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position    

    ld a, (_piece_byte)
    bit 3,a                         ;; forth bit
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position 

    ld a, (_piece_byte)
    bit 4,a                         ;; forth bit
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position 

    ld a, (_piece_byte)
    bit 5,a                         ;; forth bit
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position 

    ld a, (_piece_byte)
    bit 6,a                         ;; forth bit
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position  

    ld a, (_piece_byte)
    bit 7,a                         ;; forth bit
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position  

    ex de, hl                       ;; move piece address to hl and screen address to de

_dp_continue_0:
    inc hl                          ;; and go to th6e next byte of the piece
    pop bc                          ;; retrive number of rows

    dec b
    ld a,b
    or a
    jp z, _render_dp_loop_0         ;; can't use djnz because the jump is more than 128 bytes of distance
    
    ret

    _piece_byte::    .db #0
    _piece_width::   .db #0
    _piece_height::  .db #0

;-----------------------------------------------------------------
;;
;; sys_render_erase_player
;;
;;   Erase player 
;;  Input:  
;;  Output: 
;;  Destroyed: AF, BC, DE, HL
;;
sys_render_erase_player::
    ;; Draw tile
    ld hl, #player1
    push hl
    pop ix
    ld e, e_p_screen_p(ix)
    ld d, e_p_screen_p+1(ix)
    ld hl, #player_buffer
    ld c, e_buffer_width(ix)            ;; load in c the sprite width 
    ld b, e_buffer_width(ix)            ;; load in b sprite height
    call cpct_drawSprite_asm            ;; draw sprite
    ret


;-----------------------------------------------------------------
;;
;; sys_render_screen_test
;;
;;   Draw test screen
;;  Input: 
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
sys_render_screen_test::

;; Big balls
    ld b, #8
    ld de, #0xcee1
    ld hl, #_s_balls_big_0
_sr_loop0:
    push bc
    push hl
    push de

    ld c, #S_BALLS_BIG_W                    ;; load in c the sprite width 
    ld b, #S_BALLS_BIG_H                    ;; load in b sprite height
    call cpct_drawSprite_asm                ;; draw sprite 

    pop hl                                  ;; increment screen position
    ld a, #S_BALLS_BIG_W
    add_hl_a
    ex de, hl

    pop hl
    ld a, #S_BALLS_BIG_W * S_BALLS_BIG_H     ;; increment sprite pointer
    add_hl_a

    pop bc
    djnz _sr_loop0

;; Small balls
    ld b, #7
    ld de, #0xd3f0
    ld hl, #_s_balls_small_0
_sr_loop1:
    push bc
    push hl
    push de

    ld c, #S_BALLS_SMALL_W                    ;; load in c the sprite width 
    ld b, #S_BALLS_SMALL_H                    ;; load in b sprite height
    call cpct_drawSprite_asm                ;; draw sprite 

    pop hl                                  ;; increment screen position
    ld a, #S_BALLS_SMALL_W
    add_hl_a
    ex de, hl

    pop hl
    ld a, #S_BALLS_SMALL_W * S_BALLS_SMALL_H     ;; increment sprite pointer
    add_hl_a

    pop bc
    djnz _sr_loop1
    
    ret
