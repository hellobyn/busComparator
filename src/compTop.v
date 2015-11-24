/*****************************************************************************************
** 
**                               		北京交通大学                                     
**
**----------------------------------------------------------------------------------------
** 	文件名：			compTop.v
** 	创建时间：		2015-11-23 20:40
** 	创建人员： 		赵秉贤
** 	文件描述：  		总线数据比较器顶层例化文件
** 
**----------------------------------------------------------------------------------------
** 	最后修改时间：	2015-11-23 20:40 
** 	最后修改人员：	赵秉贤
** 	版本号：	   	V2.0
** 	版本描述：		例化二取二总线比较器所有模块 可综合
**
*****************************************************************************************/
`timescale 1 ns/ 1 ps

module compTop
(
	input rst,
	input clk,
	input dataEn1,
	input dataEn2,
	input [63:0] dataIn1_1, 
	input [63:0] dataIn2_1,
	input order_1, 
	input order_2,
	output relayCtrl_1,
	output relayCtrl_2,
	output switchCtrl_1,
	output switchCtrl_2
);	
	
	wire clk2, clk4, clk8, clk16, clkPls;
	
	
	
	wire [1:0] crcStatus1_1, crcStatus2_1, compStatus_1, outputStatus_1;
	wire crcEn1_1, crcEn2_1, compEn_1, outputEn_1;
	wire [7:0] modStatus_1;
	wire [63:0] data1_1, data2_1;
	//	wire relayCtrl_1, switchCtrl_1;						/*	这些注释为输出管脚，不输出的话取消注释		*/

	wire crc8En1_1, crc8En2_1;
	wire crcRst1_1, crcRst2_1;
	wire [15:0] crcOut1_1, crcOut2_1;
	wire [7:0] dataCache1_1, dataCache2_1;	
//	wire relayCtrl_2, switchCtrl_2;
  
  
  
  
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
		.data2(data2_1)
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
		.data2(data2_2)
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
endmodule