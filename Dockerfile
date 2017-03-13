FROM microsoft/nanoserver

SHELL ["powershell","-noprofile -command"]

ENV endpoint='KY_EDBC_DRIVER_WCFEdbcService/KyHbeEdbcDriverService.svc?wsdl' \
    DNSHost='kyrules.chfsinet.ky.gov' \
    HostIP='' \
    FriendlyName=''

ADD CHFS_ROOT_Authority.cer .
RUN Import-Certificate -FilePath .\CHFS_Root_Authority.cer -CertStoreLocation Cert:\LocalMachine\root -Verbose

CMD $entry_HOSTSFile = $env:HostIP = ' ' + $env:DNSHost ;\
    $entry_HOSTSFile | out-file -filepath C:\Windows\System32\Drivers\etc\hosts -encoding utf8 ;\
    invoke-webrequest -uri "https://$($env:DNSHost)/$($env:endpoint)" | \
    Select-object @{n='Friendlyname';e={$env:FriendlyName}}, StatusCode