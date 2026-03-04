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



module minefield (
    input clk,
    input start,
    input reset,
    input button1,
    input button2,
    input button3,
    input button4,
    output reg wingame,
    output reg losegame
);

  // State initializations
  	//Starting stage, needs start signal to progress
    localparam [2:0] INIT = 3'd0;
  	//loading stage, progresses when sequence is filled
    localparam [2:0] LOADING = 3'd1;
  //play stage, progresses when game is either won (incorrect 	 guesses for all 5 rounds) or lost (1 correct guess any round)
    localparam [2:0] PLAY = 3'd2;
    //Win stage, achieved from incorrect guesses for all 5 rounds)
    localparam [2:0] WIN = 3'd3;
  	//Lose stage, acheived from a correct guess at any round
    localparam [2:0] LOSE = 3'd4;

  	//register and wire delcarations
    reg [2:0] state;
    reg [7:0] lfsr;
    reg [2:0] index;
    reg [2:0] gameindex;  
    reg [1:0] sequence[0:4];
    wire RNG;
	wire button_raw;
    reg btn_sync;
    reg btn_sync_d;
    wire buttonpulse;  
    wire [1:0] current_input;
      
    //8 bit LFSR implementation
    assign RNG = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];
      
    always @(posedge clk or posedge reset) begin
        if (reset) 
          lfsr <= 8'h1;
        else       
          lfsr <= {lfsr[6:0], RNG};
    end

    //Edge detector for button and synchronizer
    assign button_raw = button1 | button2 | button3 | button4;
      
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            btn_sync <= 0;
            btn_sync_d <= 0;
        end 
        else begin
            btn_sync <= button_raw;
            btn_sync_d <= btn_sync;
        end
    end

    assign buttonpulse = (btn_sync && !btn_sync_d);

    // button to input logic
    assign current_input = button4 ? 2'b11 :
                               button3 ? 2'b10 :
                               button2 ? 2'b01 : 2'b00;

    
    //FSM logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= INIT;
            index <= 0;
            gameindex <= 0;
            wingame <= 0;
            losegame <= 0;
        end else begin
            case (state)
                 INIT: begin
                    wingame <= 0;
                    losegame <= 0;
                    index <= 0;
                    gameindex <= 0;
                    if (start) 
                      state <= LOADING;
                end

                LOADING: begin
                    if (index < 5) begin
                        sequence[index] <= lfsr[1:0];
                        index           <= index + 1;
                    end 
                    else begin
                      	state <= PLAY;
                    end
                end

                PLAY: begin
                    if (buttonpulse) begin
                      if (current_input == sequence[gameindex]) 					   
                        begin
                            state <= LOSE;
                            losegame <= 1;
                        end 
                        else if (gameindex == 4) begin
                            state <= WIN;
                            wingame <= 1;
                        end
                        else begin
                            gameindex <= gameindex + 1;
                            state <= PLAY; 
                        end
                    end
                end

                WIN, LOSE: begin
                  //Dead end state, doesnt progress till reset
                end

                default: state <= INIT;
            endcase
        end
    end

endmodule

