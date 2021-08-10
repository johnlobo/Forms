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
.include "sys/util.h.s"
.include "sys/text.h.s"
.include "sys/input.h.s"

.module messages_system

;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA

_window_data::
_window_x: .db #00
_window_y: .db #00
_window_w: .db #00
_window_h: .db #00
_window_message: .dw #0000
_press_any_key_string: .asciz "PRESS ANY KEY"

;; Constants to reach window data
w_x = 0
w_y = 1
w_w = 2
w_h = 3
w_message = 4


;;
;; Start of _CODE area
;; 
.area _CODE


;;-----------------------------------------------------------------
;;
;; sys_messagees_show
;;
;;  shows a message
;;  Input:  de: x and y coord
;;          bc: h and w of the window
;;          hl: message to show 
;;  Output:
;;  Modified: af, hl, de, bc
;;

sys_messagees_show::

    ld iy, #_window_data
    ld w_w(iy), c
    ld w_h(iy), b
    ld w_x(iy), e
    ld w_y(iy), d
    ld w_message(iy), l
    ld w_message+1(iy), h
    

    ;; Draw Back window
    ld de, #CPCT_VMEM_START_ASM     ;; DE = Pointer to start of the screen
    ld b, w_y(iy)                  ;; B = y coordinate 
    ld c, w_x(iy)                  ;; C = x coordinate 
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL
    ex de, hl                       ;; move screen address to de
    ld c, w_w(iy)
    ld b, w_h(iy)
    ld a,#0                         ;; Patern of solid box
    call cpct_drawSolidBox_asm

    ;; Draw Front Window
    ld de, #CPCT_VMEM_START_ASM     ;; 
    ld c, w_x(iy)                   ;;
    inc c                           ;; C = y coordinate + 1
    ld b, w_y(iy)                   ;;
    inc b                           ;; B = y coordinate + 2
    inc b                           ;;
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL
    ex de, hl                       ;; move screen address to de
    
    ld c, w_w(iy)                   ;;
    dec c                           ;; C = w - 2
    dec c                           ;;   
    
    ld b, w_h(iy)                   ;;
    dec b                           ;; B = h - 4
    dec b                           ;;
    dec b                           ;;
    dec b                           ;;
    
    ld a,#0xff                      ;; Patern of solid box
    call cpct_drawSolidBox_asm

    ;; Draw message
    ld de, #CPCT_VMEM_START_ASM     ;; 
    ld c, w_x(iy)                   ;;
    inc c                           ;; 
    inc c                           ;; C = y + 1
    inc c                           ;; 
    
    ld b, w_y(iy)                   ;;
    ld a, #10                       ;; B = y + 10
    add b                           ;;
    ld b, a                         ;;
    
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL
    ex de, hl                       ;; move screen address to de
    ld c, #0
    ld h, w_message+1(iy)
    ld l, w_message(iy)
    call sys_text_draw_string

    ;; Draw Press Any Key
    ld de, #CPCT_VMEM_START_ASM     ;; 
    
    ld a, w_w(iy)                   ;;
    ld c, #26                       ;;
    sub c                           ;;
    sra a                           ;; c = x + ((w- length(str))/2)
    ld c, w_x(iy)                   ;;
    add c                           ;;
    ld c, a                         ;;

    ld b, w_y(iy)                   ;;
    ld a, #26                       ;; B = y + 10
    add b                           ;;
    ld b, a                         ;;
    
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL
    ex de, hl                       ;; move screen address to de
    ld c, #0
    ld hl, #_press_any_key_string
    call sys_text_draw_string

    call sys_input_wait4anykey

    ret