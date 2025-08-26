class my_class;
    int unsigned data1;
    int unsigned data2;
    int unsigned data3;

endclass


module tb;
    my_class m;
    

    initial begin
        m = new();
        m.data1 = 45;
        m.data2 = 78;
        m.data3 = 90;
        
        #1;
        $display("Value of data : %0d and data2 %0d and data3 : %0d" , m.data1, m.data2, m.data3);
    end


endmodule
