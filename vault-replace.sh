#!/bin/bash
# Shell script template for replacing secrets.

usage()
{
    echo "usage: ./vault-replace [-authmethod method] [-host vaulthost] [-role vaultrole] [-path secretpath] | [-h]"
}

# params: a space separated list of files to do replacement
# eg: ./script.sh sample.xml sample2.xml
if [ $# -gt 0 ]; then
else
    echo "Please supply a list of files to secret-replace!"
    exit 1
fi

# args default
authmethod=aws
role=
address=https://
header_value=
secret_path=

while [ "$1" != "" ]; do
    case $1 in
        -authmethod )           shift
                                authmethod=$1
                                ;;
        -host )                 shift
                                address="https://$1"
                                header_value=$1
                                ;;
        -path )                 shift
                                secret_path=$1
                                ;;
        -role )                 shift
                                role=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

# auth with VE via CLI
vault auth -method=$authmethod -address=$address role=$role header_value=$header_value

# read secrets from app path in vault. hold in memory.
vault read -address=$address $secret_path | head -n -1 | tail -n -3 > secrets


declare -A secretmap
while read line; do
    splitline=( $line )
# ${splitline[0]} is key, ${splitline[1]} is value

#    echo "/${splitline[0]}/"
#    echo "${splitline[1]}"

    key="${splitline[0]}"
    value="${splitline[1]}"

    for replacefile in "$@"
    do
        sed -i -e "s/{$key}/$value/g" $replacefile
    done
    
done < secrets


# for each secret
    # search list of files for matching key value enclosed in ${}
    # replace ${} with secret value