# Table of Contents

Designing with IP Integrator

<<<<<<< Updated upstream
**Introduction**

**Tutorial Design Description** 

**Step 1: Creating a Project**

**Step 2: Creating an IP Integrator Design**

**Step 3: Customizing IP**

**Step 4: Creating Connections**

**Step 5: Running Connection Automation**

**Step 6: Adding Masters and Block Automation**

**Step 7: Using the Address Editor**

**Step 8: Validating the Design**

**Step 9: Debugging the Design**

**Step 10: Creating and Implementing the Top-level Design**

# Designing with IP Integrator

<span id="_Toc66489212" class="anchor"></span>**Introduction**

The AMD Vivado™ Design Suite IP Integrator lets you create complex system designs byinstantiating and interconnecting IP cores from the Vivado IP catalog onto a design canvas. You can create designs interactively through the IP Integrator design canvas GUI, or programmatically using a Tcl programming interface.

This tutorial walks you through the steps for building a basic IP subsystem design using the IPIntegrator. You will instantiate a few IPs in the IP Integrator and then stitch them up to create an IP sub-system design. While working through this tutorial, you will be introduced to the IP Integrator GUI, run design rule checks (DRC) on your design, and then integrate the design into a top-level design in the Vivado Design Suite. Finally, you will run synthesis and
implementation and generate a bitstream on the design.

<span id="_Toc66489213" class="anchor"></span>**Tutorial Design
Description**

=======
Introduction

Tutorial Design Description

Step 1: Creating a Project

Step 2: Creating an IP Integrator Design

Step 3: Customizing IP

Step 4: Creating Connections

Step 5: Running Connection Automation

Step 6: Adding Masters and Block Automation

Step 7: Using the Address Editor

Step 8: Validating the Design

Step 9: Debugging the Design

Step 10: Creating and Implementing the Top-level Design

# Designing with IP Integrator**Introduction**

The AMD Vivado™ Design Suite IP Integrator lets you create complex
system designs by instantiating and interconnecting IP cores from the Vivado IP catalog
onto a design canvas. You can create designs interactively through the
IP Integrator design canvas GUI, or programmatically using a Tcl
programming interface.

This tutorial walks you through the steps for building a basic IP
subsystem design using the IP Integrator. You will instantiate a few IPs in the IP Integrator and then stitch them up to create an IP sub-system design. While working through this tutorial, you will be
introduced to the IP Integrator GUI, run design rule checks (DRC) on
your design, and then integrate the design into a top-level design in
the Vivado Design Suite. Finally, you will run synthesis and
implementation and generate a bitstream on the design.

**Tutorial Design Description**

>>>>>>> Stashed changes
This tutorial is based on a simple processor-based IP Integrator design.
It contains peripheral IP cores and an AXI Interconnect core, which
connects to a number of processors.

For the purpose of learning the different IP Integrator capabilities, we
will manually do some of the steps described in this tutorial, instead
of using an automated option all the time.

The design targets an AMD Virtex™ UltraScale+™ VCU118 Evaluation Platform with
a xcvu9p-flga2104-2L-e part.

## **Step 1: Creating a Project**

<<<<<<< Updated upstream
1.  Open the AMD Vivado™ Integrated Design Environment (IDE).

- On Linux, change to the directory where the Vivado tutorial design
  file is stored: cd \<Extract_Dir\>/Vivado_Tutorial. Then launch the Vivado Design Suite:
Vivado.

- On Windows, launch the Vivado Design Suite: **Start → All Programs →
  Xilinx Design Tools→ Vivado 2023.1**.

    As an alternative, click the **Vivado 2023.1** Desktop icon to start the
Vivado IDE.

    The Vivado IDE Getting Started page contains links to open or create projects and to view documentation, as shown in the following figure:

    <img src="./media/image1.png" />


    >**Note:** Your Vivado Design Suite installation may be called something different from Xilinx Design Tools on the Start menu.
=======
1.  Open the Vivado Integrated Design Environment (IDE).

- On Linux, change to the directory where the Vivado tutorial design
  file is stored: cd

    \<Extract_Dir\>/Vivado_Tutorial. Then launch the Vivado Design Suite:
Vivado.

- On Windows, launch the Vivado Design Suite: **Start → All Programs →
  Xilinx Design Tools→ Vivado 2023.2**.

    As an alternative, click the **Vivado 2023.2** Desktop icon to start the
Vivado IDE.

    The Vivado IDE Getting Started page contains links to open or create projects and to view
documentation, as shown in the following figure:

    <img src="./media/image1.png"/>

    >**Note:** Your Vivado Design Suite installation may be called
something different from Design Tools on the Start menu.
>>>>>>> Stashed changes

2.  Under the Quick Start section, select **Create Project**.

3.  The New Project wizard opens. Click **Next** to confirm the project
    creation.

4.  In the Project Name page, shown in the following figure, set the
    following options:

<<<<<<< Updated upstream
    a\. In the Project name field, enter Lab-1.

    b\. In the Project location field, enter \<IPI-Basics\>, or your current folder work location.

    <img src="./media/image2.jpg" alt="Graphical user interface, text, application, email Description automatically generated" />
=======
     a\. In the Project name field, enter Lab-1.

    b\. In the Project location field, enter \<IPI-Basics\>, or your current folder work location.

    <img src="./media/image2.png" alt="A screenshot of a computer Description automatically generated" />
>>>>>>> Stashed changes

5.  Ensure that Create project subdirectory is checked and click
    **Next.**

6.  In the Project Type page, select **RTL Project**, and select **Do not specify sources at this time**, then click **Next**, as shown in the following figure:

<<<<<<< Updated upstream
    <img src="./media/image3.jpg" alt="Graphical user interface, text, application, email Description automatically generated" />
=======
    <img src="./media/image3.png" alt="A screenshot of a computer Description automatically generated" />
>>>>>>> Stashed changes

7.  Click next, and then you land on the Default Part page. Click on the Boards tab to select the Virtex Ultrascale+ VCU118 Evaluation sPlatform.

<<<<<<< Updated upstream
    <img src="./media/image4.jpg" alt="Graphical user interface, text, application, email Description automatically generated" />

8.  Review the project summary in the New Project Summary page.

    <img src="./media/image5.png" />
=======
    <img src="./media/image4.png" alt="A screenshot of a computer Description automatically generated" />

8.  Review the project summary in the New Project Summary page.

    <img src="./media/image5.png" alt="A screenshot of a project Description automatically generated" />
>>>>>>> Stashed changes

9.  Click **Finish** to create the project.

10. The new project opens in the Vivado IDE.

## **Step 2: Creating an IP Integrator Design**

1.  Using the Flow Navigator, select Create Block Design.

    Notice how you can set Design Name, Directory, and source set in the
    **Create Block Design** dialog box. You can change or keep the default
    values and proceed.

<<<<<<< Updated upstream
    <img src="./media/image6.jpg" alt="Graphical user interface, application Description automatically generated" />

    The Vivado IP Integrator displays a design canvas to let you quickly create complex subsystem designs by integrating IP cores.
=======
    <img src="./media/image6.png" alt="A screenshot of a computer Description automatically generated" />

    The Vivado IP Integrator displays a design canvas to let you quickly
    create complex subsystem designs by integrating IP cores.
>>>>>>> Stashed changes

2.  There are a few different ways to add IPs in the block design

<<<<<<< Updated upstream
    - By clicking the **Add IP** button in the block design canvas. <img src="./media/image7.jpg" />

         <img src="./media/image8.jpg" alt="Graphical user interface, table Description automatically generated" />
=======
     - By clicking the **Add IP** button in the block design canvas.
    <img src="./media/image7.jpg"/>

    <img src="./media/image8.jpg" alt="Graphical user interface, table Description automatically generated" />
>>>>>>> Stashed changes

    - You can also right-click on the design canvas to open the context menu
  and select **Add IP**.

    - You can also add an IP by dragging and dropping the IP from the IP
  catalog to the block design canvas. In this case, you can search for
  the IP, select it and drag-and-drop it on the block design canvas.

    > **TIP:** *To open the IP Details window beside the IP catalog, as
<<<<<<< Updated upstream
 shown in the following figure, type* Ctrl-Q* as described at the
 bottom of the IP catalog window. This window lets you see details of
 the currently selected IP in the catalog.  
=======
    > shown in the following figure, type* Ctrl-Q* as described at the
    > bottom of the IP catalog window. This window lets you see details of
    > the currently selected IP in the catalog.
>>>>>>> Stashed changes

    <img src="./media/Lab-1-step-2.png" />

<<<<<<< Updated upstream
    You must add IPs in the block design now.
=======
    Add the IPs into the block design now.
>>>>>>> Stashed changes

3.  In the search field of the IP catalog, type gpio to find the AXI
    GPIO IP.

    <img src="./media/image9.png" />

    Select **AXI GPIO** core and press **Enter** on the keyboard or
<<<<<<< Updated upstream
double-click the core in the IP catalog. The AXI GPIO core is
instantiated onto the IP Integrator design canvas.

4.  Repeat step 2 to add the AXI Block RAM Controller, AXI Uartlite, and the
=======
    double-click the core in the IP catalog. The AXI GPIO core is
    instantiated onto the IP Integrator design canvas.

4.  Repeat step 2 to add the AXI block RAM Controller, AXI Uartlite, and the
>>>>>>> Stashed changes
    AXI SmartConnect.

5.  After adding all the IPs, the IP Integrator should look like this.
    The relative positions of the blocks placed on the canvas might be
    slightly different.  
<<<<<<< Updated upstream
    <img src="./media/image10.png" />
=======
    <img src="./media/image10.png"/>
>>>>>>> Stashed changes

6.  Click the Regenerate Layout button if you need to better placement
    of the blocks on the canvas.  
      
    <img src="./media/image11.png"/>

## **Step 3: Customizing IP**

1.  Double-click the AXI SmartConnect core to open the Re-Customize IP
    dialog box, as shown in the following figure:  
      
<<<<<<< Updated upstream
    <img src="./media/image12.png" />
=======
    <img src="./media/image12.png" alt="A screenshot of a computer Description automatically generated" />
>>>>>>> Stashed changes

2.  In the Settings, change Number of Master Interfaces field to **3**
    from the drop-down menu.

3.  Leave all the remaining options as it is and click **OK**.

    The IP integrator re-customizes the AXI SmartConnect, changing the
    number of master interfaces to three, as shown in the following
    figure:

    <img src="./media/image13.png"/>

 Now you can connect the three slave IP cores to the AXI SmartConnect.

## **Step 4: Creating Connections**

 At this point, you have instantiated several AXI slaves that you can
 access through a master such as a processor. To connect to a master
 controlling these slaves, first let’s create connectivity between the
 AXI SmartConnect and the instantiated IPs.
<<<<<<< Updated upstream
 An interface is a grouping of signals that share a common function,
 containing both individual signals and multiple buses. By grouping
 these signals and buses into an interface, the Vivado IP Integrator
 can identify common interfaces and automatically make multiple
 connections in a single step. See the *Vivado Design Suite User Guide:
 Designing IP Subsystems Using IP Integrator*
 ([UG994)](https://www.xilinx.com/cgi-bin/docs/rdoc?v=2020.2;d=ug994-vivado-ip-subsystems.pdf)
 for more information on interface pins and ports.

> **IMPORTANT!** *IP Integrator treats an external reset coming into the
> block design as asynchronous to the clocks. You should always
> synchronize the external resets with a clock domain in the IP
> subsystem to help the design meet timing.*

=======

 An interface is a grouping of signals that share a common function,
 containing both individual signals and multiple buses. By grouping
 these signals and buses into an interface, the Vivado IP Integrator
 can identify common interfaces and automatically make multiple
 connections in a single step. See the *Vivado Design Suite User Guide:
 Designing IP Subsystems Using IP Integrator*
 ([UG994)](https://docs.amd.com/access/sources/dita/map?Doc_Version=2020.2%20English&url=ug994-vivado-ip-subsystems)
 for more information on interface pins and ports.

> **IMPORTANT!** *IP Integrator treats an external reset coming into the
> block design as asynchronous to the clocks. You should always
> synchronize the external resets with a clock domain in the IP
> subsystem to help the design meet timing.*

>>>>>>> Stashed changes
 You can use a Processor System Reset block (proc_sys_reset) to
 synchronize the reset. The Processing System Reset is a soft IP that
 handles numerous reset conditions at its input and generates
 appropriate system reset signals at its output; however, if a clock
 and a reset are external inputs to the block design, and the reset
 signal synchronizes externally to the clock, then you need to
 associate the related clock with the reset. This does not require the
 Processor System Reset block.

1.  Place the cursor on top of the M00_AXI interface pin of the AXI
    SmartConnect. Click and drag the cursor from the M00_AXI interface
    pin to the S_AXI interface port of AXI GPIO block.

<<<<<<< Updated upstream
    > **Note:** The cursor changes into a pencil indicating that a connection can be made from that interface pin. Clicking the mouse button here starts a connection on the M00_AXI interface pin.

     <img src="./media/image14.jpg" alt="Diagram Description automatically generated" />

    > **TIP:** You must press and hold down the mouse button while dragging the connection from the* M00_AXI *pin to the S_AXI* interface port.

    As you drag the connection wire, a green checkmark appears on the
 S_AXI interface pin indicating that you can make a valid connection
 between these points. The Vivado IP Integrator highlights all possible
 connection points in the subsystem design as you interactively wire
 the pins and ports.
=======
    > **Note:** The cursor changes into a pencil indicating that a
    > connection can be made from that interface pin. Clicking the mouse
    > button here starts a connection on the M00_AXI interface pin.

     <img src="./media/image14.jpg" alt="Diagram Description automatically generated" />

    > **TIP:** *You must press and hold down the mouse button while dragging
    > the connection from the* M00_AXI *pin to the* S_AXI *interface port.*

    As you drag the connection wire, a green checkmark appears on the
    S_AXI interface pin indicating that you can make a valid connection
    between these points. The Vivado IP Integrator highlights all possible
    connection points in the subsystem design as you interactively wire
    the pins and ports.
>>>>>>> Stashed changes

2.  Release the mouse button and Vivado IP Integrator makes a connection
    between the M00_AXI interface pin and the S_AXI port, as shown in
    the following figure:

<<<<<<< Updated upstream
     <img src="./media/image15.png"/>

3.  Repeating the steps outlined above, connect the M01_AXI and the
    M02_AXI to the S_AXI interface ports of AXI Block RAM Controller and AXI
    Uartlite.

    > **Note:** The order of connection between M_AXI interfaces of the SmartConnect and S_AXI interfaces of the slave IPs does not matter.
=======
    <img src="./media/image15.png"/>

3.  Repeating the steps outlined above, connect the M01_AXI and the
    M02_AXI to the S_AXI interface ports of AXI block RAM Controller and AXI
    Uartlite.

    > **Note:** The order of connection between M_AXI interfaces of the
    > SmartConnect and S_AXI interfaces of the slave IPs does not matter.
>>>>>>> Stashed changes

    The connections to the AXI SmartConnect should now appear as shown in
    the following figure:

<<<<<<< Updated upstream
    <img src="./media/image16.png" />
=======
    <img src="./media/image16.png"/>
>>>>>>> Stashed changes

4.  Click the **File → Save Block Design** command from the main menu.

## **Step 5: Running Connection Automation**

 At this point, there are still some output interface pins that you
 must connect external to the subsystem design, such as the following:

- UART interface of the AXI Uartlite

- GPIO interface of the AXI GPIO

<<<<<<< Updated upstream
> **Note:** The AXI Block RAM Controller is not connected to a Block Memory Generator.
=======
 Also, note that the AXI block RAM Controller is not connected to a Block
 Memory Generator.
>>>>>>> Stashed changes

 IP Integrator offers the Designer Assistance feature to automate
 certain kinds of connections. For the current subsystem design, you
 can connect the UART and GPIO interfaces to external ports using
 connection automation. You can also use the Designer Assistance
<<<<<<< Updated upstream
 feature to connect a Block Memory Generator to the Block RAM Controller.
=======
 feature to connect a Block Memory Generator to the block RAM Controller.
>>>>>>> Stashed changes

1.  Click **Run Connection Automation** in the banner at the top of the
    design canvas.

<<<<<<< Updated upstream
     <img src="./media/image17.jpg"/>
=======
    <img src="./media/image17.jpg"/>
>>>>>>> Stashed changes

     The Run Connection Automation dialog box opens.

2.  Only select the interface pins shown in the following figure. This
<<<<<<< Updated upstream
    selects all external interfaces and the Block RAM Controller for auto
    connection.

    <img src="./media/image18.png"/>

3.  Select and highlight the interfaces, as shown in the following
    figure, to see a description of the automation that the tool offers
    as well as any options needed to connect these interfaces.

     <img src="./media/image19.png"/>
=======
    selects all external interfaces and the block RAM Controller for auto
    connection.

    <img src="./media/image18.png" alt="A screenshot of a computer Description automatically generated" />

3.  Select and highlight the interfaces to see a description of the automation that the tool offers as well as any options needed to connect these interfaces.
>>>>>>> Stashed changes

    
4.  Click **OK**.

<<<<<<< Updated upstream
5.  All the external interfaces connect to I/O ports, and the Block RAM
=======
5.  All the external interfaces connect to I/O ports, and the block RAM
>>>>>>> Stashed changes
    Controller connects to the Block Memory Generator, as shown in the
    following figure:
    
    <img src="./media/image20.png"/>

<<<<<<< Updated upstream
    You can right-click on the external ports (dip_switches_4bits and rs232_uart in this design) and select the External Interface Properties command.
=======
    <img src="./media/image20.png" style="width:5.82in;height:2.15in" />
>>>>>>> Stashed changes

    In the External Interface Properties window, you can change the name of the port if needed. The IP Integrator automatically assigns the name of the port when connection automation is run. For now, leave the port names as is.

<<<<<<< Updated upstream
     <img src="./media/image21.jpg" alt="Graphical user interface, text, application, email Description automatically generated"/>

=======
    In the External Interface Properties window, you can change the name
    of the port if needed. The IP Integrator automatically assigns the
    name of the port when connection automation is run. For now, leave the
    port names as is.

    <img src="./media/image21.jpg" alt="Graphical user interface, text, application, email Description automatically generated"/>

>>>>>>> Stashed changes
## **Step 6: Adding Masters and Block Automation**

The next step is to add and connect the masters to the subsystem created
so far.

1.  Right-click the design canvas to open the popup menu and select
    **Add IP**.

2.  In the search field, type Microblaze and double-click the core to
    instantiate it onto the canvas.

3.  Click **Run Block Automation** in the banner at the top of the
    design canvas.  
      
    <img src="./media/image22.png"/>

4.  Select all the default options in the Run Block Automation dialog
    box and click OK.  
<<<<<<< Updated upstream
    <img src="./media/image23.jpg" alt="Graphical user interface, text, application, Word Description automatically generated"/>
=======
    <img src="./media/image23.png" alt="A screenshot of a computer Description automatically generated" />
>>>>>>> Stashed changes

5.  The IP Integrator adds local memory and debug to the processor block
    and connects a Clocking Wizard and Processor System Reset to the
    subsystem.

6.  Click the Regenerate Layout button to redraw the subsystem design.

<<<<<<< Updated upstream
    The optimized layout of the design should now look like the following figure:  

    <img src="./media/image24.png"/>

7.  Click Run Connection Automation in the banner at the top of the
    design canvas. The **Run Connection Automation** dialog box opens.
    
=======
    The optimized layout of the design should now look like the following
    figure:  
   
    <img src="./media/image24.png"/>

7.  Click Run Connection Automation in the banner at the top of the
    design canvas. The **Run Connection Automation** dialog box opens.  
>>>>>>> Stashed changes
    <img src="./media/image17.jpg"/>

8.  Select **All Automation (7 out of 7 selected)** as shown in the
    following figure. This selects the external interfaces for clock and
    reset on the board, the s_axi_aclk of slave peripheral, and the
    master M_AXI_DP port of the processor for auto connection.
    
    <img src="./media/image25.png"/>

<<<<<<< Updated upstream
9.  Once connection automation is done, the design canvas should look
    something like the snapshot shown below:

       <img src="./media/image26.png"/>

10. You can also change the diagram view from Default to Interfaces view
    as shown below.

=======
    <img src="./media/image25.png" alt="A screenshot of a computer Description automatically generated" />

9.  Once connection automation is done, the design canvas should look
    something like the snapshot shown below:

     <img src="./media/image26.png"/> 

10. You can also change the diagram view from Default to Interfaces view
    as shown below.

>>>>>>> Stashed changes
    <img src="./media/image27.png"/>

11. The layout of the design should now look like the figure below with
    only interfaces showing on the canvas for better viewing. You can
    click the **Regenerate Layout** button
    <img src="./media/image28.png"/> to redraw the subsystem
    design. You can also change colors, layers and other general
    settings by clicking <img src="./media/image29.png"/> in the top right corner
    of the design canvas.

<<<<<<< Updated upstream
       <img src="./media/image30.png"/>
=======
    <img src="./media/image30.png"/> 
>>>>>>> Stashed changes

12. There are different ways of changing the view on the canvas and
    better organizing the blocks. One of these capabilities is creating
    hierarchy levels to include one or more blocks. To do so, select the
    following blocks- microblaze_0, microblaze_0_local_memory, and mdm_1
    by holding down the ctrl- button clicking on them one after the
    other. They should be highlighted in orange like the following
    figure-  
    <img src="./media/image31.jpeg" alt="Diagram Description automatically generated" />

13. Now, right-click and select Create Hierarchy.

<<<<<<< Updated upstream
     <img src="./media/image32.png"/>
=======
    <img src="./media/image32.png"/>
>>>>>>> Stashed changes

14. You can assign a new name to the hierarchy or keep the default name
    in the dialog box, then click OK.

<<<<<<< Updated upstream
    >**Note:** You can expand the hierarchy to see the content inside by
 clicking on the + button on the top left of the block.

    <img src="./media/image33.png"/>  
    <img src="./media/image34.jpg" alt="Graphical user interface, application Description automatically generated" />

  Hierarchy levels can help with organizing the blocks on the canvas
=======
    > **Note:** You can expand the hierarchy to see the content inside by
    > clicking on the + button on the top left of the block.

    <img src="./media/image33.png"/> 
 
    <img src="./media/image34.jpg" alt="Graphical user interface, application Description automatically generated"/>

1.  Hierarchy levels can help with organizing the blocks on the canvas
>>>>>>> Stashed changes
    as well as replicating different sections of a block design. At this
    point, you have connected only one master to the SmartConnect block.
    To add the second master, we replicate the hierarchy block created
    in the previous step.

<<<<<<< Updated upstream
1.  Switch the diagram view from Interfaces to Default from the top
    canvas toolbar.
2.  Select the MicroBlaze subsystem hierarchy block previously created
    (hier_0), right-click and select copy.

       <img src="./media/image35.png"/>

3.  Right-click on the white space area of the canvas and select paste.
    A second hierarchical level with the exact same content gets
    created.

4.  After creating both the hierarchies, you will now have 2 Microblaze
=======
2.  Switch the diagram view from Interfaces to Default from the top
    canvas toolbar.

3.  Select the MicroBlaze subsystem hierarchy block previously created
    (hier_0), right-click and select copy.

    <img src="./media/image35.png"/> 

4.  Right-click on the white space area of the canvas and select paste.
    A second hierarchical level with the exact same content gets
    created.

5.  After creating both the hierarchies, you will now have 2 Microblaze
>>>>>>> Stashed changes
    Debug Modules. Change the **BSCAN location** of the Microblaze Debug
    Module (MDM) to **EXTERNAL** for both the debug modules. This is to
    avoid any implementation issues with both the BSCAN locations, as
    the might get assigned the same location.  
<<<<<<< Updated upstream
    <img src="./media/image36.png"/>

5.  Click **Run Connection Automation** in the banner at the top of the
    design canvas.

     <img src="./media/image17.jpg"/>

6.  Select **All Automation (2 out of 2 selected)** to connect M_AXI_DP
    of the MicroBlaze to the second master AXI port of the
    SmartConnect.  
      
    <img src="./media/image37.jpg" alt="Graphical user interface, application Description automatically generated"/>

7.  Click the **Regenerate Layout** button
    <img src="./media/image28.png"/> to redraw the subsystem design.
=======
    <img src="./media/image36.png" alt="A screenshot of a computer Description automatically generated" />

6.  Click **Run Connection Automation** in the banner at the top of the
    design canvas.

    <img src="./media/image17.jpg"/>

7.  Select **All Automation (2 out of 2 selected)** to connect M_AXI_DP
    of the MicroBlaze to the second master AXI port of the
    SmartConnect.  
      
    <img src="./media/image37.png" alt="A screenshot of a computer Description automatically generated" />

8.  Click the **Regenerate Layout** button
    <img src="./media/image28.png"/> to redraw the subsystem
    design.

    The optimized layout of the design should now look like the following
    figure:
>>>>>>> Stashed changes

    <img src="./media/image38.png"/>

<<<<<<< Updated upstream
    <img src="./media/image38.png"/>

8.  The only remaining connection is the sys_rst port of the new
    hierarchical block.

    Place the cursor on top of the pin and drag the connection to bus_struct_reset\[0:0\] port of the Processor System Reset block.

    <img src="./media/image39.jpeg" alt="Diagram Description automatically generated"/>

9. Click on **File → Save Block Design** command from the main menu.
=======
9.  The only remaining connection is the sys_rst port of the new
    hierarchical block.

    Place the cursor on top of the pin and drag the connection to
     bus_struct_reset\[0:0\] port of the Processor System Reset block.

     <img src="./media/image39.jpeg" alt="Diagram Description automatically generated" />

10. Click on **File → Save Block Design** command from the main menu.
>>>>>>> Stashed changes

## **Step 7: Using the Address Editor**

For various memory mapped master and slave interfaces, IP Integrator
<<<<<<< Updated upstream
follows the industry standard IP-XACT data format for capturing memory requirements and
capabilities of endpoint masters and slaves. This section provides an overview of how IP
Integrator models address information on a memory-mapped slave.

Master interfaces have address spaces, or address_space objects. Slave interfaces have an address_space container called a memory map to map the slave to the address space of the associated master. Typically, these memory maps are named after the slave interface pins, for example S_AXI, though that is not required.
=======
follows the industry
standard IP-XACT data format for capturing memory requirements and
capabilities of endpoint
masters and slaves. This section provides an overview of how IP
Integrator models address
information on a memory-mapped slave. Master interfaces have address spaces, or address_space objects. Slave
interfaces have an
address_space container called a memory map to map the slave to the
address space of the
associated master. Typically, these memory maps are named after the
slave interface pins, for example S_AXI, though that is not required.
>>>>>>> Stashed changes

The memory map for each slave interface pin contains address segments,
or address_segment objects. These address segments correspond to the
address decode window for that slave. A typical AXI4-Lite slave will
have only one address segment, representing a range of addresses.
However, some slaves, like a bridge, will have multiple address segments
or a range of addresses for each address decode window.

When you map a slave to the master address space, a master
address_segment object is created, mapping the address segments of the
slave to the master. The Vivado IP Integrator can automatically assign
addresses for all slaves in the design. However, you can also manually
assign the addresses using the Address Editor. In the Address Editor,
you see the address segments of the slaves, and can map them to address
spaces in the masters.

<<<<<<< Updated upstream
> **TIP:** *The Address Editor tab only appears if the subsystem design
=======
>**TIP:** *The Address Editor tab only appears if the subsystem design
>>>>>>> Stashed changes
contains an IP block that functions as a bus master. In the tutorial
design, the processors connecting through the AXI SmartConnect are the
bus masters.*

1.  Click the **Address Editor** tab to show the memory map of all the
    slaves in the design.

<<<<<<< Updated upstream
    > **Note:** If the Address Editor tab is not visible then select **Window →  Address Editor** from the main menu.

    The IP Integrator has automatically assigned the addresses.
    
    >**Note:** There are three address networks. One is the shared network between processors accessing the peripherals (AXI Block RAM, GPIO, and UART), and two networks for local memory belonging to each processor subsystem.
=======
    > **Note:** If the Address Editor tab is not visible then select
    > **Window →  Address Editor** from the main menu.

    The IP Integrator has automatically assigned the addresses.

    > **Note:** There are three address networks. One is the shared network
    between processors accessing the peripherals (AXI block RAM, GPIO, and
    UART), and two networks for local memory belonging to each processor
    subsystem.
>>>>>>> Stashed changes

    You can change the automatic address assignments by clicking in the
 corresponding column and changing the values.

<<<<<<< Updated upstream
2.  Change the size of the address segments for the AXI Block RAM Controller
=======
2.  Change the size of the address segments for the AXI block RAM Controller
>>>>>>> Stashed changes
    core for the MicroBlaze in hier_1. Click the **Range** column, and
    select **64K** from the drop-down menu as shown in the following
    figure:

    <img src="./media/image40.png"/>

3.  Select the **Diagram** tab, to return to the IP Integrator design
    canvas.

## **Step 8: Validating the Design**

1.  From the menu at the top of the IPI design canvas, run the IP
    subsystem design rule checks (DRCs) by clicking the **Validate Design** button

    <img src="./media/image41.png"/>

<<<<<<< Updated upstream
    The Validate Design dialog box opens, and validation should be successful. Click **OK**.  
   
    <img src="./media/image42.jpg" alt="Diagram Description automatically generated"/>

    At this point, you should save the IP Integrator subsystem design again.
=======
    The Validate Design dialog box opens, and validation should be
    successful. Click **OK**.  
   
    <img src="./media/image42.jpg" />

    At this point, you should save the IP Integrator subsystem design
    again.
>>>>>>> Stashed changes

2.  Select **File → Save Block Design** command from the main menu to
    save the design.

## **Step 9: Debugging the Design**

The System ILA debug core in IP integrator allows you to perform
in-system debugging of block designs. This feature should be used when
there is a need to monitor interfaces and signals in the design. We will
demonstrate how to debug a signal in this section.

1.  Mark the interface between the AXI SmartConnect and AXI GPIO IPs by
    right-clicking on the net and selecting Debug from the context menu
    as shown in the following figure:  
      
    <img src="./media/image43.png"/>
<<<<<<< Updated upstream
    
    > **Note:** The nets and interface marked for debug show a small bug icon placed on top of the net or interface in the block design.

    <img src="./media/image44.jpg" />
=======

    > **Note:** The nets and interface marked for debug show a small bug icon
    placed on top of the net or interface in the block design.

    <img src="./media/image44.jpg" alt="Diagram Description automatically generated" />
>>>>>>> Stashed changes

2.  Now, use Designer Assistance to connect the interface to the System
    ILA core.

    <img src="./media/lab-1-step-9.png"/>

3.  You can select the desired options for the System ILA core for
    debugging or accept the default values.  
      
<<<<<<< Updated upstream
    <img src="./media/image45.png"/>
=======
    <img src="./media/image45.png" alt="A screenshot of a computer Description automatically generated" />
>>>>>>> Stashed changes

4.  Validate Design to ensure that design connectivity is correct.

## **Step 10: Creating and Implementing the Top-level Design**

With the IP subsystem design completed and validated, it can be included
as a module or block in the top-level design or it may be the top-level
in the design. In either case, you need to generate the HDL files for
the subsystem design.

1.  In the **Sources** window, right-click the top-level subsystem
    design, **design_1**, and select **Generate Output Products**.

    The Generate Output Products dialog box lets you choose how to handle
     the synthesis of the block design. The three Synthesis Options
     include:

<<<<<<< Updated upstream
    - **Global:** Synthesizes the block design as part of the top-level
  project rather than as an out-of-context block.

    - **Out-of-Context per IP:** Synthesizes each IP in the block design
=======
- **Global:** Synthesizes the block design as part of the top-level
  project rather than as an out-of-context block.

- **Out-of-Context per IP:** Synthesizes each IP in the block design
>>>>>>> Stashed changes
  separately, out-of-context of the block design or the top-level
  design. This prevents each IP from being synthesized unnecessarily but
  requires updating and re-synthesizing each IP when it is updated.

<<<<<<< Updated upstream
    - **Out-of-context per Block Design:** Synthesizes the entire block
=======
- **Out-of-context per Block Design:** Synthesizes the entire block
>>>>>>> Stashed changes
  design at one time, but out-of-context from the global or top-level
  design. This prevents the block design from being synthesized
  unnecessarily when the top-level design is synthesized but requires
  updating and re-synthesizing the block design when any of the IP in it
  are updated.

<<<<<<< Updated upstream
        Leave the default selection of Out of Context per IP. 

        <img src="./media/image46.png"/>

2.  Click **Generate** to generate all output products.

    Alternatively, you can click **Generate Block Design** in the Flow Navigator, under the IP Integrator drop-down menu.

=======
    Leave the default selection of Out of Context per IP.  
   
    <img src="./media/image46.png" alt="A screenshot of a computer Description automatically generated" />

2.  Click **Generate** to generate all output products.

    Alternatively, you can click **Generate Block Design** in the Flow
    Navigator, under the IP Integrator drop-down menu.  
   
>>>>>>> Stashed changes
    <img src="./media/image47.png"/>

3.  The Out-of-Context (OOC) runs for each IP in the design launch,
    shown in the Design Runs tab below. OOC runs can take a few minutes
    to finish.

4.  After the Out-of-context runs are finished, in the Sources window,
    right-click the top-level subsystem design, **design_1**, and select
    **Create HDL Wrapper**.

    The Create HDL Wrapper dialog box opens, and offers two choices:

    - **Copy generated wrapper to allow user edits:** with this option you
  will modify the wrapper file. Often a block design is a subset of an
  overall project. In cases like these, you might need to edit the
  wrapper file and instantiate other design components in the wrapper.
  If the I/O interface of the block design changes in any manner, you
  must manually update the wrapper file to reflect those changes.

    - **Let Vivado manage wrapper and auto-update:** with this option Vivado
  generates and updates the wrapper file as needed. The wrapper file
  created using this method is automatically updated every time output
  products for the block design are generated, to reflect the latest
  changes.

5.  Select the default option, **Let Vivado manage wrapper and
    auto-update** and click **OK**.

<<<<<<< Updated upstream
    > **Note:** The Vivado IDE creates a top-level HDL wrapper for the design_1 block design and adds it to the design sources to the project and proceed to implementation.
=======
    The Vivado IDE creates a top-level HDL wrapper for the design_1 block
 design and adds it to the design sources to the project and proceed to
 implementation.
>>>>>>> Stashed changes

6.  Once the top-level HDL source is added to the project, add the
    design constraints by clicking **File → Add Sources.** Then click on
    **Add or Create Constraints** and click **Next.** Then click on
    **Add files** to add the “/constraints/vcu118_rev2.0_12082017.xdc”
    file.  
      
    <img src="./media/image48.png"/>

7.  Now, you have three options to move forward:

<<<<<<< Updated upstream
    - Use the Run Synthesis command to run only synthesis.

    - Use the Run Implementation command, which will first run synthesis if
  it has not been run and then run implementation.

    - Use the Generate Bitstream command, which will first run synthesis,
  then run implementation if they have not been run, and then write the
  bitstream for programming the Xilinx device.
=======
- Use the Run Synthesis command to run only synthesis.

- Use the Run Implementation command, which will first run synthesis if
  it has not been run and then run implementation.

- Use the Generate Bitstream command, which will first run synthesis,
  then run implementation if they have not been run, and then write the
  bitstream for programming the AMD device.
>>>>>>> Stashed changes

     These options can be selected from the Flow Navigator.

8.  For this lab, we are going to generate the bitstream for the design.
    From the Flow Navigator, click on **Generate Bitstream,** which will
    automatically synthesize, implement, and generate the bitstream for
    the design.

    <img src="./media/image49.png"/>

<<<<<<< Updated upstream
    The No Implementation Results Available dialog box opens as seen in the following figure:
    
=======
    The No Implementation Results Available dialog box opens as seen in
    the following figure:  
   
>>>>>>> Stashed changes
    <img src="./media/image50.png"/>

9.  When the bitstream generation completes, you will get the following
    message.  
    <img src="./media/image51.png"/>

<<<<<<< Updated upstream
    This marks the end of the tutorial. You can now exit Vivado.
=======
This marks the end of the tutorial. You can now exit Vivado.
>>>>>>> Stashed changes
