/*****************************************************************************************
** 
**                               		������ͨ��ѧ                                     
**
**----------------------------------------------------------------------------------------
** 	�ļ�����			compCtrl.v
** 	����ʱ�䣺		2015-9-7 15:30
** 	������Ա�� 		�Ա���
** 	�ļ�������  		���߱Ƚ���������
** 
**----------------------------------------------------------------------------------------
** 	����޸�ʱ�䣺	2015-11-23 20:45
** 	����޸���Ա��	�Ա���
** 	�汾�ţ�	   	V2.0
** 	�汾������		ʵ��CRC->�Ƚ���->�ٲ�������߼����� ���ע�� ���dataReady��� ���ۺ�
**
*****************************************************************************************/

`timescale 1ps / 1ps

module compCtrl
(
	input clk,
	input rst,
	input dataEn1,																/*	���CPU1���������Ч	*/
	input dataEn2,																/*	���CPU2���������Ч	*/
	input [63:0] dataIn1,													/*	CPU1����������			*/
	input [63:0] dataIn2,													/*	CPU2����������			*/
	input [1:0] crcStatus1,													/*	CRC1ģ��״̬���� 		*/
	input [1:0] crcStatus2,													/*	CRC2ģ��״̬���� 		*/
	input [1:0] compStatus,													/*	�Ƚ�ģ��״̬����			*/
	input [1:0] outputStatus,												/*	���ģ��״̬����			*/
	/*	xxxStatus[1:0]˵�����Ƿ����[1]:�ȴ�Ϊ1�����Ϊ0���Ƿ���ȷ[0]����ȷΪ0��������1			*/
	output reg crcEn1,														/*	CRC1ʹ���ź�				*/
	output reg crcEn2,														/*	CRC2ʹ���ź�				*/
	output reg compEn,														/*	�Ƚ�ģ��ʹ���ź�			*/
	output reg outputEn,														/*	���ģ��ʹ���ź�			*/
	output reg [7:0] modStatus,											/*	�Ƚ�������״̬��¼		*/
	output reg [63:0] data1,												/*	��CPU1���������			*/
	output reg [63:0] data2												/*	��CPU2���������			*/
//	output dataReady															/*	���Խ��бȽ�������		*/
);

													
													
	reg [1:0] dataCapture1;													/*	CPU1���ݲ���״̬			*/
	reg [1:0] dataCapture2;													/*	CPU2���ݲ���״̬			*/
	reg [2:0] state;															/*	�Ƚ���״̬��				*/
	
	parameter IDLE = 3'd0, CRCING = 3'd1, COMPING = 3'd2, OUTPUTING = 3'd3, FEEDBACK = 3'd4;	
																					/*	���� CRC �Ƚ� ��� ����*/
	parameter WAITING = 2'd3, WRITING = 2'd2, READING = 2'd1, DATAREADY = 2'd0;
	
//	assign dataReady = dataCapture1 || dataCapture2;				/*	˫CPU���ݾ������		*/
	
//	always @(posedge dataEn1)												/*	���data1������		*/
//	begin
//		if(rst) dataReady1 <= 1;
//		else dataReady1 <= 0;
//	end
//	
//	always @(posedge dataEn2)												/*	���data2������		*/
//	begin
//		if(rst) dataReady2 <= 1;
//		else dataReady2 <= 0;
//	end
	
	always @(posedge clk)
	begin
		if(rst)																	/*	rstΪ1����ʼ��ģ��״̬	*/
		begin		
			state <= IDLE;														/*	״̬��Ϊ����				*/
			crcEn1 <= 1'd1;														/*	ʧ��CRC1����				*/
			crcEn2 <= 1'd1;														/*	ʧ��CRC2����				*/
			compEn <= 1'd1;														/*	ʧ�ܱȽ�ģ��				*/
			outputEn <= 1'd1;														/*	ʧ�����ģ��				*/
			data1 <= 64'hx;													/*	data1��ʼ��Ϊ����ֵx	*/
			data2 <= 64'hx;													/*	data2��ʼ��Ϊ����ֵx	*/
			modStatus <= 8'hff;												/*	ģ��״̬�Ĵ�����1		*/
			dataCapture1 <= WAITING;										/*	���ݲ���Ϊ�ȴ�״̬		*/
			dataCapture2 <= WAITING;										/*	���ݲ���Ϊ�ȴ�״̬		*/
		end
		else
		begin
			case(state)
				IDLE:																/*	����״̬					*/
				begin
					/*	�����߼�����ӳ�ʱ����֮��ɾ��		*/
//					if(dataReady)												/*	����δ�������ظ���ʼ��	*/
//					begin
//						crcEn1 <= 1;
//						crcEn2 <= 1;
//						compEn <= 1;
//						outputEn <= 1;
//						data1 <= 64'hx;
//						data2 <= 64'hx;
//						modStatus <= 8'hff;
//					end
//					else
//					begin
//						crcEn1 <= 0; 											/*	ʹ��CRCУ��				*/
//						crcEn2 <= 0; 											/*	ʹ��CRCУ��				*/
//						data1 <= dataIn1;										/*	����data1����			*/
//						data2 <= dataIn2;										/*	����data2����			*/
//						dataReady1 <= 1;										/*	����data1������Ч��־	*/
//						dataReady2 <= 1;										/*	����data2������Ч��־	*/
//						state <= CRCING;										/*	״̬ת��ΪCRCУ��		*/
//					end
					case(dataCapture1)
						WAITING:														/*	�ȴ�״̬�����ݸ�λ		*/
						begin
							crcEn1 <= 1'd1;
							crcEn2 <= 1'd1;
							compEn <= 1'd1;
							outputEn <= 1'd1;
							data1 <= 64'hx;
							data2 <= 64'hx;
							modStatus <= 8'hff;
							if(!dataEn1)											/*	dataEn��1�䵽0			*/
								dataCapture1 <= WRITING;						/*	���ݲ���תΪд����״̬	*/
						end
						WRITING:
						begin
							if(dataEn1)												/*	dataEn��0�䵽1			*/
								dataCapture1 <= READING;						/*	���ݲ���תΪ������״̬	*/
						end
						READING:
						begin
							data1 <= dataIn1;										/*	���ݶ�ȡ					*/
							dataCapture1 <= DATAREADY;							/*	תΪ���ݾ���״̬			*/
						end
						DATAREADY:
						begin
							if(!dataCapture2)										/*	�����һ������Ҳ�Ѿ���	*/
							begin
								dataCapture1 <= WAITING;
								dataCapture2 <= WAITING;
								crcEn1 <= 1'd0; 										/*	ʹ��CRCУ��				*/
								crcEn2 <= 1'd0; 										/*	ʹ��CRCУ��				*/
								state <= CRCING;									/*	״̬ת��ΪCRCУ��		*/
							end
						end
					endcase
					
					case(dataCapture2)
						WAITING:														/*	�ȴ�״̬�����ݸ�λ		*/
						begin
							crcEn1 <= 1'd1;
							crcEn2 <= 1'd1;
							compEn <= 1'd1;
							outputEn <= 1'd1;
							data1 <= 64'hx;
							data2 <= 64'hx;
							modStatus <= 8'hff;
							if(!dataEn2)											/*	dataEn��1�䵽0			*/
								dataCapture2 <= WRITING;						/*	���ݲ���תΪд����״̬	*/
						end
						WRITING:
						begin
							if(dataEn2)												/*	dataEn��0�䵽1			*/
								dataCapture2 <= READING;						/*	���ݲ���תΪ������״̬	*/
						end
						READING:
						begin
							data2 <= dataIn2;										/*	���ݶ�ȡ					*/
							dataCapture2 <= DATAREADY;							/*	תΪ���ݾ���״̬			*/
						end
						DATAREADY:
						begin
							if(!dataCapture1)										/*	�����һ������Ҳ�Ѿ���	*/
							begin
								dataCapture1 <= WAITING;
								dataCapture2 <= WAITING;
								crcEn1 <= 1'd0; 										/*	ʹ��CRCУ��				*/
								crcEn2 <= 1'd0; 										/*	ʹ��CRCУ��				*/
								state <= CRCING;									/*	״̬ת��ΪCRCУ��		*/
							end
						end
					endcase
				end
				CRCING:															/*	CRCУ��״̬				*/
				begin					
					if(crcEn1);													/*	CRC��δ���У��ȴ�		*/
					else if(crcStatus1[1]) 									/*	CRCing���ж��Ƿ����	*/
						modStatus[7] <= 1'd1;									/*	CRCδ��ɣ�״̬��¼		*/
					else															/*	CRC�Ѿ����				*/
					begin									
						modStatus[7:6] <= crcStatus1;						/*	CRC1�������[7:6]λ	*/
						crcEn1 <= 1'd1;											/*	ʧ��CRCУ��				*/
					end
					
					if(crcEn2);								
					else if(crcStatus2[1])
						modStatus[5] <= 1'd1;
					else
					begin
						modStatus[5:4] <= crcStatus2;						/*	CRC2�������[5:4]λ	*/
						crcEn2 <= 1'd1;						
					end
					
					
					if(modStatus[7] || modStatus[5]);					/*	˫CRCδȫ����ɣ��ȴ�	*/
					else if(modStatus[6] || modStatus[4])				/*	���˫CRCδȫ��ͨ��		*/
					begin
						outputEn <= 1'd0;											/*	ʹ�������Ԫ				*/
						state <= OUTPUTING;									/*	״̬��ת��Ϊ ���		*/
					end
					else
					begin
						compEn <= 1'd0; 											/*	���˫CRCȫ��ͨ��		*/	
						state <= COMPING;										/*	״̬��ת��Ϊ �Ƚ�		*/
					end
				end
				COMPING:															/*	���ݱȽ�״̬				*/			
				begin
					if(compStatus[1]) 
						modStatus[3] <= 1'd1;
					else
					begin
						modStatus[3:2] <= compStatus;						/*	���ݱȽϽ��д��[3:2]	*/
						compEn <= 1'd1;											/*	ʧ�����ݱȽ�ģ��			*/
						outputEn <= 1'd0;											/*	ʹ�������Ԫ				*/
						state <= OUTPUTING;									/*	״̬��ת����Ϊ ���		*/
					end
				end
				OUTPUTING:														/*	�������״̬				*/
				begin
					if(outputStatus[1])						
					begin
						modStatus[1] <= 1'd1;
					end
					else
					begin
						outputEn <= 1'd1;
						modStatus[1:0] <= outputStatus;
						state <= IDLE;
						// �ж��Ƿ������ȷ ���洢modStatus��data1 data2�������
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
	
	
	
	