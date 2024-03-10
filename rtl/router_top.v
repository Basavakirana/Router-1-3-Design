module router_top(clk,rstn,pkt_valid,re_0,re_1,re_2,din,data_out_0,data_out_1,data_out_2,valid_out_0,valid_out_1,valid_out_2,error,busy);
input clk,rstn,pkt_valid;
input re_0,re_1,re_2;
input[7:0]din;
output error,busy;
output[7:0]data_out_0;
output[7:0]data_out_1;
output[7:0]data_out_2;
output valid_out_0,valid_out_1,valid_out_2;
wire[2:0] re;
wire[2:0] we;
wire [2:0]soft_rst;
wire [2:0]empty;
wire [2:0]full;
wire lfd_state;
wire lfd_state_s=lfd_state;
wire [7:0]dout;
wire[7:0]data_out_temp[2:0];
genvar i;
generate
for(i=0;i<3;i=i+1)
begin :fifo
router_fifo f1(.clk(clk),.rstn(rstn),.we(we[i]),.soft_rst(soft_rst[i]),.re(re[i]),. din(dout),.lfd_state(lfd_state_s),.empty(empty[i]),.full(full[i]),.data_out(data_out_temp[i]));
end
endgenerate
router_synchronizer s1(.clk(clk),.rstn(rstn),.din(din[1:0]),.write_enb_reg(write_enb_reg),.detect_addr(detect_addr),.valid_out_0(valid_out_0),.valid_out_1(valid_out_1),.valid_out_2(valid_out_2)
        ,.re_0(re[0]),.re_1(re[1]),.re_2(re[2]),.full_0(full[0]),.full_1(full[1]),.full_2(full[2]),.soft_rst_0(soft_rst[0]),.soft_rst_1(soft_rst[1]),.soft_rst_2(soft_rst[2])
        ,.empty_0(empty[0]),.empty_1(empty[1]),.empty_2(empty[2]),.fifo_full(fifo_full),.we(we));

router_controller c1(.clk(clk),.rstn(rstn),.pkt_valid(pkt_valid),.busy(busy),.parity_done(parity_done),.din(din[1:0]),.soft_rst_0(soft_rst[0]),.soft_rst_1(soft_rst[1]),.soft_rst_2(soft_rst[2])
        ,.fifo_full(fifo_full),.fifo_empty_0(empty[0]),.fifo_empty_1(empty[1]),.fifo_empty_2(empty[2]),.detect_addr(detect_addr),.ld_state(ld_state),.low_pkt_valid(low_pkt_valid)
        ,.laf_state(laf_state),.full_state(full_state),.write_enb_reg(write_enb_reg),.rst_int_reg(rst_int_reg),.lfd_state(lfd_state));

router_register r1(.clk(clk),.rstn(rstn),.pkt_valid(pkt_valid),.din(din),.fifo_full(fifo_full),.rst_int_reg(rst_int_reg),.detect_addr(detect_addr),.ld_state(ld_state),.laf_state(laf_state)
        ,.full_state(full_state),.lfd_state(lfd_state),.parity_done(parity_done),.low_pkt_valid(low_pkt_valid),.error(error),.dout(dout));

assign re[0]=re_0;
assign re[1]=re_1;
assign re[2]=re_2;
assign data_out_0=data_out_temp[0];
assign data_out_1=data_out_temp[1];
assign data_out_2=data_out_temp[2];
endmodule
