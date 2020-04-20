param(
    $role = $(throw "role is a required parameter!"),
    $path = $(throw "path is a required parameter!"),
    $vaultHost = $(throw "vaultHost is a required parameter!"),
    $file = $(throw "file is a required parameter!"),
    $authmethod = "aws"
)

$address = "https://$($vaultHost)"

vault login -method="$($authmethod)" -address="$($address)" role="$($role)" header_value="$($vaultHost)" > $null

# read secrets from app path in vault. hold in memory.
# Remove first 3 lines of the table that displays secrets
$vaultResponse = $( vault read -format=json -address="$($address)" "$($path)" | ConvertFrom-Json )
$data = $vaultResponse.data

# for each secret, replace the key/value pairs in the file
$data.PSObject.Properties | ForEach-Object {
    $key = $_.Name
    $value = $_.Value
    (Get-Content $file).replace( "{$($key)}", "$($value)" ) | Set-Content $file
}
