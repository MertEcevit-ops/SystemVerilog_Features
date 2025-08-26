module testbench;
    
    // Function to multiply two unsigned integers
    function int unsigned multiply(int unsigned a, int unsigned b);
        return a * b;
    endfunction
    
    initial begin
        int unsigned num1 = 5;
        int unsigned num2 = 8;
        int unsigned expected = 40;
        int unsigned result;
        
        // Call function
        result = multiply(num1, num2);
        
        // Compare and display result
        if (result == expected)
            $display("Test Passed");
        else
            $display("Test Failed");
            
        $display("Result: %0d, Expected: %0d", result, expected);
        
        $finish;
    end
    
endmodule