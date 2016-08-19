[cmdletbinding()]
Param($virtualizationType = 'hyper-v')

    #region verify the prerequisite software

    if(!$(choco --version)){
        (New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1') | out-file $home\installChocolatey.ps1
        powershell.exe -ExecutionPolicy Bypass -file $("$home\installChocolatey.ps1")
    }#verify that Chocolatey is installed

    $packageList = @(
        @{name = 'docker';version='1.12.0'}
        @{name = 'docker-machine';version='0.8.0'}
        @{name = 'boot2docker';version='1.6.2'}
    )
    foreach($package in $packageList){
        write-verbose ("Installing {0}" -f $package.name)
        choco install $package.name --version=$($package.version) -y | out-null
    }
    #endregion



    #region create + configure the VM
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
    #endregion

    #region invoke docker build + compose
    docker build -t nibons/curler:latest .

    #run the service against PROD-edbc
    docker-compose up
    docker-compose down
    #endregion


    #remove the docker-machine
    docker-machine rm --force $dockerMachineName