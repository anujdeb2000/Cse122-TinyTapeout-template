`default_nettype none
`timescale 1ns / 1ps

module minefield_tb;

    reg clk;
    reg reset;
    reg start;
    reg button1, button2, button3, button4;

    wire wingame;
    wire losegame;

   //tb initialization
    minefield testbench (
        .clk(clk),
        .start(start),
        .reset(reset),
        .button1(button1),
        .button2(button2),
        .button3(button3),
        .button4(button4),
        .wingame(wingame),
        .losegame(losegame)
    );

    //clock gen
    always #5 clk = ~clk;

    //State initialization
    reg [63:0] state_name;
    always @(*) begin
      case(testbench.state)
            3'd0: state_name = "INIT";
            3'd1: state_name = "LOAD";
            3'd2: state_name = "PLAY";
            3'd3: state_name = "WIN";
            3'd4: state_name = "LOSE";
            default: state_name = "ILOVECSE122";
        endcase
    end

    
    always @(posedge clk) begin
      $display("Time=%0t | gState=%s | gIndex=%0d | TargetSeq=%b | Win=%b | Lose=%b",
      			$time, state_name, testbench.gameindex, testbench.sequence[testbench.gameindex], wingame, losegame);
    end

    //input button task 
    task press_button;
        input [1:0] val;
        begin
            case(val)
                2'b00: button1 = 1;
                2'b01: button2 = 1;
                2'b10: button3 = 1;
                2'b11: button4 = 1;
            endcase
            // hold for 2 clock cycles
            #20; 
            {button1, button2, button3, button4} = 4'b0000;
            #40; 
        end
    endtask

    integer i;
    reg [1:0] safe_val;

    initial begin
        // Initialize Signals
        clk = 0; reset = 0; start = 0;
        {button1, button2, button3, button4} = 4'b0000;

      
//Case 1: Lose Game      
      
      
      $display("________________________Case 1: Lose Game test________________________");
        #10 reset = 1; 
        #10 reset = 0;
      #20 start = 1; //Determines target sequence vals for testing (all start times work aslong as time unit is a multiple of 10)
      	#10 start = 0;
        
      wait(testbench.state == 3'd2); // Wait till PLAY state
        #20;
        
     //input matching button
      $display("Round %0d: Sequence is %b, choosing %b", 0, testbench.sequence[0],testbench.sequence[0]);
      press_button(testbench.sequence[0]);
        #50;
        //Displayed iF Design wroked
        if (losegame) $display("Design Passes Case 1 (Lose)");

        
        
        
//Case 2: Win Game        
        
          $display("________________________Case 2: Win Game test________________________");
        #10 reset = 1; 
        #10 reset = 0;
        #20 start = 1; //Determines target sequence vals for testing (all start times work aslong as time unit is a multiple of 10)
        #10 start = 0;

        wait(testbench.state == 3'd2);
        
        
        // Input non-matching number
        for (i = 0; i < 5; i = i + 1) begin
            safe_val = testbench.sequence[i] + 2'b01; 
              $display("Round %0d: Sequence is %b, choosing %b", i, testbench.sequence[i], safe_val);
            press_button(safe_val);
            #20;
        end

        #100;
              //Displayed if Design wroked
              if (wingame) $display("Design Passes Case 2 (Win)");
        	  
        $finish;
    end

endmodule
