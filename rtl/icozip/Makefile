################################################################################
##
## Filename: 	rtl/icozip/Makefile
##
## Project:	ICO Zip, iCE40 ZipCPU demonstration project
##
## Purpose:	This makefile builds both the final bit file for loading, as
##		well as a verilator simulation of the entire icozip project.
##
## Creator:	Dan Gisselquist, Ph.D.
##		Gisselquist Technology, LLC
##
################################################################################
##
## Copyright (C) 2015-2021, Gisselquist Technology, LLC
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
################################################################################
##
##
.PHONY: all
all: cpudefs.h design.h verilated bin
CROSS ?=
ARCH  ?= $(shell bash ../../sw/host/arch.sh)
CXX   := $(CROSS)g++
FBDIR := .
VDIRFB:= $(FBDIR)/obj-$(ARCH)
VOBJ := obj-$(ARCH)
include auto.mk
PCFFILE := icozip.pcf
VERILATOR := verilator
VFLAGS := -O3 -MMD -Mdir $(VDIRFB) -Wall -Wno-TIMESCALEMOD -trace -cc $(AUTOVDIRS)
# VERILATOR := VERILATOR_ROOT=/home/dan/tmp/verilator.git /home/dan/tmp/verilator.git/bin/verilator
# toplevel.v rxuart.v txuart.v
# rtcdate.v wbubus.v
ICOSRCS := toplevel.v main.v $(WBUBUS) $(PPBUS) $(PPORT) cpu/icontrol.v memdev.v ufifo.v wbxbar.v addrdecode.v skidbuffer.v

#
# Verilator build from the main level.  This is not the toplevel verilog
# file, but one beneath it, so as to allow the top level file to contain device
# specific logic and functions (PLLs, etc.).
#
#

.PHONY: verilated
verilated: $(VDIRFB)/Vmain__ALL.a

# $(VDIRFB)/V%.cpp: $(VDIRFB)/V%.h
# $(VDIRFB)/V%.mk:  $(VDIRFB)/V%.h
# $(VDIRFB)/V%.h: $(FBDIR)/%.v
#	$(VERILATOR) -O3 -Mdir $(VDIRFB) -trace -cc $(AUTOVDIRS) $*.v

$(VDIRFB)/Vmain.cpp: $(VDIRFB)/Vmain.h
$(VDIRFB)/Vmain.mk:  $(VDIRFB)/Vmain.h
$(VDIRFB)/Vmain.h: main.v $(VFLIST)
	$(VERILATOR) $(VFLAGS) main.v
cpudefs.h: cpu/cpudefs.v
	@echo "Building cpudefs.h"
	@echo "// " > $@
	@echo "// Do not edit this file, it is automatically generated!" >> $@
	@echo "// To generate this file, \"make cpudefs.h\" in the rtl directory." >> $@
	@echo "// " >> $@
	@echo >> $@
	@sed -e '{ s/^`/#/ }' $< | sed -e ' s/cpudefs.v/cpudefs.h/' >> $@
	@echo >> $@

design.h: main.v
	@echo "Building design.h"
	@echo "// " > $@
	@echo "// Do not edit this file, it is automatically generated!" >> $@
	@echo "// To generate this file, \"make design.h\" in the rtl directory." >> $@
	@echo "// " >> $@
	@echo "#ifndef DESIGN_H" >> $@
	@echo "#define DESIGN_H" >> $@
	@echo >> $@
	@grep "^\`" $< | grep -v default_nettype | grep -v include | sed -e '{ s/^`/#/ }' | sed -e ' s/main.v/design.h/' | grep -v timescale >> $@
	@echo >> $@
	@echo "#endif // DESIGN_H" >> $@

$(VDIRFB)/V%__ALL.a: $(VDIRFB)/V%.mk
	cd $(VDIRFB); make -f V$*.mk

#
#
#
.PHONY: bin
bin: icozip.bin
#
#
icozip.json: toplevel.v wbxbar.v addrdecode.v skidbuffer.v $(VFLIST)
	@echo yosys -ql yosys.log -p 'synth_ice40 -top toplevel' ...
	@yosys -ql yosys.log -p 'synth_ice40 -json icozip.json -top toplevel' $^

.PHONY: yosys
yosys: icozip.json

icozip.asc: $(PCFFILE) icozip.json
	# arachne-pnr -d 8k -r -P ct256 -p $(PCFFILE) icozip.blif -o $@
	nextpnr-ice40 --hx8k -r --freq 50 --package ct256 --pcf $(PCFFILE) --json icozip.json --asc icozip.asc --no-promote-globals

.PHONY: arachne
arachne: icozip.asc

icozip.bin: icozip.asc
	icepack icozip.asc icozip.bin
	icetime -d hx8k -c 50 icozip.asc

#
#
#
tags: $(wildcard *.v)
	ctags *.v

.PHONY: clean
clean:
	rm -rf $(VOBJ) cpudefs.h design.h
	rm -rf *.blif *.asc *.bin *.json
	rm -rf $(VDIRFB)/*.mk
	rm -rf $(VDIRFB)/*.cpp
	rm -rf $(VDIRFB)/*.h
	rm -rf $(VDIRFB)/

DEPS := $(wildcard $(VDIRFB)/*.d)

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(DEPS),)
include $(DEPS)
endif
endif
