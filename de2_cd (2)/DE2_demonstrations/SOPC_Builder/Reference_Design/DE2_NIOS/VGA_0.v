//Legal Notice: (C)2006 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module VGA_0 (
               // inputs:
                iADDR,
                iCLK,
                iCLK_25,
                iCS,
                iDATA,
                iRD,
                iRST_N,
                iWR,

               // outputs:
                VGA_B,
                VGA_BLANK,
                VGA_CLK,
                VGA_G,
                VGA_HS,
                VGA_R,
                VGA_SYNC,
                VGA_VS,
                oDATA
             )
;

  output  [  9: 0] VGA_B;
  output           VGA_BLANK;
  output           VGA_CLK;
  output  [  9: 0] VGA_G;
  output           VGA_HS;
  output  [  9: 0] VGA_R;
  output           VGA_SYNC;
  output           VGA_VS;
  output  [ 15: 0] oDATA;
  input   [ 18: 0] iADDR;
  input            iCLK;
  input            iCLK_25;
  input            iCS;
  input   [ 15: 0] iDATA;
  input            iRD;
  input            iRST_N;
  input            iWR;

  wire    [  9: 0] VGA_B;
  wire             VGA_BLANK;
  wire             VGA_CLK;
  wire    [  9: 0] VGA_G;
  wire             VGA_HS;
  wire    [  9: 0] VGA_R;
  wire             VGA_SYNC;
  wire             VGA_VS;
  wire    [ 15: 0] oDATA;
  VGA_NIOS_CTRL the_VGA_NIOS_CTRL
    (
      .VGA_B     (VGA_B),
      .VGA_BLANK (VGA_BLANK),
      .VGA_CLK   (VGA_CLK),
      .VGA_G     (VGA_G),
      .VGA_HS    (VGA_HS),
      .VGA_R     (VGA_R),
      .VGA_SYNC  (VGA_SYNC),
      .VGA_VS    (VGA_VS),
      .iADDR     (iADDR),
      .iCLK      (iCLK),
      .iCLK_25   (iCLK_25),
      .iCS       (iCS),
      .iDATA     (iDATA),
      .iRD       (iRD),
      .iRST_N    (iRST_N),
      .iWR       (iWR),
      .oDATA     (oDATA)
    );
  defparam the_VGA_NIOS_CTRL.RAM_SIZE = 19'b1001011000000000000;


endmodule

