class itu;
    
    bit [3:0] a, b, c;
    
   
    function new(input bit[7:0] a = 4'h00, 
                 input bit[7:0] b = 4'h00, 
                 input bit[7:0] c = 4'h00); 
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
       
        I = new(.b(2), .a(1), .c(4));
        
        $display("=== Test with values a=1, b=2, c=4 ===");
        I.display();
        end
    
endmodule