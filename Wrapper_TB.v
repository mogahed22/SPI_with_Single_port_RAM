module Wrapper_TB();
    //inputs
    reg  MOSI, clk, rst_n, SS_n;  
    //outputs
    wire MISO;
    //instantiation
    Wrapper tb(clk,rst_n,MOSI,MISO,SS_n);
    reg [9:0]temp;
    integer i=0;
    //clk generation
    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end
    /////////////
    initial begin
        #1000;
        $stop;
    end
    //stimulus
    initial begin
        tb.ram.MEM[10]=0;
        //check reset
        rst_n = 0;//enable reset
        SS_n = 1;
        temp=0;
        #10;
        temp=10'b0000_01010;
        rst_n = 1;
        #10;
        @(negedge clk)begin
            SS_n=0;
        end
        @(negedge clk)begin
            MOSI = 0;
        end
        for(i=10;i>0;i=i-1)begin
        @(negedge clk)
            MOSI=temp[i-1];
        end
        //end communication and go to idle state
        @(negedge clk)
        SS_n=1;
        //write the address
        @(negedge clk)
        SS_n=0;
        @(negedge clk)begin
            MOSI = 0;
            temp = 10'b01000_01010;
        end
        for(i=10;i>0;i=i-1)begin
        @(negedge clk)
            MOSI = temp[i-1];
        end
        @(negedge clk)
        SS_n = 1;
        //read address
        @(negedge clk)
        SS_n=0;
        @(negedge clk)begin
            MOSI=1;
            temp=10'b10000_01010;
        end
        for(i=10;i>0;i=i-1)begin
        @(negedge clk)
            MOSI=temp[i-1];
        end
        @(negedge clk)
        SS_n=1;
        @(negedge clk)
        SS_n=1;
        //read address
        @(negedge clk)
        SS_n=0;
        @(negedge clk)begin
            MOSI=1;
            //read address 10
            temp=10'b11000_01010;
        end
        for(i=10;i>0;i=i-1)begin
        @(negedge clk)
            MOSI=temp[i-1];
        end
        //wait to take the data from miso
        #25;
        //cloe the communication
        @(negedge clk)
        SS_n=1;
        #100;
        $stop;
    end
    endmodule
        //****************success*************

        //check ss_n = 1 at idle state
        /*SS_n = 1;
        @(negedge clk);
        //go to CHK_CMD mode
        SS_n = 0;
        //go to write mode
        MOSI = 0;
        @(negedge clk);
        //*********************************************************
        //generate address to write
        repeat(8) begin
            MOSI = 0 ;
            @(negedge clk);
        end
        MOSI = 1 ;
        @(negedge clk);
        repeat(2) begin
            MOSI = 0;
            @(negedge clk);
        end
        SS_n = 1;
        //@(negedge clk);
        repeat(2) @(negedge clk);
        //**********************************************

        //go to CHK_CMD mode
        SS_n = 0;
        //go to write mode
        MOSI = 0;
        @(negedge clk);
        //generate data to write
        repeat(8)begin
            MOSI =$random;
            @(negedge clk);
        end
        MOSI = 1;
        @(negedge clk);
        MOSI = 1;
        @(negedge clk);
        MOSI = 0;
        @(negedge clk);
        SS_n = 1;
        repeat(2) @(negedge clk);
        //**************************************

        //go to CHK_CMD mode
        SS_n = 0;
        //go to read address mode
        MOSI = 1;
        repeat(2) @(negedge clk);
        repeat(7) begin
            MOSI = 0 ;
            @(negedge clk);
        end
        MOSI = 1 ;
        @(negedge clk);
        MOSI = 0;
        @(negedge clk);
        MOSI = 1;
        @(negedge clk);
        SS_n = 1;
        repeat(2) @(negedge clk);
        //*****************************************
        //go to CHK_CMD mode
        SS_n = 0;
        //go to read address mode
        MOSI = 1;
        repeat(2) @(negedge clk);
        repeat(7) begin
            MOSI = 0 ;
            @(negedge clk);
        end
        MOSI = 1 ;
        @(negedge clk);
        MOSI = 0;
        @(negedge clk);
        MOSI = 1;
        @(negedge clk);
        SS_n = 1;
        repeat(20) @(negedge clk);

        //go to CHK_CMD mode
        SS_n = 0;
        //go to read address mode
        MOSI = 1;
        repeat(8) begin
            MOSI = 0 ;
            @(negedge clk);
        end
        MOSI = 1 ;
        @(negedge clk);
        MOSI = 1;
        @(negedge clk);
        MOSI = 1;
        @(negedge clk);
        SS_n = 1;
        repeat(20) @(negedge clk);
        $stop;
    end*/
