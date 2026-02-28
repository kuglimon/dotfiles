### Google Drive with Rclone

TLDR:

```toml
# Gdrive config with SA and shared directories visible
[personal-drive-base]
type = drive
scope = drive
shared_with_me = true
service_account_file = /path/to//service_account.json
```

```bash
# mount with writes supported
rclone mount --vfs-cache-mode writes personal-drive-base: ~/drive
```

There's a couple of options for authentication. Using your own Oauth is a lot of
work. You'll have to submit your app to Google for verification or use the
sandbox one and refresh credentials every x days. Not that refreshing
credentials is bad, the bad part is that you don't define the duration. Service
Accounts are better, just create a key and set the validity yourself.

Service Accounts are their own Google Accounts. If you connect to a drive with
it you'll se the SA's drive, which has like 50MB of storage. To use your own
drive share a folder with the SA. You'll need to enable showing shared
directories during mount-time for this to work.
