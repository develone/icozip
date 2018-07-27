################################################################################
##
## Filename:	./rtl.make.inc
##
## Project:	ICO Zip, iCE40 ZipCPU demonstration project
##
## DO NOT EDIT THIS FILE!
## Computer Generated: This file is computer generated by AUTOFPGA. DO NOT EDIT.
## DO NOT EDIT THIS FILE!
##
## CmdLine:	autofpga autofpga -o . global.txt bkram.txt buserr.txt clock.txt pic.txt pwrcount.txt version.txt hbconsole.txt gpio.txt dlyarbiter.txt zipbones.txt spixpress.txt sramdev.txt sramscope.txt
##
## Creator:	Dan Gisselquist, Ph.D.
##		Gisselquist Technology, LLC
##
################################################################################
##
## Copyright (C) 2017-2018, Gisselquist Technology, LLC
##
## This program is free software (firmware): you can redistribute it and/or
## modify it under the terms of  the GNU General Public License as published
## by the Free Software Foundation, either version 3 of the License, or (at
## your option) any later version.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY or
## FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
## for more details.
##
## You should have received a copy of the GNU General Public License along
## with this program.  (It's in the $(ROOT)/doc directory.  Run make with no
## target there if the PDF file isn't present.)  If not, see
## <http://www.gnu.org/licenses/> for a copy.
##
## License:	GPL, v3, as defined and found on www.gnu.org,
##		http://www.gnu.org/licenses/gpl.html
##
##
################################################################################
##
##
SRAM := sramdev.v

ZIPCPUD := cpu
ZIPCPU  := $(addprefix $(ZIPCPUD)/,zipcpu.v cpuops.v dblfetch.v prefetch.v memops.v idecode.v ziptimer.v wbpriarbiter.v zipbones.v busdelay.v cpudefs.v icontrol.v div.v mpyop.v wbdblpriarb.v)
PICD := cpu
PIC  := $(addprefix $(PICD)/,icontrol.v)
SCOPE := wbscope.v

GPIO := wbgpio.v

BKRAM := memdev.v

HBBUSD := ../hexbus
HBBUS  := $(addprefix $(HBBUSD)/,hbconsole.v hbdechex.v hbdeword.v hbexec.v hbgenhex.v hbidle.v hbints.v hbnewline.v hbpack.v console.v)
BUSDLYD := cpu
BUSDLY  := $(addprefix $(BUSDLYD)/,busdelay.v wbpriarbiter.v)
PPORTD := ../pport
PPORT  := $(addprefix $(PPORTD)/,ppio.v pport.v ufifo.v)
FLASH := spixpress.v oclkddr.v

VFLIST := main.v  $(SRAM) $(ZIPCPU) $(PIC) $(SCOPE) $(GPIO) $(BKRAM) $(HBBUS) $(BUSDLY) $(PPORT) $(FLASH)
AUTOVDIRS :=  -y cpu -y cpu -y ../hexbus -y cpu -y ../pport
