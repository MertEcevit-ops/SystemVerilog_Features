class generator;
    rand bit [7:0] x;
    rand bit [7:0] y;
    rand bit [7:0] z;
    
    function void display();
        $display("x=%0d y=%0d z=%0d", x, y, z);
    endfunction
endclass

module tb;
    generator gen;
    
    initial begin
        gen = new();
        
        repeat(20) begin
            gen.randomize();
            gen.display();
            #20ns;
        end
        
        $finish;
    end
endmodule