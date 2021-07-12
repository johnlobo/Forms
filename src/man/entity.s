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

;;=============================================================================
;;  Entity Manager
;;

.module entity_manager

;; Include all CPCtelera constant definitions, macros and variables
.include "cpctelera.h.s"
.include "cmp/array_structure.h.s"
.include "cmp/entity.h.s"
.include "man/entity.h.s"
.include "man/components.h.s"
;;.include "assets/assets.h.s"


;;=================================================================
;; Manager Memeber Variables
;;=================================================================



;;-----------------------------------------------------------------
;; Entity Components
DefineComponentArrayStructure _entity, max_entities, DefineCmp_Entity_default


;;-----------------------------------------------------------------
;; Piece type Components
piece_type::
    piece_01: .db #0x1F, #0x0,  #0x0,  #0x0, #0x0
    piece_02: .db #0xF, #0x0,  #0x0,  #0x0, #0x0
    piece_03: .db #0x7, #0x0,  #0x0,  #0x0, #0x0
    piece_04: .db #0x1, #0x1,  #0x1,  #0x1, #0x1
    piece_05: .db #0x1, #0x1,  #0x1,  #0x1, #0x1
    piece_06: .db #0xF, #0x1,  #0x1,  #0x1, #0x0
    piece_07: .db #0xF, #0x1,  #0x1,  #0x1, #0x0
    piece_08: .db #0x0, #0x0,  #0x1,  #0x1, #0x1
    piece_09: .db #0x0, #0x0,  #0x1,  #0x1, #0x1
    piece_10: .db #0x7, #0x1,  #0x1,  #0x0, #0x0
    piece_11: .db #0x7, #0x1,  #0x1,  #0x0, #0x0
    piece_12: .db #0x0, #0x0,  #0x0,  #0x1, #0x1
    piece_13: .db #0x0, #0x0,  #0x0,  #0x1, #0x1
    piece_14: .db #0x3, #0x1,  #0x0,  #0x0, #0x0
    piece_15: .db #0x3, #0x1,  #0x0,  #0x0, #0x0
    piece_16: .db #0x0, #0x0,  #0x0,  #0x0, #0x1
    piece_17: .db #0x0, #0x0,  #0x0,  #0x0, #0x1
    piece_18: .db #0x0, #0x7,  #0x7,  #0x7, #0x0
    piece_19: .db #0x0, #0x3,  #0x3,  #0x0, #0x0
    piece_20: .db #0x0, #0x0,  #0x0,  #0x0, #0x0





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNC: man_entity_getArrayHL
;;      Gets a pointer to the array of entities in HL 
;; INPUT:
;; DESTROYS: HL
;; RETURN:
;;      IX: pointer to the entity array
;;      a: number of entities created        
man_entity_getArrayHL::
    ld hl, #_entity_array
    ret
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNC: man_entity_init
;;    
;; INPUT:
;; DESTROYS:
;;    AF, HL
;; RETURN:
;;  HL: pointer to the start of the array
;;
man_entity_init::
    ;; Init other subsidiary managers
    call man_components_init
    ;; Reset all component vector values
    xor a
    ld (_entity_num), a
    
    ld hl, #_entity_array
    ld (_entity_pend), hl
    
    ;; First entity must be marked as no entity as it is the last valid 
    ;; entity of the array
    ex de,hl
    ld hl, #e_w
    add hl, de
    ld (hl), #e_w_invalidEntity
    ex de, hl
    
    ret
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNC: man_entity_new
;;    
;; INPUT:
;;    HL: Pointer to the initilized values of the new entity to be created
;; DESTROYS:
;;    AF, BC, DE, HL
;; RETURN:
;;    DE pointer to the new entity
;;    BC sizeof (Entity t)  
;;
man_entity_new::
    ;; _entity_num++
    ld hl, #_entity_num
    inc (hl)
    ;; Increment array pointer to point to the next free element of the array
    ld hl, (_entity_pend)
    ld d, h
    ld e, l
    ld bc, #sizeof_e
    add hl,bc
    ld (_entity_pend), hl
    
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNC: man_entity_create
;;    
;; INPUT:
;;    HL: Pointer to the initilized values of the new entity to be created
;; DESTROYS:
;;    AF, BC, DE, HL
;; RETURN:
;;    IX pointer to the component created
;;
man_entity_create::
    ;; save hl value
    push hl
    call man_entity_new
    ;; IX = DE
    ld__ixh_d
    ld__ixl_e
    ;;Copy initilization value to new entity
    ;; DE points to the new added entity
    ;; BC holds sizeof(Entity t)
    pop hl
    ;; copy form hl to de, bc bytes (bc is returned by man_entity_new)
    ldir
    
    ;; Check for components to add the entity to
    ld a, e_cmp_type(ix)
    and #e_cmp_AI
    jr z, _noAI
_AI:
    ld a, #e_cmpID_AI
    call man_components_add
_noAI:
    ld a, e_cmp_type(ix)
    and #e_cmp_Physics
    jr z, _noPhys
_Phys:
    ld a, #e_cmpID_Physics
    call man_components_add
_noPhys:
    ld a, e_cmp_type(ix)
    and #e_cmp_Animation
    jr z, _noAnim
_Anim:
    ld a, #e_cmpID_Animation
    call man_components_add
_noAnim:

    
    ret
