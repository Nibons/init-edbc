[cmdletbinding()]
Param($virtualizationType = 'hyper-v')

set-location $PSScriptRoot
$dockerMachineName = [guid]::NewGuid() | select-object -ExpandProperty Guid

    switch($virtualizationType){
        'hyper-v' {
            $hyperVSwitchName = Get-VMSwitch -SwitchType External | select-object -ExpandProperty Name
            if(!$hyperVSwitchName){
                $hyperVSwitchName = [guid]::NewGuid() | select-object -ExpandProperty Guid
                $temporySwitch = New-VMSwitch -Name $hyperVSwitchName -SwitchType External
            }
            $string_Virtualization = ("--driver hyperv --hyperv-virtual-switch $hyperVSwitchName")}
        'virtualBox' {$string_Virtualization = ""}
    }
    $command = "docker-machine create $string_Virtualization $dockerMachineName"
    invoke-command -NoNewScope -ScriptBlock $([scriptblock]::Create($command)) | %{write-verbose $_}

    #enable connection in this session
    write-verbose "Connecting to machine"
    docker-machine env $dockerMachineName | Invoke-Expression 
        
    docker build -t nibons/curler:latest .

    #run the service against PROD-edbc
    docker-compose up
    docker-compose down

    #remove the docker-machine
    docker-machine rm --force $dockerMachineName