# Update-GoogleDynamicDns

A Powershell script for dynamically updating Google DNS records

## Usage

```powershell
.\Update-GoogleDynamicDns.ps1 [-Hostname] <String> [-Credential] <PSCredential>
  [[-IPAddress] <IPAddress>] [-Force]
```

## Examples

```powershell
# Get Google Dynamic DNS credentials.
$cred = Get-Credential

# Update example.com with detected public IP address.
.\Update-GoogleDynamicDns.ps1 example.com $cred

# Update example.com with specified IP address.
.\Update-GoogleDynamicDns.ps1 example.com $cred 93.184.216.34

# Force an update for example.com. Don't do this
# unless you're sure the IP address has changed.
.\Update-GoogleDynamicDns.ps1 example.com $cred 93.184.216.34 -Force
```

## FAQ

**Q: What is Google Dynamic DNS?**

A: Google Dynamic DNS is a feature of Google Domains. For more information,
visit [Dynamic DNS][GDDNS] in Google Domains Help.

**Q: How do I set up Google Dynamic DNS?**

A: First, you need a domain name registered through [Google Domains][GDOM].
Next, you need to configure a Dynamic DNS [synthetic record][SYNREC] for your
domain.

**Q: What credentials do I use?**

A: The credentials are unique to each DNS record for which you set up Dynamic
DNS. To find the credentials, follow the steps on [Dynamic DNS][GDDNS] in Google
Domains Help.

**Q: Why do I keep seeing the message "IP address has not changed since last
update."?**

A: The current IP address for the hostname is checked to see if it matches the
one detected or provided. If it matches, then no update is sent to Google. You
can use the `-Force` argument to force an update, but be aware that Google might
block further requests if you send too many unnecessary updates.

**Q: Why am I getting an error?**

A: Please submit a [new issue][NEWISSUE] if the error is not already addressed
in this FAQ.

[GDDNS]: https://support.google.com/domains/answer/6147083?hl=en
[GDOM]: https://domains.google.com/registrar
[SYNREC]: https://support.google.com/domains/answer/6069273?hl=en
[GCIP]: https://domains.google.com/checkip
[NEWISSUE]: issues/new
