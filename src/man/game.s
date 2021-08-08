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
.include "sys/util.h.s"
.include "sys/board.h.s"
.include "sys/render.h.s"
.include "sys/input.h.s"


.module game_manager

;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA

next_pieces:: .db #00, #00, #00
next_pieces_count:: .db #00
next_pieces_coords:: .db #46, #150, #59, #150, #70, #150
selected_piece:: .db #00
score:: .db #0x00, #0x00, #0x00, #0x00
hi_score:: .db #0x01, #0x23, #0x45, #0x00
score_buffer:: .db #0x00, #0x00, #0x00, #0x00
line_to_render:: .db #00
no_more_moves:: .db #00


;;
;; Start of _CODE area
;; 
.area _CODE


;;-----------------------------------------------------------------
;;
;; get_random_piece
;;
;;   gets a random number between 0 and 18
;;  Input: 
;;  Output: a random piece
;;  Modified: AF, BC, DE, HL
;;
man_game_get_random_piece::
    call cpct_getRandom_xsp40_u8_asm
    ld a, l
    srl a
    srl a
    srl a
    cp #19
    jr c, _get_random_piece_continue
    sub #18
_get_random_piece_continue:
    ret

;;-----------------------------------------------------------------
;;
;; man_game_renew_next_pieces
;;
;;   Renews the set of next pieces
;;  Input: 
;;  Output:
;;  Modified:
;;
man_game_renew_next_pieces::
    ;; Generate radom pieces
    call man_game_get_random_piece
    ld (next_pieces), a
    call man_game_get_random_piece
    ld (next_pieces+1), a
    call man_game_get_random_piece
    ld (next_pieces+2), a
    ;; initial number of pieces
    ld a, #3
    ld (next_pieces_count), a
    
    ;; set player1 initial piece to next_piece
    ld ix, #player1
    ld a, (next_pieces)
    ld e_type(ix), a  
    
    ;; get big sprite form the type of piece  
    call man_entity_get_piece_sprite_player
    ld e_sprite_player_ptr(ix), l
    ld e_sprite_player_ptr+1(ix), h

    ;; get big sprite form the type of piece  
    ld a, e_type(ix)
    call man_entity_get_piece_sprite_big
    ld e_sprite_big_ptr(ix), l
    ld e_sprite_big_ptr+1(ix), h


    ld a, e_type(ix)
    ;; get width and height from initial piece
    call man_entity_get_hl_from_piece
    ld a,(hl)
    ld e_w(ix), a
    inc hl
    ld a,(hl)
    ld e_h(ix), a

    call sys_render_next_pieces     ;; Render next pieces on screen

    ret

;;-----------------------------------------------------------------
;; man_game_clean_number
;;
;;  Initializes number
;;  Input: hl number to be initialzed
;;  Output:
;;  Modified: af, hl
;;
man_game_clean_number::
    xor a
    ld (hl), a
    inc hl
    ld (hl), a
    inc hl
    ld (hl), a
    inc hl
    ld (hl), a
    ret


;;-----------------------------------------------------------------
;;
;; man_game_init
;;
;;   Initializes game
;;  Input: 
;;  Output:
;;  Modified:
;;
man_game_init::

    call sys_board_init

    call man_entity_init
    
    call man_game_renew_next_pieces

    call sys_render_game_screen

    ld hl, #hi_score
    call man_game_clean_number
    call sys_render_hi_score
    
    ld hl, #score
    call man_game_clean_number
    call sys_render_score

    call sys_render_next_pieces     ;; Render next pieces on screen

    call sys_render_draw_player1

    ret

;;-----------------------------------------------------------------
;;
;; man_game_erase_current_next_piece
;;
;;   set piece in board
;;  Input: 
;;  Output:
;;  Modified:
;;
man_game_erase_current_next_piece::
    ld ix, #player1                     ;; load player struct in ix

    ld a, (selected_piece)              ;; get selectedpiece 
    ld hl, #next_pieces
    add_hl_a
    ld (hl), #0xff
    ld hl, #next_pieces_count 
    dec (hl)
    ld a, (selected_piece)              ;; get selectedpiece 
    call sys_render_erase_next_piece

    ret

;;-----------------------------------------------------------------
;;
;; man_game_erase_row
;;
;;  Erase a complete line of the board
;;  Input:  a: line to erase
;;  Output:
;;  Modified:
;;
man_game_erase_row::
    ld (line_to_render),a
    call sys_board_erase_row
    ;; first frame of animation
    ld a, (line_to_render)
    ld hl, #_s_sprites_2
    call sys_render_render_row
    ld b, #36
    call cpct_waitHalts_asm
    ;; second frame of animation
    ld a, (line_to_render)
    ld hl, #_s_sprites_3
    call sys_render_render_row
    ld b, #36
    call cpct_waitHalts_asm
    ;; first frame of animation
    ld a, (line_to_render)
    ld hl, #_s_sprites_4
    call sys_render_render_row
    ld b, #36
    call cpct_waitHalts_asm
    ;; first frame of animation
    ld a, (line_to_render)
    ld hl, #_s_sprites_0
    call sys_render_render_row
    ret

;;-----------------------------------------------------------------
;;
;; man_game_erase_col
;;
;;  Erase a complete col of the board
;;  Input:  a: col to erase
;;  Output:
;;  Modified:
;;
man_game_erase_col::
    ld (line_to_render),a
    call sys_board_erase_col
    ;; first frame of animation
    ld a, (line_to_render)
    ld hl, #_s_sprites_2
    call sys_render_render_col
    ld b, #36
    call cpct_waitHalts_asm
    ;; second frame of animation
    ld a, (line_to_render)
    ld hl, #_s_sprites_3
    call sys_render_render_col
    ld b, #36
    call cpct_waitHalts_asm
    ;; first frame of animation
    ld a, (line_to_render)
    ld hl, #_s_sprites_4
    call sys_render_render_col
    ld b, #36
    call cpct_waitHalts_asm
    ;; first frame of animation
    ld a, (line_to_render)
    ld hl, #_s_sprites_0
    call sys_render_render_col
    ret

;;-----------------------------------------------------------------
;;
;; man_game_add_score_4piece
;;
;;  set piece in board
;;  Input: 
;;  Output:
;;  Modified:
;;
man_game_add_score_4piece::
    ;; Add score
    ld hl, #piece_scoring                       ;; set hl to point the list of scoring                       
    ld a, e_type(ix)                            ;; read type in a to set offset
    add_hl_a                                    ;; add ofset to pointer
    ld a, (hl)                                  ;; read score to add in a
    ld hl, #score_buffer
    ld (hl),a                                   ;; store the score in score buffer
    ld hl, #score_buffer
    ld de, #score                               ;; point de to the current score
    ld b, #SCORE_NUM_BYTES                      ;; store in b the number of bytes of the numbers add 
    call sys_util_BCD_Add
    call sys_render_score
    ret

;;-----------------------------------------------------------------
;;
;; man_game_set_piece
;;
;;   set piece in board
;;  Input: 
;;  Output:
;;  Modified:
;;
man_game_set_piece::
    ld ix, #player1                             ;; load player struct in ix

    ;; check if piece can be set in that place
    ld c, e_x(ix)
    ld b, e_y(ix)
    ld a, e_type(ix)
    call sys_board_valid_place
    or a
    jp z, m_g_set_piece_not_valid               ;; if not valid ret

    call sys_render_erase_player                ;; erase current piece

    ld c, e_x(ix)                               ;; load x coord in c
    ld b, e_y(ix)                               ;; load y coord in b
    ld a, e_type(ix)                            ;; load piece in a
    call sys_board_set_piece                    ;; set piece in board

    call man_game_add_score_4piece              ;; add the score corresponfing to the piece set

m_g_set_piece_check_rows:                       ;; Check if the set piece has filled a line
    ld b, e_y(ix)                               ;; load in b the initial line to check if it's complete
    ld a, b                                     ;;
    add e_h(ix)                                 ;;
    ld c, a                                     ;; load in c the final line to check
    call sys_board_check_partial_rows           ;; check if the piece set has completed any line
    cp #0xff                                    ;; check if all the lines are incomplete
    jr z, m_g_set_piece_check_cols              ;;
    call man_game_erase_row                     ;; if one is complete erase line in a
    jr m_g_set_piece_check_rows                 ;; get back to check again

m_g_set_piece_check_cols:                       ;; Check if the set piece has filled a col
    ld b, e_x(ix)                               ;; load in b the initial line to check if it's complete
    ld a, b                                     ;;
    add e_w(ix)                                 ;;
    ld c, a                                     ;; load in c the final line to check
    call sys_board_check_partial_cols           ;; check if the piece set has completed any line
    cp #0xff                                    ;; check if all the lines are incomplete
    jr z, m_g_set_piece_all_clear               ;;
    call man_game_erase_col                     ;; if one is complete erase line in a
    jr m_g_set_piece_check_cols                 ;; get back to check again
m_g_set_piece_all_clear:

    call man_game_erase_current_next_piece      ;; Erase current next piece from screen

    ld a, (next_pieces_count)                   ;; Check if there are next pieces available
    or a        
    call z, man_game_renew_next_pieces          ;; If not renew the pieces

_change_piece:
    ld a, (selected_piece)              ;; read selected piece
    inc a                               ;; increment piece type
    cp #3       
    jr nz, _valid_piece     
    xor a       
_valid_piece:       
    ld (selected_piece), a              ;; Update selected piece 
    ld hl, #next_pieces
    add_hl_a
    ld a, (hl)
    cp #0xff
    jr z, _change_piece
    ;; New piece ok    

    ld e_type(ix), a                    ;; Update piece in Player1 struct
    call man_entity_get_hl_from_piece   ;; get address of the new piece
    ld a,(hl)                           ;; get piece width
    ld e_w(ix),a
    
    inc hl

    ld a,(hl)                           ;; get piece height
    ld e_h(ix),a

    ld e_x(ix), #3      
    ld e_y(ix), #3

    ld e_set(ix), #0
    
    ld e_p_screen_p(ix), #0             ;; erase previous pointer so that update capture
    ld e_p_screen_p+1(ix), #0           ;; the background

    ;; Get the sprite pointer to render the piece
    ld a, e_type(ix)
    call man_entity_get_piece_sprite_player
    ld e_sprite_player_ptr(ix), l
    ld e_sprite_player_ptr+1(ix), h

    ;; Get the sprite pointer to render the piece
    ld a, e_type(ix)
    call man_entity_get_piece_sprite_big
    ld e_sprite_big_ptr(ix), l
    ld e_sprite_big_ptr+1(ix), h

    ;; Check if are there more movements
    ld b,#3
    ld hl, #next_pieces
m_g_set_piece_check_next_pieces_loop:
    push hl
    push bc
    ld a, (hl)                                      ;; read next next_piece
    cp #0xff                                        ;; is it a valid piece??
    jr z, m_g_set_piece_next_space_check            ;; if not valid check next
    call sys_board_any_space                        ;; if valid check if there is any space for it
    or a
    jr nz, m_g_set_piece_return                     ;; if there is space just ret
m_g_set_piece_next_space_check:
    pop bc                                          ;; retrieve index
    pop hl                                          ;; retrieve pointer to current next_piece
    inc hl                                          ;; advance to next next_piece
    djnz m_g_set_piece_check_next_pieces_loop

    ld a, #1                                        ;; if loop finish -> no more moves
    ld (no_more_moves), a                           ;; set no more moves and return
    jr m_g_set_piece_not_valid                      ;; jump and return

m_g_set_piece_return:
    pop bc
    pop hl

m_g_set_piece_not_valid:
    ld e_set(ix), #0
    ret



;;-----------------------------------------------------------------
;;
;; man_game_update
;;
;;   Main loop of the game
;;  Input: 
;;  Output:
;;  Modified:
;;
man_game_update::
    ld ix, #player1                 ;; load player1 struct in ix
    
    ld b, #6
    call cpct_waitHalts_asm

    call sys_input_update           ;; call input system update
    
    ld a, e_set(ix)                 ;; check if piece has been set
    or a                            ;;
    call nz, man_game_set_piece     ;; if so manage set piece

    call sys_render_update
    ret