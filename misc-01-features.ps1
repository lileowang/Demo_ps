# Author: Li Leo Wang
# Date:   2019-05-11
# Description:
#   - A collection of import script to demo PowerShell features:
#       - Touch like in Linux 
#       - Format PS drive
#       - Compare process
#       - Filter XML
#       - SQL Server
# Notes:
#   - (none)
#

cls

# ---------- Touch like in Linux  ----------

foreach ($f in ls 'd:\temp\source' -Recurse)
{
    $f.CreationTime = Get-Date
    $f.LastWriteTime = Get-Date
    $f.LastAccessTime = Get-Date
    $f
}

# ---------- Format PS drive ----------

Get-PSDrive | ? { $_.Free -gt 0 } |
% { $c = 0; ('---------------') } `
{ $c += $_.Free; ($_.Name + ': free = ' + [math]::Round($_.Free/1gb, 1)) } `
{ Write-Host ('total free = ' + [math]::Round($c/1gb, 1)) -BackgroundColor Magenta }

# ---------- Compare process ----------
# make sure to use () not {} for -ReferenceObject or -DifferenceObject input

$fn = 'd:\temp\proc-01.xml'
Get-Process | select name, cpu, workingset | Export-Clixml $fn
Compare-Object -ReferenceObject (Import-Clixml $fn) -DifferenceObject (Get-Process) -Property name

# ---------- Filter XML ----------

$x = [xml](cat $fn)
$x.Objs.Obj.ms |
? {[math]::Round($_.db.innertext, 1) -gt 10}  |
sort {[math]::Round($_.db.'#text', 1)} -Descending |
select -First 10 |
Format-Table -AutoSize -Property `
    @{n = 'app'; e = {$_.s.innertext}}, `
    @{n = 'cpu'; e = {[math]::Round($_.db.innertext, 1)}}, `
    @{n = 'memory'; e = {[math]::Round($_.i32.'#text'/1mb, 2)}}

# ---------- PSSession into remote computer ----------

$cred = Get-Credential

Enter-PSSession -Credential $cred -ComputerName <computer_name>

whoami

# ---------- SQL Server with module SqlPs ----------

Start-Service -Name 'MSSQL$SqlServer_Name'
Get-Service *sql*
Get-Module -ListAvailable *sql*
Import-Module sqlps -DisableNameChecking
New-PSDrive -Name lwsql -Credential (Get-Credential) -PSProvider SqlServer -Root sqlserver:\sql\localhost\SqlServer_Name
Get-PSDrive *sql*
cd lwsql:\
pwd
Invoke-Sqlcmd -Query 'select @@version'


# ---------- SQL Server wtih module SqlServer ----------

Get-Service *sql*
Start-Service -Name 'MSSQL$SqlServer_Name'

get-Module -ListAvailable *sql*
Import-Module sqlserver

Get-PSDrive

New-PSDrive -Name lwsql -PSProvider SqlServer -Credential (Get-Credential) -Root SQLSERVER:\SQL\localhost\SqlServer_Name

cd sqlserver:\sql\localhost\SqlServer_Name
ls
Invoke-Sqlcmd -Query 'select @@version'
Invoke-Sqlcmd -Query 'select @@servername'
Invoke-Sqlcmd -Query "select serverproperty('servername')"

Invoke-Sqlcmd -Query 'select @@servername, @@version' | fl * -Force
Invoke-Sqlcmd -Query 'select @@servername, @@version' | gm
