`timescale	1ps / 1ps
////////////////////////////////////////////////////////////////////////////////
//
// Filename:	./main.v
//
// Project:	ICO Zip, iCE40 ZipCPU demonstration project
//
// DO NOT EDIT THIS FILE!
// Computer Generated: This file is computer generated by AUTOFPGA. DO NOT EDIT.
// DO NOT EDIT THIS FILE!
//
// CmdLine:	autofpga autofpga -o . global.txt bkram.txt buserr.txt clock.txt pic.txt pwrcount.txt version.txt hbconsole.txt gpio.txt dlyarbiter.txt zipbones.txt spixpress.txt sramdev.txt sramscope.txt
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2017-2018, Gisselquist Technology, LLC
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
`default_nettype	none
//
//
// Here is a list of defines which may be used, post auto-design
// (not post-build), to turn particular peripherals (and bus masters)
// on and off.  In particular, to turn off support for a particular
// design component, just comment out its respective `define below.
//
// These lines are taken from the respective @ACCESS tags for each of our
// components.  If a component doesn't have an @ACCESS tag, it will not
// be listed here.
//
// First, the independent access fields for any bus masters
`define	INCLUDE_ZIPCPU
`define	WBUBUS_MASTER
// And then for the independent peripherals
`define	SRAM_ACCESS
`define	WATCHDOG_ACCESS
`define	BUSTIMER_ACCESS
`define	BUSPIC_ACCESS
`define	FLASH_SCOPE
`define	GPIO_ACCESS
`define	BKRAM_ACCESS
`define	BUSCONSOLE_ACCESS
`define	FLASH_ACCESS
//
// End of dependency list
//
//
//
//
// Finally, we define our main module itself.  We start with the list of
// I/O ports, or wires, passed into (or out of) the main function.
//
// These fields are copied verbatim from the respective I/O port lists,
// from the fields given by @MAIN.PORTLIST
//
module	main(i_clk, i_reset,
		o_ram_ce_n, o_ram_oe_n, o_ram_we_n, o_ram_addr, o_ram_sel, 
			o_ram_data, i_ram_data,
		// GPIO ports
		i_gpio, o_gpio,
		// The SPI Flash
		o_spi_cs_n, o_spi_sck, o_spi_mosi, i_spi_miso,
		// Command and Control port
		i_pp_clk, i_pp_dir, i_pp_data, o_pp_data, o_pp_clkfb, o_pp_dbg);
//
// Any parameter definitions
//
// These are drawn from anything with a MAIN.PARAM definition.
// As they aren't connected to the toplevel at all, it would
// be best to use localparam over parameter, but here we don't
// check
	//
	//
	// Variables/definitions needed by the ZipCPU BUS master
	//
	//
	// A 32-bit address indicating where teh ZipCPU should start running
	// from
	localparam	RESET_ADDRESS = 32'h00c00000;
	//
	// The number of valid bits on the bus
	localparam	ZIP_ADDRESS_WIDTH = 23; // Zip-CPU address width
	//
	// Number of ZipCPU interrupts
	localparam	ZIP_INTS = 16;
	//
	// ZIP_START_HALTED
	//
	// A boolean, indicating whether or not the ZipCPU be halted on startup?
	localparam	ZIP_START_HALTED=1'b1;
	//
	// ZIP_LGCACHE_SZ
	//
	// The cache, if present, will hold 2^ZIP_LGCACHE_SZ values
	localparam	ZIP_LGCACHE_SZ=8;
//
// The next step is to declare all of the various ports that were just
// listed above.  
//
// The following declarations are taken from the values of the various
// @MAIN.IODECL keys.
//
	input	wire		i_clk;
// verilator lint_off UNUSED
	input	wire		i_reset;
	// verilator lint_on UNUSED
	output	wire		o_ram_ce_n, o_ram_oe_n, o_ram_we_n;
	output	wire	[15:0]	o_ram_addr;
	output	wire	[1:0]	o_ram_sel;
	output	wire	[15:0]	o_ram_data;
	input	wire	[15:0]	i_ram_data;
	// The SPI flash
	output	wire		o_spi_cs_n;
	output	wire		o_spi_sck;
	output	wire		o_spi_mosi;
	input	wire		i_spi_miso;
	input	wire		i_pp_clk, i_pp_dir;
	input	wire	[7:0]	i_pp_data;
	output	wire	[7:0]	o_pp_data;
	output	wire		o_pp_clkfb;
	output	wire		o_pp_dbg;
	// Make Verilator happy ... defining bus wires for lots of components
	// often ends up with unused wires lying around.  We'll turn off
	// Verilator's lint warning here that checks for unused wires.
	// verilator lint_off UNUSED



	//
	// Declaring interrupt lines
	//
	// These declarations come from the various components values
	// given under the @INT.<interrupt name>.WIRE key.
	//
	wire	i_reset;	// watchdog.INT.RESET.WIRE
	wire	watchdog_reset;	// watchdog.INT.WATCHDOG.WIRE
	wire	bustimer_int;	// bustimer.INT.BUSTIMER.WIRE
	wire	zip_cpu_int;	// zip.INT.ZIP.WIRE
	wire	w_bus_int;	// buspic.INT.BUS.WIRE
	wire	gpio_int;	// gpio.INT.GPIO.WIRE
	wire	uarttxf_int;	// console.INT.UARTTXF.WIRE
	wire	uartrxf_int;	// console.INT.UARTRXF.WIRE
	wire	uarttx_int;	// console.INT.UARTTX.WIRE
	wire	uartrx_int;	// console.INT.UARTRX.WIRE


	//
	// Component declarations
	//
	// These declarations come from the @MAIN.DEFNS keys found in the
	// various components comprising the design.
	//
// Looking for string: MAIN.DEFNS
	reg	cpu_reset;
	// ZipSystem/ZipCPU connection definitions
	// All we define here is a set of scope wires
	wire	[31:0]	zip_debug;
	wire		zip_trigger;
	wire		zip_halted;
	reg	[23-1:0]	r_buserr_addr;
	reg	[31:0]	r_pwrcount_data;
	localparam	NGPI = 2, NGPO=11;
	// GPIO ports
	input		[(NGPI-1):0]	i_gpio;
	output	wire	[(NGPO-1):0]	o_gpio;
`include "builddate.v"
	// Console definitions
	wire	w_console_rx_stb, w_console_tx_stb, w_console_busy;
	wire	[6:0]	w_console_rx_data, w_console_tx_data;
	// Bus arbiter's internal lines
	wire		hb_dwbi_cyc, hb_dwbi_stb, hb_dwbi_we,
			hb_dwbi_ack, hb_dwbi_stall, hb_dwbi_err;
	wire	[(23-1):0]	hb_dwbi_addr;
	wire	[31:0]	hb_dwbi_odata, hb_dwbi_idata;
	wire	[3:0]	hb_dwbi_sel;
	// Definitions for the WB-UART converter.  We really only need one
	// (more) non-bus wire--one to use to select if we are interacting
	// with the ZipCPU or not.
	wire	[0:0]	wbubus_dbg;
	wire		pp_rx_stb,  pp_tx_stb,  pp_tx_busy;
	wire	[7:0]	pp_rx_data, pp_tx_data;


	//
	// Declaring interrupt vector wires
	//
	// These declarations come from the various components having
	// PIC and PIC.MAX keys.
	//
	wire	[7:0]	cpu_reset_bus;
	wire	[14:0]	bus_int_vector;
	//
	//
	// Define bus wires
	//
	//

	// Bus wb
	// Wishbone master wire definitions for bus: wb
	wire		wb_cyc, wb_stb, wb_we, wb_stall, wb_err,
			wb_none_sel;
	reg		wb_many_ack;
	wire	[22:0]	wb_addr;
	wire	[31:0]	wb_data;
	reg	[31:0]	wb_idata;
	wire	[3:0]	wb_sel;
	reg		wb_ack;

	// Wishbone slave definitions for bus wb(SIO), slave buserr
	wire		buserr_sel, buserr_ack, buserr_stall;
	wire	[31:0]	buserr_data;

	// Wishbone slave definitions for bus wb(SIO), slave buspic
	wire		buspic_sel, buspic_ack, buspic_stall;
	wire	[31:0]	buspic_data;

	// Wishbone slave definitions for bus wb(SIO), slave gpio
	wire		gpio_sel, gpio_ack, gpio_stall;
	wire	[31:0]	gpio_data;

	// Wishbone slave definitions for bus wb(SIO), slave pwrcount
	wire		pwrcount_sel, pwrcount_ack, pwrcount_stall;
	wire	[31:0]	pwrcount_data;

	// Wishbone slave definitions for bus wb(SIO), slave version
	wire		version_sel, version_ack, version_stall;
	wire	[31:0]	version_data;

	// Wishbone slave definitions for bus wb(DIO), slave bustimer
	wire		bustimer_sel, bustimer_ack, bustimer_stall;
	wire	[31:0]	bustimer_data;

	// Wishbone slave definitions for bus wb(DIO), slave watchdog
	wire		watchdog_sel, watchdog_ack, watchdog_stall;
	wire	[31:0]	watchdog_data;

	// Wishbone slave definitions for bus wb, slave flash_cfg
	wire		flash_cfg_sel, flash_cfg_ack, flash_cfg_stall;
	wire	[31:0]	flash_cfg_data;

	// Wishbone slave definitions for bus wb, slave sramscope
	wire		sramscope_sel, sramscope_ack, sramscope_stall;
	wire	[31:0]	sramscope_data;

	// Wishbone slave definitions for bus wb, slave wb_dio
	wire		wb_dio_sel, wb_dio_ack, wb_dio_stall;
	wire	[31:0]	wb_dio_data;

	// Wishbone slave definitions for bus wb, slave console
	wire		console_sel, console_ack, console_stall;
	wire	[31:0]	console_data;

	// Wishbone slave definitions for bus wb, slave wb_sio
	wire		wb_sio_sel, wb_sio_ack, wb_sio_stall;
	wire	[31:0]	wb_sio_data;

	// Wishbone slave definitions for bus wb, slave bkram
	wire		bkram_sel, bkram_ack, bkram_stall;
	wire	[31:0]	bkram_data;

	// Wishbone slave definitions for bus wb, slave sram
	wire		sram_sel, sram_ack, sram_stall;
	wire	[31:0]	sram_data;

	// Wishbone slave definitions for bus wb, slave flash
	wire		flash_sel, flash_ack, flash_stall;
	wire	[31:0]	flash_data;

	// Bus zip
	// Wishbone master wire definitions for bus: zip
	wire		zip_cyc, zip_stb, zip_we, zip_stall, zip_err,
			zip_none_sel;
	reg		zip_many_ack;
	wire	[22:0]	zip_addr;
	wire	[31:0]	zip_data;
	reg	[31:0]	zip_idata;
	wire	[3:0]	zip_sel;
	reg		zip_ack;

	// Wishbone slave definitions for bus zip, slave zip_dwb
	wire		zip_dwb_sel, zip_dwb_ack, zip_dwb_stall, zip_dwb_err;
	wire	[31:0]	zip_dwb_data;

	// Bus hb
	// Wishbone master wire definitions for bus: hb
	wire		hb_cyc, hb_stb, hb_we, hb_stall, hb_err,
			hb_none_sel;
	reg		hb_many_ack;
	wire	[23:0]	hb_addr;
	wire	[31:0]	hb_data;
	reg	[31:0]	hb_idata;
	wire	[3:0]	hb_sel;
	reg		hb_ack;

	// Wishbone slave definitions for bus hb, slave hb_dwb
	wire		hb_dwb_sel, hb_dwb_ack, hb_dwb_stall, hb_dwb_err;
	wire	[31:0]	hb_dwb_data;

	// Wishbone slave definitions for bus hb, slave zip_dbg
	wire		zip_dbg_sel, zip_dbg_ack, zip_dbg_stall;
	wire	[31:0]	zip_dbg_data;


	//
	// Peripheral address decoding
	//
	//
	//
	//
	// Select lines for bus: wb
	//
	// Address width: 23
	// Data width:    32
	//
	//
	
	assign	      buserr_sel = ((wb_sio_sel)&&(wb_addr[ 2: 0] ==  3'h0));
 // 0x000000
	assign	      buspic_sel = ((wb_sio_sel)&&(wb_addr[ 2: 0] ==  3'h1));
 // 0x000004
	assign	        gpio_sel = ((wb_sio_sel)&&(wb_addr[ 2: 0] ==  3'h2));
 // 0x000008
	assign	    pwrcount_sel = ((wb_sio_sel)&&(wb_addr[ 2: 0] ==  3'h3));
 // 0x00000c
	assign	     version_sel = ((wb_sio_sel)&&(wb_addr[ 2: 0] ==  3'h4));
 // 0x000010
	assign	    bustimer_sel = ((wb_dio_sel)&&((wb_addr[ 0: 0] &  1'h1) ==  1'h0));
 // 0x000000
	assign	    watchdog_sel = ((wb_dio_sel)&&((wb_addr[ 0: 0] &  1'h1) ==  1'h1));
 // 0x000004
	assign	   flash_cfg_sel = ((wb_addr[22:19] &  4'hf) ==  4'h1); // 0x200000
	assign	   sramscope_sel = ((wb_addr[22:19] &  4'hf) ==  4'h2); // 0x400000 - 0x400007
	assign	      wb_dio_sel = ((wb_addr[22:19] &  4'hf) ==  4'h3); // 0x600000 - 0x600007
//x2	Was a master bus as well
	assign	     console_sel = ((wb_addr[22:19] &  4'hf) ==  4'h4); // 0x800000 - 0x80000f
	assign	      wb_sio_sel = ((wb_addr[22:19] &  4'hf) ==  4'h5); // 0xa00000 - 0xa0001f
//x2	Was a master bus as well
	assign	       bkram_sel = ((wb_addr[22:19] &  4'hf) ==  4'h6); // 0xc00000 - 0xc000ff
	assign	        sram_sel = ((wb_addr[22:19] &  4'hf) ==  4'h7); // 0xe00000 - 0xe1ffff
	assign	       flash_sel = ((wb_addr[22:19] &  4'h8) ==  4'h8); // 0x1000000 - 0x1ffffff
	//

	//
	//
	//
	// Select lines for bus: zip
	//
	// Address width: 23
	// Data width:    32
	//
	//
	
	assign	     zip_dwb_sel = (zip_cyc); // Only one peripheral on this bus
	//

	//
	//
	//
	// Select lines for bus: hb
	//
	// Address width: 24
	// Data width:    32
	//
	//
	
	assign	      hb_dwb_sel = ((hb_addr[23:23] &  1'h1) ==  1'h0); // 0x000000 - 0x1ffffff
//x2	Was a master bus as well
	assign	     zip_dbg_sel = ((hb_addr[23:23] &  1'h1) ==  1'h1); // 0x2000000 - 0x2000007
	//

	//
	// BUS-LOGIC for wb
	//
	assign	wb_none_sel = (wb_stb)&&({
				flash_cfg_sel,
				sramscope_sel,
				wb_dio_sel,
				console_sel,
				wb_sio_sel,
				bkram_sel,
				sram_sel,
				flash_sel} == 0);

	//
	// many_ack
	//
	// It is also a violation of the bus protocol to produce multiple
	// acks at once and on the same clock.  In that case, the bus
	// can't decide which result to return.  Worse, if someone is waiting
	// for a return value, that value will never come since another ack
	// masked it.
	//
	// The other error that isn't tested for here, no would I necessarily
	// know how to test for it, is when peripherals return values out of
	// order.  Instead, I propose keeping that from happening by
	// guaranteeing, in software, that two peripherals are not accessed
	// immediately one after the other.
	//
	always @(posedge i_clk)
		case({		flash_cfg_ack,
				sramscope_ack,
				wb_dio_ack,
				console_ack,
				wb_sio_ack,
				bkram_ack,
				sram_ack,
				flash_ack})
			8'b00000000: wb_many_ack <= 1'b0;
			8'b10000000: wb_many_ack <= 1'b0;
			8'b01000000: wb_many_ack <= 1'b0;
			8'b00100000: wb_many_ack <= 1'b0;
			8'b00010000: wb_many_ack <= 1'b0;
			8'b00001000: wb_many_ack <= 1'b0;
			8'b00000100: wb_many_ack <= 1'b0;
			8'b00000010: wb_many_ack <= 1'b0;
			8'b00000001: wb_many_ack <= 1'b0;
			default: wb_many_ack <= (wb_cyc);
		endcase

	assign	wb_sio_stall = 1'b0;
	initial r_wb_sio_ack = 1'b0;
	always	@(posedge i_clk)
		r_wb_sio_ack <= (wb_stb)&&(wb_sio_sel);
	assign	wb_sio_ack = r_wb_sio_ack;
	reg	r_wb_sio_ack;
	reg	[31:0]	r_wb_sio_data;
	always	@(posedge i_clk)
		// mask        = 00000007
		// lgdw        = 2
		// unused_lsbs = 0
		casez( wb_addr[2:0] )
			3'h0: r_wb_sio_data <= buserr_data;
			3'h1: r_wb_sio_data <= buspic_data;
			3'h2: r_wb_sio_data <= gpio_data;
			3'h3: r_wb_sio_data <= pwrcount_data;
			default: r_wb_sio_data <= version_data;
		endcase
	assign	wb_sio_data = r_wb_sio_data;

	assign	wb_dio_stall = 1'b0;
	reg	[1:0]	r_wb_dio_ack;
	always	@(posedge i_clk)
		r_wb_dio_ack <= { r_wb_dio_ack[0], (wb_stb)&&(wb_dio_sel) };
	assign	wb_dio_ack = r_wb_dio_ack[1];
	reg	[31:0]	r_wb_dio_data;
	always	@(posedge i_clk)
		casez({		bustimer_ack	}) // watchdog default
			1'b1: r_wb_dio_data <= bustimer_data;
			default: r_wb_dio_data <= watchdog_data;

		endcase
	assign	wb_dio_data = r_wb_dio_data;

	//
	// Finally, determine what the response is from the wb bus
	// bus
	//
	//
	//
	// wb_ack
	//
	// The returning wishbone ack is equal to the OR of every component that
	// might possibly produce an acknowledgement, gated by the CYC line.
	//
	// To return an ack here, a component must have a @SLAVE.TYPE tag.
	// Acks from any @SLAVE.TYPE of SINGLE and DOUBLE components have been
	// collected together (above) into wb_sio_ack and wb_dio_ack
	// respectively, which will appear ahead of any other device acks.
	//
	always @(posedge i_clk)
		wb_ack <= (wb_cyc)&&(|{ flash_cfg_ack,
				sramscope_ack,
				wb_dio_ack,
				console_ack,
				wb_sio_ack,
				bkram_ack,
				sram_ack,
				flash_ack });
	//
	// wb_idata
	//
	// This is the data returned on the bus.  Here, we select between a
	// series of bus sources to select what data to return.  The basic
	// logic is simply this: the data we return is the data for which the
	// ACK line is high.
	//
	// The last item on the list is chosen by default if no other ACK's are
	// true.  Although we might choose to return zeros in that case, by
	// returning something we can skimp a touch on the logic.
	//
	// Any peripheral component with a @SLAVE.TYPE value will be listed
	// here.
	//
	always @(posedge i_clk)
	begin
		casez({		flash_cfg_ack,
				sramscope_ack,
				wb_dio_ack,
				console_ack,
				wb_sio_ack,
				bkram_ack,
				sram_ack	})
			7'b1??????: wb_idata <= flash_cfg_data;
			7'b01?????: wb_idata <= sramscope_data;
			7'b001????: wb_idata <= wb_dio_data;
			7'b0001???: wb_idata <= console_data;
			7'b00001??: wb_idata <= wb_sio_data;
			7'b000001?: wb_idata <= bkram_data;
			7'b0000001: wb_idata <= sram_data;
			default: wb_idata <= flash_data;
		endcase
	end
	assign	wb_stall =	((flash_cfg_sel)&&(flash_cfg_stall))
				||((sramscope_sel)&&(sramscope_stall))
				||((wb_dio_sel)&&(wb_dio_stall))
				||((console_sel)&&(console_stall))
				||((wb_sio_sel)&&(wb_sio_stall))
				||((bkram_sel)&&(bkram_stall))
				||((sram_sel)&&(sram_stall))
				||((flash_sel)&&(flash_stall));

	assign wb_err = ((wb_stb)&&(wb_none_sel))||(wb_many_ack);
	//
	// BUS-LOGIC for zip
	//
	assign	zip_none_sel = 1'b0;
	always @(*)
		zip_many_ack = 1'b0;
	assign	zip_err = zip_dwb_err;
	assign	zip_stall = zip_dwb_stall;
	always @(*)
		zip_ack = zip_dwb_ack;
	always @(*)
		zip_idata = zip_dwb_data;
	//
	// BUS-LOGIC for hb
	//
	assign	hb_none_sel = (hb_stb)&&({
				hb_dwb_sel,
				zip_dbg_sel} == 0);

	//
	// many_ack
	//
	// It is also a violation of the bus protocol to produce multiple
	// acks at once and on the same clock.  In that case, the bus
	// can't decide which result to return.  Worse, if someone is waiting
	// for a return value, that value will never come since another ack
	// masked it.
	//
	// The other error that isn't tested for here, no would I necessarily
	// know how to test for it, is when peripherals return values out of
	// order.  Instead, I propose keeping that from happening by
	// guaranteeing, in software, that two peripherals are not accessed
	// immediately one after the other.
	//
	always @(posedge i_clk)
		case({		hb_dwb_ack,
				zip_dbg_ack})
			2'b00: hb_many_ack <= 1'b0;
			2'b10: hb_many_ack <= 1'b0;
			2'b01: hb_many_ack <= 1'b0;
			default: hb_many_ack <= (hb_cyc);
		endcase

	//
	// Finally, determine what the response is from the hb bus
	// bus
	//
	//
	//
	// hb_ack
	//
	// The returning wishbone ack is equal to the OR of every component that
	// might possibly produce an acknowledgement, gated by the CYC line.
	//
	// To return an ack here, a component must have a @SLAVE.TYPE tag.
	// Acks from any @SLAVE.TYPE of SINGLE and DOUBLE components have been
	// collected together (above) into hb_sio_ack and hb_dio_ack
	// respectively, which will appear ahead of any other device acks.
	//
	always @(posedge i_clk)
		hb_ack <= (hb_cyc)&&(|{ hb_dwb_ack,
				zip_dbg_ack });
	//
	// hb_idata
	//
	// This is the data returned on the bus.  Here, we select between a
	// series of bus sources to select what data to return.  The basic
	// logic is simply this: the data we return is the data for which the
	// ACK line is high.
	//
	// The last item on the list is chosen by default if no other ACK's are
	// true.  Although we might choose to return zeros in that case, by
	// returning something we can skimp a touch on the logic.
	//
	// Any peripheral component with a @SLAVE.TYPE value will be listed
	// here.
	//
	always @(posedge i_clk)
		if (hb_dwb_ack)
			hb_idata <= hb_dwb_data;
		else
			hb_idata <= zip_dbg_data;
	assign	hb_stall =	((hb_dwb_sel)&&(hb_dwb_stall))
				||((zip_dbg_sel)&&(zip_dbg_stall));

	assign hb_err = ((hb_stb)&&(hb_none_sel))||(hb_many_ack)||((hb_dwb_err));
	//
	// Declare the interrupt busses
	//
	// Interrupt busses are defined by anything with a @PIC tag.
	// The @PIC.BUS tag defines the name of the wire bus below,
	// while the @PIC.MAX tag determines the size of the bus width.
	//
	// For your peripheral to be assigned to this bus, it must have an
	// @INT.NAME.WIRE= tag to define the wire name of the interrupt line,
	// and an @INT.NAME.PIC= tag matching the @PIC.BUS tag of the bus
	// your interrupt will be assigned to.  If an @INT.NAME.ID tag also
	// exists, then your interrupt will be assigned to the position given
	// by the ID# in that tag.
	//
	assign	cpu_reset_bus = {
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		watchdog_reset,
		i_reset
	};
	assign	bus_int_vector = {
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		1'b0,
		uartrxf_int,
		uarttxf_int,
		gpio_int,
		bustimer_int
	};


	//
	//
	// Now we turn to defining all of the parts and pieces of what
	// each of the various peripherals does, and what logic it needs.
	//
	// This information comes from the @MAIN.INSERT and @MAIN.ALT tags.
	// If an @ACCESS tag is available, an ifdef is created to handle
	// having the access and not.  If the @ACCESS tag is `defined above
	// then the @MAIN.INSERT code is executed.  If not, the @MAIN.ALT
	// code is exeucted, together with any other cleanup settings that
	// might need to take place--such as returning zeros to the bus,
	// or making sure all of the various interrupt wires are set to
	// zero if the component is not included.
	//
`ifdef	SRAM_ACCESS
	sramdev #(.WBADDR(17-2))
		srami(i_clk,
			(wb_cyc), (wb_stb)&&(sram_sel), wb_we,
				wb_addr[(17-3):0], wb_data, wb_sel,
				sram_ack, sram_stall, sram_data,
			o_ram_ce_n, o_ram_oe_n, o_ram_we_n, o_ram_addr,
				o_ram_data, o_ram_sel, i_ram_data);
`else	// SRAM_ACCESS

	// In the case that there is no sram peripheral responding on the wb bus
	reg	r_sram_ack;
	initial	r_sram_ack = 1'b0;
	always @(posedge i_clk)	r_sram_ack <= (wb_stb)&&(sram_sel);
	assign	sram_ack   = r_sram_ack;
	assign	sram_stall = 0;
	assign	sram_data  = 0;

`endif	// SRAM_ACCESS

	assign	flash_cfg_data  = flash_data;
	assign	flash_cfg_stall = flash_stall;
	assign	flash_cfg_ack   = 1'b0;
`ifdef	WATCHDOG_ACCESS
	ziptimer #(.VW(16), .RELOADABLE(0))
		watchdogi(i_clk, i_reset, 1'b1,
			wb_cyc, (wb_stb)&&(watchdog_sel), wb_we, wb_data,
				watchdog_ack, watchdog_stall,
				watchdog_data, watchdog_reset);
`else	// WATCHDOG_ACCESS

	// In the case that there is no watchdog peripheral responding on the wb bus
	reg	r_watchdog_ack;
	initial	r_watchdog_ack = 1'b0;
	always @(posedge i_clk)	r_watchdog_ack <= (wb_stb)&&(watchdog_sel);
	assign	watchdog_ack   = r_watchdog_ack;
	assign	watchdog_stall = 0;
	assign	watchdog_data  = 0;

	assign	i_reset = 1'b0;	// watchdog.INT.RESET.WIRE
	assign	watchdog_reset = 1'b0;	// watchdog.INT.WATCHDOG.WIRE
`endif	// WATCHDOG_ACCESS

	always @(posedge i_clk)
		cpu_reset <= (|cpu_reset_bus);
`ifdef	BUSTIMER_ACCESS
	ziptimer #(.VW(16))
		bustimeri(i_clk, i_reset, 1'b1,
			wb_cyc, (wb_stb)&&(bustimer_sel), wb_we, wb_data,
				bustimer_ack, bustimer_stall,
				bustimer_data, bustimer_int);
`else	// BUSTIMER_ACCESS

	// In the case that there is no bustimer peripheral responding on the wb bus
	reg	r_bustimer_ack;
	initial	r_bustimer_ack = 1'b0;
	always @(posedge i_clk)	r_bustimer_ack <= (wb_stb)&&(bustimer_sel);
	assign	bustimer_ack   = r_bustimer_ack;
	assign	bustimer_stall = 0;
	assign	bustimer_data  = 0;

	assign	bustimer_int = 1'b0;	// bustimer.INT.BUSTIMER.WIRE
`endif	// BUSTIMER_ACCESS

`ifdef	INCLUDE_ZIPCPU
	//
	//
	// The ZipCPU/ZipSystem BUS master
	//
	//
	zipbones #(RESET_ADDRESS,ZIP_ADDRESS_WIDTH,ZIP_LGCACHE_SZ,
			ZIP_START_HALTED)
		swic(i_clk, cpu_reset,
			// Zippys wishbone interface
			zip_cyc, zip_stb, zip_we, zip_addr, zip_data, zip_sel,
					zip_ack, zip_stall, zip_idata, zip_err,
			w_bus_int, zip_cpu_int,
			// Debug wishbone interface
			(hb_cyc), ((hb_stb)&&(zip_dbg_sel)),hb_we,
			hb_addr[0],
			hb_data, zip_dbg_ack, zip_dbg_stall, zip_dbg_data,
			zip_debug);
	assign	zip_trigger = zip_debug[0];
`else	// INCLUDE_ZIPCPU

	// In the case that nothing drives the zip bus ...
	assign	zip_cyc = 1'b0;
	assign	zip_stb = 1'b0;
	assign	zip_we  = 1'b0;
	assign	zip_sel = 0;
	assign	zip_addr= 0;
	assign	zip_data= 0;
	// verilator lint_off UNUSED
	wire	[35:0]	unused_bus_zip;
	assign	unused_bus_zip = { zip_ack, zip_stall, zip_err, zip_data };
	// verilator lint_on  UNUSED

	assign	zip_cpu_int = 1'b0;	// zip.INT.ZIP.WIRE
`endif	// INCLUDE_ZIPCPU

	always @(posedge i_clk)
		if (wb_err)
			r_buserr_addr <= wb_addr;
	assign	buserr_data = { {(32-2-23){1'b0}},
			r_buserr_addr, 2'b00 };
`ifdef	BUSPIC_ACCESS
	//
	// The BUS Interrupt controller
	//
	icontrol #(15)	buspici(i_clk, 1'b0, (wb_stb)&&(buspic_sel),
			wb_data, buspic_data, bus_int_vector, w_bus_int);
`else	// BUSPIC_ACCESS

	// In the case that there is no buspic peripheral responding on the wb bus
	reg	r_buspic_ack;
	initial	r_buspic_ack = 1'b0;
	always @(posedge i_clk)	r_buspic_ack <= (wb_stb)&&(buspic_sel);
	assign	buspic_ack   = r_buspic_ack;
	assign	buspic_stall = 0;
	assign	buspic_data  = 0;

	assign	w_bus_int = 1'b0;	// buspic.INT.BUS.WIRE
`endif	// BUSPIC_ACCESS

`ifdef	FLASH_SCOPE
	wire	[31:0]	sram_debug;
	wire		sramscope_int;

	assign	sram_debug = { (!o_ram_ce_n),
			wb_cyc, (wb_stb)&&(sram_sel), wb_we,
				sram_stall,sram_ack,
				o_ram_ce_n, o_ram_oe_n, o_ram_we_n, o_ram_sel,
				o_ram_addr[4:0],
				(!o_ram_oe_n) ? i_ram_data[15:0]
						: o_ram_data[15:0]
				};
	wbscope #(.LGMEM(4), .SYNCHRONOUS(1), .HOLDOFFBITS(4))
		sramscopei(i_clk, 1'b1, (!o_ram_ce_n), sram_debug,
			i_clk, wb_cyc, (wb_stb)&&(sramscope_sel),
			wb_we, wb_addr[0], wb_data,
			sramscope_ack, sramscope_stall, sramscope_data,
			sramscope_int);
`else	// FLASH_SCOPE

	// In the case that there is no sramscope peripheral responding on the wb bus
	reg	r_sramscope_ack;
	initial	r_sramscope_ack = 1'b0;
	always @(posedge i_clk)	r_sramscope_ack <= (wb_stb)&&(sramscope_sel);
	assign	sramscope_ack   = r_sramscope_ack;
	assign	sramscope_stall = 0;
	assign	sramscope_data  = 0;

`endif	// FLASH_SCOPE

	initial	r_pwrcount_data = 32'h0;
	always @(posedge i_clk)
	if (r_pwrcount_data[31])
		r_pwrcount_data[30:0] <= r_pwrcount_data[30:0] + 1'b1;
	else
		r_pwrcount_data[31:0] <= r_pwrcount_data[31:0] + 1'b1;
	assign	pwrcount_data = r_pwrcount_data;
`ifdef	GPIO_ACCESS
	//
	// GPIO
	//
	// This interface should allow us to control up to 16 GPIO inputs, and
	// another 16 GPIO outputs.  The interrupt trips when any of the inputs
	// changes.  (Sorry, which input isn't (yet) selectable.)
	//
	localparam	INITIAL_GPIO = 11'h0;
	wbgpio	#(NGPI, NGPO, INITIAL_GPIO)
		gpioi(i_clk, 1'b1, (wb_stb)&&(gpio_sel), 1'b1,
			wb_data, gpio_data, i_gpio, o_gpio,
			gpio_int);
`else	// GPIO_ACCESS

	// In the case that there is no gpio peripheral responding on the wb bus
	reg	r_gpio_ack;
	initial	r_gpio_ack = 1'b0;
	always @(posedge i_clk)	r_gpio_ack <= (wb_stb)&&(gpio_sel);
	assign	gpio_ack   = r_gpio_ack;
	assign	gpio_stall = 0;
	assign	gpio_data  = 0;

	assign	gpio_int = 1'b0;	// gpio.INT.GPIO.WIRE
`endif	// GPIO_ACCESS

`ifdef	BKRAM_ACCESS
	memdev #(.LGMEMSZ(8), .EXTRACLOCK(1))
		bkrami(i_clk, 1'b0,
			(wb_cyc), (wb_stb)&&(bkram_sel), wb_we,
				wb_addr[(8-3):0], wb_data, wb_sel,
				bkram_ack, bkram_stall, bkram_data);
`else	// BKRAM_ACCESS

	// In the case that there is no bkram peripheral responding on the wb bus
	reg	r_bkram_ack;
	initial	r_bkram_ack = 1'b0;
	always @(posedge i_clk)	r_bkram_ack <= (wb_stb)&&(bkram_sel);
	assign	bkram_ack   = r_bkram_ack;
	assign	bkram_stall = 0;
	assign	bkram_data  = 0;

`endif	// BKRAM_ACCESS

	assign	version_data = `DATESTAMP;
	assign	version_ack = 1'b0;
	assign	version_stall = 1'b0;
`ifdef	BUSCONSOLE_ACCESS
	console consolei(i_clk, 1'b0,
 			wb_cyc, (wb_stb)&&(console_sel), wb_we,
				wb_addr[1:0], wb_data,
 			console_ack, console_stall, console_data,
			w_console_tx_stb, w_console_tx_data, w_console_busy,
			w_console_rx_stb, w_console_rx_data,
			uartrx_int, uarttx_int, uartrxf_int, uarttxf_int);
`else	// BUSCONSOLE_ACCESS
	assign	w_console_tx_stb  = 1'b0;
	assign	w_console_tx_data = 7'h7f;

	// In the case that there is no console peripheral responding on the wb bus
	reg	r_console_ack;
	initial	r_console_ack = 1'b0;
	always @(posedge i_clk)	r_console_ack <= (wb_stb)&&(console_sel);
	assign	console_ack   = r_console_ack;
	assign	console_stall = 0;
	assign	console_data  = 0;

	assign	uarttxf_int = 1'b0;	// console.INT.UARTTXF.WIRE
	assign	uartrxf_int = 1'b0;	// console.INT.UARTRXF.WIRE
	assign	uarttx_int = 1'b0;	// console.INT.UARTTX.WIRE
	assign	uartrx_int = 1'b0;	// console.INT.UARTRX.WIRE
`endif	// BUSCONSOLE_ACCESS

`ifdef	INCLUDE_ZIPCPU
	//
	//
	// And an arbiter to decide who gets access to the bus
	//
	//
	// Clock speed = 50000000 Hz
	wbpriarbiter #(32,23)	bus_arbiter(i_clk,
		// The Zip CPU bus master --- gets the priority slot
		zip_cyc, zip_stb, zip_we, zip_addr, zip_data, zip_sel,
			zip_ack, zip_stall, zip_err,
		// The UART interface master
		(hb_cyc),
			(hb_stb)&&(hb_dwb_sel),
			hb_we,
			hb_addr[(23-1):0],
			hb_data, hb_sel,
			hb_dwb_ack, hb_dwb_stall, hb_dwb_err,
		// Common bus returns
		hb_dwbi_cyc, hb_dwbi_stb, hb_dwbi_we, hb_dwbi_addr, hb_dwbi_odata, hb_dwbi_sel,
			hb_dwbi_ack, hb_dwbi_stall, hb_dwbi_err);

	// And because the ZipCPU and the Arbiter can create an unacceptable
	// delay, we often fail timing.  So, we add in a delay cycle
`else
	// If no ZipCPU, no delay arbiter is needed
	assign	hb_dwbi_cyc   = hb_cyc;
	assign	hb_dwbi_stb   = hb_stb;
	assign	hb_dwbi_we    = hb_we;
	assign	hb_dwbi_addr  = hb_addr[(23-1):0];
	assign	hb_dwbi_odata = hb_data;
	assign	hb_dwbi_sel   = hb_sel;
	assign	hb_dwb_ack    = hb_dwbi_ack;
	assign	hb_dwb_stall  = hb_dwbi_stall;
	assign	hb_dwb_err    = hb_dwbi_err;
	assign	hb_dwb_data   = hb_dwbi_idata;
`endif	// INCLUDE_ZIPCPU

`ifdef	WBUBUS_MASTER
`ifdef	INCLUDE_ZIPCPU
`define	BUS_DELAY_NEEDED
`endif
`endif
`ifdef	BUS_DELAY_NEEDED
	busdelay #(23)	hb_dwbi_delay(i_clk, i_reset,
		hb_dwbi_cyc, hb_dwbi_stb, hb_dwbi_we, hb_dwbi_addr, hb_dwbi_odata, hb_dwbi_sel,
			hb_dwbi_ack, hb_dwbi_stall, hb_dwbi_idata, hb_dwbi_err,
		wb_cyc, wb_stb, wb_we, wb_addr, wb_data, wb_sel,
			wb_ack, wb_stall, wb_idata, wb_err);
`else
	// If one of the two, the ZipCPU or the WBUBUS, isn't here, then we
	// don't need the bus delay, and we can go directly from the bus driver
	// to the bus itself
	//
	assign	wb_cyc    = hb_dwbi_cyc;
	assign	wb_stb    = hb_dwbi_stb;
	assign	wb_we     = hb_dwbi_we;
	assign	wb_addr   = hb_dwbi_addr;
	assign	wb_data   = hb_dwbi_odata;
	assign	wb_sel    = hb_dwbi_sel;
	assign	hb_dwbi_ack   = wb_ack;
	assign	hb_dwbi_stall = wb_stall;
	assign	hb_dwbi_err   = wb_err;
	assign	hb_dwbi_idata = wb_idata;
`endif
	assign	hb_dwb_data = hb_dwbi_idata;
`ifdef	INCLUDE_ZIPCPU
	assign	zip_dwb_data = hb_dwbi_idata;
`endif
`ifdef	FLASH_ACCESS
	spixpress flashi(i_clk, i_reset,
			(wb_cyc),
				(wb_stb)&&(flash_sel),
				(wb_stb)&&(flash_cfg_sel), wb_we,
				wb_addr[(24-3):0],
				wb_data,
			flash_stall, flash_ack, flash_data,
			o_spi_cs_n, o_spi_sck, o_spi_mosi, i_spi_miso);
`else	// FLASH_ACCESS
	assign	o_spi_cs_n = 1'b1;
	assign	o_spi_sck  = 1'b0;
	assign	o_spi_mosi = 1'b1;

	// In the case that there is no flash peripheral responding on the wb bus
	reg	r_flash_ack;
	initial	r_flash_ack = 1'b0;
	always @(posedge i_clk)	r_flash_ack <= (wb_stb)&&(flash_sel);
	assign	flash_ack   = r_flash_ack;
	assign	flash_stall = 0;
	assign	flash_data  = 0;

`endif	// FLASH_ACCESS

`ifdef	WBUBUS_MASTER
	// Parallel port logic
	pport	hbi_pp(i_clk,
			pp_rx_stb, pp_rx_data,
			pp_tx_stb, pp_tx_data, pp_tx_busy,
			i_pp_dir, i_pp_clk, i_pp_data, o_pp_data,
				o_pp_clkfb, o_pp_dbg);
`ifndef	BUSPIC_ACCESS
	wire	w_bus_int;
	assign	w_bus_int = 1'b0;
`endif
	wire	[29:0]	hb_tmp_addr;
	hbconsole genbus(i_clk, pp_rx_stb, pp_rx_data,
			hb_cyc, hb_stb, hb_we, hb_tmp_addr, hb_data, hb_sel,
			hb_ack, hb_stall, hb_err, hb_idata,
			w_bus_int,
			pp_tx_stb, pp_tx_data, pp_tx_busy,
			//
			w_console_tx_stb, w_console_tx_data, w_console_busy,
			w_console_rx_stb, w_console_rx_data);
	assign	hb_sel = 4'hf;
	assign	hb_addr= hb_tmp_addr[(24-1):0];
`else	// WBUBUS_MASTER

	// In the case that nothing drives the hb bus ...
	assign	hb_cyc = 1'b0;
	assign	hb_stb = 1'b0;
	assign	hb_we  = 1'b0;
	assign	hb_sel = 0;
	assign	hb_addr= 0;
	assign	hb_data= 0;
	// verilator lint_off UNUSED
	wire	[35:0]	unused_bus_hb;
	assign	unused_bus_hb = { hb_ack, hb_stall, hb_err, hb_data };
	// verilator lint_on  UNUSED

`endif	// WBUBUS_MASTER

	//
	//
	//


endmodule // main.v
