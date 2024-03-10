module router_top_tb();
reg clk,rstn,pkt_valid;
reg re_0,re_1,re_2;
reg[7:0]din;
wire error,busy;
wire[7:0]data_out_0;
wire[7:0]data_out_1;
wire[7:0]data_out_2;
wire  valid_out_0,valid_out_1,valid_out_2;
parameter cycle=10;
integer i;
router_top dut(clk,rstn,pkt_valid,re_0,re_1,re_2,din,data_out_0,data_out_1,data_out_2,valid_out_0,valid_out_1,valid_out_2,error,busy);
always
begin
#(cycle/2);
clk=1'b0;
#(cycle/2);
clk=1'b1;
end
task rst_dut;
begin
@(negedge clk)
rstn=1'b0;
@(negedge clk)
rstn=1'b1;
end
endtask
task initialize;
begin
{re_0,re_1,re_2,pkt_valid,din}=0;
rstn=0;
end
endtask
task pkt_gen_16;
reg[7:0]payload_data;
reg[7:0]parity,header;
reg[5:0]payload_len;
reg[1:0]addr;
begin
@(negedge clk)
wait(~busy)
@(negedge clk)
payload_len=6'd16;
addr=2'b00;
header={payload_len,addr};
parity=0;
din=header;
pkt_valid=1;
parity=parity^header;
@(negedge clk)
wait(~busy)
for(i=0;i<payload_len;i=i+1)
begin
@(negedge clk)
wait(~busy)
payload_data={$random}%256;
din=payload_data;
parity=parity^din;
end
@(negedge clk)
wait(~busy)
pkt_valid=0;
din=parity;
end
endtask
initial
begin
initialize;
rst_dut;
#20;
fork
pkt_gen_16;
begin
wait(valid_out_0);
@(negedge clk);
re_0=1'b1;
#400;
end
join
end
endmodule
