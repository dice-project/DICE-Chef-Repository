#general attributes
default['dmon_agent']['group'] = 'dmon-agent'
default['dmon_agent']['user'] = 'dmon-agent'

default['dmon_agent']['home_dir'] = '/home/dmon-agent'
default['dmon_agent']['git_url'] = 'https://github.com/igabriel85/IeAT-DICE-Repository/releases/download/v0.0.4-dmon-agent/dmon-agent.tar.gz'

#attributes for service configuration
default['dmon_agent']['logstash']['ip'] = 'ip'
default['dmon_agent']['logstash']['udp_port'] = 'port'
default['dmon_agent']['logstash']['l_port'] = '5000'
default['dmon_agent']['logstash']['lsf_crt'] = '-----BEGIN CERTIFICATE-----
MIIDmDCCAoCgAwIBAgIJANYS2TCPC3ddMA0GCSqGSIb3DQEBCwUAMFExCzAJBgNV
BAYTAlRHMQ0wCwYDVQQIEwRUb2dvMQ0wCwYDVQQHEwRMb21lMRgwFgYDVQQKEw9Q
cml2YXRlIGNvbXBhbnkxCjAIBgNVBAMUASowHhcNMTYwODA5MDgzMTE3WhcNMTYw
OTA4MDgzMTE3WjBRMQswCQYDVQQGEwJURzENMAsGA1UECBMEVG9nbzENMAsGA1UE
BxMETG9tZTEYMBYGA1UEChMPUHJpdmF0ZSBjb21wYW55MQowCAYDVQQDFAEqMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzSr96XF7x8ddnXtrbYZTGF7m
n4xdEIT5MIDEgCYk4SXjAFthARApaL6u8KgrtQwUzKHBixMOybvyPHceg7JqmvJ3
Ws7W99DeJPLxIWz7FaS/OmwPE13E1ptjYU0trrv/o+oJZXTye8h/QC7CenN19vQA
qdb3XAV6iK7ArABRME7UVWXI8jW/KQfi/8Oh4Ma9xK2oit0zftspr6EctDGagX2Y
5oP5STCUAX+7Ai4iruWOzuIZPzq1ZAcPlvLnAmL8sRsyENoIOh9PxdrXkY7YfoZY
TRjQC4EVrzwgNV3HcU9HSndaYX0cBBS6yTyTMfhabAyzwlVbP4mp8fPp5lhTBQID
AQABo3MwcTAdBgNVHQ4EFgQUjn29SNAeE1megMiuCdDY2rm7JcgwHwYDVR0jBBgw
FoAUjn29SNAeE1megMiuCdDY2rm7JcgwDAYDVR0TBAUwAwEB/zAhBgNVHREEGjAY
hwTAqAAzhwTAqAA0hwQK0zdkhwQK0zduMA0GCSqGSIb3DQEBCwUAA4IBAQCINSae
meLmeLxhb6ZvB1ktZn9gjjyzTdQpVq9sgySnTMw3gEzlKszgzUb68m6WqWKwP0Dw
e4Hh3tRVEAfir3oBxP5jGx9An4PyWff+y5J5pE5UBeiF+p6QfHl7n0xUw/eRwgpF
CFpEM5SExugK1MvLyMAk+k2DIY7jmIKR1UHSEMQ+VNaq/HydS3Gs0pso0U8TzlYe
hf5BGvVT8qMQ4Gsin2MBA958uHoY+GYi36NpVBGdxdIYpgzF7gan8MAsEYRXq3bO
PlZZGeVazX6L6GN6raH3UkPRgeu1VlBz3g1+4a3s3P0hsEvXzLiHZSmlMSyJ0NUM
Y888G4j7v7FUQ8kl
-----END CERTIFICATE-----'

