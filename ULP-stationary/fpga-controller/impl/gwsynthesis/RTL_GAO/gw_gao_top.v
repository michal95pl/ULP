module gw_gao(
    \data2[31] ,
    \data2[30] ,
    \data2[29] ,
    \data2[28] ,
    \data2[27] ,
    \data2[26] ,
    \data2[25] ,
    \data2[24] ,
    \data2[23] ,
    \data2[22] ,
    \data2[21] ,
    \data2[20] ,
    \data2[19] ,
    \data2[18] ,
    \data2[17] ,
    \data2[16] ,
    \data2[15] ,
    \data2[14] ,
    \data2[13] ,
    \data2[12] ,
    \data2[11] ,
    \data2[10] ,
    \data2[9] ,
    \data2[8] ,
    \data2[7] ,
    \data2[6] ,
    \data2[5] ,
    \data2[4] ,
    \data2[3] ,
    \data2[2] ,
    \data2[1] ,
    \data2[0] ,
    clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \data2[31] ;
input \data2[30] ;
input \data2[29] ;
input \data2[28] ;
input \data2[27] ;
input \data2[26] ;
input \data2[25] ;
input \data2[24] ;
input \data2[23] ;
input \data2[22] ;
input \data2[21] ;
input \data2[20] ;
input \data2[19] ;
input \data2[18] ;
input \data2[17] ;
input \data2[16] ;
input \data2[15] ;
input \data2[14] ;
input \data2[13] ;
input \data2[12] ;
input \data2[11] ;
input \data2[10] ;
input \data2[9] ;
input \data2[8] ;
input \data2[7] ;
input \data2[6] ;
input \data2[5] ;
input \data2[4] ;
input \data2[3] ;
input \data2[2] ;
input \data2[1] ;
input \data2[0] ;
input clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \data2[31] ;
wire \data2[30] ;
wire \data2[29] ;
wire \data2[28] ;
wire \data2[27] ;
wire \data2[26] ;
wire \data2[25] ;
wire \data2[24] ;
wire \data2[23] ;
wire \data2[22] ;
wire \data2[21] ;
wire \data2[20] ;
wire \data2[19] ;
wire \data2[18] ;
wire \data2[17] ;
wire \data2[16] ;
wire \data2[15] ;
wire \data2[14] ;
wire \data2[13] ;
wire \data2[12] ;
wire \data2[11] ;
wire \data2[10] ;
wire \data2[9] ;
wire \data2[8] ;
wire \data2[7] ;
wire \data2[6] ;
wire \data2[5] ;
wire \data2[4] ;
wire \data2[3] ;
wire \data2[2] ;
wire \data2[1] ;
wire \data2[0] ;
wire clk;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top u_ao_top(
    .control(control0[9:0]),
    .data_i({\data2[31] ,\data2[30] ,\data2[29] ,\data2[28] ,\data2[27] ,\data2[26] ,\data2[25] ,\data2[24] ,\data2[23] ,\data2[22] ,\data2[21] ,\data2[20] ,\data2[19] ,\data2[18] ,\data2[17] ,\data2[16] ,\data2[15] ,\data2[14] ,\data2[13] ,\data2[12] ,\data2[11] ,\data2[10] ,\data2[9] ,\data2[8] ,\data2[7] ,\data2[6] ,\data2[5] ,\data2[4] ,\data2[3] ,\data2[2] ,\data2[1] ,\data2[0] }),
    .clk_i(clk)
);

endmodule
