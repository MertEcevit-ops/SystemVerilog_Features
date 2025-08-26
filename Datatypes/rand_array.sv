module array_example;
    
    reg [7:0] array1 [0:14];
    reg [7:0] array2 [0:14];
    
    initial begin
        // Fill arrays with random values
        for (int i = 0; i < 15; i++) begin
            array1[i] = $urandom;
            array2[i] = $urandom;
        end
        
        // Print arrays
        $write("Array1: ");
        for (int i = 0; i < 15; i++) $write("%0d ", array1[i]);
        $display("");
        
        $write("Array2: ");
        for (int i = 0; i < 15; i++) $write("%0d ", array2[i]);
        $display("");
        
        $finish;
    end
    
endmodule