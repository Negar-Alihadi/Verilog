`include "Arithmetic_Logic_Unit.v"
`include "Defines.v"


module ALU_TB ;

    reg [31:0] operand_1 , operand_2;
    reg [2:0]  operation;
    integer operations;


    Arithmetic_Logic_Unit uut(
        .operand_1(operand_1),
        .operand_2(operand_2),
        .operation(operation)

        );


    initial begin
        $dumpfile("Arithmetic_Logic_Unit.vcd");
        $dumpvars(0,ALU_TB);

        for(operations = 0; operations <5 ;++operations)begin

        operation = operations;
        operand_1 = $random;
        operand_2 = $random;
        #1;
        end
        
    end
endmodule