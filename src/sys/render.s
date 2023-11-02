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

.include "cpctelera.h.s"
.include "../common.h.s"
.include "man/entity.h.s"
.include "man/game.h.s"
.include "sys/board.h.s"
.include "sys/text.h.s"
.include "sys/score.h.s"
.include "sys/input.h.s"
.include "sys/messages.h.s"
.include "util.h.s"

.module render_system


;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA

_piece_byte::   .db #00
_piece_x::      .db #00
_piece_y::      .db #00
_piece_width::  .db #00
_piece_height:: .db #00
_piece::        .db #00
_score_digit:   .db #00
_fila:          .db #00
_press_any_key: .asciz "PRESS S TO START"
_redefine_keys: .asciz "PRESS R TO REDEFINE KEYS"
_next_forms_string: .asciz "NEXT FORMS"
_to_change_form_string: .asciz "[I]-CHANGE"
_hiscore_string: .asciz "HIGH SCORE TABLE"
_press_any_key_string: .asciz "PRESS ANY KEY"   ;; 13 chars, 26 bytes
_tribute_string00: .asciz "HEY CPC,"            ;; 25 chars, 50 bytes
_tribute_string01: .asciz "THANKS FOR THE "     ;; 25 chars, 50 bytes
_tribute_string02: .asciz "LAST 30 YEARS"       ;; 25 chars, 50 bytes
_no_more_moves_string: .asciz "NO MORE MOVES"
_game_cancelled_string: .asciz "GAME CANCELLED"


;;
;; Start of _CODE area
;; 
.area _CODE

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
    cpctm_setBorder_asm HW_BRIGHT_WHITE
    ;;cpctm_setBorder_asm HW_BLACK

    cpctm_clearScreen_asm 255

    ret

;;-----------------------------------------------------------------
;;
;; sys_render_logo_screen
;;
;;   Initializes render
;;  Input: 
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_render_logo_screen::

    cpctm_clearScreen_asm 255
    
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 21, 35     ;; screen address in de
    ld hl, #_s_logo
    ld c, #S_LOGO_W
    ld b, #S_LOGO_H
    call cpct_drawSprite_asm

    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 16, 134    ;; screen address in de
    ld hl, #_redefine_keys
    call sys_text_draw_string

    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 24, 150    ;; screen address in de
    ld hl, #_press_any_key
    call sys_text_draw_string

    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 26, 184    ;; screen address in de
    ld hl, #_g_glasnost
    ld c, #G_GLASNOST_W
    ld b, #G_GLASNOST_H
    call cpct_drawSprite_asm

    ret

;-----------------------------------------------------------------
;;
;; sys_render_hiscore_screen
;;
;;   Renders high score screen
;;  Input: 
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_render_hiscore_screen::
    cpctm_push hl, de, bc, ix
    
    ;; clear screen
    cpctm_clearScreen_asm 255           ;; Clear screen
          
    ;; print title
    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 24, 26  ;; screen address for 30, 120 in de
    ld hl, #_hiscore_string    ;; message
    call sys_text_draw_string

    ;; first line
    ;; print score
    ld de,#hi_score_table
    cpctm_screenPtr_asm hl, CPCT_VMEM_START_ASM, 16, 55  ;; screen address for 1, 20 in de
    call sys_render_BCD_show
    ;; print name
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 46, 58  ;; screen address for 9, 13 in de
    ld c, #0
    ld hl,#hi_score_table + sc_name
    call sys_text_draw_string
    
    ;; second line
    ;; print score
    ld de,#hi_score_table + sizeof_sc
    cpctm_screenPtr_asm hl, CPCT_VMEM_START_ASM, 16, 75  ;; screen address for 1, 20 in de
    call sys_render_BCD_show
    ;; print name
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 46, 78  ;; screen address for 9, 13 in de
    ld c, #0
    ld hl,#hi_score_table + sizeof_sc + sc_name
    call sys_text_draw_string
    
    ;; third line
    ;; print score
    ld de,#hi_score_table + (sizeof_sc * 2)
    cpctm_screenPtr_asm hl, CPCT_VMEM_START_ASM, 16, 95  ;; screen address for 1, 20 in de
    call sys_render_BCD_show
    ;; print name
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 46, 98  ;; screen address for 9, 13 in de
    ld c, #0
    ld hl,#hi_score_table + (sizeof_sc * 2) + sc_name
    call sys_text_draw_string
    
    ;; forth line
    ;; print score
    ld de,#hi_score_table + (sizeof_sc * 3)
    cpctm_screenPtr_asm hl, CPCT_VMEM_START_ASM, 16, 115  ;; screen address for 1, 20 in de
    call sys_render_BCD_show
    ;; print name
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 46, 118  ;; screen address for 9, 13 in de
    ld c, #0
    ld hl,#hi_score_table + (sizeof_sc * 3) + sc_name
    call sys_text_draw_string
    
    ;; fifth line
    ;; print score
    ld de,#hi_score_table + (sizeof_sc * 4)
    cpctm_screenPtr_asm hl, CPCT_VMEM_START_ASM, 16, 135  ;; screen address for 1, 20 in de
    call sys_render_BCD_show
    ;; print name
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 46, 138  ;; screen address for 9, 13 in de
    ld c, #0
    ld hl,#hi_score_table + (sizeof_sc * 4) + sc_name
    call sys_text_draw_string

    ;; print press any key
    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 27, 170  ;; screen address for 30, 120 in de
    ld hl, #_press_any_key_string                        ;; message
    call sys_text_draw_string
    
    call sys_input_wait4anykey

    cpctm_pop ix, bc, de, hl
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
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 1, 14       ;; screen address for 4, 6 in de

    ld hl, #_s_high_score_icon             ;; load in HL the address of the sprite
    ld c, #S_HI_SCORE_ICON_W             ;; load in c the sprite width 
    ld b, #S_HI_SCORE_ICON_H             ;; load in b sprite height
    call cpct_drawSprite_asm        ;; draw sprite

    ;; Draw Score Title
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 60, 4       ;; screen address for 57, 6 in de

    ld hl, #_s_star_icon                ;; load in HL the address of the sprite
    ld c, #S_STAR_ICON_W                ;; load in c the sprite width 
    ld b, #S_STAR_ICON_H                ;; load in b sprite height
    call cpct_drawSprite_asm        ;; draw sprite

    call sys_render_board

    ;; Text to remember I Key change pieces
    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 48, 74  ;; screen address for 30, 120 in de
    ld hl, #_next_forms_string
    call sys_text_draw_string

    ;; Text to remember I Key change pieces
    ld c, #0
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 49, 138  ;; screen address for 30, 120 in de
    ld hl, #_to_change_form_string
    call sys_text_draw_string

    ret

;-----------------------------------------------------------------
;;
;; sys_render_cell
;;
;;  Renders a single cell of the board
;;  Input:  b: y coord of board to render
;;          c: x coord of board to render
;;  Output:
;;  Modified: af, hl, de, bc
;;
sys_render_cell::
    push bc
    ;; calculate x coord of screen
    ld e, c
    ld h, #S_BALLS_BIG_W
    call sys_util_h_times_e
    ld a, #BOARD_X_COORD
    add l
    ld c, a

    ;; calculate y coord of screen
    ld e, b
    ld h, #S_BALLS_BIG_H + 1
    call sys_util_h_times_e
    ld a, #BOARD_Y_COORD
    add l
    ld b, a

    ;; calculate screen address
    ld de, #CPCT_VMEM_START_ASM         ;; DE = Pointer to start of the screen
    call cpct_getScreenPtr_asm          ;; Calculate video memory location and return it in HL
    ex de, hl                           ;; move screen address to de

    ;; draw sprite
    pop bc                              ;; retrieve x,y coords of board
    call sys_board_cell_sprite
    ld c, #S_BALLS_BIG_W                ;; load in c the sprite width 
    ld b, #S_BALLS_BIG_H                ;; load in b sprite height
    call cpct_drawSprite_asm            ;; draw sprite

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
    
    ld (current_row + 1), a     ;; Store current row for printing sprite (self modifying code)
    
    ld h, a                     ;; Move to h
    ld e, #S_BALLS_BIG_H + 1    ;; Cell height + 1
    call sys_util_h_times_e     ;; Number of rows drawn x cell height + 1
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

    ld a, #BOARD_COLS           ;;
    sub b                       ;;
    ld c, a                     ;; load in a the current col

current_row:
    ld b, #00                   ;; load in b current row 

    ld hl, #_s_sprites_0

    ld c, #S_BALLS_BIG_W        ;; load in c the sprite width 
    ld b, #S_BALLS_BIG_H        ;; load in b sprite height
    call cpct_drawSprite_asm    ;; draw sprite
    pop hl                      ;; retrieve the destiny screen adress from the stack in hl
    ld a, #S_BALLS_BIG_W        ;;--
    add_hl_a                    ;; add hl and S_BALLS_BIG_W
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

    ld ix, #player1

    ld e_p_screen_p(ix), l
    ld e_p_screen_p+1(ix), h        ;; Screen address to restore

    ld h, b                         ;; Height of the piece
    ld e, #S_BALLS_BIG_H + 1        ;; Piece size in bytes + 1 for the separation between forms
    call sys_util_h_times_e         ;; Calculate offset for piece type in HL
    ld a, l                         ;; store buffer height in player
    ld e_buffer_height(ix), a       ;; store height in player1
    
    ld h, c                         ;; Width of the piece
    ld e, #S_BALLS_BIG_W            ;; Piece size in bytes
    call sys_util_h_times_e                  ;; Calculate offset for piece type in HL
    ld a, l                         ;; store buffer width in player
    ld e_buffer_width(ix), a        ;; store width in player1

    ld de, #player_buffer           ;; Buffer address
    ld l, e_p_screen_p(ix)
    ld h, e_p_screen_p+1(ix)        ;; Screen address to restore
    ld c, e_buffer_width(ix)
    ld b, e_buffer_height(ix)

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
;;          b: current row (inverse)
;;          c: current col
;;  Output: 
;;  Destroyed: AF, BC, DE, HL
;;
sys_render_draw_player_tile::
    ;; Draw tile
    push hl
    push de
    push bc

    ex de, hl

    ;; check if cell board is empty
    ld a, e_h(ix)                           ;; Store heith of piece in a
    sub b                                   ;; Substract b to know current row
    ld (draw_player_tile_add_row + 1), a    ;; Self modifying code to add the current row
    ld a, c
    ld (draw_player_tile_add_col + 1), a    ;; Self modifying code to add the current col
    ld a, e_y(ix)                           ;; load y coord in a
draw_player_tile_add_row:
    add #00                                 ;; add current row (self modifying code)
    ld b, a                                 ;; and save the same value in b
    ;; TODO Sustituir por call ten_times_a
    sla a
    sla a
    sla a                                   ;; multiply by 8
    add b
    add b                                   ;; then add 2 times coord y and thats it.
    ;;
    ld b, e_x(ix)
    add b                                   ;; then add the x coord and we have the offset for the cell
draw_player_tile_add_col:
    add #00                                 ;; add current row (self modifying code)
    ld hl, #board
    add_hl_a                                  ;; Then add the offset
    ld a, (hl)                      ;; load the content of the board in a
    ;;ld   hl, #_s_balls_big_05       ;; Load in hl the tile by default
    ld l, e_sprite_player_ptr(ix)
    ld h, e_sprite_player_ptr+1(ix)
    or a                            ;; check if the content is 0
    jr z, draw_player_tile_draw     ;; if 0 just print the default tile
    ld hl, #_s_sprites_1         ;; other wise draw the not valid tile
draw_player_tile_draw:
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
    ld ix, #player1                 ;; move the address of p1 to ix
    ld e, e_x(ix)                   ;; Calculate x screen position
    ld h, #S_BALLS_BIG_W            ;;
    call sys_util_h_times_e                  ;; e_x(ix) x S_BALLS_BIG_W
    ld a,#BOARD_X_COORD             ;; add board x pos to x position
    add l                           ;;
    ld (_piece_x), a                ;;

    ld e, e_y(ix)                   ;; Calculate y screen position
    ld h, #S_BALLS_BIG_H + 1        ;;
    call sys_util_h_times_e                  ;; e_y(ix) x S_BALLS_BIG_H
    ld a,#BOARD_Y_COORD             ;; add board y pos to x position
    add l                           ;;
    ld (_piece_y), a                ;;

    ld c, e_p_screen_p(ix)          ;; if previous address is not null, then erase 
    ld a, e_p_screen_p+1 (ix)       ;;
    add c                           ;;
    or a                            ;;
    jr z, _render_draw_start        ;; 
    call sys_render_erase_player    ;;

_render_draw_start:
    ;; Get Screen Pointer
    ld a, (_piece_x)
    ld c, a
    ld a, (_piece_y)
    ld b, a 
    ld  de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to video memory start
    call cpct_getScreenPtr_asm      ;; Get Screen Pointer
    ;; Return value: HL = Screen Pointer to (X, Y) byte
    ld a, e_w(ix)            ;; retrive width to capture
    ld c, a
    ld a, e_h(ix)            ;; retrieve height to capture
    ld b, a
    call sys_render_capture_background  ;; capture background

    ld a, e_type(ix)                    ;; Type of piece
    call man_entity_get_hl_from_piece   ;; get address for a type of piece in hl
    inc hl                          ;; skip piece width
    inc hl                          ;; skip piece height

    ld b, e_h(ix)                   ;; Number of rows to loop (piece_height)

_render_dp_loop_0:
    ld a,b
    ld (_fila), a
    push bc                         ;; save number of rows in the stack
    push hl                         ;; store the start of the model of the piece in the stack

    ld a, e_h(ix)                   ;; Calculate y coord and store in in a
    sub b        
    ld e, a                         ;; player1.y + tile height - ROWS drawn
    ld h, #S_BALLS_BIG_H + 1 
    call sys_util_h_times_e                  ;; hl has PIECE_SIZE x ROWS drawn
    ld a, (_piece_y)                ;; load the initial y coord of player
    add l                           ;; and add PIECE_SIZE x ROWS
    ld b, a

    ld a, (_piece_x)                ;;
    ld c, a                         ;; Store x position in c

    ;; Get Screen Pointer
    ld  de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to video memory start
    call cpct_getScreenPtr_asm      ;; Get Screen Pointer
    ;; Return value: HL = Screen Pointer to (X, Y) byte

    ex de, hl                       ;; store screen address in de

    pop hl                          ;; retrieve piece address

    ld a, (hl)                      ;; load first row (byte) in a
    or a                            ;; check if piece byte is 00
    jr z, _dp_continue_0            ;; jump to next byte if so

    ld (_piece_byte),a
    ex de, hl                       ;; load in hl the screen to draw
 
    bit 4,a                         ;; first bit
    ld c, #00                       ;; load number of col in c
    ld a, (_fila)
    ld b, a
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position
    
    ld a, (_piece_byte)
    bit 3,a  
    ld c, #01                       ;; load number of col in c
    ld a, (_fila)
    ld b, a
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position    

    ld a, (_piece_byte)
    bit 2,a  
    ld c, #02                       ;; load number of col in c
    ld a, (_fila)
    ld b, a
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position    

    ld a, (_piece_byte)
    bit 1,a  
    ld c, #03                       ;; load number of col in c
    ld a, (_fila)
    ld b, a
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position 

    ld a, (_piece_byte)
    bit 0,a  
    ld c, #04                       ;; load number of col in c
    ld a, (_fila)
    ld b, a
    call nz, sys_render_draw_player_tile
    call sys_render_increment_hl    ;; increment hl to next sprite position 

    ex de, hl                       ;; move piece address to hl and screen address to de

_dp_continue_0:
    inc hl                          ;; and go to th6e next byte of the piece
    pop bc                          ;; retrive number of rows

    dec b
    ld a,b
    or a
    jp nz, _render_dp_loop_0         ;; can't use djnz because the jump is more than 128 bytes of distance
    
    ret

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
    ld ix, #player1
    ld e, e_p_screen_p(ix)
    ld d, e_p_screen_p+1(ix)
    ld hl, #player_buffer
    ld c, e_buffer_width(ix)            ;; load in c the sprite width 
    ld b, e_buffer_height(ix)            ;; load in b sprite height
    call cpct_drawSprite_asm            ;; draw sprite
    ret

;-----------------------------------------------------------------
;;
;; sys_reder_update
;;
;;   Draw test screen
;;  Input: 
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
sys_render_update::
    ld ix, #player1                     ;; moved??
    ld a, e_moved(ix)                   ;;  
    or a                                ;;
    ret z                               ;; return if not moved
    call sys_render_draw_player1        ;; moved -> render player1
    xor a                               ;; moved = 0
    ld e_moved(ix), a                   ;;
    ret

;-----------------------------------------------------------------
;;
;; sys_render_increment_hl_small
;;
;;   Increments hl with the width of a ball
;;  Input: 
;;  Output: hl
;;  Modified: 
;;
sys_render_increment_hl_small::
    ld c, a                     ;; save piece row in c   
    ld a, #S_BALLS_SMALL_W
    add_hl_a                    ;; increment hl with sprite width
    ld a, c                     ;; retrive piece row
    ret

;-----------------------------------------------------------------
;;
;; sys_render_draw_small_tile
;;
;;   Draw player tile
;;  Input:  de screen address to draw the tile 
;;          iy pointer to the sprite
;;  Output: 
;;  Destroyed: AF, BC, DE, HL
;;
sys_render_draw_small_tile::
    ;; Draw tile
    push hl
    push de
    push bc
    ex de, hl                       ;; save screen address in de
    push iy                         ;; save sprite pointer in stack
    pop hl                          ;; retrieve sprite pointer
    ld c, #S_BALLS_SMALL_W          ;; load in c the sprite width 
    ld b, #S_BALLS_SMALL_H          ;; load in b sprite height
    call cpct_drawSprite_asm        ;; draw sprite
    pop bc
    pop de
    pop hl
    ret

;-----------------------------------------------------------------
;;
;; sys_render_erase_next_piece
;;
;;   Draw player1
;;  Input:  a : number of piece
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
sys_render_erase_next_piece::
    ;; Get Screen Pointer
    add a                           ;; duplicate piece number to get the offset
    ld hl, #next_pieces_coords
    add_hl_a                        ;; sum netx piece coords address with offset to get piece address
    ld a, (hl)                      ;; load x coord of piece in a
    ld c, a                         ;; store it in c
    inc hl                          ;; inc pointer to get y coord
    ld a, (hl)                      ;; load y coord of piece in a
    ld b, a                         ;; store it in b
    ld  de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to video memory start
    call cpct_getScreenPtr_asm      ;; Get Screen Pointer to upper left corner of next piece

    ex de, hl                       ;; store screen addres in de
    ld c,#NEXT_PIECE_MAX_WIDTH
    ld b,#NEXT_PIECE_MAX_HEIGHT
    ld a,#255                        ;; Patern of solid box

    call cpct_drawSolidBox_asm

    ret


;-----------------------------------------------------------------
;;
;; sys_render_draw_piece_small
;;
;;   Draw player1
;;  Input:  b : x position
;;          c : y position
;;          a ; piece
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
sys_render_draw_piece_small::
    ld (_piece), a
    ld a, b
    ld (_piece_x), a                    ;; save x coord
    ld a, c
    ld (_piece_y), a                    ;; save y coord

    ;; Load in iy the sprite to render
    ld a, (_piece)
    call man_entity_get_piece_sprite_small
    push hl
    pop iy

    ld a, (_piece)
    call man_entity_get_hl_from_piece   ;; Get hl form the piece in a
    ld a, (hl)                          ;; read piece width
    ld (_piece_width), a
    inc hl                              ;; skip piece height
    ld a, (hl)                          ;; read piece height
    ld (_piece_height), a
    inc hl

    ld b, a                             ;; Number of rows to loop (piece_height)

_render_dp2_loop_0:
    push bc                         ;; save number of rows in the stack
    push hl                         ;; store the start of the model of the piece in the stack

    ld a, (_piece_height)            ;; Calculate y coord and store in in a
    sub b        
    ld e, a                         ;; player1.y + tile height - ROWS drawn
    ld h, #S_BALLS_SMALL_H + 1 
    call sys_util_h_times_e                  ;; hl has PIECE_SIZE x ROWS drawn
    ld a, (_piece_y)                ;; load the initial y coord of player
    add l                           ;; and add PIECE_SIZE x ROWS
    ld b, a

    ld a, (_piece_x)                ;;
    ld c, a                         ;; Store x position in c

    ;; Get Screen Pointer
    ld  de, #CPCT_VMEM_START_ASM    ;; DE = Pointer to video memory start
    call cpct_getScreenPtr_asm      ;; Get Screen Pointer
    ;; Return value: HL = Screen Pointer to (X, Y) byte

    
    ex de, hl                       ;; store screen address in de

    pop hl                          ;; retrieve piece address
    ld a, (hl)                      ;; load first row (byte) in a
    or a                            ;; check if piece byte is 00
    jr z, _dp2_continue_0            ;; jump to next byte if so

    ld (_piece_byte),a
    ex de, hl                       ;; load in hl the screen to draw
 
    bit 4,a                         ;; first bit
    call nz, sys_render_draw_small_tile
    call sys_render_increment_hl_small    ;; increment hl to next sprite position
    
    ld a, (_piece_byte)
    bit 3,a                         ;; second bit
    call nz, sys_render_draw_small_tile
    call sys_render_increment_hl_small    ;; increment hl to next sprite position    

    ld a, (_piece_byte)
    bit 2,a                         ;; third bit
    call nz, sys_render_draw_small_tile
    call sys_render_increment_hl_small    ;; increment hl to next sprite position    

    ld a, (_piece_byte)
    bit 1,a                         ;; forth bit
    call nz, sys_render_draw_small_tile
    call sys_render_increment_hl_small    ;; increment hl to next sprite position 

    ld a, (_piece_byte)
    bit 0,a                         ;; forth bit
    call nz, sys_render_draw_small_tile
    call sys_render_increment_hl_small    ;; increment hl to next sprite position 

    ex de, hl                       ;; move piece address to hl and screen address to de

_dp2_continue_0:
    inc hl                          ;; and go to th6e next byte of the piece
    pop bc                          ;; retrive number of rows

    dec b
    ld a,b
    or a
    jp nz, _render_dp2_loop_0         ;; can't use djnz because the jump is more than 128 bytes of distance
    
    ret

;;-----------------------------------------------------------------
;;
;; sys_render_next_pieces
;;
;;   Draw player1
;;  Input:  b : x position
;;          c : y position
;;          a ; piece
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
sys_render_next_pieces::
    ld hl, #next_pieces_coords
    ld a, (hl)
    ld b, a
    inc hl
    ld a, (hl)
    ld c, a
    ld a, (next_pieces)
    call sys_render_draw_piece_small

    ld hl, #next_pieces_coords + 2
    ld a, (hl)
    ld b, a
    inc hl
    ld a, (hl)
    ld c, a
    ld a, (next_pieces + 1)
    call sys_render_draw_piece_small
    
    ld hl, #next_pieces_coords + 4
    ld a, (hl)
    ld b, a
    inc hl
    ld a, (hl)
    ld c, a
    ld a, (next_pieces + 2)
    call sys_render_draw_piece_small
    ret

;;-----------------------------------------------------------------
;;
;; sys_render_next_pieces
;;
;;   Draw player1
;;  Input:  b : x position
;;          c : y position
;;          a ; piece
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
sys_render_draw_next_frame::
    ld hl, #next_pieces_coords
    sla a                               ;; duplicate a to calculate offset
    add_hl_a
    ld c, (hl)                          ;; load x coord in c
    dec c
    inc hl                              ;; inc pointer
    ld b, (hl)                          ;; load y coord in b
    dec b
    dec b
    ld de, #CPCT_VMEM_START_ASM         ;; load screen begin
    call cpct_getScreenPtr_asm          ;; get string pointer in hl
    ex de, hl
    ld hl, #_s_next_frame
    ld c, #S_NEXT_FRAME_H
    ld b, #S_NEXT_FRAME_W
    call cpct_drawSpriteBlended_asm
    ret

;-----------------------------------------------------------------
;;
;; sys_render_hi_score
;;
;;   Draw socre
;;  Input: 
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
sys_render_hi_score::
    cpctm_push hl, de, bc, ix
    
    ld de,#hi_score
    cpctm_screenPtr_asm hl, CPCT_VMEM_START_ASM, 9, 23  ;; screen address for 1, 20 in de
    call sys_render_BCD_show

    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 9, 12  ;; screen address for 9, 13 in de
    ld c, #0
    ld hl, #(hi_score + 4)
    call sys_text_draw_string
    
    cpctm_pop ix, bc, de, hl
    ret

;-----------------------------------------------------------------
;;
;; sys_render_score
;;
;;   Draw socre
;;  Input: 
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
sys_render_score::
    ld de,#score
    ;;ld hl, #SCORE_SCREEN_ADDRESS
    cpctm_screenPtr_asm hl, CPCT_VMEM_START_ASM, 49, 23  ;; screen address for 30, 120 in de
    call sys_render_BCD_show
    ret


;-----------------------------------------------------------------
;;
;; sys_render_BCD_show
;;
;;   Draw score
;;  Input:  hl: screen address to render numbers
;;          de: source of BCD
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
;;  Chibi Akumas BCD code (https://www.chibiakumas.com/z80/advanced.php#LessonA1)
;;
sys_render_BCD_show::
    push hl
    ld b, #SCORE_NUM_BYTES
    ld c, #0
    call sys_util_BCD_GetEnd
    pop hl
_BCD_show_direct:
	ld a,(de)
	and #0b11110000		;Use the high nibble
	rrca
	rrca
	rrca
	rrca
	call sys_render_print_score_char
	ld a,(de)	
	dec de
    inc c
	and #0b00001111		;Now the Low nibble
	call sys_render_print_score_char
    inc c	
	djnz _BCD_show_direct	;Next byte
    ret


;;-----------------------------------------------------------------
;;
;; sys_render_print_score_char
;;
;;   Draw socre
;;  Input:  a: number to print
;;          hl: screen address
;;          c: position
;;  Output: 
;;  Destroyed: a
;;
sys_render_print_score_char::
;Some of our commands need to start from the most significant byte
;This will shift HL and DE along b bytes
    push bc
    push de
    push hl

    ;; point hl to number sprite
    ld hl, #_s_score_numbers_00                 ;; load in hl the initial address of the score numbers sprites
    ld b, a                                     ;; store digit to draw in b
    ld a, c                                     ;; load digit positio in a
    ld (_retrive_digit_position+1),a            ;; self modifying code to load digit position without the stack
    ld a, b
    or a
    jr z, _print_score_draw_number              ;; if number to show is 0 offset = 0
    ld de, #(S_SCORE_NUMBERS_W * S_SCORE_NUMBERS_H)
_print_score_char_loop0:
    add hl, de
    djnz _print_score_char_loop0    
    ;; draw number
_print_score_draw_number:                       ;; draw sprite
    pop de                                      ;; retrieve screen addres to draw form stack
    push de                                     ;; restore the stack
_retrive_digit_position:
    ld a, #00                                   ;; load digit position in c (self modifying code)
    ld c, a
    sla a
    add c                                       ;; multiply digit position by 3 wich is the width of the number sprite (hard coded) to get the screen offset
    add_de_a
    ld c, #S_SCORE_NUMBERS_W
    ld b, #S_SCORE_NUMBERS_H
    call cpct_drawSprite_asm

    pop hl
    pop de
    pop bc
	ret


;;-----------------------------------------------------------------
;;
;; sys_render_get_hl_from_cell
;;
;;  return hl pointing to the first byte of the cell row stored in a
;;  Input:  c: col (x)
;;          b: row (y)
;;  Output: hl: point to the address of the first element of the cell
;;  Modified: af, hl, bc
;;
sys_render_get_hl_from_cell::
    ld e, b
    ld h, #S_BALLS_BIG_H+1
    call sys_util_h_times_e
    ld a, #BOARD_Y_COORD                ;; add Y coord of the board to the row 
    add l
    ld (s_r_get_hl_from_cell_y+1), a

    ld e, c
    ld h, #S_BALLS_BIG_W
    call sys_util_h_times_e
    ld a, #BOARD_X_COORD                ;; add X coord of the board to the row 
    add l
    ld (s_r_get_hl_from_cell_x+1), a

s_r_get_hl_from_cell_y:
    ld b, #00                           ;; load sum in b
s_r_get_hl_from_cell_x:
    ld c, #00                           ;; load X coord of the board in c
    ld de, #CPCT_VMEM_START_ASM         ;; load screen begin
    call cpct_getScreenPtr_asm          ;; get string pointer in hl
    ret

;;-----------------------------------------------------------------
;;
;; sys_render_render_row
;;
;;  renders a complete line of the board
;;  Input:  a: row to render
;;          hl: sprite to render
;;  Output: 
;;  Modified: af, hl, bc
;;
sys_render_render_row::
    ld (s_r_render_line_sprite+1), hl   ;; self modifying code to save the sprite pointer
    ld c, #0
    ld b, a
    call sys_render_get_hl_from_cell    ;; obtain the origin address of the board row
    ex de, hl                           ;; keep screen addres in de
    ld b, #0
    push bc
s_r_render_line_loop:
    push de                             ;; save screen address in the stack
s_r_render_line_sprite:
    ld hl, #0000                        ;; load in hl a pointer to the sprite to draw
    ld b, #S_BALLS_BIG_H                ;; Height of the sprite
    ld c, #S_BALLS_BIG_W                ;; Height of the sprite
    call cpct_drawSprite_asm            ;; draw sprite
    pop hl                              ;; retrive screen address from the stack in hl
    ld a, #S_BALLS_BIG_W                ;; add the width of the sprite to inc the pointer
    add_hl_a                            ;;
    ex de, hl                           ;; return screen pointer to de    
    pop bc                              ;; retrieve bc
    inc b                               ;; inc row
    push bc
    ld a, b                             ;; check if is the last row
    cp #BOARD_COLS                      ;;
    jr nz, s_r_render_line_loop         ;;  if not, get back to loop
    pop bc                              ;; retrive bc form stack to reset the stack
    ret

;;-----------------------------------------------------------------
;;
;; sys_render_render_col
;;
;;  renders a complete col of the board
;;  Input:  a: col to erase
;;          hl: sprite to render
;;  Output: 
;;  Modified: af, hl, bc
;;
sys_render_render_col::
    ld (s_r_render_col_sprite+1), hl    ;;self modifying code to save the sprite pointer
    ld c, a
    ld b, #0
s_r_render_col_loop:
    push bc
    call sys_render_get_hl_from_cell    ;; obtain the origin address of the board col

    ex de, hl                           ;; keep screen addres in de to use it drawing the sprite
s_r_render_col_sprite:
    ld hl, #0000                        ;; load in hl a pointer to the sprite to draw
    ld b, #S_BALLS_BIG_H                ;; Height of the sprite
    ld c, #S_BALLS_BIG_W                ;; Height of the sprite
    call cpct_drawSprite_asm            ;; draw sprite
    
    pop bc                              ;; retrieve bc
    inc b                               ;; inc row
    ld a, b
    cp #BOARD_ROWS                      ;;
    jr nz, s_r_render_col_loop          ;;  if not, get back to loop
    
s_r_render_col_y:    
    ret



;;-----------------------------------------------------------------
;;
;; sys_render_nomoremoves_screen
;;
;;  renders the no more moves screen
;;  Input: 
;;  Output: 
;;  Modified: af, hl, bc
;;
sys_render_nomoremoves_screen::

    ;;cpctm_setBorder_asm HW_BLACK

    ld e, #16                           ;; x
    ld d, #60                           ;; y
    ld b, #69                           ;; h
    ld c, #47                           ;; w
    ld hl, #_no_more_moves_string       ;; message
    ld a, #0                            ;; wait for a key
    call sys_messages_show

    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 19, 101     ;; screen address for 1, 20 in de
    ld hl, #_press_any_key_string
    ld c, #0
    call sys_text_draw_string

    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 52, 78     ;; screen address for 1, 20 in de
    ld hl, #_s_witch_0
    ld c, #S_WITCH_W
    ld b, #S_WITCH_H
    call cpct_drawSprite_asm

    call sys_input_wait4anykey

    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 52, 78     ;; screen address for 1, 20 in de
    call sys_render_deadwitch_animation

    ret

;;-----------------------------------------------------------------
;;
;;  sys_render_getNextLine
;;
;;  Shows the the entire fight screen
;;  Input: hl : screen address 
;;  Output: hl : screen address below
;;  Modified: AF, DE, HL
;;
sys_render_getNextLine::
    ld     a, #0x8          ;; [2] / HL = DE = DE + 0x800
    add    h                ;; 
    ld     h, a             ;; [1] | Adding 0x800 makes HL point to the start of the next line
    ;; We check if we have crossed video memory boundaries (which will happen every 8 lines). 
    ;; ... If that happens, bits 13,12 and 11 of destination pointer will be 0
    and   #0x38             ;; [2] leave out only bits 13,12 and 11 from new memory address (00xxx000 00000000)
    jp    nz, srg_exit          ;; [3] If any bit from {13,12,11} is not 0, we are still inside 
                            ;; ... video memory boundaries, so proceed with next line
    ;; Every 8 lines, we cross the 16K video memory boundaries and have to
    ;; reposition destination pointer. That means our next line is 16K-0x50 bytes back
    ;; which is the same as advancing 48K+0x50 = 0xC050 bytes, as memory is 64K 
    ;; and our 16bit pointers cycle over it
    ld    de, #0xC050       ;; [3] We advance destination pointer to next line
    add   hl, de            ;; [3] HL = DE + 0xC050
srg_exit:
    ret


;;-----------------------------------------------------------------
;;
;; sys_render_deadwitch_animation
;;
;;  renders the animation of the dead witch
;;  Input: de : screen addres to render animation
;;  Output: 
;;  Modified: af, hl, bc
;;

HALTS = 60

sys_render_deadwitch_animation::
    push de
    ld hl, #_s_witch_0
    ld c, #S_WITCH_W
    ld b, #S_WITCH_H
    call cpct_drawSprite_asm

    ld b,#HALTS
    call cpct_waitHalts_asm

    pop de
    push de
    ld hl, #_s_witch_1
    ld c, #S_WITCH_W
    ld b, #S_WITCH_H
    call cpct_drawSprite_asm

    ld b,#HALTS
    call cpct_waitHalts_asm

    pop de
    push de
    ld hl, #_s_witch_2
    ld c, #S_WITCH_W
    ld b, #S_WITCH_H
    call cpct_drawSprite_asm

    ld b,#HALTS
    call cpct_waitHalts_asm

    pop de
    push de
    ld c, #S_WITCH_W
    ld b, #S_WITCH_H
    ld a,#255                        ;; Patern of solid box
    call cpct_drawSolidBox_asm

    ld a, #6
_animation_loop:
    ld (_LOOP_INDEX), a
    
    pop hl                              ;; screen address in hl
    ld b, #4                            ;; screen address going down 4 lines
_hat_go_down:
    call sys_render_getNextLine         ;;
    djnz _hat_go_down                   ;;
    ex de, hl
    
    push de
    ld hl, #_s_hat
    ld c, #S_HAT_W
    ld b, #S_HAT_H
    call cpct_drawSprite_asm

    ld b,#HALTS
    call cpct_waitHalts_asm

    pop de
    push de
    ld c, #S_HAT_W
    ld b, #S_HAT_H
    ld a,#255                           ;; Patern of solid box
    call cpct_drawSolidBox_asm

_LOOP_INDEX = . + 1                      ;; loop avoiding using the stack
    ld a, #0000
    dec a 
    jr nz, _animation_loop

    pop de
    ld hl, #_s_hat
    ld c, #S_HAT_W
    ld b, #S_HAT_H
    call cpct_drawSprite_asm

    ld b,#180
    call cpct_waitHalts_asm

    ret

;;-----------------------------------------------------------------
;;
;; sys_render_game_cancelled_screen
;;
;;  renders the no more moves screen
;;  Input: 
;;  Output: 
;;  Modified: af, hl, bc
;;
sys_render_game_cancelled_screen::
    ld e, #24                           ;; x
    ld d, #78                           ;; y
    ld b, #44                           ;; h
    ld c, #34                           ;; w
    ld hl, #_game_cancelled_string      ;; message
    ld a, #1                            ;; wait for a key
    jp sys_messages_show                 ;; call+ret = jp
    ;;ret

;;-----------------------------------------------------------------
;;
;; sys_render_tribute_screen
;;
;;  renders the no more moves screen
;;  Input: 
;;  Output: 
;;  Modified: af, hl, bc
;;
sys_render_tribute_screen::
    cpctm_clearScreen_asm 255
  
    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 6, 55  ;; screen address in de
    ld hl, #_s_cpc
    ld c, #S_CPC_W
    ld b, #S_CPC_H
    call cpct_drawSprite_asm

    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 50, 70     ;; screen address for 1, 20 in de
    ld hl, #_tribute_string00
    ld c, #0
    call sys_text_draw_string

    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 44, 90     ;; screen address for 1, 20 in de
    ld hl, #_tribute_string01
    ld c, #0
    call sys_text_draw_string

    cpctm_screenPtr_asm de, CPCT_VMEM_START_ASM, 45, 110     ;; screen address for 1, 20 in de
    ld hl, #_tribute_string02
    ld c, #0
    call sys_text_draw_string



    call sys_input_wait4anykey

    ret
