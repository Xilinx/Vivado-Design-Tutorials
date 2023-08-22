# 2022.2 Update Process

1. [Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) this [template repository](https://gitenterprise.xilinx.com/techdocs/MIT_License_Included).
   - For the new repository's name, use the name of the directory that contains your tutorial, such as [`ryanv/VNOC_Sharing`](https://gitenterprise.xilinx.com/ryanv/VNOC_Sharing)
2. [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) your newly forked repository to your local space/machine.
3. [Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) the [swm/Vivado-Design-Tutorials](https://gitenterprise.xilinx.com/swm/Vivado-Design-Tutorials) repository.
4. Clone your fork of `Vivado-Design-Tutorials` (e.g. [ryanv/Vivado-Design-Tutorials](https://gitenterprise.xilinx.com/ryanv/Vivado-Design-Tutorials)), to your local space/machine.
5. Ensure you use the `2022.2_next` branch.
6. On your machine, move your tutorial's directory (e.g., `Vivado-Design-Tutorials\Device_Architecture_Tutorials\Versal\DFX\VNOC_Sharing`) from your local instance of the Vivado-Design-Tutorials repository (e.g., [`ryanv/Vivado-Design-Tutorials/2022.2_next`](https://gitenterprise.xilinx.com/ryanv/Vivado-Design-Tutorials/tree/2022.2_next)) to your newly created tutorial repository (e.g., [`ryanv/VNOC_Sharing`](https://gitenterprise.xilinx.com/ryanv/VNOC_Sharing)).
7. Use your newly-created-tutorial-repository (e.g., [`ryanv/VNOC_Sharing`](https://gitenterprise.xilinx.com/ryanv/VNOC_Sharing)) as the link in your SCL Open Sourcing Pre-approval.
8. After you have made all desired and necessary changes, when you want to bring your changes into the [upstream repository](https://gitenterprise.xilinx.com/swm/Vivado-Design-Tutorials), move your tutorial's directory from your newly-created-tutorial-repository back to its original location in your forked Vivado-Design-Tutorials instance (i.e., move `VNOC_Sharing` back to `Vivado-Design-Tutorials\Device_Architecture_Tutorials\Versal\DFX\`)
9. To merge the changes from the *2022.2_next* branch of your fork (e.g., [ryanv/Vivado-Design-Tutorials/tree/2022.2_next](https://gitenterprise.xilinx.com/ryanv/Vivado-Design-Tutorials/tree/2022.2_next)) back to the upstream repository ([swm/Vivado-Design-Tutorials](https://gitenterprise.xilinx.com/swm/Vivado-Design-Tutorials)), create a [Pull Request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork).

## References

- [CKA Basic Workflow for GitHub](https://confluence.xilinx.com/display/CKA/Basic+Workflow)
- [Vivado-Design-Tutorials 2023.1 Release Plan](https://confluence.xilinx.com/display/TDL/Vivado-Design-Tutorials+2023.1+Release+Readiness)

<p class="sphinxhide" align="center"><sub>Copyright © 2020–2023 Advanced Micro Devices, Inc</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
