;; ENTITY COMPONENT
;;  1B component type (cmp_type)
;;  2B Position (x, y)
;;  2B Velocity (vx, vy)
;;  2B Size (sx, sy)
;;  2B Sprite Pointer (pspr)
;;  2B Last Video Pointer (lastVP)
;;  2B AI-AIM Target (ai_aim_x, ai_aim_y)
;;  1B AI-Status    (ai_st)
;;  1B AI-Previous-Status (ai_pre_st)
;;  2B AI_Next-Patrol-Step (ai_patrol_setp) Pointer

;; Easily assign offsets to Entity t members without error
__off = 0
.macro DefOffset _size, _name
    _name = __off           ;; Define name constant on current offset
    __off = __off + _size   ;; Add sizeiof (_name)  size to offset
.endm

;; Easily define an enumeration statrting at 0
;;  It adds sizes of types to an offset constant 
.macro DefEnum _name
    _name'_offset = 0
.endm

;; Define enumeration element for an enumeration name
.macro Enum _enumname, _element
    _enumname'_'_element = _enumname'_offset
    _enumname'_offset = _enumname'_offset + 1
.endm
 
;; Default constructor for Entity t
  .macro DefineCmp_Entity_default
    DefineCmp_Entity  0,0,0,0, e_w_invalidEntity, 1, e_cmp_default, nullptr, nullptr, 1
  .endm
  
;; Defines an array of N entities with default values
  .macro DefineCmpArray_Entity _N
    .rept _N
        DefineCmp_Entity_default
    .endm
  .endm
  
;;Defines a new entity structure
;; All entity data together to simplify acess, at the cost
.macro DefineCmp_Entity _x, _y, _vx, _vy, _w, _h, _cmp_type, _pspr, _animptr, _aist
    .narg __argn
    .if __argn - 10
        .error 1
    .else
        ;; Type of component
        .db _cmp_type   ;; Types of components that the entity has
        ;; CMP Position
        .db _x, _y      ;; position
        ;; CMP Velocity
        .db _vx, _vy    ;; velocity
        ;; CMP Animation
        .dw _animptr
        ;; CMP Render
        .db _w, _h      ;; size
        .dw _pspr       ;; Sprite
        .dw 0xcccc      ;; current video memory pointer
        .dw 0xcccc      ;; last video memory pointer
        ;; CMP AI
        .db 0x00, 0x00  ;; AI-aim (ai aim x, ai aim y)
        .db _aist        ;; AI-status (ai st)
        .db _aist        ;; AI-previous-status (ai pre st)
        .dw nullptr     ;; Next AI Patrol step (ai patrol step)
        .db 1           ;; Moved flag
        .db 0x00
     .endif
.endm

;;
;; Entity offsets
;;
DefOffset 1, e_cmp_type
;; CMP Position
DefOffset 1, e_x
DefOffset 1, e_y
;; CMP Velocity
DefOffset 1, e_vx
DefOffset 1, e_vy
;; Animation
DefOffset 1, e_anim_ptr_l
DefOffset 1, e_anim_ptr_h
;; CMP Render
DefOffset 1, e_w
DefOffset 1, e_h
DefOffset 1, e_pspr_l
DefOffset 1, e_pspr_h
DefOffset 1, e_currVP_l
DefOffset 1, e_currVP_h
DefOffset 1, e_lastVP_l
DefOffset 1, e_lastVP_h
;; CMP AI 
DefOffset 1, e_ai_aim_x
DefOffset 1, e_ai_aim_y
DefOffset 1, e_ai_st
DefOffset 1, e_ai_pre_st
DefOffset 1, e_ai_patrol_step_l
DefOffset 1, e_ai_patrol_step_h
DefOffset 1, e_moved
DefOffset 1, e_damage
;; Size of entity
DefOffset 0, sizeof_e

;;=============================================================================
;; Entity status enum
;;
DefEnum e_ai_st
Enum e_ai_st, noAI
Enum e_ai_st, stand_by
Enum e_ai_st, move_to
Enum e_ai_st, patrol

;;=============================================================================
;; Entity component types
;;
e_cmp_AI = 0x01
e_cmp_Physics = 0x02
e_cmp_Animation = 0x04
e_cmp_Render = 0x08
e_cmp_default = e_cmp_Render | e_cmp_Physics

;;=============================================================================
;; Entity component IDs
;;
DefEnum e_cmpID
Enum e_cmpID, AI
Enum e_cmpID, Physics
Enum e_cmpID, Animation
Enum e_cmpID, Num_Components

;;=============================================================================
;; Entity Status enum
;;
e_w_invalidEntity = 0xff  ;;Entity width -1 means invalid entity

;;=============================================================================
;; Utility Definitions
;;
nullptr = 0x000
        

    