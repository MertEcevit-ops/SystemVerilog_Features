class generator;
    randc bit [7:0] x;
    randc bit [7:0] y;
    randc bit [7:0] z;

    constraint data {

        (x inside {[0:50]});
        (y inside {[0:50]});
        (z inside {[0:50]});
    }
    
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