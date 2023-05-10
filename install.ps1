$FilesToCopy = @("removeFiles.ps1")

$Destination = "$env:SystemDrive\scripts\KompassetSlettFiler\"

$LogFile = "$env:TEMP\Kompass.txt"

"Starting ..." | Out-File $LogFile -Append

Try

{

# Create Folder if not exist

if ( -not ( Test-Path -Path "$Destination" ) )

{

"Creating $Destination Folder ..." | Out-File $LogFile -Append

New-Item -Path $Destination -ItemType Directory

}

# Copy each file

foreach ($FileToCopy in $FilesToCopy)

{

# Using $PSScriptRoot

"Copying $FileToCopy ..." | Out-File $LogFile -Append

Copy-Item -Path "$PSScriptRoot\$FileToCopy" -Destination "$Destination\$FileToCopy"


}

###Creating the schedule###
"Creating task action" | Out-File $LogFile -Append
#Set the action
$action = New-ScheduledTaskAction -Execute "C:\Scripts\KompassetSlettFiler\removeFiles.ps1"
$action | Out-File $LogFile -Append

#Set a trigger
"Creating task trigger" | Out-File $LogFile -Append
$trigger1 = New-ScheduledTaskTrigger -Daily -At 3am
$trigger2 = New-ScheduledTaskTrigger -AtLogOn
$triggers = @($trigger1, $trigger2) 
$triggers | Out-File $LogFile -Append
#Set a Name
$taskname = "KompassetRens"

#Set a Description
$taskdescription = "Fjerner brukermappene"

#Register the Task
"Registering task" | Out-File $LogFile -Append
Register-ScheduledTask -Action $action -Trigger $triggers -TaskName $taskname -Description $taskdescription
"=====Done=====" | Out-File $LogFile -Append

}

Catch

{

# The error message to the log

"Error: $PSItem" | Out-File $LogFile -Append

}
