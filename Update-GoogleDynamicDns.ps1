# Updates Google Dynamic DNS Records.
# 
# Usage: .\Update-GoogleDynamicDns.ps1 [-Hostname] <String> [-Credential] <PSCredential> [[-IPAddress] <IPAddress> ] [-Force]
#
# For more information, see https://support.google.com/domains/answer/6147083

Param
(
    # Hostname to update.
    [Parameter(Mandatory=$true, Position=1)]
    [string] $Hostname,

    # Username and password for the hostname.
    [Parameter(Mandatory=$true, Position=2)]
    [PSCredential] $Credential,

    # Optional IP address to set as DNS record.
    # If not specified, the public IP address will be
    # determined by using Google's Check IP service.
    [Parameter(Position=3)]
    [IPAddress] $IPAddress,

    # Force an update to Google.
    # If the public IP address hasn't changed according
    # to a DNS lookup, an update will not be sent.
    # Recommended value is $false unless you know the IP
    # has changed or the hostname does not resolve properly.
    [switch] $Force
)

if($IPAddress)
{
    # If an IP address was specified, use it.
    $publicIP = $IPAddress
}
else
{
    # Otherwise, get the current public IP address.
    $publicIP = [IPAddress]::Parse((Invoke-WebRequest https://domains.google.com/checkip).Content)
}

if(!$Force)
{
    # Get the current DNS record for the hostname.
    $currentDnsIP = (Resolve-DnsName $Hostname).IPAddress
}

# Only update Google if the IP address has changed, or if forcing a change.
if($Force -or $publicIP -ne $currentDnsIP)
{
    # Tell Google what hostname we're updating.
    $body = @{hostname=$Hostname}

    if($IPAddress)
    {
        # If a public IP address was specified, use it.
        # Otherise, Google will determine the public IP address itself.
        $body.Add("myip", $publicIP)
    }
    
    # Send the update to Google.
    $response = Invoke-WebRequest https://domains.google.com/nic/update -Body $body -Method Post -Credential $Credential

    # Write the response.
    Write-Host $response.Content
}
else
{
    # If the public IP address hasn't changed, we didn't send the update.
    Write-Host "IP address has not changed since last update."
}
