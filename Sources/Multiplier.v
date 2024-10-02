`include "Defines.v"

module Multiplier
(
    input enable,
    input [31 : 0] operand_1,
    input [31 : 0] operand_2,
    output reg [31 : 0] product
);

   //signal for encoder
    reg [3:0] neg;
    reg [3:0] one;
    reg [3:0] two;

    //description of partial products
    //partial products for 4 rows
    reg [15:0] pp0;
    reg [15:0] pp1;
    reg [15:0] pp2;
    reg [15:0] pp3;

    // // partial products array
    reg [7:0]p;

    // carry array
    reg [2:0]c;

    reg [7:0] operand_1_c;

     // represent bits of the operand_1 during the multiplication process used in signaling
    reg aj;
    reg aj_1;

    integer i ;
    integer j ;
    // // negative flag
    reg ng;

    reg [15:0]result;
    // carry save
    reg [7:0]c_save;

     // sign bit flag
      reg s;
   
    //negated values  

    reg naj;
    reg naj_1;
   

    always @(*)
    begin

        if(enable==1) begin
            i = 0;
            j = 0;
            c_save = 8'b0;

            // make signals values
            one[0] = ~(operand_2[2*0]^0);
            two[0]= ~(( operand_2[2*0+1] & ~operand_2[2*0] & (~0)  ) | ( (~operand_2[2*0+1]) & (operand_2[2*0]) & 0 ) );
            neg[0] = ((~(0))|(~(operand_2[2*0])))&(operand_2[2*0+1]);
            c[0] = neg[0] & ( ~operand_1[0] | one[0]);
                
            one[1] = ~(operand_2[2*1]^operand_2[2*1-1]);
            two[1]= ~(( operand_2[2*1+1] & ~operand_2[2*1] & (~operand_2[2*1-1])  ) | ( (~operand_2[2*1+1]) & (operand_2[2*1]) & operand_2[2*1-1] ) );
            neg[1] = ((~(operand_2[2*1-1]))|(~(operand_2[2*1])))&(operand_2[2*1+1]);
            c[1] = neg[1] & ( ~operand_1[0] | one[1]);

            one[2] = ~(operand_2[2*2]^operand_2[2*2-1]);
            two[2]= ~(( operand_2[2*2+1] & ~operand_2[2*2] & (~operand_2[2*2-1])  ) | ( (~operand_2[2*2+1]) & (operand_2[2*2]) & operand_2[2*2-1] ) );
            neg[2] = ((~(operand_2[2*2-1]))|(~(operand_2[2*2])))&(operand_2[2*2+1]);
            c[2] = neg[2] & ( ~operand_1[0] | one[2]);


            one[3] = ~(operand_2[2*3]^operand_2[2*3-1]);
            two[3]= ~(( operand_2[2*3+1] & ~operand_2[2*3] & (~operand_2[2*3-1])  ) | ( (~operand_2[2*3+1]) & (operand_2[2*3]) & operand_2[2*3-1] ) );
            neg[3] = ((~(operand_2[2*3-1]))|(~(operand_2[2*3])))&(operand_2[2*3+1]);



             // Computation of partial products for each 4-bit segment of operand_2

            for(i=0;i<=2;i++) begin
                
                for(j=0;j<=7;j++)begin 
                    if (j==0) begin
                        aj = operand_1[j];
                        aj_1 = 0;
                    end else begin
                        aj = operand_1[j];
                        aj_1 = operand_1[j-1];
                    end
                    naj_1 = ~((aj_1)^(neg[i]));
                    naj = ~((aj)^(neg[i]));
                    p[j] = ~(((two[i])|(naj_1))&((one[i])|(naj)));
                    if(j==7) begin
                        s = ~naj & (~one[i] | ~two[i]);
                    end
                end

                p[0] = ~(one[i]) & operand_1[0];
                
                 // determine partial products
                case (i) //[i][15:0]
                    0 : pp0 = {5'b0, ~s ,s ,s , p[7] ,p[6],p[5],p[4],p[3],p[2],p[1],p[0] };  
                    1 : pp1 = {4'b0,1'b1 ,~s , p[7] ,p[6],p[5],p[4],p[3],p[2],p[1],p[0] , c[i-1],1'b0 };
                    2 : pp2 = {2'b0 ,  1'b1 ,~s , p[7] ,p[6],p[5],p[4],p[3],p[2],p[1],p[0] , c[i-1],1'b0,1'b0,1'b0 };
                endcase
            end
                // Computation of carry-save based on operand_1
                for(i=0;i<=3;i++) begin
                    if(operand_1[2*i]==1'b1)begin
                        c_save[2*i] = 1;
                        c_save[2*i+1] = 1;
                    end else begin
                        if(operand_1[2*i]==1'b1) begin
                            c_save[2*i] = 0;
                            c_save[2*i+1] = 1;
                        end else begin
                            c_save[2*i] = 0;
                            c_save[2*i+1] = 0;
                        end
                    end
                end

                // Computation of carry-propagate for carry save
                for(i=0;i<=1;i++) begin
                    if(c_save[4*i+1]==1)begin
                        c_save[4*i+2] =1;
                        c_save[4*i+2] =1;
                    end
                end

                 // Set higher bits of carry_save if needed
                if(c_save[3]==1) begin
                    c_save[4]=1;
                    c_save[5]=1;
                    c_save[6]=1;
                    c_save[7]=1;
                end

                // Compute operand_1_carry  based on carry_save and operand_1
                ng = 0;
                for (i=0;i<=7;i++) begin
                    if(ng==1'b1) begin
                        operand_1_c[i] = ~operand_1[i];
                    end else begin
                        operand_1_c[i] = operand_1[i];
                    end
                    if(c_save[i]==1'b1) begin
                        ng = 1;
                    end
                end


            // Compute pp3 based on operand_1_carry 
            if(neg[3]==1'b1) begin
                neg[3]=0;
                for(j=0;j<=7;j++)begin 
                    if (j==0) begin
                        aj = operand_1_c[j];
                        aj_1 = 0;
                    end else begin
                        aj = operand_1_c[j];
                        aj_1 = operand_1_c[j-1];
                    end
                    p[j] = ~( (  (two[3])|(~((aj_1)^(neg[3])))  )&(   (one[3])|(~((aj)^(neg[3])))  ) );
                end


                pp3 = {  1'b1 ,~p[7] , p[7] ,p[6],p[5],p[4],p[3],p[2],p[1],p[0] , c[2],1'b0,1'b0,1'b0 ,1'b0,1'b0};          
            
            end else begin
                for(j=0;j<=7;j++)begin 
                    if (j==0) begin
                        aj = operand_1[j];
                        aj_1 = 0;
                    end else begin
                        aj = operand_1[j];
                        aj_1 = operand_1[j-1];
                    end
                    p[j] = ~( (  (two[3])|(~((aj_1)^(neg[3])))  )&(   (one[3])|(~((aj)^(neg[3])))  ) );
                end

                p[0] = ~(one[3]) & operand_1[0];
                pp3 = {  1'b1 ,~p[7] , p[7] ,p[6],p[5],p[4],p[3],p[2],p[1],p[0] , c[2],1'b0,1'b0,1'b0 ,1'b0,1'b0};                 
            end

            // Final addition of partial products to get the result
            result = pp0 + pp1 + pp2 + pp3;

           // Set the output product and make second 16 bit to zero
            product = {{16{result[15]}},result};
            end
    end 
    

    // Start your 8-bit multiplier design here
endmodule