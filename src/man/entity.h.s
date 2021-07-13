;;=============================================================================
;; ENTITY MANAGER
;;



;;=============================================================================
;; ENTITY MANAGER VARIABLES
;;

;;
;; Macro: struct Player
;;    Macro that creates a new initialized instance of Player Struct
;; 
;; Parameters:
;;    instanceName: name of the variable that will be created as an instance of Player struct
;;    st:           status of the player
;;    px:           X location of the Player (bytes)
;;    py:           Y location of the Player (pixels)
;;    wi:           Width of the Player Sprite (bytes)
;;    he:           Height of the Player Sprite (bytes)
;;    sprite:       Pointer to the player sprite
;;
.macro definePlayer instanceName, st, x, y, p_sc, type
   ;; Struct data
   instanceName:
      instanceName'_status:     .db st                      ;; Status of the Player
      instanceName'_x_pos:      .db x                       ;; X location of the Player (bytes)
      instanceName'_y_pos:      .db y                       ;; Y location of the Player (pixels)
      instanceName'_p_screen_p: .dw p_sc                    ;; Previous screen address
      instanceName'_type:       .db type                    ;; Pointer to the player sprite
.endm

;;
;; Macro: struct Player offsets
;;
;;    Macro that generates offsets for accessing different elements of 
;; the Player struct (distances from the start of the struct to each
;; struct member). Requires a already defined instance as an example for
;; calculating offsets.
;;
;; Parameters:
;;    stname:        Name of the structure
;;    instanceName:  Name of the instance that will be used to calculate offsets
;;
.macro definePlayerOffsets stname, instanceName
   ;; Offset constants
   stname'_status_off       = instanceName'_status - instanceName ;; status offset
   stname'_x_off            = instanceName'_x_pos  - instanceName ;; X offset
   stname'_y_off            = instanceName'_y_pos  - instanceName ;; Y offset
   stname'_p_screen_p_off   = instanceName'_p_screen_p  - instanceName ;; Width offset
   stname'_type_off         = instanceName'_type - instanceName ;; Height offset
.endm

;;=============================================================================
;; ENTITY MANAGER CONSTANTS
;;

PIECE_SIZE = 5