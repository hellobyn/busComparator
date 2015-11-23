/*****************************************************************************************
** 
**                               		北京交通大学                                     
**
**----------------------------------------------------------------------------------------
** 	文件名：		compCtrl.v
** 	创建时间：		2015-9-7 15:30
** 	创建人员： 		赵秉贤
** 	文件描述：  	总线比较器控制器
** 
**----------------------------------------------------------------------------------------
** 	最后修改时间：	2015-11-23 16:30
** 	最后修改人员：	赵秉贤
** 	版本号：	   	V2.0
** 	版本描述：		实现CRC->比较器->仲裁输出的逻辑控制 添加注释 添加dataReady输出
**
*****************************************************************************************/

`timescale 1ps / 1ps

module compCtrl
(
	input clk,
	input rst,
	input dataEn1,											/*	标记CPU1输出数据有效	*/
	input dataEn2,											/*	标记CPU2输出数据有效	*/
	input [63:0] dataIn1,									/*	CPU1的数据输入			*/
	input [63:0] dataIn2,									/*	CPU2的数据输入			*/
	input [1:0] crcStatus1,									/*	CRC1模块状态反馈 		*/
	input [1:0] crcStatus2,									/*	CRC2模块状态反馈 		*/
	input [1:0] compStatus,									/*	比较模块状态反馈		*/
	input [1:0] outputStatus,								/*	输出模块状态反馈		*/
	/*	xxxStatus[1:0]说明：是否完成[1]:等待为1，完成为0；是否正确[0]：正确为0，错误置1	*/
	output reg crcEn1,										/*	CRC1使能信号			*/
	output reg crcEn2,										/*	CRC2使能信号			*/
	output reg compEn,										/*	比较模块使能信号		*/
	output reg outputEn,									/*	输出模块使能信号		*/
	output reg [7:0] modStatus,								/*	比较器整体状态记录		*/
	output reg [63:0] data1,								/*	将CPU1的数据输出		*/
	output reg [63:0] data2									/*	将CPU2的数据输出		*/
	output wire dataReady;									/*	可以进行比较器流程		*/
);

	reg dataReady1;											/*	标记CPU1数据输出完成	*/
	reg dataReady2;											/*	标记CPU2数据输出完成	*/
	reg [2:0] state;										/*	比较器状态机			*/
	
	parameter IDLE = 0, CRCING = 1, COMPING = 2, OUTPUTING = 3, FEEDBACK = 4;	
															/*	空闲 CRC 比较 输出 反馈	*/
	assign dataReady = dataReady1 | dataReady2;				/*	双CPU就绪标记			*/
	
	always @(posedge dataEn1)								/*	标记data1输出完成		*/
	begin
		if(rst) dataReady1 <= 1;
		else dataReady1 <= 0;
	end
	
	always @(posedge dataEn2)								/*	标记data2输出完成		*/
	begin
		if(rst) dataReady2 <= 1;
		else dataReady2 <= 0;
	end
	
	always @(posedge clk)
	begin
		if(rst)												/*	rst为1，初始化模块状态	*/
		begin
			
			state <= IDLE;									/*	状态机为空闲			*/
			crcEn1 <= 1;									/*	失能CRC1解码			*/
			crcEn2 <= 1;									/*	失能CRC2解码			*/
			compEn <= 1;									/*	失能比较模块			*/
			outputEn <= 1;									/*	失能输出模块			*/
			data1 <= 64'hx;									/*	data1初始化为不定值x	*/
			data2 <= 64'hx;									/*	data2初始化为不定值x	*/
			modStatus <= 8'hff;								/*	模块状态寄存器置1		*/
		end
		else
		begin
			case(state)
				IDLE:										/*	空闲状态				*/
				begin
					if(dataReady)							/*	数据未就绪，重复初始化	*/
					begin
						crcEn1 <= 1;
						crcEn2 <= 1;
						compEn <= 1;
						outputEn <= 1;
						data1 <= 64'hx;
						data2 <= 64'hx;
						modStatus <= 8'hff;
					end
					else
					begin
						crcEn1 <= 0; 						/*	使能CRC校验				*/
						crcEn2 <= 0; 						/*	使能CRC校验				*/
						data1 <= dataIn1;					/*	读入data1数据			*/
						data2 <= dataIn2;					/*	读入data2数据			*/
						dataReady1 <= 1;					/*	重置data1数据有效标志	*/
						dataReady2 <= 1;					/*	重置data2数据有效标志	*/
						state <= CRCING;					/*	状态转换为CRC校验		*/
					end
				end
				CRCING:										/*	CRC校验状态	*/
				begin					
					if(crcEn1);								/*	CRC并未运行，等待		*/
					else if(crcStatus1[1]) 					/*	CRCing，判断是否完成	*/
						modStatus[7] <= 1;					/*	CRC未完成，状态记录		*/
					else									/*	CRC已经完成				*/
					begin									
						modStatus[7:6] <= crcStatus1;		/*	CRC1结果记入[7:6]位		*/
						crcEn1 <= 1;						/*	失能CRC校验				*/
					end
					
					if(crcEn2);								
					else if(crcStatus2[1])
						modStatus[5] <= 1;
					else
					begin
						modStatus[5:4] <= crcStatus2;		/*	CRC2结果记入[5:4]位		*/
						crcEn2 <= 1;						
					end
					
					
					if(modStatus[7] || modStatus[5]);		/*	双CRC未全部完成，等待	*/
					else if(modStatus[6] || modStatus[4])	/*	如果双CRC未全部通过		*/
					begin
						outputEn <= 0;						/*	使能输出单元			*/
						state <= OUTPUTING;					/*	状态机转换为 输出		*/
					end
					else
					begin
						compEn <= 0; 						/*	如果双CRC全部通过		*/	
						state <= COMPING;					/*	状态机转换为 比较		*/
					end
				end
				COMPING:									/*	数据比较状态			*/			
				begin
					if(compStatus[1]) 
						modStatus[3] <= 1;
					else
					begin
						modStatus[3:2] <= compStatus;		/*	数据比较结果写入[3:2]	*/
						compEn <= 1;						/*	失能数据比较模块		*/
						outputEn <= 0;						/*	使能输出单元			*/
						state <= OUTPUTING;					/*	状态机转换成为 输出		*/
					end
				end
				OUTPUTING:									/*	输出控制状态			*/
				begin
					if(outputStatus[1])						
					begin
						modStatus[1] <= 1;
					end
					else
					begin
						outputEn <= 1;
						modStatus[1:0] <= outputStatus;
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
	
	
	
	