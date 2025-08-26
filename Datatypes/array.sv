module array_example;
    
    
    int arr [0:9];
    
    initial begin
       
        for (int i = 0; i < 10; i++) begin
            arr[i] = i * i;  
        end
        
        
        $display("Array değerleri:");
        for (int i = 0; i < 10; i++) begin
            $display("arr[%0d] = (%0d)^2 = %0d", i, i, arr[i]);
        end
        
        $finish;
    end
    
endmodule