# Author: Li Leo Wang
# Date:   2019-08-31
# Description:
#   - Find files that are created today in a given folder
# Notes:
#   - (none)
#
#
# Change history:
# 	- Refer to GitHub comments related to each source file.
#

cls

$folder="C:\temp"

$r = Get-Childitem $folder * -Recurse | 
     Where-Object {$_.CreationTime -gt (Get-Date).Date }

Write-Host ("Total count: ", $r.Count)

Write-Host ("name ==> size (bytes) ==> folder")

$size = 0
foreach ($f in $r)
{
    Write-Host ($f.Name, ' ==> ', $f.Length, ' ==> ', $f.DirectoryName)
    $size += $f.Length
}

Write-Host ('Total size: ', $size, ' bytes = ', [math]::Round($size/1mb, 1), ' MB')
