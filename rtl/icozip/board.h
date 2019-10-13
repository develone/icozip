////////////////////////////////////////////////////////////////////////////////
//
// Filename:	./board.h
//
// Project:	ICO Zip, iCE40 ZipCPU demonstration project
//
// DO NOT EDIT THIS FILE!
// Computer Generated: This file is computer generated by AUTOFPGA. DO NOT EDIT.
// DO NOT EDIT THIS FILE!
//
// CmdLine:	autofpga autofpga -o . global.txt bkram.txt clock50.txt spixpress.txt pic.txt version.txt dlyarbiter.txt zipbones.txt
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2017-2019, Gisselquist Technology, LLC
//
// This program is free software (firmware): you can redistribute it and/or
// modify it under the terms of  the GNU General Public License as published
// by the Free Software Foundation, either version 3 of the License, or (at
// your option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program.  (It's in the $(ROOT)/doc directory.  Run make with no
// target there if the PDF file isn't present.)  If not, see
// <http://www.gnu.org/licenses/> for a copy.
//
// License:	GPL, v3, as defined and found on www.gnu.org,
//		http://www.gnu.org/licenses/gpl.html
//
//
////////////////////////////////////////////////////////////////////////////////
//
//
#ifndef	BOARD_H
#define	BOARD_H

// And, so that we can know what is and isn't defined
// from within our main.v file, let's include:
#include <design.h>

#include <design.h>
#include <cpudefs.h>

#define	_HAVE_ZIPBONES



#define BUSPIC(X) (1<<X)


#define	CLKFREQHZ	50000000


#ifdef	BUSPIC_ACCESS
#define	_BOARD_HAS_BUSPIC
static volatile unsigned *const _buspic = ((unsigned *)12582912);
#endif	// BUSPIC_ACCESS
#ifdef	BUSTIMER_ACCESS
#define	_BOARD_HAS_BUSTIMER
static volatile unsigned *const _bustimer = ((unsigned *)0x00800000);
#endif	// BUSTIMER_ACCESS
#ifdef	BKRAM_ACCESS
#define	_BOARD_HAS_BKRAM
extern char	_bkram[0x00002000];
#endif	// BKRAM_ACCESS
#ifdef	FLASH_ACCESS
#define	_BOARD_HAS_FLASH
extern char _flash[0x01000000];
#endif	// FLASH_ACCESS
#define	_BOARD_HAS_VERSION
//
// Interrupt assignments (2 PICs)
//
// PIC: buspic
#define	BUSPIC_BUSTIMER	BUSPIC(0)
// PIC: cpu_reset
#define	CPU_RESET_RESET	CPU_RESET(0)
#define	CPU_RESET_WATCHDOG	CPU_RESET(1)
#endif	// BOARD_H
