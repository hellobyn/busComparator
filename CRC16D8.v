/*****************************************************************************************
** 
**                               		北京交通大学                                     
**
**----------------------------------------------------------------------------------------
** 	文件名：			CRC16D8.v
** 	创建时间：		2015-8-21 10:00
** 	创建人员： 		赵秉贤
** 	文件描述：  		CRC16校验算法文件
** 
**----------------------------------------------------------------------------------------
** 	最后修改时间：	2015-8-24 10:00 
** 	最后修改人员：	赵秉贤
** 	版本号：	   	V1.0
** 	版本描述：		基于CRC16-CCITT-X25标准 （另需 翻转 + 取反 + 调换字节） 
**
*****************************************************************************************/ 
//----------------------------------------------------------------------------------------
// CRC module for data[7:0] ,   crc[15:0]=1+x^5+x^12+x^16;
//----------------------------------------------------------------------------------------
`timescale 1 ps/ 1 ps
	
module CRC16D8(
	input	[7:0] data,
	input	crcEn,
	input	rst,
	input	clk,
	output [15:0] crcOut);

	reg [15:0] crcReg;
	wire[15:0] nextCRC;

	assign crcOut = crcReg;

	always @(posedge clk, posedge rst) begin
		if(rst) begin
			crcReg <= {16{1'b1}};
		end
		else begin
			crcReg <= crcEn ? nextCRC : crcReg;
		end
	end 

	assign nextCRC[0] = crcReg[8] ^ crcReg[12] ^ data[7] ^ data[3];
	assign nextCRC[1] = crcReg[9] ^ crcReg[13] ^ data[6] ^ data[2];
	assign nextCRC[2] = crcReg[10] ^ crcReg[14] ^ data[5] ^ data[1];
	assign nextCRC[3] = crcReg[11] ^ crcReg[15] ^ data[4] ^ data[0];
	assign nextCRC[4] = crcReg[12] ^ data[3];
	assign nextCRC[5] = crcReg[8] ^ crcReg[12] ^ crcReg[13] ^ data[7] ^ data[3] ^ data[2];
	assign nextCRC[6] = crcReg[9] ^ crcReg[13] ^ crcReg[14] ^ data[6] ^ data[2] ^ data[1];
	assign nextCRC[7] = crcReg[10] ^ crcReg[14] ^ crcReg[15] ^ data[5] ^ data[1] ^ data[0];
	assign nextCRC[8] = crcReg[0] ^ crcReg[11] ^ crcReg[15] ^ data[4] ^ data[0];
	assign nextCRC[9] = crcReg[1] ^ crcReg[12] ^ data[3];
	assign nextCRC[10] = crcReg[2] ^ crcReg[13] ^ data[2];
	assign nextCRC[11] = crcReg[3] ^ crcReg[14] ^ data[1];
	assign nextCRC[12] = crcReg[4] ^ crcReg[8] ^ crcReg[12] ^ crcReg[15] ^ data[7] ^ data[3] ^ data[0];
	assign nextCRC[13] = crcReg[5] ^ crcReg[9] ^ crcReg[13] ^ data[6] ^ data[2];
	assign nextCRC[14] = crcReg[6] ^ crcReg[10] ^ crcReg[14] ^ data[5] ^ data[1];
	assign nextCRC[15] = crcReg[7] ^ crcReg[11] ^ crcReg[15] ^ data[4] ^ data[0];
endmodule