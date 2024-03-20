module SPI (MOSI,MISO,SS_n,clk,rst_n,rx_data,tx_data,rx_valid,tx_valid);

    //parameters
    parameter TX_SIZE = 8;
    parameter RX_SIZE = 10;
    //decler states as parameter
    parameter IDLE = 3'b000;
    parameter CHK_CMD = 3'b001;
    parameter WRITE = 3'b010;
    parameter READ_ADD = 3'b011;
    parameter READ_DATA = 3'b100;

    //inputs
    input  MOSI, clk, rst_n, SS_n, tx_valid;
    input [TX_SIZE-1:0] tx_data;

    //outputs
    output reg [RX_SIZE-1:0] rx_data;
    //output reg [RX_SIZE-1:0] rx_data0;
    //output reg [RX_SIZE-1:0] rx_data1;
    output reg rx_valid;
    output reg MISO;

    //regs
    reg [2:0] cs,ns;
    reg read_data_falg  ;
    reg [3:0] counter ,  counter1 ;
    reg [9:0]spbus ;
    reg [7:0]psbus;
    //reg [RX_SIZE-1:0] counter ;
    //reg [RX_SIZE-1:0]  bit_counter_pts;

    //genvar  i;


    //state memory block
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n) cs <= IDLE;
        else cs <= ns;
    end

    //next state block
    always @(*) begin
        case (cs)
            IDLE:begin
                //check SS_n = 1
                if(SS_n) ns = IDLE;
                else ns = CHK_CMD;
            end 

            CHK_CMD:begin
                //check SS_n = 1
                if(SS_n) ns = IDLE;
                //when SS_n = 0
                else begin
                    //when mosi = 1 and read_data_flag = 0
                    if(MOSI) begin
                        if(read_data_falg) begin
                            ns <= READ_DATA;
                        end
                         //when mosi = 1 and read_Data_flag = 1
                        else begin
                            ns <= READ_ADD;
                            //read_data_falg = 0;
                        end
                    end
                    //when mosi = 0
                    else ns <= WRITE;
                end
            end

            WRITE:begin
                //when SS_n = 0
                if(SS_n) ns = IDLE; //&& bit_counter_stp != RX_SIZE-1 ) 
                //when SS_n = 1
                else ns = WRITE;
            end

            READ_ADD:begin
                if(SS_n)ns = IDLE;// && counter != RX_SIZE-1 ) 
                //when SS_n =1
                else ns = READ_ADD;
            end

            READ_DATA:begin
                if(SS_n) ns = IDLE; // && bit_counter_pts != TX_SIZE-1 ) 
                //when SS_n =1
                else ns = READ_DATA;
            end
            default: ns = IDLE;
        endcase
    end

    //output block
    always @(posedge clk) begin
        case(cs)
            WRITE:begin
                spbus[counter-1] <= MOSI;
                counter <= counter - 1 ;     
                if(counter == 0) begin
                    counter <= 10;  
                    rx_valid <= 1;
                    rx_data <= spbus;
                end                          
            end

            READ_ADD:begin
                spbus[counter-1] <= MOSI;
                counter <= counter - 1;
                if(counter ==0 ) begin
                    counter <= 10;
                    rx_valid <= 1;
                    rx_data <= spbus;
                    read_data_falg <= 1;
                end
            end

        READ_DATA:begin
            if(~tx_valid)begin
                spbus[counter-1] <= MOSI;
                counter<=counter-1;
                if(counter==0)begin
                counter<=10;
                rx_valid<=1;
                rx_data<=spbus;
                read_data_falg<=0;
                end
            end
            else begin
                psbus<=tx_data;
                MISO<=psbus[counter1-1];
                counter1=counter1-1;
                if(counter1==0)
                counter1<=8;
            end
        end

        IDLE:begin
            rx_valid <= 0;
            MISO <=0;
            counter <= 10;
            counter1 <= 8;
            psbus<=0;
            spbus <= 0;
            end
        endcase
    end

endmodule