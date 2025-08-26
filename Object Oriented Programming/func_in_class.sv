class itu;
    
    bit [7:0] a, b, c;
    
   
    function new(input bit[7:0] a = 8'h00, 
                 input bit[7:0] b = 8'h00, 
                 input bit[7:0] c = 8'h00); 
        this.a = a;
        this.b = b;
        this.c = c;
    endfunction
    
    // Display function to show values
    function void display();
        $display("Values - a: %0d, b: %0d, c: %0d", a, b, c);
    endfunction
    
endclass

module tb;
    
    itu I;
    
    initial begin
       
        I = new(.b(4), .a(2), .c(56));
        
        $display("=== Test with values a=2, b=4, c=56 ===");
        I.display();
        end
    
endmodule