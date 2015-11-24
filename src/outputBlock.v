/*****************************************************************************************
** 
**                               		������ͨ��ѧ                                     
**
**----------------------------------------------------------------------------------------
** 	�ļ�����			outputBlock.v
** 	����ʱ�䣺		2015-9-11 10:30
** 	������Ա��		�Ա���
** 	�ļ�������		�Ƚ��������Ԫ���ж������Ч�ԣ���ʹ�ܻ�ʧ�����
**							����ԪΪ��ģ��ķ�����������Ҫ��ʵӲ��ʵ��
** 
**----------------------------------------------------------------------------------------
** 	����޸�ʱ�䣺	2015-11-24 20:45
** 	����޸���Ա��	�Ա���
** 	�汾�ţ�	   	V2.0
** 	�汾������		���������Ԫ����������Դ���� ���ۺ�
**
*****************************************************************************************/

`timescale 1ps / 1ps

module outputBlock
(
	input clk,
	input rst,
	input relayCtrl1,
	input relayCtrl2,
	input switchCtrl1,
	input switchCtrl2,
	output reg relayEn,
	output reg switchEn
);

	wire relayCtrl;
	reg [4:0] clkCount1H;
	reg [4:0] clkCount1L;
	reg [4:0] clkCount2H;
	reg [4:0] clkCount2L;
//	wire [4:0] clkPeak1;
//	wire [4:0] clkPeak2;
	
//	assign clkPeak1 = switchCtrl1 ? 5'h1 : 5'hf;						/*	����ߵ͵�ƽ���ȼ���		*/
//	assign clkPeak2 = switchCtrl2 ? 5'hf : 5'h1;						/*	˫ģ��ߵ͵�ƽ���ȶԵ�	*/
	assign relayCtrl = relayCtrl1 ^ relayCtrl2;						/*	����ʱ���������			*/
	
	always @(posedge clk)
	begin
		if(rst)
		begin
			relayEn <= 1;
		end
		else
		begin
			relayEn <= relayCtrl ? 1'b0 : 1'b1; 						/*	�жϵ�ƽ�Ƿ񻥲�			*/
		end
	end
	
	always @(negedge clk)
	begin
		if(rst)
		begin
			switchEn <= 1;
			clkCount1H <= 5'd2;
			clkCount1L <= 5'd16;
			clkCount2H <= 5'd16;
			clkCount2L <= 5'd2;
		end
		else
		begin
		
/*	�����߼��޷��ۺ�		*/

//			switchEn <= ((clkCount1 <= clkPeak1) && (clkCount2 <= clkPeak2)) ? 1'b0 : 1'b1;
//																					/*	�жϵ�ƽ����				*/
//			clkCount1 <= clkCount1 + 1'b1;
//			clkCount2 <= clkCount2 + 1'b1;
			if(switchCtrl1)													/*	����ߵ�ƽ���峤��		*/
			begin
				switchEn <= (clkCount1H <= 5'h1) ? 1'h0 : 1'h1;		/*	�Ƿ�С��3��clk2����	*/
				clkCount1H <= clkCount1H + 1'h1;							/*	��ʱ+1						*/
				clkCount1L <= 5'h0;											/*	����͵�ƽ��ʱ�Ĵ���		*/
			end
			else
			begin
				switchEn <= (clkCount1L <= 5'hf) ? 1'h0 : 1'h1;		/*	�Ƿ�С��16��clk2����	*/
				clkCount1L <= clkCount1L + 1'h1;							/*	��ʱ+1						*/
				clkCount1H <= 5'h0;											/*	����ߵ�ƽ��ʱ�Ĵ���		*/
			end
			
			if(switchCtrl2)													/*	�������������������ж�	*/
			begin
				switchEn <= (clkCount2H <= 5'hf) ? 1'h0 : 1'h1;
				clkCount2H <= clkCount2H + 1'h1;
				clkCount2L <= 5'h0;
			end
			else
			begin
				switchEn <= (clkCount2L <= 5'h1) ? 1'h0 : 1'h1;
				clkCount2L <= clkCount2L + 1'h1;
				clkCount2H <= 5'h0;				
			end
		end
	end
	
/*	�����߼��޷��ۺ�		*/

//	always @(switchCtrl1) 													/*	�����ؼ�������			*/
//	begin
//		clkCount1 <= 0;
//	end
//	
//	always @(switchCtrl2) 													//�첽�����ܷ��ۺ���δ��֤
//	begin
//		clkCount2 <= 0;
//	end
endmodule