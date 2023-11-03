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
.include "sys/audio.h.s"
.include "common.h.s"

.module system_system


;;
;; Start of _CODE area
;; 
.area _CODE

;;-----------------------------------------------------------------
;;
;; sys_system_activate_firmware
;;
;;    Activates the firmware   
;;    Input: 
;;    Output:
;;    Modified: af, hl, de, bc
;;
sys_system_activate_firmware::        
    DI   
    EXX                 ; On preserve les registre normaux
    LD BC,#0x7F88       ;connexion sur ROM inferieure
    OUT (C),C
    EXX
    XOR A               ; utile ?
    EX AF,AF' 
    CALL #0x0044        ; Restore 'High Kernel jump' 
                        ; Init zones ram &0 a &3f, &B900 a &BAE4
    CALL #0x08BD        ; Restore 'Main Jump adress'
                        ; Init zone ram &BB00 a ?
    ;;CALL #0x1B5C      ; Init gestion clavier
    ;;CALL #0x1074      ; Init du 'pack' texte
    EXX  
    LD BC,#0x7F8C       ; On deconnecte la rom inferieure
    OUT (C),C           ; et on se met accessoirement en mode 0
    EXX
    EI                  ; hop, on n'oublie pas de remettre les interruptions
    LD HL,#0xABFF       ; Init classique du systeme disque
    LD DE,#0x0040       ; via le vecteur Amsdos regenere !
    LD C,#0x07
    CALL #0xBCCE
    ret

;;-----------------------------------------------------------------
;;
;; sys_system_deactivate_firmware
;;
;;    Deactivates the firmware   
;;    Input: 
;;    Output:
;;    Modified: af, hl, de, bc
;;
sys_system_deactivate_firmware::
   call cpct_disableFirmware_asm
   ld hl, #sys_system_int_handler1
   call cpct_waitVSYNC_asm
   halt
   halt
   call cpct_waitVSYNC_asm
   call cpct_setInterruptHandler_asm
   ret


;;-----------------------------------------------------------------
;;
;; sys_system_int_handler1
;;
;;       
;;    Input: 
;;    Output:
;;    Modified: af, hl, de, bc
;;
sys_system_int_handler1:
	ld hl, #sys_system_int_handler2
 	call cpct_setInterruptHandler_asm	
	ret

;;-----------------------------------------------------------------
;;
;; sys_system_int_handler2
;;
;;       
;;    Input: 
;;    Output:
;;    Modified: af, hl, de, bc
;;
sys_system_int_handler2:
	call cpct_scanKeyboard_if_asm


	ld hl, #sys_system_int_handler3
   call cpct_setInterruptHandler_asm
	ret

;;-----------------------------------------------------------------
;;
;; sys_system_int_handler3
;;
;;       
;;    Input: 
;;    Output:
;;    Modified: af, hl, de, bc
;;
sys_system_int_handler3:
	ld hl, #sys_system_int_handler4
   call cpct_setInterruptHandler_asm
	ret

;;-----------------------------------------------------------------
;;
;; sys_system_int_handler4
;;
;;       
;;    Input: 
;;    Output:
;;    Modified: af, hl, de, bc
;;
sys_system_int_handler4:
	ld hl, #sys_system_int_handler5
   call cpct_setInterruptHandler_asm
	ret

;;-----------------------------------------------------------------
;;
;; sys_system_int_handler5
;;
;;       
;;    Input: 
;;    Output:
;;    Modified: af, hl, de, bc
;;
sys_system_int_handler5:
   ld a, (music_switch)
   or a
   jr z, sys_system_int_handler5_exit
   exx
   ex af', af  
   push af
   push bc
   push de
   push hl
   call PLY_AKG_PLAY
   pop hl
   pop de
   pop bc
   pop af
   ex af', af  
   exx
sys_system_int_handler5_exit:
	ld hl, #sys_system_int_handler6
   call cpct_setInterruptHandler_asm
	ret

;;-----------------------------------------------------------------
;;
;; sys_system_int_handler6
;;
;;       
;;    Input: 
;;    Output:
;;    Modified: af, hl, de, bc
;;
sys_system_int_handler6:
	ld hl, #sys_system_int_handler1
   call cpct_setInterruptHandler_asm
	ret