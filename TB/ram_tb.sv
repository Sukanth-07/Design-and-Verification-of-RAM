module ram_tb;

localparam  data_width=8;
localparam  adres_width=4;
localparam  depth=16;

logic clk,rst_n,wr_en;
logic [data_width-1:0] wdata;
logic [adres_width-1:0] address;
logic[data_width-1:0] rdata;

logic [data_width-1:0] mod_mem [0:depth-1];

integer error;

single_port_ram #(.data_width(data_width),.adres_width(adres_width),.depth(depth))
dut (.clk(clk),.rst_n(rst_n),.wr_en(wr_en),.address(address),.wdata(wdata),.rdata(rdata)
);

always #5 clk=~clk;

task automatic reset_chk;
 integer rst_index;
 begin
 rst_n=0;
 wr_en=0;
 wdata=0;
 address=0;
 
 for(rst_index=0;rst_index<depth;rst_index=rst_index+1)
 mod_mem[rst_index]=0;
 
 repeat(2)@(posedge clk);
  @(negedge clk);
  rst_n=1;
  
  @(posedge clk);
  #1;
  if(rdata!==0) begin
  $error("The memory is not reseted value:%0h",rdata);//%0h means it cuts unnecesary 0 in output(eg:002A->2A)
  error++;
  end
  end
  endtask
  
  task write_chk(input logic [adres_width-1:0]wr_addr,input logic[data_width-1:0]value);
  begin
  @(negedge clk);
  wr_en=1;
  address=wr_addr;
  wdata=value;
  mod_mem[wr_addr]=value;
  end
  endtask
  
  task read_chk(input logic [data_width-1:0] read_addr);
  begin
  @(negedge clk);
  wr_en=0;
  address=read_addr;
  @(posedge clk); //its for giving a time to execute in design 
  #1;
  if (rdata!==mod_mem[read_addr]) begin
  $error("Data mismatch:expected=%0h,actual=%0h",mod_mem[read_addr],rdata);
  error++;
  end
  end
  endtask
  
  initial begin
  clk=0;
  rst_n=0;
  wr_en=0;
  address=0;
  wdata=0;
  error=0;
  reset_chk();
  write_chk(7,8'h2A);
  read_chk(7);
   if(error==0)
   $display("Test passed");
   else 
   $error("Got error: %0d",error);
   
   $finish;
   end
   endmodule
  
  

