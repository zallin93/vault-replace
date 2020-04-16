# vault-replace

A CLI utility that can be used to fetch secrets and replace their values in files. 

Currently written and built to support IAM authentication in AWS. 

To see usage, call the script with the '-h' or '--help' flag. 


## Usage

````
echo "usage: ./vault-replace [-authmethod method] [-host vaulthost] [-role vaultrole] [-path secretpath] | [-h]"
````

Format the values you need to replace inside curly braces. The values between curly braces should 
match the keys in Vault. 

### Parameters

-authmethod 
Only value currently supported is _aws_.

-host
Should be the host of the Vault Enterprise server you want to connect to, ie _vault.vaultenterprisesandbox.aws.gartner.com_.

-role
Should be the Vault Role you want to authenticate as. 

-path
Should be the secret path your secrets are found on. If you need to replace from multiple 
secret paths, call vault-replace once for each. 

-h
Usage doc printout.


### Example

Sample file snippet:

````
<variable name="{A_SECRET_KEY}" value="{ANOTHER_SECRET_KEY}" />
````


## Windows Port

Untested, the Windows port uses Powershell to execute the Vault secret fetching 
and secret replacement. 

### Usage

````
.\vault-replace -vaultHost <vault-hostname> -role <aws-role> -path <secret-path> -file <replace-file>
````

Currently only works supplying a single file. 

TODO: Add support for list of files, like bash impl.