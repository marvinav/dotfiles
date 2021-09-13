echo "Start installation"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
} else{
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition;
choco install pulseaudio vcxsrv
$host.enternestedprompt()
}

