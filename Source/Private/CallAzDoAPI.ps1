function CallAzDoAPI {
   [CmdletBinding()]
    param(
       [Parameter(ValueFromPipeline = $true)]
      #  [Object]$profile,
       [string]$profilename,
       [string]$area,
       [string]$resource,
       [string]$id,
       [ValidateSet('Get', 'Post', 'Patch', 'Delete', 'Options', 'Put', 'Default', 'Head', 'Merge', 'Trace')]
       [string]$method,
       [Parameter(ValueFromPipeline = $true)]
       [object]$body,
       [string]$Url,
       [string]$ContentType,
       [string]$subdomain,
       [string]$projectname,
       [string]$version,
       [string]$pat

    )
    process {
        
       # If the caller did not provide a Url build it.

       if (-not $Url) {
          $buildUriParams = @{ } + $PSBoundParameters;
          $extra = 'method', 'body','ContentType','config','profile','pat'
          foreach ($x in $extra) { $buildUriParams.Remove($x) | Out-Null }
          $Url = CreateAzdoAPIURL @buildUriParams
       }

       $profile = Get-AzdoAPIToolsProfile -profilename $profilename
       $pat = $profile.pat

       if ($body) {
          Write-Verbose "Body $body"
       }

       $params = $PSBoundParameters
       $params.Add('Uri', $Url)

       $params.Add('TimeoutSec', 30)


       $security = Create-BasicAuthParam -Name 'ServiceAccount' -PAT $pat
       $params.Add('Headers', @{Authorization = "$security" })

       $extra = 'profile', 'profilename', 'Area', 'Id', 'Url', 'Resource','config','profile','subdomain','projectname','version','pat'
       foreach ($e in $extra) { $params.Remove($e) | Out-Null }

       try {
          $resp = Invoke-RestMethod @params

          if ($resp) {
             Write-Verbose "return type: $($resp.gettype())"
             Write-Verbose $resp
          }

          return $resp
       }
       catch {
            Write-Error "$_"

          throw
       }
    }
 }