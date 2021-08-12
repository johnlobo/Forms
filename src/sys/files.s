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

.include "common.h.s"
.include "man/game.h.s"


;; firmware function to open a file for reading
cas_in_open = 0xbc77
;; firmware function to read an entire file (must have a AMSDOS header)
;; the file must have been opened for reading
cas_in_direct = 0xbc83
;; firmware function to close a file opened for reading
cas_in_close = 0xbc7a
;; firmware function to open a file for writing
cas_out_open = 0xbc8c
;; firmware function to write an entire file
;; the file will be written with a AMSDOS header
cas_out_direct = 0xbc98
;; firmware function to close a file opened for writing
cas_out_close = 0xbc8f


;; the filename to load
;; disc filenames are a maximum of 12 characters long
;; 8 characters for name, and 3 characters for extension
filename:
.ascii "HISCORE.BIN"
end_filename:


sys_files_check_file::
;; B = length of the filename in characters
ld b, #(end_filename - filename)
;; HL = address of the start of the filename
ld hl, #filename
;; DE = address of a 2k buffer
;; 
;; in disc mode: this buffer is not used when CAS IN DIRECT
;; firmware function is used, so it is safe to put it anywhere
;; you want.
ld de, #0
;; firmware function to open a file for reading
call cas_in_open
;; cas_in_open returns:
;; if file was opened successfully:
;; - carry is true 
;; - HL contains address of the file's AMSDOS header
;; - DE contains the load address of the file (from the header)
;; - BC contains the length of the file (from the file header)
;; - A contains the file type (2 for binary files)
ret


;; This example shows the firmware functions used to load
;; a file with a AMSDOS header (a non-ASCII file)
;;
;; in this example, the file is called SCREEN.SCR
;; and is loaded to the default screen location &c000-&ffff





sys_files_load_file::
;; B = length of the filename in characters
ld b, #(end_filename - filename)

;; HL = address of the start of the filename
ld hl, #filename

;; DE = address of a 2k buffer
;; 
;; in disc mode: this buffer is not used when CAS IN DIRECT
;; firmware function is used, so it is safe to put it anywhere
;; you want.
ld de, #0

;; firmware function to open a file for reading
call cas_in_open

;; cas_in_open returns:
;; if file was opened successfully:
;; - carry is true 
;; - HL contains address of the file's AMSDOS header
;; - DE contains the load address of the file (from the header)
;; - BC contains the length of the file (from the file header)
;; - A contains the file type (2 for binary files)

;; firmware function to load the entire file
;; this will work with files that have a AMSDOS header (ASCII
;; files do not have a header)

;; HL = load address

ld hl, #hi_score
;; read file
call cas_in_direct

;; firmware function to close a file opened for reading
call cas_in_close

ret





;; This example shows the firmware functions used to save
;; a file.
;;
;; in this example, the file is called SCREEN.SCR
;; and is a dump of the screen (from the default location &c000-&ffff)
sys_files_save_file::
;; B = length of the filename in characters
ld b, #(end_filename - filename)

;; HL = address of the start of the filename
ld hl, #filename

;; DE = address of a 2k buffer
;; 
;; in disc mode: this buffer is not used when CAS IN DIRECT
;; firmware function is used, so it is safe to put it anywhere
;; you want.
ld de, #0

;; firmware function to open a file for reading
call cas_out_open

;; firmware function to write the entire file
;; this will automatically generate a AMSDOS header
;; and write it before the the file data.

;; HL = load address
ld hl,#hi_score
;; DE = length
ld de,#SCORE_NUM_BYTES
;; BC = execution address
ld bc,#0x0000
;; A = file type (2 = binary)
ld a,#2

;; write file
call cas_out_direct

;; firmware function to close a file opened for writing
call cas_out_close

ret
