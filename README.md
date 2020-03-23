# vault-replace

A CLI utility that can be used to fetch secrets and replace their values in files. 

Currently written and built to support IAM authentication in AWS. 

To see usage, call the script with the '-h' or '--help' flag. 


## Usage

````
echo "usage: ./vault-replace [-authmethod method] [-host vaulthost] [-role vaultrole] [-path secretpath] | [-h]"
````