/*****************************************************************************************
** 
**                               		北京交通大学                                     
**
**----------------------------------------------------------------------------------------
** 	文件名：			compCtrl.v
** 	创建时间：		2015-9-7 15:30
** 	创建人员： 		赵秉贤
** 	文件描述：  		总线比较器控制器
** 
**----------------------------------------------------------------------------------------
** 	最后修改时间：	2015-9-7 15:30
** 	最后修改人员：	赵秉贤
** 	版本号：	   	V1.0
** 	版本描述：		实现CRC->比较器->仲裁输出的逻辑控制
**
*****************************************************************************************/

`timescale 1ps / 1ps

module compCtrl
(
	input clk,
	input rst,
	input dataEn1,
	input dataEn2,
	input dataIn1,
	input dataIn2,
	input [1:0] crcStatus1,
	input [1:0] crcStatus2,
	input [1:0] compStatus,
	input [1:0] outputStatus,
	output reg crcEn1,
	output reg crcEn2,
	output reg compEn,
	output reg outputEn,
	output reg [7:0] modStatus;
	output reg [63:0] data1,
	output reg [63:0] data2
)

	reg dataReady1;
	reg dataReady2;
	wire dataReady;
	reg [2:0] state;
	
	parameter IDLE = 0, CRCING = 1, COMPING = 2, OUTPUTING = 3, FEEDBACK = 4;
	
	assign dataReady = (!dataReady1) & (!dataReady2);
	
	always @(dataEn1)
	begin
		if(rst) dataReady1 <= 1;
		else dataReady1 <= 0;
	end
	
	always @(dataEn2)
	begin
		if(rst) dataReady2 <= 1;
		else dataReady2 <= 0;
	end
	
	always @(posedge clk)
	begin
		if(rst)
		begin
			//initial
		end
		else
		begin
			case(state)
				IDLE:
				begin
					if(dataReady)
					begin
						crcEn1 <= 1;
						crcEn2 <= 1;
						compEn <= 1; //失能
						outputEn <= 1;
						data1 <= 64'hx;
						data2 <= 64'hx;
					end
					else
					begin
						crcEn1 <= 0; //使能
						crcEn2 <= 0; //使能
						data1 <= dataIn1;
						data2 <= dataIn2;
						dataReady1 <= 1;
						dataReady2 <= 1;
						//modStatus <= ;
						state <= CRCING;
					end
				end
				CRCING:
				begin					
					if(crcEn1);
					else if(crcStatus1[1]) 
						modStatus[7] <= 1;
					else
					begin
						modStatus{7:6} <= crcStatus1;
						crcEn1 <= 1;
					end
					
					if(crcEn2);
					else if(crcStatus2[1])
						modStatus[5] <= 1;
					else
					begin
						modStatus{5:4} <= crcStatus2;
						crcEn2 <= 1;						
					end
					
					
					if(modStatus[7] || modStatus[5]);
					else if(modStatus[6] || modStatus[4])
					begin
						outputEn <= 0;
						state <= OUTPUTING;
					end
					else
					begin
						compEn <= 0; //使能		
						state <= COMPING;
					end
				end
				COMPING:
				begin
					if(compStatus[1]) 
						modStatus[3] <= 1;
//					else if(compStatus[0])
//					begin
//						modStatus{13:12} <= compStatus;
//						compEn <= 1;
//						state <= OUTPUTING;
//					end
					else
					begin
						modStatus{3:2} <= compStatus;
						compEn <= 1;
						outputEn <= 0;
						state <= OUTPUTING;
					end
				end
				OUTPUTING:
				begin
					if(outputStatus[1])
					begin
						modStatus[1] <= 1;
					end
					else
					begin
						outputEn <= 1;
						modStatus{1:0} <= outputStatus;
						state <= IDLE;
						// 判断是否输出正确 ，存储modStatus和data1 data2进入磁盘
					end
				end
				FEEDBACK:
				begin
					
				end
				default:
				begin
					state <= IDLE;
				end
			endcase
		end
	end
endmodule
	
	
	
	