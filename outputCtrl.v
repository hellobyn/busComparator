/*****************************************************************************************
** 
**                               		北京交通大学                                     
**
**----------------------------------------------------------------------------------------
** 	文件名：		outputCtrl.v
** 	创建时间：		2015-9-8 10:55
** 	创建人员： 		赵秉贤
** 	文件描述：  	根据比较器的判决结果，控制输出端口
** 
**----------------------------------------------------------------------------------------
** 	最后修改时间：	2015-11-23 16:30 
** 	最后修改人员：	赵秉贤
** 	版本号：	   	V2.0
** 	版本描述：		初步根据modStatus的值，出错即失能输出，无容错 添加超时锁死功能
**
*****************************************************************************************/

`timescale 1 ps / 1 ps

module outputCtrl
(
	input clk1,												/*	输出判断基准时钟	*/
	input clk2,												/*	反向输出基准时钟	*/
	input clk3,												/*	脉冲输出基准时钟	*/
	input rst,						
	input order,											/*	区别正反输出		*/
	input outputEn1,										/*	模块1的输出时能		*/
	input outputEn2,										/*	模块2的输出时能		*/
	input [7:0] modStatus1,									/*	模块1的状态寄存器	*/
	input [7:0] modStatus2,									/*	模块2的状态寄存器	*/
	input dataReady,										/*	用于超时锁死判定	*/
	output reg [1:0] outputStatus,							/*	输出状态寄存器		*/
	output reg relayCtrl,									/*	继电器控制端口		*/
	output reg switchCtrl									/*	电子开关控制端口	*/
);

	reg [2:0] state;
	reg outputEn;											/*	输出有效性（0有效）	*/
//	reg [7:0] compResult1;
//	reg [7:0] compResult2;
	reg [1:0] errorCount;									/*	出错记录，三次错锁死*/
	reg [23:0] timeCount;									/*	超时时间记录		*/
	reg timeOut;											/*	超时状态标志位		*/
	parameter IDLE = 0, ERROR = 1, LOCK = 2;				/*	默认 错误 锁死		*/
	
	always @(negedge clk1)				
	begin
		if(rst)												/*	重启初始化			*/
		begin
			outputStatus <= 2'b1x;
			errorCount <= 2'b00;
			outputEn <= 1;
			outputStatus[1] <= 1;
//			relayCtrl <= order;     
//			switchCtrl <= order;
		end
		else
		begin
			case(state)
				IDLE:
				begin
					if(outputEn1 || outputEn2)				/*	等待双模块输出使能	*/
					begin
						outputStatus[1] <= 1;				
					end
					else if(modStatus1[2] || modStatus2[2])	/*	非双比较通过		*/
					begin
						outputStatus <= 2'b01;				/*	状态寄存器记录		*/
//	compResult1 <= {modStatus1[7:2], 2'b01};
//	compResult2 <= {modStatus2[7:2], 2'b01};
						state <= ERROR;						/*	跳转至ERROR状态		*/
					end
					else
					begin
						outputStatus <= 2'b00;		·		/*	双比较通过			*/
						outputEn <= 0;						/*	使能输出有效		*/
//						compResult1 <= {modStatus1[7:2], 2'b00};
//						compResult2 <= {modStatus2[7:2], 2'b00};
					end
				end
				ERROR:
				begin
					if(errorCount <= 1)						/*	前两次出错			*/
					begin
						//输出一次错误信息
						//一次错误LED使能
						errorCount <= errorCount + 1'b1;	/*	出错次数记录 +1		*/
						state <= IDLE;						/*	跳转至默认状态		*/
					end
					else									/*	第三次出错锁死		*/
					begin
						outputEn <= 1;						/*	失能输出信号		*/
						//返回错误信息
						//三次错误LED使能
						state <= LOCK;						/*	跳转至锁死状态		*/
					end
				end
				LOCK:
				begin
					//锁定输出
				end
				default:
				begin
					state <= ERROR;							/*	其他状态默认1次错误	*/
				end
			endcase
		end
	end
	
	always @(posedge clk1 or negedge clk1 or posedge outputEn)  //异步触发能否综合尚未验证
	begin
		if(rst || outputEn)									/*	初始化赋值			*/
		begin
			relayCtrl <= 1;
		end
		else if(order)										/*	依次序互反时钟输出	*/
		begin
			relayCtrl <= ~clk2;
		end
		else
		begin
			relayCtrl <= clk2;
		end
	end
	
	always @(posedge clk1 or negedge clk1 or posedge outputEn)	  //异步触发能否综合尚未验证
	begin
		case(order)											/*	依次序输出互补脉冲	*/
		0:
		begin
			if(rst || outputEn)								/*	初始化赋值			*/
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
				switchCtrl <= ~clk3;
			end
		end
	  endcase
	end
	
	always @(negedge dataReady)								/*	双输入数据有效		*/
	begin
		timeCount <= 24'd0;									/*	清空事件计数		*/
	end
	
	always @(posedge clk2)
	begin
		if(rst)												/*	初始化赋值			*/
		begin
			timeOut <= 0;
			timeCount <= 24'd2500001;						/*	100ms的计数值		*/
		end
		else if(timeOut)									/*	超时标志位有效		*/
		begin
			outputEn <= 1;									/*	失能输出信号		*/
			state <= LOCK;									/*	跳转至锁死状态		*/
		end
		else if(!outputEn)									/*	若此时输出有效		*/
		begin
			if(timeCount >= 24'd2500000)					/*	超过100ms无比较数据	*/
			begin
				timeOut <= 1;								/*	使能超时标志位		*/
				outputEn <= 1;								/*	失能输出信号		*/
				state <= LOCK;								/*	跳转至锁死状态		*/
			end
			else
				timeCount <= timeCount + 1;					/*	没超过100ms则计数+1	*/
		end			
	end
endmodule

