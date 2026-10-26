//
// Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
// SPDX-License-Identifier: X11
//

`timescale 1 ns / 1 ps

   module validate_ip_S_AXIS_rm2 #
   (
      // Users to add parameters here
      parameter integer C_NUM_OF_AXIS_BURST_TXNS   = 20, //Must be increments of 4
      parameter integer C_NUM_OF_AXIS_TXNS   = C_NUM_OF_AXIS_BURST_TXNS * 32,
      // AXI4Stream sink: Data Width
      parameter integer C_S_AXIS_TDATA_WIDTH   = 64,
      parameter integer C_S_DATA_TYPE = 0,
      parameter integer NUM_M_AXIS = 4,
      parameter S_AXIS_INST = 0
   )
   (
      // Users to add ports here
        //input tx_done,
        output reg error,
      // AXI4Stream sink: Clock
      input wire  S_AXIS_ACLK,
      // AXI4Stream sink: Reset
      input wire  S_AXIS_ARESETN,
      // Ready to accept data in
      (* MARK_DEBUG="true" *) output wire  S_AXIS_TREADY,
      // Data in
      (* MARK_DEBUG="true" *) input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
      // Byte qualifier
      (* MARK_DEBUG="true" *) input wire [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] S_AXIS_TKEEP,
       // TDEST routing info
      (* MARK_DEBUG="true" *) input wire [3:0] S_AXIS_TDEST,
      // Indicates boundary of last packet
      (* MARK_DEBUG="true" *) input wire  S_AXIS_TLAST,
      // Data is in valid
      (* MARK_DEBUG="true" *) input wire  S_AXIS_TVALID,
      // TID
      (* MARK_DEBUG="true" *) input wire [3:0] S_AXIS_TID
   );
   // function called clogb2 that returns an integer which has the 
   // value of the ceiling of the log base 2.
   function integer clogb2 (input integer bit_depth);
     begin
       for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
         bit_depth = bit_depth >> 1;
     end
   endfunction

   // Total number of input data.
   localparam NUMBER_OF_INPUT_WORDS  = C_NUM_OF_AXIS_TXNS;   //BILL    8;
   // bit_num gives the minimum number of bits needed to address 'NUMBER_OF_INPUT_WORDS' size of FIFO.
   localparam bit_num  = clogb2(NUMBER_OF_INPUT_WORDS-1);
   // Define the states of state machine
   // The control state machine oversees the writing of input streaming data to the FIFO,
   // and outputs the streaming data from the FIFO
   parameter [1:0] IDLE = 1'b0,        // This is the initial/idle state 

                   WRITE_FIFO  = 1'b1; // In this state FIFO is written with the
                                       // input stream data S_AXIS_TDATA 
   wire     axis_tready;
   // State variable
   reg mst_exec_state;  
   // FIFO implementation signals
   genvar byte_index;     
   // FIFO write enable
   wire fifo_wren;
   // FIFO full flag
   reg fifo_full_flag;
   // FIFO write pointer
   reg [bit_num-1:0] write_pointer;
   wire writes_done;
   reg [C_S_AXIS_TDATA_WIDTH-1:0] counter;
   wire [31:0] prbs_data;
   (* MARK_DEBUG="true" *) wire [C_S_AXIS_TDATA_WIDTH-1:0] reference_data;
   (* MARK_DEBUG="true" *) reg [C_S_AXIS_TDATA_WIDTH-1:0] result_data_reg;
   reg check_data;
    
   reg tvalid;
   reg tready;
   (* MARK_DEBUG="true" *) reg [C_S_AXIS_TDATA_WIDTH-1 : 0] s_axis_tdata_reg;
    
   wire [3:0] slave_inst_num;
    
   assign slave_inst_num = S_AXIS_INST;
   assign S_AXIS_TREADY   = axis_tready;
   assign writes_done = 0;
   assign axis_tready = 1; 

    always @(posedge S_AXIS_ACLK) 
        begin
        tvalid <= S_AXIS_TVALID;
        tready <= S_AXIS_TREADY;
        s_axis_tdata_reg <= S_AXIS_TDATA;
        end

   // Control state machine implementation
   always @(posedge S_AXIS_ACLK) 
   begin  
     if (!S_AXIS_ARESETN )
       begin
       mst_exec_state <= IDLE;
       end  
     else
       case (mst_exec_state)
         IDLE: 
           // The sink starts accepting tdata when 
           // there tvalid is asserted to mark the
           // presence of valid streaming data 
             if (tvalid)
               begin
               mst_exec_state <= WRITE_FIFO;
               end
             else
               begin
               mst_exec_state <= IDLE;
               end
         WRITE_FIFO: 
           // When the sink has accepted all the streaming input data,
           // the interface swiches functionality to a streaming master
           if (writes_done)
             begin
             mst_exec_state <= IDLE;
             end
           else
             begin
             // The sink accepts and stores tdata 
             // into FIFO
             mst_exec_state <= WRITE_FIFO;
             end
       endcase
   end

    wire [31:0] cnt_data;
    wire [23:0] cnt_final;
    reg [23:0] cnt[NUM_M_AXIS-1:0];
    genvar m_axis_num;
        generate
        for (m_axis_num=0; m_axis_num < NUM_M_AXIS; m_axis_num=m_axis_num+1) 
            begin
            wire [3:0] current_m_axis_num;
            assign current_m_axis_num =  m_axis_num;   
            always @(posedge S_AXIS_ACLK) 
                begin
                if (!S_AXIS_ARESETN)
                    begin
                    cnt[m_axis_num] <= 'h0;
                    end
                else
                    begin
                    if (tvalid && tready && s_axis_tdata_reg[27:24]==current_m_axis_num)
                        begin
                        cnt[m_axis_num] <= cnt[m_axis_num] + 1;
                        end
                    else
                        begin
                        cnt[m_axis_num] <= cnt[m_axis_num];
                        end    
                    end
                end 
             end
        endgenerate
    
    assign cnt_final = (s_axis_tdata_reg[27:24] > NUM_M_AXIS-1) ? 24'h0 : cnt[s_axis_tdata_reg[27:24]];
    assign reference_data = {(C_S_AXIS_TDATA_WIDTH/32){slave_inst_num,s_axis_tdata_reg[27:24],cnt_final}};
    
    always @ (posedge S_AXIS_ACLK)
        begin
        if (!S_AXIS_ARESETN)
            begin
            result_data_reg <= 0;
            check_data <= 0;
            end
        else
            begin
            if (tvalid && tready )
                begin
                result_data_reg <= s_axis_tdata_reg - reference_data;
                check_data <= 1;
                end
            else
                begin
                result_data_reg <= result_data_reg;
                check_data <= 0;
                end
            end
        end
   
    always @ (posedge S_AXIS_ACLK)
        begin
        if (!S_AXIS_ARESETN)
            begin
            error <= 0;
            end
        else
            begin
            if (check_data)
                begin
                if (result_data_reg != 0)
                    begin
                    error <= 1;
                    end
                else
                    error <= error;
                end  
            else
                begin
                error <= error;
                end
            end
        end

endmodule
