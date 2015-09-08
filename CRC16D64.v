/*****************************************************************************************
** 
**                               		北京交通大学                                     
**
**----------------------------------------------------------------------------------------
** 	文件名：			CRC16D64.v
** 	创建时间：		2015-9-1 20:45
** 	创建人员： 		赵秉贤
** 	文件描述：  		64位数据的CRC16校验输出
** 
**----------------------------------------------------------------------------------------
** 	最后修改时间：	2015-9-1 20:45 
** 	最后修改人员：	赵秉贤
** 	版本号：	   	V1.0
** 	版本描述：		对输入的带CRC检验位的数据进行接校验 
**
*****************************************************************************************/

`timescale 1 ps / 1 ps

module CRC16D64
(
	input clk,
	input rst,
	input [63:0] dataIn,
	input [15:0] crcOut,
	output reg crcRst,
	output reg crcEn,
	output reg [1:0] crcStatus,	//1: 等待为1，完成为0 //0: 正确为0，错误置1
	output reg [7:0] dataCaches
);

	reg [2:0] state;
	reg [3:0] byte;
	reg [15:0] checkCode;
	parameter IDLE = 0, CRCCALC = 1, JUDGE = 2, TRUE = 3, FALSE = 4;
	parameter BYTE8 = 0, BYTE7 = 1, BYTE6 = 2, BYTE5 = 3;
	parameter BYTE4 = 4, BYTE3 = 5, BYTE2 = 6, BYTE1 = 7, DONE = 8;
	
	always @(negedge clk)
	begin	
		if(rst)
		begin
			crcRst <= 1;
			crcEn <= 0;
			state <= IDLE;
			byte <= BYTE8;
			dataCache <= 8'hx;
			crcStatus <= 2'b1x;
		end
		else
		begin
			case (state)
				IDLE:
				begin
					dataCache <= 8'hx;
					crcRst <= 1;
					crcEn <= 0;
					byte <= BYTE8;
					state <= CRCCALC;
				end
				CRCCALC:
				begin
					case (byte)
						BYTE8:
						begin	
							crcRst <= 0;
							dataCache <= dataIn[63:56];
							byte <= BYTE7;
						end
						BYTE7:
						begin
							crcEn <= 1;
							dataCache <= dataIn[55:48];
							byte <= BYTE6;
						end
						BYTE6:
						begin	
							dataCache <= dataIn[47:40];
							byte <= BYTE5;
						end
						BYTE5:
						begin	
							dataCache <= dataIn[39:32];
							byte <= BYTE4;
						end
						BYTE4:
						begin	
							dataCache <= dataIn[31:24];
							byte <= BYTE3;
						end
						BYTE3:
						begin	
							dataCache <= dataIn[23:16];
							byte <= BYTE2;
						end
						BYTE2:
						begin	
							dataCache <= dataIn[15:8];
							byte <= BYTE1;
						end
						BYTE1:
						begin	
							dataCache <= dataIn[7:0];
							byte <= DONE;
						end
						DONE:
						begin
							dataCache <= 8'hx;
							checkCode <= crcOut;
							crcRst <= 1;
							crcEn <= 0;
							byte <= BYTE8;
							state <= JUDGE;
						end
						default:
						begin
							state <= IDLE;
						end
					endcase
				end
				JUDGE:
				begin
					if (checkCode == 16'h1D0F)
					begin
						state <= TRUE;
					end
					else
					begin
						state <= FALSE;
					end
				end
				TRUE:
				begin
					crcStatus <= 2'b00;
				end
				FALSE:
				begin
					crcStatus <= 2'b01;
				end
				default:
				begin
					state <= IDLE;
				end
			endcase
		end
	end
endmodule