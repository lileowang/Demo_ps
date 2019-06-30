# Author: Li Leo Wang
# Date:   2019-05-11
# Description:
#   - Touch in PowerShell
# Notes:
#   - (none)
#

cls

function touch
{
    param
    (
        $create_time,
        $last_write_time,
        $last_access_time
    )

    $create_time
    $last_write_time

    foreach ($file in ls $folder -Recurse)
    {
        $file.CreationTime = $create_time
        $file.LastWriteTime = $last_write_time
        $file.LastAccessTime = $last_access_time
        $file | select name, Directory, CreationTime, LastWriteTime, LastAccessTime 
    }
}

$folder = 'c:\tutorial\test'

$now = Get-Date
Write-Host ('Now: ' + $now) -BackgroundColor Magenta

$create_time = [datetime]::Parse('2002-01-01')
$last_write_time = ([datetime]$now).AddDays(-5)
$last_access_time = Get-Date

touch -create_time $create_time -last_write_time $last_write_time -last_access_time $last_access_time
