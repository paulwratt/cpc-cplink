// 
//  This code is part of the cpc-cplink project
//  
//  https://github.com/revaldinho/cpc-cplink
//  
//  Copyright (C) 2019 Revaldinho
// 
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
// 
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
// 
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
// 

module cpc_fifo ();

  // wire declarations
  supply0 VSS;
  supply1 VDD;
  supply1 VDD_IO;
  supply1 VDD_3V3;
  supply1 VDD_PI;      

  wire Sound;  
  wire A15,A14,A13,A12,A11,A10,A9,A8,A7,A6,A5,A4,A3,A2,A1,A0 ;
  wire D7,D6,D5,D4,D3,D2,D1,D0 ;
  wire MREQ_B;  
  wire M1_B;
  wire RFSH_B;
  wire IOREQ_B;
  wire RD_B;
  wire WR_B;
  wire HALT_B;
  wire INT_B ;
  wire NMI_B ;
  wire BUSRQ_B;  
  wire BUSACK_B;
  wire READY;
  wire BUSRESET_B;
  wire RESET_B;
  wire ROMEN_B;
  wire ROMDIS ;
  wire RAMRD_B;
  wire RAMDIS;
  wire CURSOR;
  wire LPEN;
  wire EXP_B;
  wire CLK;


  wire fifo_host_dir;
  wire fifo_host_dor;
  wire host_fifo_si;
  wire host_fifo_sob;
  wire host_fifo_oeb;
  wire host_fifo_reset;

  wire fifo_slave_dir;
  wire fifo_slave_dor;
  wire slave_fifo_si;
  wire slave_fifo_sob;
  wire slave_fifo_wnr;


  wire PI_GPIO_02; // FIFO DATA[0]
  wire PI_GPIO_03; // FIFO DATA[1] 
  wire PI_GPIO_04; // FIFO DATA[2]
  wire PI_GPIO_05; //-- 40W only
  wire PI_GPIO_06; //-- 40W only
  wire PI_GPIO_07; // FIFO DATA[3]
  wire PI_GPIO_08; // FIFO DATA[4]
  wire PI_GPIO_09; // FIFO DATA[5]
  wire PI_GPIO_10; // FIFO DATA[6]
  wire PI_GPIO_11; // FIFO DATA[7]
  wire PI_GPIO_12; //-- 40W only
  wire PI_GPIO_13; //-- 40W only
  wire PI_GPIO_14; // UART TxD
  wire PI_GPIO_15; // UART RxD
  wire PI_GPIO_16; //-- 40W only
  wire PI_GPIO_17; // FIFO DATA INPUT READY (DIR)
  wire PI_GPIO_18; // FIFO SHIFT IN (SI)
  wire PI_GPIO_19; //-- 40W only
  wire PI_GPIO_20; //-- 40W only
  wire PI_GPIO_21; //-- 40W only
  wire PI_GPIO_22; // NOT FIFO SHIFT OUT (SOB)
  wire PI_GPIO_23; // FIFO DATA OUTPUT READY (DOR)
  wire PI_GPIO_24; // FIFO WRITE NOT READ (WNR)
  wire PI_GPIO_25; // unused
  wire PI_GPIO_26; //-- 40W only
  wire PI_GPIO_27; // unused

  wire SDA;  
  wire SCL;
  wire sd7,sd6,sd5,sd4,sd3,sd2,sd1,sd0; 
  
       
  wire TMS;
  wire TDI;
  wire TDO;
  wire TCK;
  
  // Amstrad CPC Edge Connector
  //
  // V1.01 Corrected upper and lower rows

  idc_hdr_50w  CONN1 (
                      .p50(Sound),   .p49(VSS),
                      .p48(A15),     .p47(A14),
                      .p46(A13),     .p45(A12),
                      .p44(A11),     .p43(A10),
                      .p42(A9),      .p41(A8)
                      .p40(A7),      .p39(A6),
                      .p38(A5),      .p37(A4),
                      .p36(A3),      .p35(A2),
                      .p34(A1),      .p33(A0),
                      .p32(D7),      .p31(D6)
                      .p30(D5),      .p29(D4),
                      .p28(D3),      .p27(D2),
                      .p26(D1),      .p25(D0),
                      .p24(VDD),     .p23(MREQ_B),
                      .p22(M1_B),    .p21(RFSH_B),
                      .p20(IOREQ_B), .p19(RD_B),
                      .p18(WR_B),    .p17(HALT_B),
                      .p16(INT_B),   .p15(NMI_B),
                      .p14(BUSRQ_B), .p13(BUSACK_B),
                      .p12(READY),   .p11(BUSRESET_B),
                      .p10(RESET_B), .p9 (ROMEN_B),
                      .p8 (ROMDIS),  .p7 (RAMRD_B),
                      .p6 (RAMDIS),  .p5 (CURSOR),
                      .p4 (LPEN),    .p3 (EXP_B),
                      .p2 (VSS),     .p1 (CLK),
                      ) ;

  // Standard layout JTAG port for programming the CPLD
  hdr8way JTAG (
                .p1(VSS),  .p2(VSS),
                .p3(TMS),  .p4(TDI),
                .p5(TDO),  .p6(TCK),
                .p7(VDD),  .p8(),
                );


    
  // 9572XL CPLD - 3.3V core, 5V IO
  xc9572pc44  CPLD (
                    .p1(host_fifo_si),
	            .p2(host_fifo_sob),
	            .p3(host_fifo_oeb),
	            .p4(host_fifo_reset),
	            .gck1(CLK),
	            .gck2(A0),
	            .gck3(A1),
	            .p8(A4),
	            .p9(A5),
	            .gnd1(VSS),
	            .p11(A6),
	            .p12(A7),
	            .p13(A8),
	            .p14(A9),
	            .tdi(TDI),
	            .tms(TMS),
	            .tck(TCK),
	            .p18(A10),
	            .p19(A11),
	            .p20(A12),
	            .vccint1(VDD),
	            .p22(A13),
	            .gnd2(VSS),
	            .p24(A14),
	            .p25(A15),
	            .p26(D7),
	            .p27(D6),
	            .p28(D5),
	            .p29(D4),
	            .tdo(TDO),
	            .gnd3(VSS),
	            .vccio(VDD),
	            .p33(D3),
	            .p34(D2),
	            .p35(D1),
	            .p36(D0),
	            .p37(fifo_host_dor),
	            .p38(fifo_host_dir),
	            .gsr(RESET_B),
	            .gts2(IOREQ_B),
	            .vccint2(VDD),
	            .gts1(WR_B),
	            .p43(READY),            
	            .p44(RD_B),
                    );

  // Select 5V or 3V3 for CPLD IO voltage 
  hdr1x03      J1 (
                   .p1(VDD),
                   .p2(VDD_IO),
                   .p3(VDD_3V3)
                   );

  // 5V Power jumper for 40W socket
  hdr1x02      J2 (
                   .p1(VDD_PI),
                   .p2(VDD)
                   );

  // 3 pin header for PI Debug UART pins
  hdr1x03  UART (
                 .p1(VSS),
                 .p2(PI_GPIO_14), // UART TX
                 .p3(PI_GPIO_15)  // UART RX
                 );

  // Always enabled for unidirectional control DIR=1: A->B
  // Safe to tie off unused inputs
  LVC74245 LS_0(
                .dir(VDD_IO),       .vdd(VDD_IO),
                .a0(VSS),            .gb(VSS),
                .a1(VSS),           .b0(),
                .a2(VSS),           .b1(),
                .a3(PI_GPIO_24),    .b2(),
                .a4(fifo_slave_dor),.b3(slave_fifo_wnr),
                .a5(PI_GPIO_22),    .b4(PI_GPIO_23),
                .a6(PI_GPIO_18),    .b5(slave_fifo_sob),
                .a7(fifo_slave_dir),.b6(slave_fifo_si),
                .vss(VSS),          .b7(PI_GPIO_17)
                );

  LVC74245 LS_1(
                .dir(PI_GPIO_24),   .vdd(VDD_IO),
                .a0(PI_GPIO_11),    .gb(VSS),
                .a1(PI_GPIO_10),    .b0(sd7),
                .a2(PI_GPIO_09),    .b1(sd6),
                .a3(PI_GPIO_08),    .b2(sd5),
                .a4(PI_GPIO_07),    .b3(sd4),
                .a5(PI_GPIO_04),    .b4(sd3),
                .a6(PI_GPIO_03),    .b5(sd2),
                .a7(PI_GPIO_02),    .b6(sd1),
                .vss(VSS),          .b7(sd0)
                );
  
  SN74HCT40105 FIFO0_0(
                      .oeb(slave_fifo_wnr),   .vdd(VDD),
                      .dir(fifo_host_dir),    .sob(slave_fifo_sob),
                      .si(host_fifo_si),      .dor(fifo_slave_dor),
                      .d0(D3),                .q0(sd3),
                      .d1(D2),                .q1(sd2),
                      .d2(D1),                .q2(sd1),
                      .d3(D0),                .q3(sd0),
                      .vss(VSS),              .mr(host_fifo_reset)
                      );

  SN74HCT40105 FIFO0_1(
                      .oeb(slave_fifo_wnr),   .vdd(VDD),
                      .dir(),                 .sob(slave_fifo_sob),
                      .si(host_fifo_si),      .dor(),
                      .d0(D7),                .q0(sd7),
                      .d1(D6),                .q1(sd6),
                      .d2(D5),                .q2(sd5),
                      .d3(D4),                .q3(sd4),
                      .vss(VSS),              .mr(host_fifo_reset)
                      );

  SN74HCT40105 FIFO1_0(
                      .oeb(host_fifo_oeb),    .vdd(VDD),
                      .dir(fifo_slave_dir),   .sob(host_fifo_sob),
                      .si(slave_fifo_si),     .dor(fifo_host_dor),
                      .d0(sd3),               .q0(D3),
                      .d1(sd2),               .q1(D2),
                      .d2(sd1),               .q2(D1),
                      .d3(sd0),               .q3(D0),
                      .vss(VSS),              .mr(host_fifo_reset)
                      );

  SN74HCT40105 FIFO1_1(
                      .oeb(host_fifo_oeb),    .vdd(VDD),
                      .dir(),                 .sob(host_fifo_sob),
                      .si(slave_fifo_si),     .dor(),
                      .d0(sd7),               .q0(D7),
                      .d1(sd6),               .q1(D6),
                      .d2(sd5),               .q2(D5),
                      .d3(sd4),               .q3(D4),
                      .vss(VSS),              .mr(host_fifo_reset)
                      );
  
    hdr2x20 CONN2 (
                     .p1(VDD_3V3),     .p2(VDD_PI),
                     .p3(PI_GPIO_02),  .p4(VDD_PI),
		     .p5(PI_GPIO_03),  .p6(VSS),
		     .p7(PI_GPIO_04),  .p8(PI_GPIO_14),
		     .p9(VSS),         .p10(PI_GPIO_15),
		     .p11(PI_GPIO_17), .p12(PI_GPIO_18),
		     .p13(PI_GPIO_27), .p14(VSS),
		     .p15(PI_GPIO_22), .p16(PI_GPIO_23),
		     .p17(VDD_3V3),    .p18(PI_GPIO_24),
		     .p19(PI_GPIO_10), .p20(VSS),
		     .p21(PI_GPIO_09), .p22(PI_GPIO_25),
		     .p23(PI_GPIO_11), .p24(PI_GPIO_08),
		     .p25(VSS),        .p26(PI_GPIO_07),
		     .p27(SDA),        .p28(SCL),
		     .p29(PI_GPIO_05), .p30(VSS),
		     .p31(PI_GPIO_06), .p32(PI_GPIO_12),
		     .p33(PI_GPIO_13), .p34(VSS),
		     .p35(PI_GPIO_19), .p36(PI_GPIO_16),
		     .p37(PI_GPIO_26), .p38(PI_GPIO_20),
		     .p39(VSS),        .p40(PI_GPIO_21)
                     );

  
  // Radial electolytic, one each on the main 5V and incoming 3V3 supply
  cap22uf         CAP22UF_5V(.minus(VSS),.plus(VDD));
  cap22uf         CAP22UF_IO(.minus(VSS),.plus(VDD_3V3));

  
   // Decoupling caps for CPLD and one for SRAM
   cap100nf CAP100N_1 (.p0( VSS ), .p1( VDD ));
   cap100nf CAP100N_2 (.p0( VSS ), .p1( VDD ));
   cap100nf CAP100N_3 (.p0( VSS ), .p1( VDD ));
   cap100nf CAP100N_4 (.p0( VSS ), .p1( VDD ));
   cap100nf CAP100N_5 (.p0( VSS ), .p1( VDD ));
   cap100nf CAP100N_6 (.p0( VSS ), .p1( VDD ));

   // Decoupling for the level shifters
   cap100nf CAP100N_7 (.p0( VSS ), .p1( VDD_IO ));
   cap100nf CAP100N_8 (.p0( VSS ), .p1( VDD_IO ));    

endmodule
