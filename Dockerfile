FROM microsoft/powershell:ubuntu14.04

SHELL ["powershell","-noprofile -command"]

ENV DNSHost kyrules.chfsinet.ky.gov

CMD powershell -command  invoke-webrequest -uri "https://$($env:DNSHost)/KY_EDBC_DRIVER_WCFEdbcService/KyHbeEdbcDriverService.svc?wsdl" -UseBasicParsing