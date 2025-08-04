<table>
 <tr>
   <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal Tutorial</h1>
   <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>Segmented Configuration for Versal -- PL Reload</h1>
 </td>
 </tr>
</table>

# Checks performed by PR_Verify for Segmented Configuration use cases

Use <code>pr_verify</code> to compare routed checkpoints from different design runs within a project or between projects to check if the NoC solution is identical. This must be done using two routed design checkpoints (.dcp) whose PS-PL connectivity and NoC solutions are related.

The syntax is as follows, simply list the two routed design images to compare:
 ```
 pr_verify -initial <first_design>_routed.dcp -additional <second_design>_routed.dcp
 ```

The first design checkpoint to be listed must be the "golden" design that has established the NoC solution reused in subsequent projects/runs. This initial run must contain the greatest usage of PS/PL and NoC boundary connections to establish the superset of connectivity possible.

<table>
  <tr>
    <th>Type of Check</th>
    <th>Description</th>
    <th>Error Codes</th>
  </tr>
  <tr>
    <td>Part & design property</td>
    <td>
        <li>The same part/package/speedgrade must be targeted in both checkpoints</li>
        <li>The SEGMENTED_CONFIGURATION property must be present in both designs</li>
    </td>
    <td>Dfx 88-133, 88-134, 88-135, 88-136</td>
  </tr>
  <tr>
    <td>PS & CPM to PL interface</td>
    <td>pr_verify checks netlist connections from/to PS and CPM cells
        <li>The PLD design cannot add new connections from/to PS or CPM netlist cell</li>
        <li>Error checking is limited to pins ending with "*RCLKCLK" or "*PL*VALID"; changes to other pin names are reported as warnings</li>
        <li>The PLD design can have fewer connections from/to PS or CPM cell in secondary runs; this is tolerated as a warning</li>
        </td>
    <td>Dfx 88-137</td>
  </tr>
  <tr>
    <td>Boot partition NMU configurations</td>
    <td>Configuration of a NMU relies on address map and Id of its connected NSUs. For each NMU on a boot path:
     <li>Check all connected NSUs have the same addresses and ID</li>
     <li>The secondary PLD design cannot add new connections to a boot path NMU</li>
     <li>The secondary PLD design can have fewer connections to a boot path NMU</li>
    </td>
    <td>Dfx 88-139</td>
  </tr>
  <tr>
    <td>All NoC sites in boot partition</td>
    <td>
     <li>Same number NOC sites in boot and pld designs</li>
     <li>Same NOC endpoint type, protocol, destination id, slave addresses</li>
    </td>
    <td>Dfx 88-140, 88-141, 88-142, 88-143, 88-147</td>
  </tr>
  <tr>
    <td>Boot path masters connections</td>
    <td>The secondary PLD design cannot add new connection from a boot path NMU</td>
    <td>Dfx 88-144</td>
  </tr>
  <tr>
    <td>Boot path endpoints</td>
    <td>The same number of booth paths and end points are required</td>
    <td>Dfx 88-145, 88-146</td>
  </tr>
  <tr>
    <td>Boot path settings</td>
    <td>
     <li>Same endpoint type (master/slave)</li>
     <li>Same protocol used</li>
     <li>Same destination ID</li>
     <li>Same slave addresses</li>
    </td>
    <td>Dfx 88-147</td>
  </tr>
  <tr>
    <td>Boot path routing</td>
    <td>
      <li>Same endpoint location</li>
      <li>Same virtual channel</li>
      <li>Same physical routes</li>
    </td>
    <td>Dfx 88-148</td>
  </tr>
</table>




<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2020-2024 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
