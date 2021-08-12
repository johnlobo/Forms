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
;;-------------------------------------------------------------------------------6


;;------------------------------------------------------------------------------
;; Global routines
;;------------------------------------------------------------------------------

.globl FDC_GetVersion
.globl FDC_GetDriveStatus
.globl FDC_read 					
.globl FDC_write					
.globl FDC_CheckErrors
.globl FDC_GetIdd
.globl FDC_track					
.globl FDC_Track0    
.globl FDC_MotorOn 
.globl FDC_MotorOff
.globl FDC_RetryTrack
.globl FDC_DriveWaitReady
