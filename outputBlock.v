/*****************************************************************************************
** 
**                               		北京交通大学                                     
**
**----------------------------------------------------------------------------------------
** 	文件名：			outputBlock.v
** 	创建时间：		2015-9-11 10:30
** 	创建人员： 		赵秉贤
** 	文件描述：  		比较器输出单元
** 
**----------------------------------------------------------------------------------------
** 	最后修改时间：	2015-9-11 10:30
** 	最后修改人员：	赵秉贤
** 	版本号：	   	V1.0
** 	版本描述：		最终输出单元，接输出板电源开关
**
*****************************************************************************************/

`timescale 1ps / 1ps

module outputBlock
(
	input clk,
	input rst,
	input relayCtrl1,
	input relayCtrl2,
	input switchCtrl1,
	input switchCtrl2,
	output relayEn,
	output switchEn
)

	wire relayCtrl;
	reg [4:0] clkCount1;
	reg [4:0] clkCount1;
	reg [3:0] clkPeak1;
	reg [3:0] clkPeak2;
	
	assign clkPeak1 = switchCtrl1 ? 4'd1 : 4'd15;
	assign clkPeak2 = switchCtrl2 ? 4'd15 : 4'd1;
	assign relayCtrl = relayCtrl1 ^ relayCtrl2;
	
	always @(posedge clk)
	begin
		if(rst)
		begin
			relayEn <= 1;
		end
		else
		begin
			relayEn <= relayCtrl ? 1 : 0; 
		end
	end
	
	always @(negedge clk)
	begin
		if(rst)
		begin
			switchEn <= 1;
			clkCount1 <= 0;
			clkCount2 <= 0;
		end
		else
		begin
			switchEn <= ((clkCount1 <= clkPeak1) && (clkCount2 <= clkPeak2)) ? 0 : 1;
			clkCount1 <= clkCount1 + 1'b1;
			clkCount2 <= clkCount2 + 1'b1;
		end
	end
	
	always @(posedge switchCtrl1 or negedge switchCtrl1) //跳变沿计数清零
	begin
		clkCount1 <= 0;
	end
	
	always @(posedge switchCtrl2 or negedge switchCtrl2)
	begin
		clkCount2 <= 0;
	end
	
	
	
	
	
	
	
	
	
	
	