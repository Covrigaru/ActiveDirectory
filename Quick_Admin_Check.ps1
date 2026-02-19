# Quick Active Directory Admin Check
# Simple script to list all Domain Admins and Enterprise Admins

#Requires -Modules ActiveDirectory

Write-Host "Active Directory Administrators" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Function to get all members recursively
function Get-GroupMembersRecursive {
    param([string]$GroupName)
    
    $members = Get-ADGroupMember -Identity $GroupName -Recursive
    return $members | Where-Object { $_.objectClass -eq 'user' }
}

# Domain Admins
Write-Host "Domain Admins:" -ForegroundColor Yellow
$DomainAdmins = Get-GroupMembersRecursive -GroupName "Domain Admins"
foreach ($user in $DomainAdmins) {
    $userDetails = Get-ADUser -Identity $user.SamAccountName -Properties DisplayName, EmailAddress, Enabled, LastLogonDate
    Write-Host "  - $($userDetails.SamAccountName) ($($userDetails.DisplayName)) - Enabled: $($userDetails.Enabled) - Last Logon: $($userDetails.LastLogonDate)" -ForegroundColor $(if($userDetails.Enabled){"Green"}else{"Red"})
}

Write-Host ""

# Enterprise Admins
Write-Host "Enterprise Admins:" -ForegroundColor Yellow
try {
    $EnterpriseAdmins = Get-GroupMembersRecursive -GroupName "Enterprise Admins"
    foreach ($user in $EnterpriseAdmins) {
        $userDetails = Get-ADUser -Identity $user.SamAccountName -Properties DisplayName, EmailAddress, Enabled, LastLogonDate
        Write-Host "  - $($userDetails.SamAccountName) ($($userDetails.DisplayName)) - Enabled: $($userDetails.Enabled) - Last Logon: $($userDetails.LastLogonDate)" -ForegroundColor $(if($userDetails.Enabled){"Green"}else{"Red"})
    }
} catch {
    Write-Host "  (Not available - single domain forest)" -ForegroundColor Gray
}

Write-Host ""

# Schema Admins
Write-Host "Schema Admins:" -ForegroundColor Yellow
try {
    $SchemaAdmins = Get-GroupMembersRecursive -GroupName "Schema Admins"
    foreach ($user in $SchemaAdmins) {
        $userDetails = Get-ADUser -Identity $user.SamAccountName -Properties DisplayName, EmailAddress, Enabled, LastLogonDate
        Write-Host "  - $($userDetails.SamAccountName) ($($userDetails.DisplayName)) - Enabled: $($userDetails.Enabled) - Last Logon: $($userDetails.LastLogonDate)" -ForegroundColor $(if($userDetails.Enabled){"Green"}else{"Red"})
    }
} catch {
    Write-Host "  (Not available)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Domain Admins: $($DomainAdmins.Count)"
Write-Host "  Enterprise Admins: $($EnterpriseAdmins.Count)"
Write-Host "  Schema Admins: $($SchemaAdmins.Count)"

# Export to CSV
$AllAdmins = @()
foreach ($user in $DomainAdmins) {
    $userDetails = Get-ADUser -Identity $user.SamAccountName -Properties DisplayName, EmailAddress, Enabled, LastLogonDate
    $AllAdmins += [PSCustomObject]@{
        Username = $userDetails.SamAccountName
        DisplayName = $userDetails.DisplayName
        Email = $userDetails.EmailAddress
        Group = "Domain Admins"
        Enabled = $userDetails.Enabled
        LastLogon = $userDetails.LastLogonDate
    }
}

$AllAdmins | Export-Csv -Path "AD_Admins.csv" -NoTypeInformation
Write-Host ""
Write-Host "Exported to: AD_Admins.csv" -ForegroundColor Green
