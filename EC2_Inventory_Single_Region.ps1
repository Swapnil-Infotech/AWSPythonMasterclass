# Ensure AWS Tools for PowerShell are installed:
# Install-Module -Name AWSPowerShell -Scope CurrentUser
#Check which account is configured for CLI
#aws sts get-caller-identity
#The most direct way to retrieve the current region name
#aws configure get region

param(
    [string]$Region = "ap-south-1"   # Default region, override when running
)

# Set the AWS region
Set-DefaultAWSRegion -Region $Region

# Get all EC2 instances in the region
$instances = Get-EC2Instance

$inventory = foreach ($reservation in $instances) {
    foreach ($instance in $reservation.Instances) {
        [PSCustomObject]@{
            InstanceId   = $instance.InstanceId
            InstanceType = $instance.InstanceType
            State        = $instance.State.Name
            PrivateIP    = $instance.PrivateIpAddress
            PublicIP     = $instance.PublicIpAddress
            LaunchTime   = $instance.LaunchTime
            SecurityGroupsID = $instance.SecurityGroups.GroupID
            SecurityGroupsName = $instance.SecurityGroups.GroupName
            Tags         = ($instance.Tags | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "; "
        }
    }
}

# Output inventory to console
$inventory | Format-Table -AutoSize

# Optionally export to CSV
$csvPath = ".\EC2_Inventory_$Region.csv"
$inventory | Export-Csv -Path $csvPath -NoTypeInformation
$fullPath = (Resolve-Path $csvPath).Path
Write-Host "EC2 inventory exported to $fullPath"
