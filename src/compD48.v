/*****************************************************************************************
** 
**                               		北京交通大学                                     
**
**----------------------------------------------------------------------------------------
** 	文件名：			compD48.v
** 	创建时间：		2015-9-6 17:20
** 	创建人员： 		赵秉贤
** 	文件描述：  		两组48位数据比较器
** 
**----------------------------------------------------------------------------------------
** 	最后修改时间：	2015-9-6 17:20 
** 	最后修改人员：	赵秉贤
** 	版本号：	   	V1.0
** 	版本描述：		对CRC校验通过的两组数据进行比较 
**
*****************************************************************************************/

`timescale 1 ps / 1 ps

module compD48
(
	input clk,
	input rst,
	input [63:0] dataIn1,
	input [63:0] dataIn2,
	output reg [1:0] compStatus											/*	比较模块状态寄存器		*/
);
	reg [47:0] data1;															/*	除CRC校验码的高48位数据*/
	reg [47:0] data2;
	reg [1:0] state;
	wire dataXOR;																/*	两组数据按位异或			*/
	parameter IDLE = 0, COMP = 1, TRUE = 2, FALSE = 3;
	
	assign dataXOR = (data1^data2) ? 1'd1 : 1'd0;							/*	两组数据按位异或			*/
	
	always @(negedge clk)
	begin
		if(rst)
		begin
			compStatus <= 2'b1x;
			state <= IDLE;
			data1 <= 48'hx;
			data2 <= 48'hx;
		end
		else
		begin
			case(state)
				IDLE:
				begin
					data1 <= dataIn1[63:16];								/*	高48位数据截取			*/
					data2 <= dataIn2[63:16];
					state <= COMP;
				end
				COMP:
				begin
					if(dataXOR) state <= FALSE;
					else  state <= TRUE;
				end
				TRUE:
				begin
					compStatus <= 2'b00;
				end
        FALSE:
				begin
					compStatus <= 2'b01;
				end
			endcase
		end
	end
endmodule