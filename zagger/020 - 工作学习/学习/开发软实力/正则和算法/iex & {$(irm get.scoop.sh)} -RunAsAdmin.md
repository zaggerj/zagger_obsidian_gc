---
created: 2023-11-06T08:20
updated: 2023-11-06T08:20
---
# iex & {$(irm get.scoop.sh)} -RunAsAdmin

　　iex "& {\$(irm get.scoop.sh)} -RunAsAdmin"

　　iwr -useb get.scoop.sh \| iex

　　\$env:SCOOP='D:\Applications\Scoop'

　　\[Environment\]::SetEnvironmentVariable('SCOOP', \$env:SCOOP, 'User')

　　\$env:SCOOP_GLOBAL='D:\GlobalScoopApps'

　　\[Environment\]::SetEnvironmentVariable('SCOOP_GLOBAL', \$env:SCOOP_GLOBAL, 'Machine')
