# Open-Website
___
*Powershell Module (v5) for Windows OS for opening new browsers from the command line.*

To use simply download the module and run the following command:

`Import-Module "Location\Of\Module\Open-Website.psm1" -Force`

Supported browsers are:

- Internet Explorer
- Chrome
- Firefox
- \*Edge

\* **Opening Edge from Powershell can potentially crash the terminal. Use at your own risk.**

`Open-Website -Browser Chrome -URL github.com/pixelstroke`

You may also focus on an element id if one exists using the `-Focus` parameter
