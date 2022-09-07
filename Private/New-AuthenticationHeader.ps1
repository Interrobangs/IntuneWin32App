function New-AuthenticationHeader {
    <#
    .SYNOPSIS
        Construct a required header hash-table based on the access token from Get-AccessToken function.

    .DESCRIPTION
        Construct a required header hash-table based on the access token from Get-AccessToken function.

    .PARAMETER AccessToken
        Pass the AuthenticationResult object returned from Get-AccessToken cmdlet.

    .NOTES
        Author:      Nickolaj Andersen
        Contact:     @NickolajA
        Created:     2021-04-08
        Updated:     2021-09-08

        Version history:
        1.0.0 - (2021-04-08) Script created
        1.0.1 - (2021-09-08) Fixed issue reported by Paul DeArment Jr where the local date time set for ExpiresOn should be UTC to not cause any time related issues
    #>
    param(
        [parameter(Mandatory = $true, HelpMessage = "Pass the AuthenticationResult object returned from Get-AccessToken cmdlet.")]
        [ValidateNotNullOrEmpty()]
        $AccessToken,
        [parameter(Mandatory = $false, HelpMessage = "Specify to not load and use PS.MSAL")]
        [switch]$SkipMSAL
    )
    Process {
        if($SkipMSAL){
            # Construct default header parameters
            $AuthenticationHeader = @{
                "Content-Type" = "application/json"
                "Authorization" = "Bearer $($accessToken.access_token)"
                ExpiresOn = [System.DateTimeOffset][datetime]::UtcNow.AddSeconds($AccessToken.expires_in)
                
               
            }
        }else{
            # Construct default header parameters
                $AuthenticationHeader = @{
                    "Content-Type" = "application/json"
                    "Authorization" = [Microsoft.Identity.Client.AuthenticationResult]$AccessToken.CreateAuthorizationHeader()
                    "ExpiresOn" = [Microsoft.Identity.Client.AuthenticationResult]$AccessToken.ExpiresOn.UTCDateTime
                }
            }
        # Handle return value
        return $AuthenticationHeader
    }
}


