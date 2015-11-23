// Copyright (C) 1991-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, the Altera Quartus II License Agreement,
// the Altera MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Altera and sold by Altera or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// *****************************************************************************
// This file contains a Verilog test bench template that is freely editable to  
// suit user's needs .Comments are provided in each section to help the user    
// fill out necessary details.                                                  
// *****************************************************************************
// Generated on "04/30/2015 15:32:57"
                                                                                
// Verilog Test Bench template for design : Test
// 
// Simulation tool : ModelSim (Verilog)
// 

	`timescale 1 ns/ 1 ps
//	`include "CRC16D8.v"
module compTest;
	  
	reg rst;
	reg	clk;
	reg dataEn1,dataEn2;
	reg [63:0] dataIn1_1, dataIn2_1;
	reg order_1, order_2;
	
	
	
	wire clk2, clk4, clk8, clk16, clkPls;
	
	
	
	wire [1:0] crcStatus1_1, crcStatus2_1, compStatus_1, outputStatus_1;
	wire crcEn1, crcEn2_1, compEn_1, outputEn_1;
	wire [7:0] modStatus_1;
	wire [63:0] data1_1, data2_1;
	wire relayCtrl_1, switchCtrl_1;
	wire dataReady1;

	wire crc8En1_1, crc8En2_1;
	wire crcRst1_1, crcRst2_1;
	wire [15:0] crcOut1_1, crcOut2_1;
	wire [7:0] dataCache1_1, dataCache2_1;	
	wire relayCtrl_2, switchCtrl_2;
	wire dataReady2;
  
  
  
  
	reg [63:0] dataIn1_2, dataIn2_2;
	wire [1:0] crcStatus1_2, crcStatus2_2, compStatus_2, outputStatus_2;
	wire crcEn1_2, crcEn2_2, compEn_2, outputEn_2;
	wire [7:0] modStatus_2;
	wire [63:0] data1_2, data2_2;

	wire crc8En1_2, crc8En2_2;
	wire crcRst1_2, crcRst2_2;
	wire [15:0] crcOut1_2, crcOut2_2;
	wire [7:0] dataCache1_2, dataCache2_2;	
  
	wire relayEn, switchEn;
	                       
	CRC16D8 CRC16D8_1 
	(   
		.dataIn(dataCache1_1),
		.crcEn(crc8En1_1),
		.rst(crcRst1_1),
		.clk(clk),
		.crcOut(crcOut1_1)
	);

	CRC16D8 CRC16D8_2 
	(   
		.dataIn(dataCache2_1),
		.crcEn(crc8En2_1),
		.rst(crcRst2_1),
		.clk(clk),
		.crcOut(crcOut2_1)
	);
	
	CRC16D8 CRC16D8_3 
	(   
		.dataIn(dataCache1_2),
		.crcEn(crc8En1_2),
		.rst(crcRst1_2),
		.clk(clk),
		.crcOut(crcOut1_2)
	);

	CRC16D8 CRC16D8_4 
	(   
		.dataIn(dataCache2_2),
		.crcEn(crc8En2_2),
		.rst(crcRst2_2),
		.clk(clk),
		.crcOut(crcOut2_2)
	);
	
	CRC16D64 CRC16D64_1
	(
		.clk(clk),
		.rst(crcEn1_1),
		.dataIn(data1_1),
		.crcOut(crcOut1_1),
		.crcRst(crcRst1_1),
		.crc8En(crc8En1_1),
		.crcStatus(crcStatus1_1),
		.dataCache(dataCache1_1)
	);
  
	
	CRC16D64 CRC16D64_2
	(
		.clk(clk),
		.rst(crcEn2_1),
		.dataIn(data2_1),
		.crcOut(crcOut2_1),
		.crcRst(crcRst2_1),
		.crc8En(crc8En2_1),
		.crcStatus(crcStatus2_1),
		.dataCache(dataCache2_1)
	);
	CRC16D64 CRC16D64_3
	(
		.clk(clk),
		.rst(crcEn1_2),
		.dataIn(data1_2),
		.crcOut(crcOut1_2),
		.crcRst(crcRst1_2),
		.crc8En(crc8En1_2),
		.crcStatus(crcStatus1_2),
		.dataCache(dataCache1_2)
	);
  
	
	CRC16D64 CRC16D64_4
	(
		.clk(clk),
		.rst(crcEn2_2),
		.dataIn(data2_2),
		.crcOut(crcOut2_2),
		.crcRst(crcRst2_2),
		.crc8En(crc8En2_2),
		.crcStatus(crcStatus2_2),
		.dataCache(dataCache2_2)
	);
  
	clkDiv clkDiv_0
	(
		.clk(clk),
		.rst(rst),
		.clk2(clk2),
		.clk4(clk4),
		.clk8(clk8),
		.clk16(clk16),
		.clkPls(clkPls)
	);
  
	compCtrl compCtrl_1
	(
		.clk(clk),
		.rst(rst),
		.dataEn1(dataEn1),
		.dataEn2(dataEn2),
		.dataIn1(dataIn1_1),
		.dataIn2(dataIn2_1),
		.crcStatus1(crcStatus1_1),
		.crcStatus2(crcStatus2_1),
		.compStatus(compStatus_1),
		.outputStatus(outputStatus_1),
		.crcEn1(crcEn1_1),
		.crcEn2(crcEn2_1),
		.compEn(compEn_1),
		.outputEn(outputEn_1),
		.modStatus(modStatus_1),
		.data1(data1_1),
		.data2(data2_1),
		.dataReady(dataReady1)
	);

	compCtrl compCtrl_2
	(
		.clk(clk),
		.rst(rst),
		.dataEn1(dataEn1),
		.dataEn2(dataEn2),
		.dataIn1(dataIn1_2),
		.dataIn2(dataIn2_2),
		.crcStatus1(crcStatus1_2),
		.crcStatus2(crcStatus2_2),
		.compStatus(compStatus_2),
		.outputStatus(outputStatus_2),
		.crcEn1(crcEn1_2),
		.crcEn2(crcEn2_2),
		.compEn(compEn_2),
		.outputEn(outputEn_2),
		.modStatus(modStatus_2),
		.data1(data1_2),
		.data2(data2_2),
		.dataReady(dataReady2)
	);

	compD48 compD48_1
	(
		.clk(clk),
		.rst(compEn_1),
		.dataIn1(data1_1),
		.dataIn2(data2_1),
		.compStatus(compStatus_1)
	);

	compD48 compD48_2
	(
		.clk(clk),
		.rst(compEn_2),
		.dataIn1(data1_2),
		.dataIn2(data2_2),
		.compStatus(compStatus_2)
	);

	outputCtrl outputCtrl_1
	(
		.clk1(clk),
		.clk2(clk4),
		.clk3(clkPls),
		.rst(rst),
		.order(order_1),
		.outputEn1(outputEn_1),
		.outputEn2(outputEn_2),
		.modStatus1(modStatus_1),
		.modStatus2(modStatus_2),
		.dataReady(dataReady1),
		.outputStatus(outputStatus_1),
		.relayCtrl(relayCtrl_1),
		.switchCtrl(switchCtrl_1)
	);

	outputCtrl outputCtrl_2
	(
		.clk1(clk),
		.clk2(clk4),
		.clk3(clkPls),
		.rst(rst),
		.order(order_2),
		.outputEn1(outputEn_1),
		.outputEn2(outputEn_2),
		.modStatus1(modStatus_1),
		.modStatus2(modStatus_2),
		.dataReady(dataReady2),
		.outputStatus(outputStatus_2),
		.relayCtrl(relayCtrl_2),
		.switchCtrl(switchCtrl_2)
	);

	outputBlock outputBlock_0
	(
		.clk(clk2),
		.rst(rst),
		.relayCtrl1(relayCtrl_1),
		.relayCtrl2(relayCtrl_2),
		.switchCtrl1(switchCtrl_1),
		.switchCtrl2(switchCtrl_2),
		.relayEn(relayEn),
		.switchEn(switchEn)
	);


	
	initial
		begin
			clk = 0;
			while(1)
				#10 clk = !clk;
		end
		
	initial
	 	begin
			rst = 1;	
			dataEn1 = 0;	   	
			dataEn2 = 0;
			
			order_1 = 0;
			order_2 = 1;
	 
	//    	data = 64'h123456789123228F;
			#115 rst = 0;
		  
			dataIn1_1 = 64'h123456789abcf407;
			dataIn2_1 = 64'h123456789abcf407;
		  
			dataIn1_2 = 64'h123456789abcf407;
			dataIn2_2 = 64'h123456789abcf407;
		  
		 
			#10 dataEn1 = 1;  	  
			#10 dataEn2 = 1;
		end
endmodule