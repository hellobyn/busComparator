/*****************************************************************************************
** 
**                               		������ͨ��ѧ                                     
**
**----------------------------------------------------------------------------------------
** 	�ļ�����			outputCtrl.v
** 	����ʱ�䣺		2015-9-8 10:55
** 	������Ա�� 		�Ա���
** 	�ļ�������  		���ݱȽ������о��������������˿�
** 
**----------------------------------------------------------------------------------------
** 	����޸�ʱ�䣺	2015-11-23 20:47 
** 	����޸���Ա��	�Ա���
** 	�汾�ţ�	   	V2.0
** 	�汾������		��������modStatus��ֵ������ʧ����������ݴ� ��ӳ�ʱ�������� ���ۺ�
**
*****************************************************************************************/

`timescale 1 ps / 1 ps

module outputCtrl
(
	input clk1,																	/*	����жϻ�׼ʱ��			*/
	input clk2,																	/*	���������׼ʱ��			*/
	input clk3,																	/*	���������׼ʱ��			*/
	input rst,						
	input order,																/*	�����������				*/
	input outputEn1,															/*	ģ��1�����ʱ��			*/
	input outputEn2,															/*	ģ��2�����ʱ��			*/
	input [7:0] modStatus1,													/*	ģ��1��״̬�Ĵ���		*/
	input [7:0] modStatus2,													/*	ģ��2��״̬�Ĵ���		*/
//	input dataReady,															/*	���ڳ�ʱ�����ж�			*/
	output reg [1:0] outputStatus,										/*	���״̬�Ĵ���			*/
	output reg relayCtrl,													/*	�̵������ƶ˿�			*/
	output reg switchCtrl													/*	���ӿ��ؿ��ƶ˿�			*/
);

	reg [2:0] state;
	reg outputEn;																/*	�����Ч�ԣ�0��Ч��		*/
	reg [1:0] errorCount;													/*	�����¼�����δ�����		*/
	reg [31:0] timeCount;													/*	��ʱʱ���¼				*/
//	reg timeOut;																/*	��ʱ״̬��־λ			*/
	parameter IDLE = 0, ERROR = 1, LOCK = 2;							/*	Ĭ�� ���� ����			*/
	
	always @(negedge clk1)				
	begin
		if(rst)																	/*	������ʼ��				*/
		begin
			outputStatus <= 2'b1x;
			errorCount <= 2'b00;
			outputEn <= 1;
			outputStatus[1] <= 1;
			timeCount <= 32'd0;												/*	����¼�����				*/
			state <= IDLE;
//			relayCtrl <= order;     
//			switchCtrl <= order;
		end
		else
		begin
			case(state)
				IDLE:
				begin
					if(outputEn1 || outputEn2)								/*	�ȴ�˫ģ�����ʹ��		*/
					begin
						outputStatus[1] <= 1;				
					end
					else if(modStatus1[2] || modStatus2[2])			/*	��˫�Ƚ�ͨ��				*/
					begin
						outputStatus <= 2'b01;								/*	״̬�Ĵ�����¼			*/
						state <= ERROR;										/*	��ת��ERROR״̬			*/
					end
					else
					begin
						timeCount <= 32'd0;									/*	����¼�����				*/
						outputStatus <= 2'b00;								/*	˫�Ƚ�ͨ��				*/
						outputEn <= 0;											/*	ʹ�������Ч				*/
					end
					
					if(timeCount >= 32'd10000000)
					begin
						outputEn <= 1;											/*	ʧ������ź�				*/
						state <= LOCK;											/*	��ת������״̬			*/
					end
					else if(!outputEn)
						timeCount <= timeCount + 1'd1;
					
				end
				ERROR:
				begin
					if(errorCount <= 1)										/*	ǰ���γ���				*/
					begin
						//���һ�δ�����Ϣ
						//һ�δ���LEDʹ��
						errorCount <= errorCount + 1'b1;					/*	���������¼ +1			*/
						state <= IDLE;											/*	��ת��Ĭ��״̬			*/
					end	
					else															/*	�����γ�������			*/
					begin
						outputEn <= 1;											/*	ʧ������ź�				*/
						//���ش�����Ϣ
						//���δ���LEDʹ��
						state <= LOCK;											/*	��ת������״̬			*/
					end
				end
				LOCK:
				begin
					//�������
				end
				default:
				begin
					state <= ERROR;											/*	����״̬Ĭ��1�δ���		*/
				end
			endcase
		end
	end
	
	always @(negedge clk1)  	//�첽�����ܷ��ۺ���δ��֤
	begin
		if(rst || outputEn)													/*	��ʼ����ֵ				*/
		begin
			relayCtrl <= 1;
		end
		else if(order)															/*	�����򻥷�ʱ�����		*/
		begin
			relayCtrl <= ~clk2;
		end
		else
		begin
			relayCtrl <= clk2;
		end
	end
	
	always @(negedge clk1)	//�첽�����ܷ��ۺ���δ��֤
	begin
		case(order)																/*	�����������������		*/
		0:
		begin
			if(rst || outputEn)												/*	��ʼ����ֵ				*/
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

/*	�����߼��޷��ۺ�		*/
	
//	always @(negedge dataReady)											/*	˫����������Ч			*/
//	begin
//		timeCount <= 24'd0;													/*	����¼�����				*/
//	end
//	
//	always @(posedge clk2)
//	begin
//		if(rst)																	/*	��ʼ����ֵ				*/
//		begin
//			timeOut <= 0;
//			timeCount <= 24'd2500001;										/*	100ms�ļ���ֵ			*/
//		end
//		else if(timeOut)														/*	��ʱ��־λ��Ч			*/
//		begin
//			outputEn <= 1;														/*	ʧ������ź�				*/
//			state <= LOCK;														/*	��ת������״̬			*/
//		end	
//		else if(!outputEn)													/*	����ʱ�����Ч			*/
//		begin
//			if(timeCount >= 24'd2500000)									/*	����100ms�ޱȽ�����		*/
//			begin
//				timeOut <= 1;													/*	ʹ�ܳ�ʱ��־λ			*/
//				outputEn <= 1;													/*	ʧ������ź�				*/
//				state <= LOCK;													/*	��ת������״̬			*/
//			end
//			else
//				timeCount <= timeCount + 1;								/*	û����100ms�����+1		*/
//		end			
//	end
endmodule

