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

## Checks performed by PR_Verify for Segmented Configuration use cases

Use <code>pr_verify</code> to compare routed checkpoints from different design runs within a project or between projects to check if the NoC solution is identical. This must be done using two routed design checkpoints (.dcp) whose PS-PL connectivity and NoC solutions are related.

The syntax is as follows, simply list the two routed design images to compare:
 ```
 pr_verify -initial <first_design>_routed.dcp -additional <second_design>_routed.dcp
 ```

The first design checkpoint to be listed must be the "golden" design that has established the NoC solution reused in subsequent projects/runs. This initial run must contain the greatest usage of PS/PL and NoC boundary connections to establish the superset of connectivity possible.

<table>
  <tr>
    <th>Error Codes</th>
    <th>Type of Check</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>HDPRVerify-01, <br> 
        HDPRVerify-02, <br> 
        HDPRVerify-03, <br> 
        HDPRVerify-37</td>
    <td>Part & design property</td>
    <td>
        <li>The same part/package/speedgrade must be targeted in both checkpoints</li>
        <li>The SEGMENTED_CONFIGURATION property must be present in both designs</li>
    </td>
  </tr>
  <tr>
    <td>SegConfig-Validation-1, <br>
        SegConfig-Validation-2</td>
    <td>Boot path endpoints</td>
    <td>The same number of booth paths and end points are required</td>
  </tr>
  <tr>
    <td>SegConfig-Validation-3</td>
    <td>Boot path settings</td>
    <td>
     <li>Same endpoint type (master/slave)</li>
     <li>Same protocol used</li>
     <li>Same destination ID</li>
     <li>Same slave addresses</li>
    </td>
  </tr>
  <tr>
    <td>SegConfig-Validation-4</td>
    <td>Boot path routing</td>
    <td>
      <li>Same endpoint location</li>
      <li>Same virtual channel</li>
      <li>Same physical routes</li>
    </td>
  </tr>
  <tr>
    <td>SegConfig-Validation-10</td>
    <td>PS & CPM to PL interface</td>
    <td>pr_verify checks netlist connections from/to PS and CPM cells
        <li>The PLD design cannot add new connections from/to PS or CPM netlist cell</li>
        <li>Error checking is limited to pins ending with "*RCLKCLK" or "*PL*VALID"; changes to other pin names are reported as warnings</li>
        <li>The PLD design can have fewer connections from/to PS or CPM cell in secondary runs; this is tolerated as a warning</li>
        </td>
  </tr>
  <tr>
    <td>SegConfig-Validation-12</td>
    <td>Boot partition NMU configurations</td>
    <td>Configuration of a NMU relies on address map and Id of its connected NSUs. For each NMU on a boot path:
     <li>Check all connected NSUs have the same addresses and ID</li>
     <li>The secondary PLD design cannot add new connections to a boot path NMU</li>
     <li>The secondary PLD design can have fewer connections to a boot path NMU</li>
    </td>
  </tr>
  <tr>
    <td>SegConfig-Validation-13, <br>
        SegConfig-Validation-14, <br>
        SegConfig-Validation-15, <br> 
        SegConfig-Validation-16, <br>
        SegConfig-Validation-3 </td>
    <td>All NoC sites in boot partition</td>
    <td>
     <li>Same number NOC sites in boot and pld designs</li>
     <li>Same NOC endpoint type, protocol, destination id, slave addresses</li>
    </td>
  </tr>
  <tr>
    <td>SegConfig-Validation-17</td>
    <td>Boot path masters connections</td>
    <td>The secondary PLD design cannot add new connection from a boot path NMU</td>
  </tr>
  <tr>
    <td>SegConfig-Validation-18</td>
    <td>Boot partition IO usage</td>
    <td>The secondary PLD design cannot add new IO to banks included in the boot partition.<br> 
    These banks are used for DDRMC and are not reprogrammed with the PLD image.</td>
  </tr>
  </table>


<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2020-2024 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
