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

.include "sys/audio.h.s"

;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA

music_switch::  .db #00

;;-----------------------------------------------------------------
;;
;; sys_audio_init
;;   Draw player1
;;  Input:  
;;  Output: 
;;  Destroyed: af, bc,de, hl
;;
sys_audio_init::

    ld a, #ORINOCO_SONG
    call sys_audio_init_song

    call sys_audio_init_soundEffects

    ld a, #1                            ;; switch on music
    ld (music_switch), a                ;;

    ret

;;-----------------------------------------------------------------
;;
;; sys_audio_init_song
;;
;;  Initilizes a song
;;  Input: a song to play
;;  Output: 
;;  Modified: af
;;
sys_audio_init_song::
    push bc
    push hl
    push de
    ld hl,#ORINOCO_START    ;The music.
    ;;ld a, #7     ;The Subsong to play (&gt;=0).
    call PLY_AKG_INIT
    pop de
    pop hl
    pop bc
    ret

;;-----------------------------------------------------------------
;;
;; sys_audio_init_sooundEffects
;;
;;  Initilizes th esound effects
;;  Input: 
;;  Output: 
;;  Modified: af
;;
sys_audio_init_soundEffects::
    push bc
    push hl
    push de
    ld hl,#FX_SOUNDEFFECTS    ;Address of the sound effects.
    call PLY_AKG_INITSOUNDEFFECTS
    pop de
    pop hl
    pop bc
    ret


;;-----------------------------------------------------------------
;;
;; sys_audio_play_sooundEffect
;;
;;  Plays a sound effect
;;  Input: a sound to play
;;  Output: 
;;  Modified: af
;;
sys_audio_play_soundEffect::
    push bc
    push hl
    push de
    ;;ld a,#SOUND_LINE  ;Sound effect number (&gt;=1)
    ld c,#2  ;channel (0-2)
    ld b,#0  ;Inverted volume (0-16)
    call PLY_AKG_PLAYSOUNDEFFECT
    pop de
    pop hl
    pop bc
    ret


;;-----------------------------------------------------------------
;;
;; sys_audio_stop_music
;;
;;  Plays a sound effect
;;  Input: a sound to play
;;  Output: 
;;  Modified: af
;;
sys_audio_stop_music::
    push bc
    push hl
    push de
    xor a                               ;; switch off music
    ld (music_switch), a                ;;
    call PLY_AKG_STOP
    pop de
    pop hl
    pop bc
    ret

