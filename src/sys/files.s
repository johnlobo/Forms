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


.include "sys/score.h.s"
.include "common.h.s"

.module files_system

;;-----------------------------------------------------------------
;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA

is_disk:: .db 0x00

;; the filename to load
;; disc filenames are a maximum of 12 characters, 8 for name, and 3 for extension
filename:
.ascii "HISCORE.BIN"
end_filename:

cas_in_open = 0xbc77    ;; firmware function to open a file for reading
cas_in_direct = 0xbc83  ;; firmware function to read an entire file (must have a AMSDOS header been opened
cas_in_close = 0xbc7a   ;; firmware function to close a file opened for reading
cas_out_open = 0xbc8c   ;; firmware function to open a file for writing
cas_out_direct = 0xbc98 ;; firmware function to write an entire filewith a AMSDOS header
cas_out_close = 0xbc8f  ;; firmware function to close a file opened for writing
disk_error_messages =  0xbe78       ;; firmware function to enable (0x00) of disable (0xff) the disk error messages

;;
;; Start of _CODE area
;; 
.area _CODE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sys_files_check_media
;;
;; Check if the gmae has been loaded from disk or tape. If the game has been loaded from disk 
;; address a70a stores a number higher than 64, in cas of tape stores 0.
;;
;; DESTROYS: HL, AF
;;
;; Thanks to  Jean-Marie (https://www.cpcwiki.eu/forum/programming/how-to-check-if-program-was-launched-from-disk-or-tape/msg228058/#msg228058)
sys_files_check_media::
    ;; check cpc464, cpc6128
    ld hl, #0xa70a
    ld a, (hl)
    ld hl, #is_disk
    ld (hl), a
    ret

_StoreDriveLetter:
  ;;------------------------------------------------------------------------
  ;; store the drive number the loader was run from to InitializeAmsdos
  ld hl,(#0xbe7d)
  ld a,(hl)                 
  ld (_driveLoad+1),a                 
  
  ;;------------------------------------------------------------------------
  ;; store jump restore call to InitializeAmsdos
  ld a,(#0xbD38)                 
  ld (_firmJump+1),a
   
  ret


_InitializeAmsdos:
  ;; ** INITIALISE ALTERNATE REGISTER SET FOR FIRMWARE **
  exx
  ld bc,#0x7f88     ;initialise lower rom and select mode 0
  out (c),c         ;this routine must be located above &4000
  exx 
  ex af,AF
  xor a
  ex af,af

  ;; ** INITIALISE FIRMWARE **
  call #0x0044      ;initialise lower jumpblock (&0000-&0040)
                  ;and high kernal jumpblock (&b800-&bae4)
  _firmJump: call #0x08bd                ;initialise firmware jumpblock entries
                      ;call #0xBD37
                      ;(&bb00- ...)
  call #0xbb00                ;initialise keyboard manager
  call #0xb909                ;disable lower rom

  ;;; ** INITIALISE DISK ROM FOR LOADING/SAVING **
  ld c,#7                      ;disk rom
  ld de,#0x8000                 ;lowest useable byte of memory
  ld hl,#0xb0ff                 ;highest useable byte of memory
  call #0xbcce           ;initialise disk rom

  ld c,#6                      ;disk rom
  ld de,#0x8000                 ;lowest useable byte of memo ry
  ld hl,#0xb0ff                 ;highest useable byte of memory
  call #0xbcce           ;initialise disk rom

  ld a,#0xc9
  ld (#0xbb5a),a           ;prevent printing of text characters
                      ;don t get error messages corrupting screen

  ld a,#0xff
  ld (#0xbe78),a                ;turn off disc error messages
                    
  ;;------------------------------------------------------------------------
  ;; when AMSDOS is enabled, the drive reverts back to drive 0!
  ;; This will restore the drive number to the drive the loader was run from
  _driveLoad: ld a, #0x00
  ld hl,(#0xbe7d)
  ld (hl),a 

  ret

;;
;; This example shows the firmware functions used to load
;; a file with a AMSDOS header (a non-ASCII file)
;;
;; https://www.cpcwiki.eu/index.php/Programming:Loading_a_file
;;
sys_files_load_file::
    call _StoreDriveLetter
    call _InitializeAmsdos
    ;; disable disk error messages
    ld a, #0xff
    ld (#disk_error_messages),a                          ;; turn off disc error messages
    ;; load file
    ld b, #(end_filename - filename)        ;; B = length of the filename in characters
    ld hl, #filename                        ;; HL = address of the start of the filename
    ld de, #0                               ;; DE = address of a 2k buffer
                                            ;; 
                                            ;; in disc mode: this buffer is not used when CAS IN DIRECT
                                            ;; firmware function is used, so it is safe to put it anywhere
                                            ;; you want.
    call cas_in_open                        ;; firmware function to open a file for reading
                                            ;; cas_in_open returns:
                                            ;; if file was opened successfully:
                                            ;; - carry is true 
                                            ;; - HL contains address of the file's AMSDOS header
                                            ;; - DE contains the load address of the file (from the header)
                                            ;; - BC contains the length of the file (from the file header)
                                            ;; - A contains the file type (2 for binary files)
    jr nc, _load_file_exit                  ;; if the file has not properly opened exit
    ld hl, #hi_score_table                  ;; HL = load address
    call cas_in_direct                      ;; read file
_load_file_exit:
    call cas_in_close                       ;; firmware function to close a file opened for reading
    ret

;;
;; This example shows the firmware functions used to save
;; a file.
;;
;; https://www.cpcwiki.eu/index.php/Programming:Saving_a_file
;;
sys_files_save_file::
    ;; disable disk error messages
    ld a, #0xff
    ld (#disk_error_messages),a                          ;; turn off disc error messages
    call _StoreDriveLetter
    call _InitializeAmsdos
    ;; save file
    ld b, #(end_filename - filename)       ;; B = length of the filename in characters
    ld hl, #filename                        ;; HL = address of the start of the filename
    ld de, #0                               ;; DE = address of a 2k buffer
                                            ;; 
                                            ;; in disc mode: this buffer is not used when CAS IN DIRECT
                                            ;; firmware function is used, so it is safe to put it anywhere
                                            ;; you want.
    call cas_out_open                       ;; firmware function to open a file for writing
                                            ;; firmware function to write the entire file
                                            ;; this will automatically generate a AMSDOS header
                                            ;; and write it before the the file data.
    ld hl,#hi_score_table                   ;; HL = load address
    ld de,#sizeof_sc_tb                     ;; DE = length
    ld bc,#0x0000                           ;; BC = execution address
    ld a,#2                                 ;; A = file type (2 = binary)
    call cas_out_direct                     ;; write file
    call cas_out_close                      ;; firmware function to close a file opened for writing
    ret
