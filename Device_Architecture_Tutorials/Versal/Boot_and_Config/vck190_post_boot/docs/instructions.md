

<!-- Start of main page-->
<table width="100%">
 <tr width="100%">
    <td align="center"><h1>Instructions - remove this file before publishing</h1>
    </td>
 </tr>
</table>

Instructions for using the tutorial repository template - To be added

# Repository Folder and File Structure

The structure of this repository should stay in sync with the template. The repository contains the following folders and files:

- **docs** folder
  - Individual folders for each tutorial. They can contain the following:
      - **Media** folder - put all images and other media in this folder.
      - **Design Files** folder - put any design files specific to the tutorial here.
      - **README.md** - this is the first section of the tutorial. For simple tutorials, this is the only file. For multi-page tutorials, this is the starting page.
      - Additional .md files for multi-page tutorials.

- **README.md** - This is the front page of your repository. From here, add links to individual tutorials and a description of each. You can also add introductory information here. For an example, see the [Vitis Tutorials](https://github.com/Xilinx/Vitis-Tutorials/tree/2020.1).
- **Resources** - This folder should contain the following:
  - **License file** and/or **notices** - This should include the license file(s) for the repository. This is often created as a result of the [Legal Sweep](https://confluence.xilinx.com/display/CKA/Facilitating+Legal+Sweep+for+Licensing+Requirements).
- **docs/language** folder - If your document is translated into additional languages, a translated version will be added in a separate docs folder. For example, **docs-jp** would include Japanese translated files.

# README.md files

The tutorial consists of one or more markdown files. If you are using the [Simple Tutorial Template](simple-tutorial-template.md), then the file should be named readme.md and be located at the top-level of the tutorial's folder.

Tutorials with multiple pages may have additional markdown files, but the first entry page should always be the README.md file. See the [Multi-Page Tutorial Template](multi-page-tutorial-template.md) for more information.

## Header

The header is defined by a table that includes the AMD logo, the title of the tutorial set, and the title of the individual tutorial.

**Note**: If the tutorial is a standalone document and not part of a set, then the tutorial set title is not needed.

The header looks like this:

<table>
 <tr>
   <td align="center"><img src="https://raw.githubusercontent.com/Xilinx/Image-Collateral/main/xilinx-logo.png" width="30%"/><h1>Title of Tutorial Set</h1>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>Title of Tutorial</h1>
 <p>(If this is a standalone tutorial, put the tutorial title in the row above and remove this row.)</p>
 </td>
 </tr>
</table>

## Tutorial content/labs
The templates provide a template structure for creating your tutorial.

## Xilinx Support section

All tutorials require the Xilinx Support section that is included in the template. In this section, add information about the support policy and where to get support (links to forums/SRs)


## Footer

The footer must contain the doc ID and the copyright dates. The following text is included in the template:

<p align="center"><sup>DOC ID | Copyright&copy; 2023 Advanced Micro Devices, Inc.</sup></p>

# Branches and Versioning

The current version is always the **master** branch.

When you update to another version of the document, a branch is created for the previous version, and the changes are made in the master branch.
