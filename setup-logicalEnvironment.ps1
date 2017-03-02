[cmdletbinding()]
Param(
    [string]$logicalEnvironment = 'perf'
)
import-module e:\scripts\get-servers.psm1
$header = @"
version: "2"
services:

"@
$containerTemplate = @"
    rules{COUNTER}:
        image: chfs/init-edbc:latest
        environment:
         - DNSHost={HOSTNAME}
        extra_hosts:
         - "{HOSTNAME}:{IPAddress}"

"@

$counter = 0
[string]$containerSet = get-servers -LogicalEnvironment $logicalEnvironment | Where-Object function -eq rules | foreach-object {
    $counter ++
    $containerTemplate.Replace("{COUNTER}",$counter).Replace("{HOSTNAME}",$_.DNSHost).Replace("{IPAddress}",$_.IP)
}

@"
$header
$containerSet
"@ | out-file -FilePath "$psscriptroot\docker-compose.yml" -Encoding utf8 -Force