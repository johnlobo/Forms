;;=============================================================================
;; COMPONENT ENTITY POINTER MANAGER
;;=============================================================================

.module component_entity_ptr_manager

.include "cpctelera.h.s"
.include "cpct_functions.h.s"
.include "cmp/entity.h.s"
.include "cmp/array_structure.h.s"
.include "man/entity.h.s"

;;=============================================================================
;; Manager Member Variables
;;=============================================================================

DefineComponentPointersTable _entities,  e_cmpID_Num_Components, max_entities
_components_size = . - _entities_components

;;=============================================================================
;; Manager Public Functions
;;=============================================================================

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNC: man_components_getComponentPtrHL
;;     Loads HL with the address of the component strructure of pointers (including pend) 
;; INPUT:
;;      A: Camponent ID        
;; DESTROYS: AF
;; RETURNS:
;;      HL Pointer to the start of the pointers array
;;      a: number of entities created        
man_components_getComponentPtrHL::
    ld hl, #_entities_access_table
    add a                           ;; Each pointer in the access table takes 2 bytes
    add_hl_a

    ;; Get pointer to the component structure in HL
    ld a, (hl)
    inc hl
    ld h, (hl)
    ld l, a

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNC: man_components_getArrayHL
;;      Gets a pointer to the array of entities in HL 
;; INPUT:
;; DESTROYS: HL
;; RETURN:
;;      IX: pointer to the entity array
;;      a: number of entities created        
man_components_getArrayHL::
    call man_components_getComponentPtrHL
    inc hl
    inc hl
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNC: man_components_init
;;    
;; INPUT:
;; DESTROYS:
;;    AF, BC, DE, HL
;; RETURN:
;;  HL: pointer to the start of the array
;;
man_components_init::
    ;;Set all values of the pointer array to nullptr
    ;; filling in the array with zeroes
    ld hl, #_entities_components
    ld de, #_entities_components+1
    ld (hl), #0
    ld bc, #_components_size-1
    ldir

    ;; set values for all Pend pointer in all pointer vectors
    ld b, #e_cmpID_Num_Components
_init_next_pend:
    ;; Get in HL a pointer to the next component
    ld a, b
    dec a
    call man_components_getComponentPtrHL
    ;; sets pend(HL location) with array address (HL + 2)
    ld e, l
    ld d, h
    inc de
    inc de
    ld (hl), e
    inc hl
    ld (hl), d
    djnz _init_next_pend

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNC: man_components_init
;;    
;; INPUT:
;; DESTROYS:
;;    AF, BC, DE, HL
;; RETURN:
;;  HL: pointer to the start of the array
;;
man_components_add::
    ret

