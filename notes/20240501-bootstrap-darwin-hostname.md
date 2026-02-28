# Bootstrap darwin hostname

```bash
sudo scutil --set HostName lorien
sudo scutil --set LocalHostName lorien
sudo scutil --set ComputerName lorien
dscacheutil -flushcache
```

