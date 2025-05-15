# Create a function to change colors in PowerShell
function Color-Console {
	$Host.ui.rawui.foregroundcolor = "gray"
	Clear-Host
}
 
# Calls the Color-Console function
Color-Console