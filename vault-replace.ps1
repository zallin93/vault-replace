param(
    $role = $(throw "role is a required parameter!")
    $path = $(throw "path is a required parameter!")
    $host = $(throw "host is a required parameter!")
    $file = $(throw "file is a required parameter!")
    $authmethod = "aws"
)

function usage {
    Write-Host "usage: vault-replace [-authmethod method] [-host vaulthost] [-role vaultrole] [-path secretpath] | [-h]"
}

$address = "https://$($host)"

vault login -method=$authmethod -address=$address role=$role header_value=$host

# read secrets from app path in vault. hold in memory.
# Remove bottom newline
# Remove first 3 lines of the table that displays secrets
# vault read -address=$address $path | head -n -1 | tail -n +4 > secrets
vault read -address=$address $path | Select-Object -skip 1 -last 10000000 | Select-Object -skip 4 | Out-File -FilePath .\secrets

# for each secret, replace the key/value pairs in the file
foreach($line in Get-Content .\secrets) {
    # $line -split '\s+'
    $secretArray = $line.split()
    $key = $secretArray[0]
    $value = $secretArray[1]

    (Get-Content $file).replace("{$($key)}", "$($value)") | Set-Content $file
}

# cleanup by removing temp secrets file
Remove-Item .\secrets
