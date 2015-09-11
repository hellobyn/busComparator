/*****************************************************************************************
** 
**                               		北京交通大学                                     
**
**----------------------------------------------------------------------------------------
** 	文件名：			outputCtrl.v
** 	创建时间：		2015-9-8 10:55
** 	创建人员： 		赵秉贤
** 	文件描述：  		根据比较器的判决结果，控制输出端口
** 
**----------------------------------------------------------------------------------------
** 	最后修改时间：	2015-9-8 10:55 
** 	最后修改人员：	赵秉贤
** 	版本号：	   	V1.0
** 	版本描述：		初步根据modStatus的值，出错即失能输出，无容错 
**
*****************************************************************************************/

`timescale 1 ps / 1 ps

module outputCtrl
(
	input clk1,
	input clk2,
	input rst,
	input order,
	input compResultEn1,
	input compResultEn2,
	input [7:0] modStatus1,
	input [7:0] modStatus2,
	output reg [1:0] outputStatus,
	output reg relayCtrl,
	output reg switchCtrl
)

	reg [2:0] state;
	reg outputEn;
//	reg [7:0] compResult1;
//	reg [7:0] compResult2;
	reg [1:0] errorCount;
	parameter IDLE = 0, ERROR = 1, LOCK = 2;
	
	always @(negedge clk1)
	begin
		if(rst)
		begin
			outputStatus <= 2'b1x;
			errorCount <= 2'b00;
			outputEn <= 0;
		end
		else
		begin
			case(state)
				IDLE:
				begin
					if(compResultEn1 || compResultEn2)
					begin
						outputStatus[1] <= 1;
					end
					else if(modStatus1[2] || modStatus2[2])
					begin
						outputStatus <= 2'b01;
//						compResult1 <= {modStatus1[7:2], 2'b01};
//						compResult2 <= {modStatus2[7:2], 2'b01};
						state <= ERROR;
					end
					else
					begin
						outputStatus <= 2'b00;
//						compResult1 <= {modStatus1[7:2], 2'b00};
//						compResult2 <= {modStatus2[7:2], 2'b00};
					end
				end
				ERROR:
				begin
					if(errorCount <= 1)
					begin
						//输出一次错误信息
						//一次错误LED使能
						state <= IDLE;
					end
					else
					begin
						outputEn <= 1;	//失能输出信号
						//返回错误信息
						//三次错误LED使能
						state <= LOCK;
					end
					errorCount <= errorCount + 1;
				end
				LOCK:
				begin
					//锁定输出
				end
				default:
				begin
					state <= ERROR;
				end
			endcase
		end
	end
	
	always @(posedge clk2 or negedge clk2 or posedge outputEn)
	begin
		if(rst || outputEn)
		begin
			relayCtrl <= 1;
		end
		else if(order)
		begin
			relayCtrl <= !clk2;
		end
		else
		begin
			relayCtrl <= clk2;
		end
	end
	
	always @(posedge clk3 or negedge clk3 or posedge outputEn)
	begin
		case(order)
		0:
		begin
			if(rst || outputEn)
			begin
				switchCtrl <= 1;
			end
			else
			begin
				switchCtrl <= clk3;
			end
		end
		1:
		begin
			if(rst || outputEn)
			begin
				switchCtrl <= 0;
			end
			else
			begin
				switchCtrl <= !clk3;
			end
		end
	end
endmodule