#general attributes
default['dmon_agent']['group'] = 'dmon'
default['dmon_agent']['user'] = 'dmon'

default['dmon_agent']['home_dir'] = '/home/dmon'
default['dmon_agent']['git_url'] = 'https://github.com/igabriel85/IeAT-DICE-Repository/releases/download/v0.0.4-dmon-agent/dmon-agent.tar.gz'

#attributes for service configuration
default['dmon_agent']['logstash']['ip'] = '10.211.55.100'
default['dmon_agent']['logstash']['udp_port'] = '25680'
default['dmon_agent']['logstash']['l_port'] = '5000'
default['dmon_agent']['logstash']['lsf_crt'] = '-----BEGIN CERTIFICATE-----
MIIDhjCCAm6gAwIBAgIJAKicaGNTYXsAMA0GCSqGSIb3DQEBCwUAMFExCzAJBgNV
BAYTAlRHMQ0wCwYDVQQIEwRUb2dvMQ0wCwYDVQQHEwRMb21lMRgwFgYDVQQKEw9Q
cml2YXRlIGNvbXBhbnkxCjAIBgNVBAMUASowHhcNMTYwODAxMDk1NzM5WhcNMTYw
ODMxMDk1NzM5WjBRMQswCQYDVQQGEwJURzENMAsGA1UECBMEVG9nbzENMAsGA1UE
BxMETG9tZTEYMBYGA1UEChMPUHJpdmF0ZSBjb21wYW55MQowCAYDVQQDFAEqMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsnzyQaK4IazEU7UoGxyEzNPE
KIE9B148LjTb+kzuu/APeFiiuChyLGtccgN0FJDgaoSixIWt+WrpPiB5DCx9R1Jb
uMbKciBYD9VzqIlyBYDDzUk9xG2wFXfLyL3PqSKbFlkd7zvczHhtKbsnY+ekwRR9
d8Y/DuXBXX8mpyxe0fxSUhhuqy90Q/MIVkYAflFv4ID+AZlJnP9zxhqQfZCCtGXp
LFTep5idsVSb2CiDwTSyDuQo/KfJPsM1OG4HJapnkdJCndOrmOJBkvh4d42hcEAc
SIC9JCoMHXxrYtxGKGWxiv9tEOqO4z39/5z6phhiTIoJXcrpzlgpYQNnXoF3lQID
AQABo2EwXzAdBgNVHQ4EFgQUxyuszgHjcffQR7tRz+E59MsDzVkwHwYDVR0jBBgw
FoAUxyuszgHjcffQR7tRz+E59MsDzVkwDAYDVR0TBAUwAwEB/zAPBgNVHREECDAG
hwQK0zdkMA0GCSqGSIb3DQEBCwUAA4IBAQBPKttx0a9mqe7k1HsnGBhnA8aonNWk
/c+invD7F3BzOAHdr02FvEZrVjUphlLYneAfWULS/M956EJlyjtXZnLWBPA1urLL
o0mUAebxf7wrL/RRJY5sJBUoCILFCF5Vjs+mX23TNdeyhJHVGkVkFMZoV0Elrfwd
EjPcNj79LD74+HeHsEoYABfdv81N11Xul1/ekhL+DPYGIDKAQBNbnx92gHlHabFh
swpxjILowZpnMlEtcedGZVwEdORaCQF2eM2EkOQwWxrDq52yvxWv3cWw8BRsRGv4
agke5I6jQYK7ssCZ9JhR5ina/xzZwdQnyR+Pq9cqHaGU5ZpA7Y91nGiO
-----END CERTIFICATE-----'

