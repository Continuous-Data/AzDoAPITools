function CreateAzdoAPIURL {
    [CmdletBinding()]
    param(

       [string]$profilename,
       [string]$area,
       [string]$resource,
       [string]$id,
       [string]$subdomain,
       [string]$projectname,
       [string]$version
    )

    process {
        
       $profile = Get-AzdoAPIToolsProfile -profilename $profilename
       $subdomain = $profile.Organization
       #$projectname = $profile.TeamProject
      #  $version = $profile.APIVersion
       
       $sb = New-Object System.Text.StringBuilder
 
       $sb.Append('Https://') | Out-Null
       if($area -eq 'Release'){
          $sb.Append('vsrm.') | Out-Null
       }
       $sb.Append('dev.azure.com') | Out-Null
       $sb.Append("/$subdomain") | Out-Null
       if ($projectname) {
         $sb.Append("/$projectname") | Out-Null
       }
       $sb.Append("/_apis") | Out-Null
 
       if ($area) {
          $sb.Append("/$area") | Out-Null
       }
 
       if ($resource) {
          $sb.Append("/$resource") | Out-Null
       }
 
       if ($id) {
          $sb.Append("/$id") | Out-Null
       }
 
       if ($version) {
          $sb.Append("?api-version=$version") | Out-Null
       }
 
       $url = $sb.ToString()
 
       return $url
    }
 }