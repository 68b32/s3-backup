# s3-backup.sh #

This is a small script to call duplicity on a daily base for incremental daily file system backup to Amazon S3.

For setup configure the parameter at the first lines of the script.

	export AWS_SECRET_ACCESS_KEY='' # IAM user's access secret key
	export AWS_ACCESS_KEY_ID=''     # IAM user's access key
	export PASSPHRASE=""            # Passphrase for GPG encryption key
	export SIGN_PASSPHRASE=""       # Passphrase for GPG signing key
	export S3_USE_SIGV4="True"      # Needed when using eu-central AWS region

	BUCKET="s3://s3.eu-central-1.amazonaws.com/<bucketname>" # S3 destination URL
	FILE_LIST="/etc/backup/file.list"                        # List of backup sources
	GPG_ENCRYPT="<keyid>"                                    # GPG keyid for data encryption
	GPG_SIGN="<keyid>"                                       # GPG keyid for data signature
	KEEP_BACKUP_FOR="2M"                                     # Backup chains older than that will be deleted

Line #38 causes a full backup on every Monday.