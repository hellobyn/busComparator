/*****************************************************************************************
** 
**                               		������ͨ��ѧ                                     
**
**----------------------------------------------------------------------------------------
** 	�ļ�����			CRC16D64.v
** 	����ʱ�䣺		2015-9-1 20:45
** 	������Ա�� 		�Ա���
** 	�ļ�������  		64λ���ݵ�CRC16У�����
** 
**----------------------------------------------------------------------------------------
** 	����޸�ʱ�䣺	2015-9-1 20:45 
** 	����޸���Ա��	�Ա���
** 	�汾�ţ�	   	V1.0
** 	�汾������		������Ĵ�CRC����λ�����ݽ��н�У�� 
**
*****************************************************************************************/

`timescale 1 ps / 1 ps

module CRC16D64
(
	input clk,													
	input rst,
	input [63:0] dataIn,														/*	64λ��������				*/
	input [15:0] crcOut,														/*	CRC�������				*/
	output reg crcRst,														/*	CRC16D8��λ�˿�			*/
	output reg crc8En,														/*	CRC16D8ʧ�ܶ�			*/
	output reg [1:0] crcStatus,											/*	CRC״̬�Ĵ���			*/
	output reg [7:0] dataCache												/*	����CRC16D8������		*/
);

	reg [2:0] state;															/*	CRC�ֽ����㷨״̬		*/
	reg [3:0] oneByte;
	reg [15:0] checkCode;
	parameter IDLE = 0, CRCCALC = 1, JUDGE = 2, TRUE = 3, FALSE = 4;
	parameter BYTE8 = 0, BYTE7 = 1, BYTE6 = 2, BYTE5 = 3;
	parameter BYTE4 = 4, BYTE3 = 5, BYTE2 = 6, BYTE1 = 7, DONE = 8;
	
	always @(negedge clk)
	begin	
		if(rst)																	/*	��ʼ����ֵ				*/
		begin
			crcRst <= 1;
			crc8En <= 0;
			state <= IDLE;
			oneByte <= BYTE8;
			dataCache <= 8'hx;
			crcStatus <= 2'b1x;
		end
		else
		begin
			case (state)
				IDLE:																/*	Ĭ��״̬					*/
				begin
					dataCache <= 8'hx;
					crcRst <= 1;												/*	��λcrcReg��ֵΪ16{1}	*/
					crc8En <= 0;												/*	�ֽ����㷨ʹ��			*/
					oneByte <= BYTE8;
					state <= CRCCALC;
				end
				CRCCALC:
				begin
					case (oneByte)
						BYTE8:
						begin	
							crcRst <= 0;										/*	ʹ��crc16D8��λ��		*/
							dataCache <= dataIn[63:56];					/*	���λ��������			*/
							oneByte <= BYTE7;										/*	״̬��ת					*/
						end
						BYTE7:
						begin
							crc8En <= 1;										/*	��2��CRCʹ���ֽ��㷨	*/
							dataCache <= dataIn[55:48];
							oneByte <= BYTE6;
						end
						BYTE6:
						begin	
							dataCache <= dataIn[47:40];
							oneByte <= BYTE5;
						end
						BYTE5:
						begin	
							dataCache <= dataIn[39:32];
							oneByte <= BYTE4;
						end
						BYTE4:
						begin	
							dataCache <= dataIn[31:24];
							oneByte <= BYTE3;
						end
						BYTE3:
						begin	
							dataCache <= dataIn[23:16];
							oneByte <= BYTE2;
						end
						BYTE2:
						begin	
							dataCache <= dataIn[15:8];
							oneByte <= BYTE1;
						end
						BYTE1:
						begin	
							dataCache <= dataIn[7:0];
							oneByte <= DONE;
						end
						DONE:														/*	8�ֽڼ������				*/
						begin
							dataCache <= 8'hx;								/*	����״̬��λ				*/
							checkCode <= crcOut;
							crcRst <= 1;
							crc8En <= 0;
							oneByte <= BYTE8;
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
					if (checkCode == 16'h1D0F)								/*	�ж�CRC�������Ƿ���ȷ	*/
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