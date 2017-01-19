[cmdletbinding()]
Param(
    [string]$logicalEnvironment
)
#region setup docker-compose.yml
$header = @"
version: "2"
services:

"@
$containerTemplate = @"
    rules{COUNTER}:
        image: chfs/init-edbc
        extra_hosts:
         - "{HOSTNAME}:{IPAddress}"
"@

$counter = 0
[string]$containerSet = get-servers -LogicalEnvironment Conv | Where-Object function -eq rules | foreach-object {
    $counter ++
    $containerTemplate.Replace("{COUNTER}",$counter).Replace("{HOSTNAME}",$_.DNSHost).Replace("{IPAddress}",$_.IP)
    $dnsHost = $_.DNSHost
}

@"
$header
$containerSet
"@ | out-file -FilePath "$psscriptroot\docker-compose.yml" -Encoding utf8 -Force
#endregion

#region setup Dockerfile
[string]$Dockerfile_Template = @"
FROM alpine:latest

#RUN apt-get update && apt-get install -y curl
RUN apk add --update curl

CMD curl -k 'https://{DNSHost}/KY_EDBC_DRIVER_WCFEdbcService/KyHbeEdbcDriverService.svc?wsdl'>/dev/null 
"@
$Dockerfile_Template.replace("{DNSHost}",$dnsHost) | out-file -FilePath "$psscriptroot\Dockerfile" -Encoding utf8 -Force