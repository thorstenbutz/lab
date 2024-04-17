<#
Exported GPO: IT Lab Policy
GpoId           : b0c3ef2e-cef6-44a8-bab2-b54c39154b0d
Id              : 0f527411-9687-4ba7-994b-0b131b27ca3e
#>

Expand-Archive -Path '.\gpo.zip' -DestinationPath 'gpo' ## Creates new folder "gpo"
New-GPO -Name 'IT Lab Policy'
Import-GPO -Path C:\gpo\ -TargetName 'IT Lab Policy' -BackupGpoName 'IT Lab Policy'
Get-GPO -Name 'IT Lab Policy' | New-GPLink -Target 'OU=it,DC=contoso,DC=com'