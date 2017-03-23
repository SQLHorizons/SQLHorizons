$source = "Source Directory (drive:\path or \\server\share\path)."
$destination = "Destination Dir  (drive:\path or \\server\share\path)."

$process = "$env:windir\SysWOW64\Robocopy.exe"

$Arguments = @(
    "$source $destination /E /ZB /DCOPY:T /COPYALL /R:1 /W:1 /V /TEE /LOG:Robocopy.log"
)

Start-Process $process -ArgumentList $Arguments -Wait
