#!/bin/bash

# Directory to decrypt
export DIR_DEC=$1
# Directory to save encrypted files
export DIR_ENC=$2
# Recipient name (public key should be available)
export RECIPIENT=$3

echo "Creating folders"
find "$DIR_DEC" -type d | xargs -I % sh -c 'mkdir -p "$(echo "%" | sed "s,"$DIR_DEC",$DIR_ENC,")"'
echo "Encryption"
find "$DIR_DEC" -type f | xargs -I % sh -c 'gpg --batch --yes -r $RECIPIENT --output "$(echo "%" | sed "s,"$DIR_DEC",$DIR_ENC,").gpg" --encrypt "$(echo "%")"'
echo "Check files and folders"
diff <(find $DIR_DEC -printf '%P\n' | sort) <(find $DIR_ENC -printf '%P\n' | sort) | grep '^[<>].gpg'