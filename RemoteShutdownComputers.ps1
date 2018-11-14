$DateTimeNow = (Get-Date).ToString('HH:mm')

$DateTime9PM = (Get-Date -Hour 21 -Minute 0).ToString('HH:mm')

$LogTime = (Get-Date -format D)
$LogFilePath="\\domain.local\data\its\PowerShell\Workstations Shutdown Logs\"
$LogFileName="Shutdown_Script_$LogTime.csv"



if ($DateTimeNow -lt $DateTime9PM) {

$Computers = Get-ADComputer -SearchBase "OU=Computers,OU=Contoso Computers,DC=contoso,DC=local" -Filter * | ? {$_.distinguishedname -notmatch 'OU=VDI|OU=MIS'}|  Select-Object -ExpandProperty Name

foreach ($Computer in $Computers) {


     if (Test-Connection -ComputerName $Computer -count 1 -quiet){
        $GetWMIObject = Get-WmiObject win32_computersystem -ComputerName $Computer 
        $Username = $GetWMIObject.UserName
        $CompName = $GetWMIObject.Name
       # $GetWMIObject | select Name , Username
       
        echo "$computer - $Username logged in"

        if ($Username -eq $null){
            echo "shutting down before 9PM - $Computer - no one loggedin"

       $win32OS = get-wmiobject win32_operatingsystem -computername $Computer
$win32OS.psbase.Scope.Options.EnablePrivileges = $true
$win32OS.win32shutdown(5)





 $NewLine = -join ("`r`n($computer ON - Shutting Down ")

Add-Content -Value $NewLine -Path "$LogFilePath$LogFileName"



        }
        }
  
  }

  } else {
  

  $Computers = Get-ADComputer -SearchBase "OU=Computers,OU=Contoso Computers,DC=contoso,DC=local" -Filter *  | ? {$_.distinguishedname -notmatch 'OU=VDI|OU=MIS'} | Select-Object -ExpandProperty Name
  $NewLine = -join ("9PM Shutdown List ")
foreach ($Computer in $Computers) {


     if (Test-Connection -ComputerName $Computer -count 1 -quiet){
        $GetWMIObject = Get-WmiObject win32_computersystem -ComputerName $Computer 
        $Username = $GetWMIObject.UserName
        $CompName = $GetWMIObject.Name
        $GetWMIObject | select Name , Username
       

      
$win32OS = get-wmiobject win32_operatingsystem -computername $Computer
$win32OS.psbase.Scope.Options.EnablePrivileges = $true
$win32OS.win32shutdown(5)


     
 $NewLine = -join ("`r`n($computer ON - Shutting Down ")

Add-Content -Value $NewLine -Path "$LogFilePath$LogFileName"



        }
  
  }




  } 
