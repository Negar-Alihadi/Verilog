`timescale 1ns/1ns
`include "Multiplier.v"

module multiplier_TestBench;

    parameter check_num = 10;
    reg [31:0] operand_1; 
    reg [31:0] operand_2;
    // wire [31:0] product;
    reg [7:0] var_1 ;
    reg [7:0] var_2;
    reg enable = 1;

    integer i = 0;


    // Instantiate the Multiplier module
    Multiplier uut (
        .operand_1(operand_1),
        .operand_2(operand_2),
        .enable(enable)
        //.product(product)

    );

    initial begin
      $dumpfile("Multiplier.vcd");
      $dumpvars(0,multiplier_TestBench);
        for (i=0;i<check_num;i++) 
        begin
           var_1 = $random;
           var_2  =$random;
            operand_1 =var_1; 
            operand_2 =var_2; 
            #1;

            //operand_1= -30;
            //operand_2= 20;
            //#1
        end

    end
    // // Stimulus generation
    // initial begin
    //     $dumpfile("Multiplier.vcd");
    //     $dumpvars(0,multiplier_TestBench);

    //     // Initialize inputs
    //     enable = 1;
    //     operand_1 = 8'b11001100; // Example input values
    //     operand_2 = 8'b10101010;

    //     #10 enable = 0; // Disable multiplier after 10 time units
    //     #10 enable = 1; // Re-enable multiplier
    //     #10 operand_1 = 8'b11110000; // Change input values
    //     #10 operand_2 = 8'b01010101;


    //     #100 $finish; // Stop simulation after 100 time units
    // end

    // Display results
    //   always @*
    //     $display("Result: %b", product);

endmodule
