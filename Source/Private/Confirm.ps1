function Confirm ( [string] $message )
{
    do
    { 
        $input = Read-Host -prompt "$message (Y/N)? "
        if ($input -Like 'Y') { return $true }
        elseif ($input -Like 'N') { return $false }
    } while (true);
}