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

;; 
;; Funcion de renderizar de una entidad
;;
;; INPUT:
;;      IX: puntero a la entidad a renderizar. Ix permite agregar desplazamientos
;;       

;;sys_render_update_one_entity::
;;
;;    ;;comprobamos si los jugadores estan dentro de la pantalla o no para el render
;;    ld  a, e_type(ix)
;;    and #(e_type_player1|e_type_player2)
;;    ld  a, e_x(ix)
;;    call nz, sys_scroll_check_within
;;    ret c                           ;;si la funcion nos devuelve el flag C es que no se ve en la pantalla
;;
;;    ;;metemos en la llamada de abajo la dir de mem del dibujar de esa entidad
;;    ld  d, e_sprite_h(ix)
;;    ld  e, e_sprite_l(ix)
;;
;;    ld  hl, #call_to_draw
;;    ld  (hl), e
;;    inc hl
;;    ld  (hl), d
;;
;;    ;;Calcular la posicion en la memoria de video
;;    call sys_scroll_screen_start_DE  ;;relativos a la primera pos de pantalla
;;
;;    call sys_scroll_calcule_x   ;;mete en c el valor de x de la entidad en funcion del comienzo de pantalla
;;    ld   b, e_y(ix)             ;;y -> carga en b lo que hay en ix+2
;;    call cpct_getScreenPtr_asm  ;;lo devuelve en hl  
;;
;;
;;call_to_draw = . + 1
;;    call #0x0000                ;;esta llamada se sustituira por la que tenga cada entidad
;;
;;    ret
;;
;;;;
;;;; UPDATE
;;;;  Renders an entity
;;;; Input
;;;;  IX: Entity to be rendered
;;;;
;;sys_render_update::
;;    ;; HL = Pointer to previous render location
;;    ld e, e_lastVP_l(ix)
;;    ld d, e_lastVP_h(ix)
;;    ;; Check previous render location (nullptr = no previous render location)
;;    ld a, e
;;    or d
;;    jr z, _do_not_erase
;;_erase_prev:
;;    ld c, #BIRD_HEIGHT                   ;; Bird heighj
;;    ld b, #BIRD_WIDTH                    ;; Bird width
;;    ld hl, #_g_bird                      ;; Bird sprite
;;    call cpct_drawSpriteBlended_asm
;;_do_not_erase:
;;    ;; Check entity alive before drawing
;;    ld a, e_cmp_type(ix)
;;    and #e_type_dead
;;    ret nz
;;;; Calculate new location
;;    ld de, #0xc000
;;    ld c, e_x(ix)
;;    ld b, e_y(ix)
;;    call cpct_getScreenPtr_asm
;;
;;;;
;;;; TODO Print sprite to video 
;;;;
;;;; Draw pixel
;;    ld a, e_color(ix)
;;    ld (hl), a
;;
;;;; Save new location to previous (for later erasing)
;;    ex de, hl
;;    ld e_lastVP_l(ix), e
;;    ld e_lastVP_h(ix), d
;;    ret
;;
;;
;;    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; 
;;;; Funcion de render de todas las entidades 
;;;;      Utilizamos inversion de control para que sea el manager el que se encargue de solo pasar entidades validas
;;;;  
;;
;;sys_render_update::
;;
;;    ld  de, #sys_render_update_one_entity
;;    ld  hl, #func_update_forall             ;;modificamos la direccion de memoria en la que esta guardada la funcion a la que tiene que hacer call el update forall
;;    ld  (hl), e
;;    inc hl
;;    ld  (hl), d
;;
;;    call man_entity_update_forall          ;;para hacer division de tareas y que manager se encargue de comprobar cada uno
;;    ret