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
	input [1:0] compStatus1,
	input [1:0] outputStatus1,
	input [1:0] crcStatus2,
	input [1:0] compStatus2,
	input [1:0] outputStatus2,
	output reg crcStart1,
	output reg crcStart2,
	output reg compStart,
	output reg outputStart1,
	output reg outputStart2
)

	reg [15:0] modStatus;
	reg dataReady1;
	reg dataReady2;
	wire dataReady;
	reg [2:0] state;
	reg [63:0] data1;
	reg [63:0] data2;
	
	parameter IDLE = 0, CRCING = 1, COMPING = 2, OUTPUTING = 3;
	
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
						crcStart1 <= 1;
						compStart1 <= 1; //失能
						crcStart2 <= 1;
						compStart2 <= 1; //失能
					end
					else
					begin
						crcStart1 <= 0; //使能
						crcStart2 <= 0; //使能
						data1 <= dataIn1;
						data2 <= dataIn2;
						//modStatus <= ;
						state <= CRCING;
					end
				end
				CRCING:
				begin					
					if(crcStart1);
					else if(crcStatus1[1]) 
						modStatus[15] <= 1;
					else
					begin
						modStatus{15:14} <= crcStatus1;
						crcStart1 <= 1;
					end
					
					if(crcStart2);
					else if(crcStatus2[1])
						modStatus[7] <= 1;
					else
					begin
						modStatus{7:6} <= crcStatus2;
						crcStart2 <= 1;						
					end
					
					
					if(modStatus[15] || modStatus[7]);
					else if(modStatus[14] || modStatus[6])
					begin
						state <= CRCFAIL;
					end
					else
					begin
						compStart <= 0; //使能		
						state <= COMPING;
					end
				end
				COMPING:
				begin
					if(compStatus[1]) 
						modStatus[13] <= 1;
					else if(compStatus[0])
					begin
						modStatus{13:12} <= compStatus;
						compStart <= 1;
						state <= COMPFAIL;
					end
					else
					begin
						modStatus{13:12} <= compStatus;
						compStart <= 1;
						state <= OUTPUTING;
					end
				end
				OUTPUTING:
				begin
					
				end
			endcase
		end
	end
	
	
	
	