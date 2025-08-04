//
// Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
// SPDX-License-Identifier: X11
//

`timescale 1 ns / 1 ps

   module validate_ip_M_AXIS #
   (
      parameter integer C_NUM_OF_AXIS_BURST_TXNS   = 1, //Must be increments of 4
      parameter integer C_NUM_OF_AXIS_TXNS   = C_NUM_OF_AXIS_BURST_TXNS * 32,      
      // Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
      parameter integer C_M_AXIS_TDATA_WIDTH   = 32,
      // Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.
      parameter integer C_M_START_COUNT   = 8,
      parameter PRBS_INIT_VALUE   = 31'h5500_1456,
      parameter integer NUM_S_AXIS = 4,
      parameter M_AXIS_INST = 4'h0
   )
   (
      // Users to add ports here
      output  reg tx_done, 
      // User ports ends
      // Do not modify the ports beyond this line

      // Global ports
      input wire  M_AXIS_ACLK,
      // 
      (* MARK_DEBUG="true" *) input wire  M_AXIS_ARESETN,
      // Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
      (* MARK_DEBUG="true" *) output wire  M_AXIS_TVALID,
      // TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
      (* MARK_DEBUG="true" *) output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA,
      // TDEST routing info
      (* MARK_DEBUG="true" *) output wire [3:0] M_AXIS_TDEST,
      // TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
      (* MARK_DEBUG="true" *) output wire [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] M_AXIS_TKEEP,
      // TLAST indicates the boundary of a packet.
      (* MARK_DEBUG="true" *) output wire  M_AXIS_TLAST,
      // TREADY indicates that the slave can accept a transfer in the current cycle.
      (* MARK_DEBUG="true" *) input wire  M_AXIS_TREADY,
        // TID
      (* MARK_DEBUG="true" *) output wire [3:0] M_AXIS_TID
   );
   // Total number of output data                                                 
   localparam NUMBER_OF_OUTPUT_WORDS = C_NUM_OF_AXIS_TXNS;   //BILL  8;                                         
                                                                                        
   // function called clogb2 that returns an integer which has the                      
   // value of the ceiling of the log base 2.                                           
   function integer clogb2 (input integer bit_depth);                                   
     begin                                                                              
       for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                                      
         bit_depth = bit_depth >> 1;                                                    
     end                                                                                
   endfunction                                                                          
                                                                                        
   // WAIT_COUNT_BITS is the width of the wait counter.                                 
   localparam integer WAIT_COUNT_BITS = clogb2(C_M_START_COUNT-1);                      
                                                                                        
   // bit_num gives the minimum number of bits needed to address 'depth' size of FIFO.  
   localparam bit_num  = clogb2(NUMBER_OF_OUTPUT_WORDS);                                
                                                                                        
   // Define the states of state machine                                                
   // The control state machine oversees the writing of input streaming data to the FIFO,
   // and outputs the streaming data from the FIFO                                      
   parameter [1:0] IDLE           = 2'b00,                                        
                   INIT_COUNTER   = 2'b01,     
                   SEND_STREAM    = 2'b10,                    
                   SEND_TLAST     = 2'b11; 
   // State variable                                                                    
   (* MARK_DEBUG="true" *) reg [1:0] mst_exec_state;                                                            
   // Example design FIFO read pointer                                                  
   reg [bit_num-1:0] read_pointer;                                                      

   // AXI Stream internal signals
   //wait counter. The master waits for the user defined number of clock cycles before initiating a transfer.
   reg [WAIT_COUNT_BITS-1 : 0]    count;
   //streaming data valid
   reg     axis_tvalid;
   //streaming data valid delayed by one clock cycle
   reg     axis_tvalid_delay;
   //Last of the streaming data 
   reg     axis_tlast;
   //Last of the streaming data delayed by one clock cycle
   reg     axis_tlast_delay;
   //The master has issued all the streaming data stored in FIFO
   reg [15:0] num_packets_sent;
   wire [C_M_AXIS_TDATA_WIDTH-1 : 0] axis_tdata; 
   reg [3:0] axis_tdest;
   wire [3:0] master_inst_num;
   wire [3:0] init_tdest;
   
   assign init_tdest = (NUM_S_AXIS == 1) ? 0 : M_AXIS_INST;
   assign master_inst_num = M_AXIS_INST;
   assign M_AXIS_TID = M_AXIS_INST;
   // I/O Connections assignments
   assign M_AXIS_TVALID   = axis_tvalid;
   assign M_AXIS_TDATA      = axis_tdata;
   assign M_AXIS_TLAST      = axis_tlast;
   assign M_AXIS_TKEEP      = {(C_M_AXIS_TDATA_WIDTH/8){1'b1}};
   assign M_AXIS_TDEST    = axis_tdest;

   // Control state machine implementation                             
   always @(posedge M_AXIS_ACLK)                                             
   begin                                                                     
     if (!M_AXIS_ARESETN)                                                    
       begin                                                                 
       mst_exec_state <= IDLE;                                             
       count    <= 0;     
       read_pointer <= 0;
       axis_tvalid <= 0; 
       axis_tlast <= 0; 
       axis_tdest <= init_tdest;
       num_packets_sent <= 0;
       tx_done <= 0;
       end                                                                   
     else                                                                    
       case (mst_exec_state)                                                 
         IDLE:                                                                                                             
              begin                                                           
              count <= 0;   
              read_pointer <= 0; 
              axis_tvalid <= 0; 
              axis_tlast <= 0;                          
              if (num_packets_sent == 16'hFFFF)
                  begin
                  mst_exec_state <= IDLE;
                  tx_done <= 1;
                  end
              else
                  begin
                  mst_exec_state  <= INIT_COUNTER; 
                  tx_done <= 0;
                  end
              end                                                             
         INIT_COUNTER:                                                                                      
           if ( count == C_M_START_COUNT - 1 )                               
              begin                                                           
              mst_exec_state  <= SEND_STREAM;
              axis_tvalid <= 1; 
              axis_tlast <= 0;                                
              end                                                             
           else                                                              
             begin                                                           
               count <= count + 1;                                           
               mst_exec_state  <= INIT_COUNTER;                              
             end                                                             
         SEND_STREAM:                                                        
           if (read_pointer == NUMBER_OF_OUTPUT_WORDS-1)                                                      
              begin                                                           
              mst_exec_state <= SEND_TLAST;
              read_pointer <= read_pointer;
              axis_tvalid <= axis_tvalid;                                        
              axis_tlast <= 1;
              end                                                             
           else if (M_AXIS_TREADY && M_AXIS_TVALID)                                                             
              begin                                                           
              mst_exec_state <= SEND_STREAM;
              read_pointer <= read_pointer +1;
              axis_tvalid <= axis_tvalid;
              axis_tlast <= axis_tlast;                                 
              end
           else
              begin
              mst_exec_state <= SEND_STREAM;
              read_pointer <= read_pointer; 
              axis_tvalid <= axis_tvalid;
              axis_tlast <= axis_tlast;               
              end                                                             
         SEND_TLAST:                                                                                
           if (M_AXIS_TREADY && M_AXIS_TVALID && M_AXIS_TLAST)                                                      
              begin                                                           
              mst_exec_state <= IDLE;
              axis_tlast <= 0;
              axis_tvalid <= 0;
              read_pointer <= read_pointer;
              num_packets_sent <= num_packets_sent + 1;
              if (axis_tdest == (NUM_S_AXIS-1))
                  axis_tdest <= 4'h0;
              else
                  axis_tdest <= axis_tdest + 1;               
              end                                                             
           else                                                              
              begin                                                           
              mst_exec_state <= SEND_TLAST;
              end  
       endcase                                                               
   end                                                                                                             

    wire [31:0] cnt_data[NUM_S_AXIS-1:0];
    genvar s_axis_num;
        generate
        for (s_axis_num=0; s_axis_num < NUM_S_AXIS; s_axis_num=s_axis_num+1) 
            begin
            reg [23:0] cnt;
            wire [3:0] current_s_axis_num;
            assign current_s_axis_num =  s_axis_num;
            
            always @(posedge M_AXIS_ACLK) 
                begin
                if (!M_AXIS_ARESETN)
                    begin
                    cnt <= 'h0;
                    end
                else
                    begin
                    if (M_AXIS_TVALID && M_AXIS_TREADY && axis_tdest==s_axis_num)
                        begin
                        cnt <= cnt + 1;
                        end
                    else
                        begin
                        cnt <= cnt;
                        end    
                    end
                end
                assign cnt_data[s_axis_num] = {current_s_axis_num, master_inst_num,cnt};
            end
        endgenerate 

      assign axis_tdata =  {(C_M_AXIS_TDATA_WIDTH/32){cnt_data[axis_tdest]}};

   endmodule
