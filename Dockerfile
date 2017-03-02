FROM microsoft/nanoserver
SHELL ["powershell","-noprofile -command"]
ENV DNSHost kyrules.chfsinet.ky.gov

CMD invoke-webrequest -uri "https://$($env:DNSHost)/KY_EDBC_DRIVER_WCFEdbcService/KyHbeEdbcDriverService.svc?wsdl"