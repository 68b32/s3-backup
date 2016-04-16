#!/bin/bash
export AWS_SECRET_ACCESS_KEY=''
export AWS_ACCESS_KEY_ID=''
export PASSPHRASE=""
export SIGN_PASSPHRASE=""
export S3_USE_SIGV4="True"

BUCKET="s3://s3.eu-central-1.amazonaws.com/<bucketname>"
GPG_ENCRYPT="<keyid>"
GPG_SIGN="<keyid>"
KEEP_BACKUP_FOR="2M"


GENERAL_OPTIONS="\
	--s3-use-new-style \
	--s3-european-buckets \
	--hidden-encrypt-key ${GPG_ENCRYPT} \
	--sign-key ${GPG_SIGN} \
	"

DESTINATION="${BUCKET}"

# Restore backup
if [ -n "$1" -a -n "$2" -a "$1" == "restore" -a -d "$2" ]; then
	echo "Restore to $2 requested."
	duplicity ${GENERAL_OPTIONS} --progress --numeric-owner restore "$DESTINATION" "$2"
	exit
fi

[ -n "$1" ] && echo "Usage: $0 [restore <path>]" && exit 1


# Delete backup chains older than $KEEP_BACKUP_FOR
duplicity ${GENERAL_OPTIONS} remove-older-than --force "${KEEP_BACKUP_FOR}" "${DESTINATION}"

# Start new backup chain on Monday
OPTION_FULL=""
if [ "`date +%u`" -eq 1 ]; then
	echo "Full backup requested."
	OPTION_FULL="full"
fi

# Create the backup
duplicity ${OPTION_FULL} ${GENERAL_OPTIONS} \
	--include-filelist /etc/backup/filelist.list \
	--exclude '**' \
	-v6 \
	/ "${DESTINATION}"

# List available backup chains
duplicity collection-status ${GENERAL_OPTIONS} "${DESTINATION}"

# Unset sensitive data
for k in AWS_SECRET_ACCESS_KEY AWS_ACCESS_KEY PASSPHRASE SIGN_PASSPHRASE; do
	unset $k
done
