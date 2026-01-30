<table>
 <tr>
   <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal Tutorial</h1>
   <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>Segmented Configuration for Versal -- DRCs</h1>
 </td>
 </tr>
</table>

## Interactive Design Rule Checks available for Segmented Configuration

Design Rule Checks (DRC) can be called interactively for designs in Vivado. A comprehensive lists of checks can be done, covering a wide range of design flows and silicon features. A few of these checks are categorized for Segmented Configuration and focus on IO bank usage and clocking resources:

<img src="../images/segcfg_drcs.png?raw=true">

Run these DRCs on a post-synthesis checkpoint to analyze the design for the IO and clocking requirements noted here.

<table>
  <tr>
    <th>Check ID</th>
    <th>Type of Check</th>
    <th>DRC message</th>
  </tr>
  <tr>
    <td><nobr>SEGCONFIG-1</nobr></td>
    <td>Shared IO bank</td>
    <td>IO bank &lt;name&gt; is shared by the initial boot design and pld design. In Segmented Configuration flow, tiles and site in the boot image will only be loaded once, this IO bank will not be reprogrammed when pld image is loaded.</td>
  </tr>
  <tr>
    <td><nobr>SEGCONFIG-2</nobr></td>
    <td>Non-LVCMOS pld port in shared IO bank</td>
    <td>Pld port &lt;name&gt; is found in IO bank &lt;name&gt;, which contains another port &lt;name&gt; of the initial boot design. In a Segmented Configuration design, pld port in an IO bank that is shared with boot design must be confgured as LVCMOS, please change IOSTANDARD property of &lt;name&gt; to from &lt;name&gt; to LVCMOS.</td>
  </tr>
  <tr>
    <td><nobr>SEGCONFIG-3</nobr></td>
    <td>Clock resource in boot design</td>
    <td>Clocking tile &lt;name&gt; is used by the initial boot design, this may lead to problem in a Segmented Configuration flow. Clocking resources are typically used by pld designs.</td>
  </tr>
  <tr>
    <td><nobr>SEGCONFIG-4</nobr></td>
    <td>Shared resource by boot design & pld design</td>
    <td>Tile &lt;name&gt; is shared by the initial boot design and pld design. XPLL and CLK_PLL_AND_PHY tiles should not be shared by the initial boot design and pld design.</td>
  </tr>
</table>




<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2020-2024 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
