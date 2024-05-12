## GPG backup

Backup keys to keepass:

```bash
gpg --output public.pgp --armor --export <email>
gpg --output backupkeys.pgp --armor --export-secret-keys --export-options export-backup <email>

keepassxc-cli attachment-import -f <kdbx> Services/gpg public.pgp public.pgp
keepassxc-cli attachment-import -f <kdbx> Services/gpg backupkeys.pgp backupkeys.pgp
```

