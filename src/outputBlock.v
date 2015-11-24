/*****************************************************************************************
** 
**                               		北京交通大学                                     
**
**----------------------------------------------------------------------------------------
** 	文件名：			outputBlock.v
** 	创建时间：		2015-9-11 10:30
** 	创建人员：		赵秉贤
** 	文件描述：		比较器输出单元：判断输出有效性，并使能或失能输出
**							本单元为输模块的仿真描述，需要真实硬件实现
** 
**----------------------------------------------------------------------------------------
** 	最后修改时间：	2015-11-24 20:45
** 	最后修改人员：	赵秉贤
** 	版本号：	   	V2.0
** 	版本描述：		最终输出单元，接输出板电源开关 可综合
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
	output reg relayEn,
	output reg switchEn
);

	wire relayCtrl;
	reg [4:0] clkCount1H;
	reg [4:0] clkCount1L;
	reg [4:0] clkCount2H;
	reg [4:0] clkCount2L;
//	wire [4:0] clkPeak1;
//	wire [4:0] clkPeak2;
	
//	assign clkPeak1 = switchCtrl1 ? 5'h1 : 5'hf;						/*	脉冲高低电平长度计数		*/
//	assign clkPeak2 = switchCtrl2 ? 5'hf : 5'h1;						/*	双模块高低电平长度对等	*/
	assign relayCtrl = relayCtrl1 ^ relayCtrl2;						/*	互补时钟输出鉴相			*/
	
	always @(posedge clk)
	begin
		if(rst)
		begin
			relayEn <= 1;
		end
		else
		begin
			relayEn <= relayCtrl ? 1'b0 : 1'b1; 						/*	判断电平是否互补			*/
		end
	end
	
	always @(negedge clk)
	begin
		if(rst)
		begin
			switchEn <= 1;
			clkCount1H <= 5'd2;
			clkCount1L <= 5'd16;
			clkCount2H <= 5'd16;
			clkCount2L <= 5'd2;
		end
		else
		begin
		
/*	以下逻辑无法综合		*/

//			switchEn <= ((clkCount1 <= clkPeak1) && (clkCount2 <= clkPeak2)) ? 1'b0 : 1'b1;
//																					/*	判断电平长度				*/
//			clkCount1 <= clkCount1 + 1'b1;
//			clkCount2 <= clkCount2 + 1'b1;
			if(switchCtrl1)													/*	计算高电平脉冲长度		*/
			begin
				switchEn <= (clkCount1H <= 5'h1) ? 1'h0 : 1'h1;		/*	是否小于3个clk2长度	*/
				clkCount1H <= clkCount1H + 1'h1;							/*	计时+1						*/
				clkCount1L <= 5'h0;											/*	清零低电平计时寄存器		*/
			end
			else
			begin
				switchEn <= (clkCount1L <= 5'hf) ? 1'h0 : 1'h1;		/*	是否小于16个clk2长度	*/
				clkCount1L <= clkCount1L + 1'h1;							/*	计时+1						*/
				clkCount1H <= 5'h0;											/*	清零高电平计时寄存器		*/
			end
			
			if(switchCtrl2)													/*	上述方法，互补脉宽判断	*/
			begin
				switchEn <= (clkCount2H <= 5'hf) ? 1'h0 : 1'h1;
				clkCount2H <= clkCount2H + 1'h1;
				clkCount2L <= 5'h0;
			end
			else
			begin
				switchEn <= (clkCount2L <= 5'h1) ? 1'h0 : 1'h1;
				clkCount2L <= clkCount2L + 1'h1;
				clkCount2H <= 5'h0;				
			end
		end
	end
	
/*	以下逻辑无法综合		*/

//	always @(switchCtrl1) 													/*	跳变沿计数清零			*/
//	begin
//		clkCount1 <= 0;
//	end
//	
//	always @(switchCtrl2) 													//异步触发能否综合尚未验证
//	begin
//		clkCount2 <= 0;
//	end
endmodule