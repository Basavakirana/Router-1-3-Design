module router_controller_tb();
reg clk,rstn,pkt_valid,parity_done,low_pkt_valid,fifo_full;
reg soft_rst_0,soft_rst_1,soft_rst_2;
reg fifo_empty_0,fifo_empty_1,fifo_empty_2;
reg[1:0] din;
wire busy,detect_addr,ld_state,laf_state,lfd_state,full_state,write_enb_reg,rst_int_reg;
parameter cycle=10;
router_controller dut(clk,rstn,pkt_valid,parity_done,soft_rst_0,soft_rst_1,soft_rst_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,
din,busy,detect_addr,lfd_state,laf_state,full_state,write_enb_reg,rst_int_reg,ld_state);
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
task t1();
begin
@(negedge clk)
pkt_valid=1'b1;
din=2'b01;
fifo_empty_1=1'b1;
@(negedge clk)
@(negedge clk)
fifo_full=1'b0;
pkt_valid=1'b0;
@(negedge clk)
@(negedge clk)
fifo_full=1'b0;
end
endtask
task t2();
begin
@(negedge clk)
pkt_valid=1'b1;
din=2'b01;
fifo_empty_1=1'b1;
@(negedge clk)
@(negedge clk)
fifo_full=1'b1;
@(negedge clk)
fifo_full=1'b0;
@(negedge clk)
parity_done=1'b0;
low_pkt_valid=1'b1;
@(negedge clk)
@(negedge clk)
fifo_full=1'b0;
end
endtask
task t3();
begin
@(negedge clk)
pkt_valid=1'b1;
din=2'b01;
fifo_empty_1=1'b1;
@(negedge clk)
@(negedge clk)
fifo_full=1'b1;
@(negedge clk)
fifo_full=1'b0;
@(negedge clk)
parity_done=1'b0;
low_pkt_valid=1'b0;
@(negedge clk)
fifo_full=1'b0;
pkt_valid=1'b0;
@(negedge clk)
@(negedge clk)
fifo_full=1'b0;
end
endtask
task t4();
begin
@(negedge clk)
pkt_valid=1'b1;
din=2'b01;
fifo_empty_1=1'b1;
@(negedge clk)
@(negedge clk)
fifo_full=1'b0;
pkt_valid=1'b0;
@(negedge clk)
@(negedge clk)
fifo_full=1'b1;
@(negedge clk)
fifo_full=1'b0;
@(negedge clk)
parity_done=1'b1;
end
endtask
initial
begin
reset;
#20;
t1();
#40;
t2();
#40;
t3();
#40;
t4();
#40;
reset;
#100;
$finish;
end
endmodule
