/*****************************************************************************************
** 
**                               		������ͨ��ѧ                                     
**
**----------------------------------------------------------------------------------------
** 	�ļ�����			compD48.v
** 	����ʱ�䣺		2015-9-6 17:20
** 	������Ա�� 		�Ա���
** 	�ļ�������  		����48λ���ݱȽ���
** 
**----------------------------------------------------------------------------------------
** 	����޸�ʱ�䣺	2015-9-6 17:20 
** 	����޸���Ա��	�Ա���
** 	�汾�ţ�	   	V1.0
** 	�汾������		��CRCУ��ͨ�����������ݽ��бȽ� 
**
*****************************************************************************************/

`timescale 1 ps / 1 ps

module compD48
(
	input clk,
	input rst,
	input [63:0] dataIn1,
	input [63:0] dataIn2,
	output reg [1:0] compStatus											/*	�Ƚ�ģ��״̬�Ĵ���		*/
);
	reg [47:0] data1;															/*	��CRCУ����ĸ�48λ����*/
	reg [47:0] data2;
	reg [1:0] state;
	wire dataXOR;																/*	�������ݰ�λ���			*/
	parameter IDLE = 0, COMP = 1, TRUE = 2, FALSE = 3;
	
	assign dataXOR = (data1^data2) ? 1'd1 : 1'd0;							/*	�������ݰ�λ���			*/
	
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
					data1 <= dataIn1[63:16];								/*	��48λ���ݽ�ȡ			*/
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