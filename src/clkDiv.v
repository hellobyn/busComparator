/*****************************************************************************************
** 
**                               		������ͨ��ѧ                                     
**
**----------------------------------------------------------------------------------------
** 	�ļ�����			clkDiv.v
** 	����ʱ�䣺		2015-9-11 17:30
** 	������Ա�� 		�Ա���
** 	�ļ�������  		ʱ�ӷ�Ƶģ��
** 
**----------------------------------------------------------------------------------------
** 	����޸�ʱ�䣺	2015-9-11 17:30
** 	����޸���Ա��	�Ա���
** 	�汾�ţ�	   	V1.0
** 	�汾������		ʵ�ָ��ַ�Ƶ���������
**
*****************************************************************************************/

`timescale 1ps / 1ps

module clkDiv
(
	input clk,
	input rst,
	output clk2,
	output clk4,
	output clk8,
	output clk16,
	output reg clkPls										
);
	reg [7:0] clkCount;
	
	assign clk2 = clkCount[0];												/*	ʱ��2��Ƶ					*/
	assign clk4 = clkCount[1];												/*	ʱ��4��Ƶ					*/
	assign clk8 = clkCount[2];												/*	ʱ��8��Ƶ					*/
	assign clk16 = clkCount[3];											/*	ʱ��16��Ƶ				*/
	
	always @(posedge clk)
	begin
		if(rst)
		begin
			clkCount <= 8'h00;
			clkPls <= 0;														/*	����ʱ�����				*/			
		end
		else 
		begin
			if(!(clkCount & 8'h1f))
				clkPls <= 1;													/*	�͵�ƽ32��clk����		*/
			else if (!(clkCount & 8'h3))									/*	�ߵ�ƽ4��clk����			*/
				clkPls <= 0; 
			else
				clkPls <= clkPls;
			clkCount <= clkCount + 8'd1;		
		end
	end
endmodule