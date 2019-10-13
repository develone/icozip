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
## CmdLine:	autofpga autofpga -d -o . clock50.txt global.txt dlyarbiter.txt version.txt buserr.txt pic.txt pwrcount.txt gpio.txt spixpress.txt sramdev.txt bkram.txt hbconsole.txt zipbones.txt mem_flash_bkram.txt mem_bkram_only.txt mem_flash_sram.txt mem_sram_only.txt
##
## Creator:	Dan Gisselquist, Ph.D.
##		Gisselquist Technology, LLC
##
################################################################################
##
## Copyright (C) 2017-2019, Gisselquist Technology, LLC
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
HBBUSD := ../hexbus
HBBUS  := $(addprefix $(HBBUSD)/,hbconsole.v hbdechex.v hbdeword.v hbexec.v hbgenhex.v hbidle.v hbints.v hbnewline.v hbpack.v console.v)
BKRAM := memdev.v

SRAM := sramdev.v

ZIPCPUD := cpu
ZIPCPU  := $(addprefix $(ZIPCPUD)/,zipcpu.v cpuops.v dblfetch.v prefetch.v memops.v idecode.v ziptimer.v wbpriarbiter.v zipbones.v busdelay.v cpudefs.v icontrol.v div.v mpyop.v slowmpy.v wbdblpriarb.v)
FLASH := spixpress.v oclkddr.v

GPIO := wbgpio.v

BUSPICD := cpu
BUSPIC  := $(addprefix $(BUSPICD)/,icontrol.v)
PPORTD := ../pport
PPORT  := $(addprefix $(PPORTD)/,ppio.v pport.v ufifo.v)
BUSDLYD := cpu
BUSDLY  := $(addprefix $(BUSDLYD)/,busdelay.v wbpriarbiter.v)
VFLIST := main.v  $(HBBUS) $(BKRAM) $(SRAM) $(ZIPCPU) $(FLASH) $(GPIO) $(BUSPIC) $(PPORT) $(BUSDLY)
AUTOVDIRS :=  -y ../hexbus -y cpu -y ../pport
