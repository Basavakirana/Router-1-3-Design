module router_fifo_tb();
parameter depth=16,width=8,addr_bus_width=5;
reg clk,rstn,soft_rst,we,re,lfd_state;
reg[width-1:0]din;
wire[width-1:0]data_out;
wire full,empty;
reg[width-1:0]mem[depth-1:0];
integer i=0;
integer j=1;
integer k;
parameter cycle=10;
router_fifo dut(clk,rstn,soft_rst,we,re,din,lfd_state,data_out,empty,full);
always
begin
        #(cycle/2);
        clk=1'b0;
        #(cycle/2);
        clk=~clk;
end
task soft_dut();
begin
@(negedge clk);
soft_rst=1'b1;
@(negedge clk);
soft_rst=1'b0;
end
endtask
task rst_dut();
begin
@(negedge clk);
rstn=1'b0;
@(negedge clk);
rstn=1'b1;
end
endtask
task write;
        reg[7:0]payload_data,parity,header;
        reg[5:0]payload_len;
        reg[1:0]addr;
        begin
                @(negedge clk);
                payload_len=6'd14;
                addr=2'b01;
                header={payload_len,addr};
                din=header;
                lfd_state=1'b1;
                we=1;
                for(k=0;k<payload_len;k=k+1)
        begin
                @(negedge clk);
                lfd_state=0;
                payload_data={$random}%256;
                din=payload_data;
        end
        @(negedge clk);
        parity={$random}%256;
        din=parity;
end
endtask
task read(input i,input j);
begin
@(negedge clk)
we=i;
re=j;
end
endtask
initial
begin
rst_dut;
write;
re=i;
din=$random;
#500;
we=i;
re=j;
#200;
        $monitor("clk=%b,rstn=%b,soft_rst=%b,we=%b,re=%b,din=%b,lfd_state=%b,data_out=%b,empty=%b,full=%b",clk,rstn,soft_rst,we,re,din,lfd_state,data_out,empty,full);
#100;
$finish;
end
endmodule
