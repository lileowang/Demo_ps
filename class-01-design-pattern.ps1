# Author: Li Leo Wang
# Date:   2019-05-11
# Description:
#   - Use PowerShell class to demo design patterns like:
#       - Parameter splatting
#       - Polymorphism
#       - Abstract class
#       - Class factory
#       - Singleton
#       - Method chainning
# Notes:
#   - (none)
#

cls

class helper
{
    [hashtable] splatting([string[]]$props)
    {
        $splat = @{}

        foreach ($p in $props)
        {
            if ($this.GetType().GetProperty($p))
            {
                $splat.Add($p, $this.$p)
            }
        }

        return $splat
    }
}

class vehicle : helper
{
    [string]$name
    [string]$manufacturer

    vehicle()
    {
        $this.testAbstract()
    }

    vehicle([string]$name, [string]$manufacturer)
    {
        $this.testAbstract()

        $this.name = $name
        $this.manufacturer = $manufacturer
    }

    [void] testAbstract()
    {
        $type = $this.GetType()

        if ($type -eq [vehicle])
        {
            throw ("cannot instantiate class $type")
        }
    }

    [vehicle] setName([string]$name)
    {
        $this.name = $name
        return $this
    }

    [vehicle] setManufacturer([string]$manufacturer)
    {
        $this.manufacturer = $manufacturer
        return $this
    }

    [void] writeMessage()
    {
        Write-Host ('type = ' + $this.GetType() `
            + ', name = ' + $this.name `
            + ', manufacturer = ' + $this.manufacturer 
        )
    }
}

class sedan : vehicle
{
    sedan()
    {
    }

    sedan([string]$name, [string]$manufacturer) : base($name, $manufacturer)
    {
    }
}

class minivan : vehicle
{
    minivan()
    {
    }

    minivan([string]$name, [string]$manufacturer) : base($name, $manufacturer)
    {
    }
}

class mycar : vehicle
{
    static [mycar]$instance

    hidden mycar()
    {
    }

    hidden mycar([string]$name, [string]$manufacturer) : base($name, $manufacturer)
    {
    }

    static [mycar] getInstance([string]$name, [string]$manufacturer)
    {
        if ([mycar]::instance -eq $null)
        {
            [mycar]::instance = [mycar]::new($name, $manufacturer)
        }

        return [mycar]::instance
    }
}

function write-message($name, $manufacturer)
{
    Write-Host ('n = ' + $name `
        + ', m = ' + $manufacturer
    )
}

class vehicleFactory
{
    static [vehicle[]]$instances

    static [object] getByType([object]$type)
    {
        return [vehicleFactory]::instances.Where({$_ -is $type})
    }

    static [object] getByName([string]$name)
    {
        return [vehicleFactory]::instances.Where({$_.name -eq $name})
    }

    [vehicle] getInstance([string]$type, [string]$name, [string]$manufacturer)
    {
        return (New-Object -TypeName "$type" -ArgumentList $name, $manufacturer)
    }
}

# ========== test ==========
# - Uncomment out test sections to verify the code

# ---------- Test class and abstract class ----------
#[vehicle[]]$cars = @(
#    [vehicle]::new('mazda 3', 'mazda')
#    [vehicle]::new('mazda 5', 'mazda')
#)
#$cars | % { $_.writeMessage() }

# ---------- Test parameter splatting ----------
#[vehicle[]]$cars = @(
#    [vehicle]::new('mazda 3', 'mazda')
#    [vehicle]::new('mazda 5', 'mazda')
#)
#$cars | % { 
#    $splat = $_.splatting(('name', 'manufacturer'))
#    write-message @splat
#}

# ---------- Test polymorphism ----------
#[vehicle[]]$cars = @(
#    [sedan]::new('mazda 3', 'mazda')
#    [minivan]::new('mazda 5', 'mazda')
#)
#$cars | % { $_.writeMessage() }

# ---------- Test class factory (1) ----------
#$vf = [vehicleFactory]::new()
#[vehicle[]]$cars = @(
#    $vf.getInstance('sedan', 'mazda 3', 'mazda')
#    $vf.getInstance('minivan', 'mazda 5', 'mazda')
#)
#$cars | % { $_.writeMessage() }

# ---------- Test class factory (2) ----------
#[vehicleFactory]::instances = @(
#    [sedan]::new('mazda 3', 'mazda')
#    [minivan]::new('mazda 5', 'mazda')
#)
#[vehicleFactory]::getByType([sedan]).writeMessage()
#[vehicleFactory]::getByName('mazda 5').writeMessage()

# ---------- Test singleton ----------
#[vehicle[]]$cars = @(
#    [mycar]::getInstance('mazda 3', 'mazda')
#    [mycar]::getInstance('mazda 5', 'mazda')
#)
#$cars | % { $_.writeMessage() }

# ---------- Test method chaining ----------
#[vehicle[]]$cars = @(
#    [sedan]::new()
#    [minivan]::new()
#)
#$cars[0].setName('mazda 3').setManufacturer('mazda').writeMessage()
#$cars[1].setName('mazda 5').setManufacturer('mazda').writeMessage()
