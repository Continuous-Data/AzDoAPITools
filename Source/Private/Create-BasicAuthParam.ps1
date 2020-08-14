function Create-BasicAuthParam {
    Param(
      [Parameter(Mandatory=$true)]
      [string]$Name,
      [Parameter(Mandatory=$true)]
      [string]$PAT
  )
  
    $Auth = '{0}:{1}' -f $Name, $PAT
    $Auth = [System.Text.Encoding]::UTF8.GetBytes($Auth)
    $Auth = [System.Convert]::ToBase64String($Auth)
    $Header = "Basic {0}" -f $Auth
    $Header
  }