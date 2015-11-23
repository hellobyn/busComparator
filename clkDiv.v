/*****************************************************************************************
** 
**                               		北京交通大学                                     
**
**----------------------------------------------------------------------------------------
** 	文件名：			clkDiv.v
** 	创建时间：		2015-9-11 17:30
** 	创建人员： 		赵秉贤
** 	文件描述：  		时钟分频模块
** 
**----------------------------------------------------------------------------------------
** 	最后修改时间：	2015-9-11 17:30
** 	最后修改人员：	赵秉贤
** 	版本号：	   	V1.0
** 	版本描述：		实现各种分频和脉冲输出
**
*****************************************************************************************/

`timescale 1ps / 1ps

module clkDiv	//是否需要使用PLL产生分频信号待验证
(
	input clk,
	input rst,
	output clk2,
	output clk4,
	output clk8,
	output clk16,
	output reg clkPls
);
	reg [7:0] clkCount;
	
	assign clk2 = clkCount[0];
	assign clk4 = clkCount[1];
	assign clk8 = clkCount[2];
	assign clk16 = clkCount[3];
	
	always @(posedge clk)
	begin
		if(rst)
		begin
			clkCount <= 8'h00;
			clkPls <= 0;
		end
		else 
		begin
			if(!(clkCount & 8'h1f))
				clkPls <= 1;
			else if (!(clkCount & 8'h3))
				clkPls <= 0; 
			else
				clkPls <= clkPls;
			clkCount <= clkCount + 8'd1;		//注意解决程序中所有的数据位宽问题！！！
		end
	end
endmodule