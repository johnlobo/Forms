.module system_fdc

;;----------------------------------------------------
;;	fdc low level routines by fano
;;
;;	https://www.cpcwiki.eu/forum/programming/what-is-the-lowest-memory-method-of-reading-from-disk/
;;
;;----------------------------------------------------


;**************************
;*** LOW LEVEL FDC CODE ***
;**************************

;** fonctions list **
;FDC_GetVersion
;FDC_GetDriveStatus
;FDC_read 					(HL,DE,BC)
;FDC_CheckErrors
;FDC_GetIdd
;FDC_track					(A)
;FDC_Track0    
;FDC_MotorOn 
;FDC_MotorOff
;FDC_RetryTrack
;FDC_DriveWaitReady

;globals
default_gap3 = 	51
motor_wait	 = 	75	;1.5 seconds
;FDC ports
FDC_Port_State	= 0xFB7E
FDC_Port_Data	= 0xFB7F
FDC_Port_Motor	= 0xFA7E
;commands used (no multitrack)
cmd_read_track	 =  0b01000010
cmd_read_sector	 =  0b01000110
cmd_write_sector = 	0b01000101
cmd_goto_track	 = 	0b00001111
cmd_goto_track0	 = 	0b00000111
cmd_int_state	 = 	0b00001000
cmd_drive_state	 = 	0b00000100
cmd_version		 = 	0b00010000

;************************
;*** WAIT DRIVE READY ***
;************************
FDC_DriveWaitReady::
	call FDC_GetDriveStatus
	bit 5, a						;test ready state
	jr z,FDC_DriveWaitReady
	
	ret

;***********************
;*** RETRY HEAD MOVE ***
;***********************
; move head to track 0 and return to current track
FDC_RetryTrack::
	ld A,(current_track)
	push AF
	call FDC_Track0 
	
	ld E, #25
	call DSK_wait	
	
	pop AF
	call FDC_track
	
	ld E, #25
	call DSK_wait
	ret

;***********************
;*** GET FDC VERSION ***
;***********************
;return version in A
FDC_GetVersion::
	ld A, #cmd_version
	call FDC_send		;command
	call FDC_get		;version in A
	ret

;************************
;*** GET DRIVE STATUS ***
;************************
;return ST3 in A
FDC_GetDriveStatus::
	ld A, #cmd_drive_state
	call FDC_send			;command
	
	call FDC_GetIdd
	call FDC_send 			;IDD
	
	call FDC_get			;get ST3
	ld (st3),A
	ret
	
;***********************
;*** WRITE SECTOR(S) ***
;***********************
; HL = address with data to write
; DE = data count (bytes)
; B = first sector C = last


FDC_write::
	ld (data_addr),HL	;save all params
	ld (data_size),DE
	ld (data_sectors),BC

;*** send command ***

	ld A,#cmd_write_sector
	call FDC_send			;command
	
	call FDC_GetIdd
	call FDC_send 			;IDD
	
	ld   A,(current_track)
	call FDC_send 			;track

	ld A,(current_head)
	call FDC_send 			;head , must match with sector header !
	
	ld A,(data_sector_first)
	call FDC_send 			;first sector to write to
	
	ld A,#2	
	call FDC_send 			;sector size (512bytes)
	
	ld A,(data_sector_last)
	call FDC_send			;last sector to write
	
	ld   A,(gap3)
	call FDC_send 			;GAP3
	
	ld   A,#0xFF
	call FDC_send 			;ignore , just send #FF (NEC Doc)

;read data
	ld BC,#FDC_Port_State	;set on state port
	ld HL,(data_addr)
	ld DE,(data_size)

;first loop to read data and writte it
FDC_write_loop1:
	in   A,(C)  			;get state    
	jp   P,FDC_write_loop1	;are we ready ?

	and  #0b00100000  		;is instruction finished ?	
	jr   Z,FDC_write_done

;write byte
	inc  C					;data port
	ld A,(HL)
	out   (C),A				;send byte
	inc  HL
	dec  C					;state port
	
;check if we wrote all our datas
	dec de
	ld a,e
	or d

	jr nz,FDC_write_loop1	;if no continue

;does we finish to write our datas ?
FDC_write_loop2:
	in   A,(C)                
	jp   P,FDC_write_loop2
	and  #0b00100000  
	jr   Z,FDC_write_done	;yes ? so exit !

	inc  C					;data port
	;remaining write 0
	xor A
	out   (C),A
	dec  C					;state port
	jr FDC_write_loop2		;else continue to read data but do not write

FDC_write_done:

	call FDC_getresult		;get results
	jp FDC_CheckErrors		;and check for error

;**********************
;*** READ SECTOR(S) ***
;**********************
; HL = address to write data
; DE = data count (bytes)
; B = first sector C = last


FDC_read::
	ld (data_addr),HL	;save all params
	ld (data_size),DE
	ld (data_sectors),BC

;*** send command ***

	ld A, #cmd_read_sector
	call FDC_send			;command
	
	call FDC_GetIdd
	call FDC_send 			;IDD
	
	ld   A,(current_track)
	call FDC_send 			;track

	ld A,(current_head)
	call FDC_send 			;head , must match with sector header !
	
	ld A,(data_sector_first)
	call FDC_send 			;first sector to read
	
	ld A,#2	
	call FDC_send 			;sector size (512bytes)
	
	ld A,(data_sector_last)
	call FDC_send			;last sector to read
	
	ld   A,(gap3)
	call FDC_send 			;GAP3
	
	ld   A,#0xFF
	call FDC_send 			;ignore , just send #FF (NEC Doc)

;read data
	ld BC,#FDC_Port_State	;set on state port
	ld HL,(data_addr)
	ld DE,(data_size)

;first loop to read data and writte it
FDC_read_loop1:
	in   A,(C)  			;get state    
	jp   P,FDC_read_loop1	;are we ready ?

	and  #0b00100000  		;is instruction finished ?	
	jr   Z,FDC_read_done

;read byte
	inc  C					;data port
	in   A,(C)				;get byte
	ld   (HL),A				;and write it
	inc  HL
	dec  C					;state port
	
;check if we rode all our datas
	dec de
	ld a,e
	or d

	jr nz,FDC_read_loop1	;if no continue

;does we finish to read our datas ?
FDC_read_loop2:
	in   A,(C)                
	jp   P,FDC_read_loop2
	and  #0b00100000  
	jr   Z,FDC_read_done	;yes ? so exit !

	inc  C					;data port
	in   A,(C)
	dec  C					;state port
	jr FDC_read_loop2		;else continue to read data but do not write

FDC_read_done:

	call FDC_getresult		;get results
	jr FDC_CheckErrors		;and check for error

;*******************
;*** GET RESULTS ***
;*******************
;return carry if success

FDC_getresult::
	call FDC_get	;ST0
	ld (st0),A	
	
	call FDC_get	
	ld (st1),A		;ST1
	
	call FDC_get
	ld (st2),A		;ST2
	
	call FDC_get	;track
	ld (r_track),A
	
	call FDC_get	;head
	ld (r_head),A
	
	call FDC_get	;sector ID
	ld (r_sector),A
	
	call FDC_get	;sector size
	ld (r_size),A
	
	ret
	
;**********************
;*** GET FDC ERRORS ***
;**********************
; Carry if no error
; else error is returned in A
;	
FDC_CheckErrors::

;*** ST 0 ***
	
	ld B,#1
	ld A,(st0)
	bit 7,A
	jr nz,FDC_error		;1 no disc (Disc Changed)
	
	inc B
	bit 3,A				
	jr nz,FDC_error		;2 drive not ready (Not Ready)
	
	inc B
	bit 4,A
	jr nz,FDC_error		;3 drive mechanics fault (Equipment Check)	

;*** ST 1 ***
	
	inc B
	ld A,(st1)
	bit 0,A
	jr nz,FDC_error		;4 formating error (Missing Address Mark)
	
	inc B
	bit	1,A
	jr nz,FDC_error		;5 disc is protected (Not Writeable)
	
	inc B
	bit 2,A
	jr nz,FDC_error		;6 invalid sector ID (No Data)
	
	inc B
	bit 4,A
	jr nz,FDC_error		;7 Z80 not enough fast (Overrun)
	
	inc B
	bit 5,A
	jr nz,FDC_error		;8 checksum error (Data Error)
	
	
;*** ST 2 ***

	inc B
	ld A,(st2)
	bit 4,A
	jr nz,FDC_error		;9 track is not the same as the sector on (Wrong Cylinder)
	
	;inc B
	;bit 0,A
	;jr nz,FDC_error		;10 formating error
	
	
	inc B				;10 other errors
	and #0b00110000
	jr nz,FDC_error

	xor A
	scf
	ret

FDC_error:
	or A
	ld A,B
	ret
	
FDC_Error_str:
	.ascii 	"FDC LOW LEVEL ERROR "
FDC_Error_str_digits:
	.ascii "00 "
	
	
;***************************************
;*** COMPUTE IDD FROM HEAD AND DRIVE ***
;***************************************
; return IDD in A
; F' , B corrupted
FDC_GetIdd::
	ld A,(current_head)
	add A
	add A						;head = bit 3 = 4
	ld B,A
	ld A,(current_drive)
	or B						;0bXXXXXXXHDD
	ret

;********************
;*** GOTO TRACK X ***
;********************
; A = track
; BC , AF , AF' corrupted

FDC_track::
	push AF
	ld   A,#cmd_goto_track
	call FDC_send			;command
	call FDC_GetIdd
	call FDC_send			;IDD
	pop AF
	call FDC_send			;track
	call FDC_waitdone
	ld (current_track),A
	ret
	
;**********************************
;*** GOTO TRACK 0 (RECALIBRATE) ***
;**********************************
;BC, AF , AF' corrupted

FDC_Track0::
	ld   A,#cmd_goto_track0
	call FDC_send				;command
	call FDC_GetIdd 
	call FDC_send				;IDD
	call FDC_waitdone			;wait exection done
	or A						;are we on track 0 ?
	jr nz,FDC_Track0 			;if not , retry
	ld (current_track),A
	ret

;*********************************
;*** WAIT FOR OPERATION ENDING ***
;*********************************
;get ST0 status to see if operation ended
;and return track in A
;BC , F , AF' corrupted
FDC_waitdone::
	ld   A,#cmd_int_state
	call FDC_send

	call FDC_get		;ST0
	ld   (st0),A
	call FDC_get		;track
	ld B,A				;save track in B
	xor  A
	ld   (st1),A                   
	ld   (st2),A
	ld   A,(st0)

	bit  5,A      		;is instruction finished ?                
	jr z,FDC_waitdone 
	ld A,B				;return track in A

	ret
;************************
;*** SEND DATA TO FDC ***
;************************
; A = data to send
; BC , AF , AF ' corrupted
FDC_send::
	ex 	AF,AF'				;save data to send
	ld	BC,#FDC_Port_State	
FDC_sendwait: 				;wait until ready
	in   A,(C)
	jp   P,FDC_sendwait
	
	ex	 AF,AF'				;restore data
	inc C					;next port = data port
	out  (C),A				;send data
	ret  
	
;*************************
;*** GET DATA FROM FDC ***
;*************************
; same but in other way
; result in A
; BC , F corrupted
FDC_get::
 	ld   BC,#FDC_Port_State
FDC_getwait:
	in   A,(C)
 	jp   P,FDC_getwait		;wait until ready
	
 	inc C					;next port = data port
	in   A,(C)				;get data
	ret
	
;******************
;*** STOP MOTOR ***
;******************
FDC_MotorOff::
	ld A,(motor_state)
	or A
	ret z
	
	ld BC,#FDC_Port_Motor
	xor A
	out (C),A
	ld (motor_state),A
	ret
	
;*****************
;***START MOTOR***
;*****************
FDC_MotorOn::
	ld A,(motor_state)
	or A
	ret nz
	
	;motor on
	ld BC,#FDC_Port_Motor
	ld A,#1
	out (C),A
	ld (motor_state),A
	
	;wait a bit
	ld E,#motor_wait
DSK_wait:
	ld B,#0xF5
DSK_waitLoop:
	in A,(C)
	rra
	jr nc,DSK_waitLoop
;wait end of VBL
DSK_waitCounterLoop:
	in A,(C)
	rra
	jr c,DSK_waitCounterLoop
	dec E
	jr nz,DSK_waitLoop	
	ret



;variables
data_addr:		    .dw #0
data_size:		    .dw #0
data_sectors:	    .dw #0
data_sector_first = data_sectors+1
data_sector_last  = data_sectors
;returned values
st0:		.db #0
st1:		.db #0
st2:		.db #0
st3:		.db #0
;other returned datas
r_track:	.db #0
r_head:		.db #0
r_sector:	.db #0
r_size:		.db #0

motor_state:
	.db	#0
current_drive:
	.db	#0
current_head:
	.db	#0
current_track:
	.db	#0
gap3:
	.db	default_gap3