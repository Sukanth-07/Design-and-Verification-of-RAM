module single_port_ram #(
parameter data_width=8,
parameter adres_width=4,
parameter depth=16)
(
input logic clk,rst_n,wr_en,
input logic [data_width-1:0] wdata,
input logic [adres_width-1:0] address,
output logic[data_width-1:0] rdata
);
 logic [data_width-1:0] mem [0:depth-1];
 integer i;
 
 always_ff@(posedge clk) begin
 if(!rst_n) begin
 rdata<=0;
 for (i=0;i<depth;i=i+1)
 mem[i]<=0;
 end 
 else if (wr_en) begin
 mem[address]<=wdata;
 end 
 else
 rdata<=mem[address];
 
 end 
endmodule
