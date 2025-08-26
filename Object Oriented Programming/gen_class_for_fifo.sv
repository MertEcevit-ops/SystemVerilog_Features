class generator;
    bit [3:0] a = 5, b = 7;
    bit wr = 1;
    bit en = 1;
    bit [4:0] s = 12;
    
    function generator copy();
        copy = new();
        copy.a = this.a;
        copy.b = this.b;
        copy.wr = this.wr;
        copy.en = this.en;
        copy.s = this.s;
    endfunction
    
    function void display();
        $display("a:%0d b:%0d wr:%0b en:%0b s:%0d", a, b, wr, en, s);
    endfunction
endclass

module tb;
    generator g1, g2;
    
    initial begin
        g1 = new();
        g2 = g1.copy();
        
        $display("g1:");
        g1.display();
        
        $display("g2:");
        g2.display();
        
        g2.a = 10;
        g2.b = 15;
        
        $display("\nAfter changing g2:");
        $display("g1:");
        g1.display();
        $display("g2:");
        g2.display();
    end
endmodule