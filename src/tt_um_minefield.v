/*
 * Project: Minefield Game
 * Author:  Anuj Deb
 * License: Apache-2.0
 */

`default_nettype none

module tt_um_minefield (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

 
    wire win_signal;
    wire lose_signal;
    

    // Reset translation to  match reset_n low to reset
    wire internal_reset;
    assign internal_reset = (!rst_n) || ui_in[1];

    // Initialization
    minefield game_inst (
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

    // Output assignments
    assign uo_out[0] = win_signal;  // uo[0]: wingame
    assign uo_out[1] = lose_signal; // uo[1]: losegame
    assign uo_out[2] = 1'b0;
    assign uo_out[3] = 1'b0;
    assign uo_out[4] = 1'b0;
    assign uo_out[5] = 1'b0;
    assign uo_out[6] = 1'b0;
    assign uo_out[7] = 1'b0;

    // Bi-directional IOs set to input mode (high-impedance/zero)
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Unused inputs list to prevent synthesis warnings
    wire _unused;
    assign _unused = &{ena, ui_in[7:6], uio_in, 1'b0};

endmodule

// minefield module
module minefield (
    input  wire clk,
    input  wire start,
    input  wire reset,
    input  wire button1,
    input  wire button2,
    input  wire button3,
    input  wire button4,
    output reg  wingame,
    output reg  losegame
);

    // State initialization 
    localparam [2:0] INIT    = 3'd0;
    localparam [2:0] LOADING = 3'd1;
    localparam [2:0] PLAY    = 3'd2;
    localparam [2:0] WIN     = 3'd3;
    localparam [2:0] LOSE    = 3'd4;

    reg [2:0] state;
    reg [7:0] lfsr;
    reg [2:0] index;
    reg [2:0] gameindex;  
	reg [1:0] game_sequence[0:4];
    
    wire RNG;
    wire button_raw;
    reg  btn_sync;
    reg  btn_sync_d;
    wire buttonpulse;  
    wire [1:0] current_input;
      
    // 8-bit LFSR 
    assign RNG = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];
      
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 8'h1;
        end else begin     
            lfsr <= {lfsr[6:0], RNG};
        end
    end

		// Edge detector and Synchronizer
    assign button_raw = button1 | button2 | button3 | button4;
      
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            btn_sync   <= 1'b0;
            btn_sync_d <= 1'b0;
        end 
        else begin
            btn_sync   <= button_raw;
            btn_sync_d <= btn_sync;
        end
    end

    assign buttonpulse = (btn_sync && (!btn_sync_d));

    //Button to input function
    assign current_input = button4 ? 2'b11 :
                           button3 ? 2'b10 :
                           button2 ? 2'b01 : 2'b00;

    // FSM
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state     <= INIT;
            index     <= 3'd0;
            gameindex <= 3'd0;
            wingame   <= 1'b0;
            losegame  <= 1'b0;
        end else begin
            case (state)
                INIT: begin
                    wingame   <= 1'b0;
                    losegame  <= 1'b0;
                    index     <= 3'd0;
                    gameindex <= 3'd0;
                    if (start) begin
                        state <= LOADING;
                    end
                end

                LOADING: begin
                    if (index < 3'd5) begin
                        game_sequence[index] <= lfsr[1:0];
                        index           <= index + 3'd1;
                    end 
                    else begin
                        state <= PLAY;
                    end
                end

                PLAY: begin
                    if (buttonpulse) begin
						if (current_input == game_sequence[gameindex]) begin
                            state    <= LOSE;
                            losegame <= 1'b1;
                        end 
                        else if (gameindex == 3'd4) begin
                            state    <= WIN;
                            wingame  <= 1'b1;
                        end
                        else begin
                            gameindex <= gameindex + 3'd1;
                            state     <= PLAY; 
                        end
                    end
                end

                WIN: begin
                    
                    state <= WIN;
                end

                LOSE: begin
                    
                    state <= LOSE;
                end

                default: begin
                    state <= INIT;
                end
            endcase
        end
    end

endmodule

`default_nettype wire

