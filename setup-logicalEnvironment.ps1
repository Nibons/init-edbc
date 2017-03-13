[cmdletbinding()]
Param(
    [string]$logicalEnvironment = 'perf'
)
import-module e:\scripts\get-servers.psm1
$header = @"
version: "3"
networks:
    vSwitch_External:
        external: true
services:
"@
$containerTemplate = @"

    rules{COUNTER}:
        image: chfs/init-edbc:latest
        networks:
         - vSwitch_External
        environment:
         - DNSHost={HOSTNAME}
         - HostIP='{IPAddress}'
         - FriendlyName='{FRIENDLYNAME}'
"@

$counter = 0
[string]$containerSet = get-servers -LogicalEnvironment $logicalEnvironment | Where-Object function -eq rules | foreach-object {
    $counter ++
    $currentTemplate = $containerTemplate.Replace("{COUNTER}",$counter)
        $currentTemplate = $currentTemplate.Replace("{HOSTNAME}",$_.DNSHost)
        $currentTemplate = $currentTemplate.Replace("{IPAddress}",$_.IP)
        $currentTemplate = $currentTemplate.replace('{LOGICALENVIRONMENT}',$logicalEnvironment)
    $currentTemplate.Replace('{FRIENDLYNAME}', $_.Friendlyname)
}

@"
$header
$containerSet
"@ | out-file -FilePath "$psscriptroot\docker-compose.yml" -Encoding unicode -Force
# SIG # Begin signature block
# MIIL7gYJKoZIhvcNAQcCoIIL3zCCC9sCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU5cjO09gQgJANDmQM8dsg4VoU
# X56gggkgMIID7jCCAtagAwIBAgIQeAt1QHFYYqJI3fLokHGDtzANBgkqhkiG9w0B
# AQUFADB/MRMwEQYKCZImiZPyLGQBGRYDZ292MRIwEAYKCZImiZPyLGQBGRYCa3kx
# EjAQBgoJkiaJk/IsZAEZFgJkczEUMBIGCgmSJomT8ixkARkWBGNoZnMxKjAoBgNV
# BAMTIUNIRlMgUm9vdCBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0xMzAzMTQy
# MjMwMThaFw0yMzAzMTQyMjQwMTdaMH8xEzARBgoJkiaJk/IsZAEZFgNnb3YxEjAQ
# BgoJkiaJk/IsZAEZFgJreTESMBAGCgmSJomT8ixkARkWAmRzMRQwEgYKCZImiZPy
# LGQBGRYEY2hmczEqMCgGA1UEAxMhQ0hGUyBSb290IENlcnRpZmljYXRpb24gQXV0
# aG9yaXR5MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnwA7cIp2hDZu
# SuLOOLpUINzJObsc1Oedzi9wODd+FhazYZYNiHQOYy5JjIcpSytq0Q6x2ETwx7/M
# weSy+jlskgr2mj/T1+2cM6yX1U7KWxNxgvuCYETkiDqhUf6CLJ5zLXDR6S4QqTEC
# DAdcTqXdabSl3AhvnU/OoJds9IIoqZM/qk9/IjwASV4DI9gVnqLfsEvh/uRSNyGf
# e6PyQyql8FsQnXn0lQmjCQbIDy+TjakhAOgPIW3lgVPuX9jSU6yJ1NpJlSOPtlBm
# quyB02XtcvIj44wvHnmQoY5U9muPA0jhpUAUaB2D8z2E2FIZD+r9r77EN6t8k9F8
# 7XAFOYEQ+wIDAQABo2YwZDATBgkrBgEEAYI3FAIEBh4EAEMAQTALBgNVHQ8EBAMC
# AUYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUN8+r8Ldz0AHG42KyrJDC5a/5
# v80wEAYJKwYBBAGCNxUBBAMCAQAwDQYJKoZIhvcNAQEFBQADggEBAJft0r+DnPd/
# upP15ZCQX5FVBM7Z6wbHVCR0vn4I04cyh2OnB3+Gn+6rlTlkcITg77ar3dqN5F9/
# 7kP/SKhrvF0S+LxTRRkdlZMZpkaEUvuEUmgd2ExGNp+uYHVUzq/3YaGkfR4hfMjA
# KnsD/kdFjDewpMY9anIGxRRsrX2ldN8dlGMGmMp9LfJrwiu1HXoeBFNAH4JXQ8j2
# reJOd+Qbw43/Rhb65gFPE/IncVaTFaZbUp+wYWiRDnbBBK2Wwg5EBbO7w2bHUqvF
# JN6JBAIX8cHZF4ct4kuJAdDeyY8aEZbw5QgKm6R08xUbjnbUFNg0ORToNypIa1LY
# ZJ9OtF9LKKwwggUqMIIEEqADAgECAhMUAAAEwTRlAqF6MVNQAAAAAATBMA0GCSqG
# SIb3DQEBBQUAMH8xEzARBgoJkiaJk/IsZAEZFgNnb3YxEjAQBgoJkiaJk/IsZAEZ
# FgJreTESMBAGCgmSJomT8ixkARkWAmRzMRQwEgYKCZImiZPyLGQBGRYEY2hmczEq
# MCgGA1UEAxMhQ0hGUyBSb290IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTE2
# MDkyMzEyMjgxM1oXDTIxMDkyMzEyMzgxM1owfzELMAkGA1UEBhMCVVMxETAPBgNV
# BAgTCEtlbnR1Y2t5MRIwEAYDVQQHEwlGcmFua2ZvcnQxITAfBgNVBAoTGENvbW1v
# bndlYWx0aCBvZiBLZW50dWNreTEMMAoGA1UECxMDQ09UMRgwFgYDVQQDDA9IQkVf
# Q29kZVNpZ25pbmcwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQClUFOw
# f6JMvq4ixqFZofmmEAIPH3/R9/lgEPp4WcClr9AT2Rn5QoNRdi4lzppm4Lmufhwq
# HFK90Slac95tNrm1vTRuouMwOjdLHkEdk50YeyFYDXpDa3TEPwAQgshx06P50N6m
# x/VGGnYQu9aqQ9H9s0C6U31Pl5QwiD1EJY07FE4xOvTmFTFFfDjc60lg3OUMzSmr
# VCO1Hj6pc6Y0JFfTj1EOVPdEAzOEm6bd2rMRE3kA8c8+q3vmGKPcyz7926WK/ZlH
# Fhdzp/RysaADAbM8T/xJK/KwtgAYGlpVrIM3my8855N8nrtquVsD0MA/utpTcc66
# /1yz9MXZ8H9Q+menAgMBAAGjggGdMIIBmTAOBgNVHQ8BAf8EBAMCBaAwEwYDVR0l
# BAwwCgYIKwYBBQUHAwMwGwYJKwYBBAGCNxUKBA4wDDAKBggrBgEFBQcDAzAdBgNV
# HQ4EFgQURBU1sO+8ybqxEG1fNJD3x4zDHZgwHwYDVR0jBBgwFoAUN8+r8Ldz0AHG
# 42KyrJDC5a/5v80wbAYDVR0fBGUwYzBhoF+gXYZbaHR0cDovL0hGU0ZMMTIxLTAz
# NzEyLmNoZnMuZHMua3kuZ292L0NlcnRFbnJvbGwvQ0hGUyUyMFJvb3QlMjBDZXJ0
# aWZpY2F0aW9uJTIwQXV0aG9yaXR5LmNybDCBmAYIKwYBBQUHAQEEgYswgYgwgYUG
# CCsGAQUFBzAChnlmaWxlOi8vSEZTRkwxMjEtMDM3MTIuY2hmcy5kcy5reS5nb3Yv
# Q2VydEVucm9sbC9IRlNGTDEyMS0wMzcxMi5jaGZzLmRzLmt5Lmdvdl9DSEZTJTIw
# Um9vdCUyMENlcnRpZmljYXRpb24lMjBBdXRob3JpdHkuY3J0MAwGA1UdEwEB/wQC
# MAAwDQYJKoZIhvcNAQEFBQADggEBAEUpyP2VMrmjgCfoLffR4tXq2DXLnOMpOWp7
# O+5zNyrwPEwCGGE890Qzwz4sPpJqgRzdzb5n/UxpEw5DeUM1Flxq5ungD94BvBoU
# 21o/FACyeTCd69K1pq+KoWmHcIufEisRUmdNPHpeqEk+XZYOrXHuVe/HLbIXq3li
# uF5QdYQz9dTc09Wvo9xSBkxKBmT2ClpaeKgN3U2Mxuxcft7oPaHHdoEcFGrdWoOw
# 75YaBifFjQi18zpxBpd+SZgkx1txtI5SvHTHhw9s6YkCqwhjcSvdxYCQa2jPXGyI
# Wdu0dnV3Vb1q2G/0nLisjHXU3H822bXzWHXWkDe/Fo9JdGsXBSMxggI4MIICNAIB
# ATCBljB/MRMwEQYKCZImiZPyLGQBGRYDZ292MRIwEAYKCZImiZPyLGQBGRYCa3kx
# EjAQBgoJkiaJk/IsZAEZFgJkczEUMBIGCgmSJomT8ixkARkWBGNoZnMxKjAoBgNV
# BAMTIUNIRlMgUm9vdCBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eQITFAAABME0ZQKh
# ejFTUAAAAAAEwTAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKA
# ADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYK
# KwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUSfNQFsVcgaFGYZ5j6HNNnst6G+Iw
# DQYJKoZIhvcNAQEBBQAEggEAZnuAJdpjl1MlCwPtB0sVGHY3dfdLg871WRXBITOR
# ybXa7RQhE/n0tFp0rbyuOnpMx4WTg3fFObVCGUqf6j7zcB3yuCz7Pi/f/su0200Q
# +KJq7GClrP9K9Q0nMg4ZfmlhpG5PLwWM5idiYD4AOmIFCewcae7kPXcwridJ9Ipv
# NN+3e3uTD2zEY7303joPHwOqN654O6PJGOz7QAiq5PK+/7dEwqqICwPo9V09rZsS
# f2rdxULb7YOs9x4CMi9AqT5ouCgQrfWweNRVG0LGuo6krzjKZIXC8WLoyEgQi7Ep
# s/QTSNwPu43wK/lqR/BdW52S1VRGJTp+Av1qdvNW7S3VdA==
# SIG # End signature block
