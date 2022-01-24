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


.include "sys/score.h.s"
.include "common.h.s"

.module files_system

cas_in_open = 0xbc77    ;; firmware function to open a file for reading
cas_in_direct = 0xbc83  ;; firmware function to read an entire file (must have a AMSDOS header been opened
cas_in_close = 0xbc7a   ;; firmware function to close a file opened for reading
cas_out_open = 0xbc8c   ;; firmware function to open a file for writing
cas_out_direct = 0xbc98 ;; firmware function to write an entire filewith a AMSDOS header
cas_out_close = 0xbc8f  ;; firmware function to close a file opened for writing

;; the filename to load
;; disc filenames are a maximum of 12 characters, 8 for name, and 3 for extension
filename:
.ascii "HISCORE.BIN"
end_filename:

;;
;; This example shows the firmware functions used to load
;; a file with a AMSDOS header (a non-ASCII file)
;;
;; https://www.cpcwiki.eu/index.php/Programming:Loading_a_file
;;
sys_files_load_file::
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
