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
