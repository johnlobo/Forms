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


;;------------------------------------------------------------------------------
;; Global constants
;;------------------------------------------------------------------------------

;;FX
SOUND_VIRUS = 4
SOUND_LINE = 9
SOUND_HIT = 14
SOUND_TURN = 15
SOUND_HIHAT = 16

;; SONGS
ORINOCO_SONG = 0
LOSE_SONG = 1
WIN_SONG = 2
SILENCE_SONG = 3

;;------------------------------------------------------------------------------
;; Global variables
;;------------------------------------------------------------------------------
.globl ORINOCO_START
.globl FX_SOUNDEFFECTS
.globl music_switch

;;------------------------------------------------------------------------------
;; Global routines
;;------------------------------------------------------------------------------
.globl PLY_AKG_INIT
.globl PLY_AKG_PLAY
.globl PLY_AKG_STOP
.globl PLY_AKG_INITSOUNDEFFECTS
.globl PLY_AKG_PLAYSOUNDEFFECT

.globl sys_audio_init
.globl sys_audio_play_soundEffect
.globl sys_audio_init_song
.globl sys_audio_init_soundEffects
.globl sys_audio_stop_music