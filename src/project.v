/*
 * Copyright (c) 2026 Anuj Deb
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_minefield (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);


    wire win_signal;
    wire lose_signal;
    wire internal_reset = !rst_n || ui_in[1];
    minefield game (
        .clk     (clk),
        .reset   (internal_reset),
        .start   (ui_in[0]),    //start
        .button1 (ui_in[2]),    //button1
        .button2 (ui_in[3]),    //button2
        .button3 (ui_in[4]),    //button3
        .button4 (ui_in[5]),    //button4
        .wingame (win_signal),
        .losegame(lose_signal)
    );
  // All output pins must be assigned. If not used, assign to 0.
    assign uo_out[0] = win_signal;  //wingame
    assign uo_out[1] = lose_signal; //losegame
    assign uo_out[7:2] = 6'b0;      //unused outputs

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

  // List all unused inputs to prevent warnings
 wire _unused = &{ena, ui_in[7:6], uio_in, 1'b0};

endmodule
