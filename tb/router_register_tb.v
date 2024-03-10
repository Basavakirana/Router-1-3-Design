module router_register_tb();
reg clk,rstn,pkt_valid,fifo_full,rst_int_reg,detect_addr,ld_state,laf_state,full_state,lfd_state;
reg [7:0]din;
wire parity_done,low_pkt_valid,error,dout;
router_register dut(clk,rstn,pkt_valid,fifo_full,rst_int_reg,detect_addr,ld_state,laf_state,full_state,lfd_state,din,parity_done,low_pkt_valid,error,dout);
parameter cycle=10;
integer i;
always@(posedge clk)
begin
#(cycle/2);
clk=1'b0;
#(cycle/2);
clk=~clk;
end
task reset;
begin
@(negedge clk)
rstn=1'b0;
@(negedge clk)
rstn=1'b1;
end
endtask
task pkt_gen();
reg[7:0]payload_data,parity,header;
reg[5:0]payload_len;
reg[1:0]addr;
begin
@(negedge clk)
payload_len=6'd6;
addr=2'b00;
parity=0;
pkt_valid=1;
detect_addr=1;
header={payload_len,addr};
din=header;
parity=parity^din;
@(negedge clk)
detect_addr=0;
lfd_state=1;
full_state=0;
fifo_full=0;
laf_state=0;
for(i=0;i<payload_len;i=i+1)
begin
@(negedge clk)
lfd_state=0;
ld_state=1;
payload_data={$random}%256;
din=payload_data;
parity=parity^din;
end
@(negedge clk)
pkt_valid=0;
din=parity;
@(negedge clk)
ld_state=0;
end
endtask
initial
begin
reset;
fifo_full=1'b0;
laf_state=1'b0;
full_state=1'b0;
#20;
pkt_gen();
#100;
$finish;
end
endmodule
