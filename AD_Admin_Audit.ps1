# Check if specific user has admin rights
# Usage: .\Check-UserAdminRights.ps1 -Username "john.doe"

#Requires -Modules ActiveDirectory

param(
    [Parameter(Mandatory=$false)]
    [string]$Username
)

# If no username provided, prompt
if (-not $Username) {
    $Username = Read-Host "Enter username to check"
}

Write-Host ""
Write-Host "Checking admin rights for: $Username" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

try {
    # Get user object
    $User = Get-ADUser -Identity $Username -Properties MemberOf, AdminCount, DisplayName, EmailAddress, Enabled, LastLogonDate, whenCreated
    
    Write-Host "User Information:" -ForegroundColor Yellow
    Write-Host "  Username: $($User.SamAccountName)"
    Write-Host "  Display Name: $($User.DisplayName)"
    Write-Host "  Email: $($User.EmailAddress)"
    Write-Host "  Enabled: $($User.Enabled)"
    Write-Host "  Created: $($User.whenCreated)"
    Write-Host "  Last Logon: $($User.LastLogonDate)"
    Write-Host "  AdminCount: $($User.AdminCount)"
    Write-Host ""
    
    # Check if user is in admin groups
    $AdminGroups = @(
        "Domain Admins",
        "Enterprise Admins",
        "Schema Admins",
        "Administrators",
        "Account Operators",
        "Backup Operators",
        "Server Operators",
        "Print Operators",
        "Group Policy Creator Owners",
        "DnsAdmins"
    )
    
    $UserAdminGroups = @()
    
    Write-Host "Administrative Group Membership:" -ForegroundColor Yellow
    foreach ($group in $AdminGroups) {
        try {
            $isMember = Get-ADGroupMember -Identity $group -Recursive | Where-Object { $_.SamAccountName -eq $Username }
            if ($isMember) {
                Write-Host "  ✓ $group" -ForegroundColor Green
                $UserAdminGroups += $group
            }
        } catch {
            # Group doesn't exist or no access
        }
    }
    
    if ($UserAdminGroups.Count -eq 0) {
        Write-Host "  No administrative group membership found" -ForegroundColor Gray
    }
    Write-Host ""
    
    # Show all groups
    Write-Host "All Group Memberships:" -ForegroundColor Yellow
    if ($User.MemberOf) {
        foreach ($groupDN in $User.MemberOf) {
            $group = Get-ADGroup -Identity $groupDN
            Write-Host "  - $($group.Name)" -ForegroundColor Cyan
        }
    } else {
        Write-Host "  No group memberships" -ForegroundColor Gray
    }
    Write-Host ""
    
    # Check delegation rights
    Write-Host "Delegation Rights:" -ForegroundColor Yellow
    $DelegationAttr = Get-ADUser -Identity $Username -Properties msDS-AllowedToDelegateTo
    if ($DelegationAttr.'msDS-AllowedToDelegateTo') {
        Write-Host "  ✓ User has delegation rights" -ForegroundColor Green
        foreach ($target in $DelegationAttr.'msDS-AllowedToDelegateTo') {
            Write-Host "    - $target" -ForegroundColor Cyan
        }
    } else {
        Write-Host "  No delegation rights" -ForegroundColor Gray
    }
    Write-Host ""
    
    # Summary
    Write-Host "Summary:" -ForegroundColor Cyan
    if ($UserAdminGroups.Count -gt 0 -or $User.AdminCount -eq 1 -or $DelegationAttr.'msDS-AllowedToDelegateTo') {
        Write-Host "  ⚠ USER HAS ADMINISTRATIVE ACCESS" -ForegroundColor Red -BackgroundColor Yellow
        Write-Host "  Admin Groups: $($UserAdminGroups.Count)"
        Write-Host "  Protected Admin: $(if($User.AdminCount -eq 1){'Yes'}else{'No'})"
        Write-Host "  Has Delegation: $(if($DelegationAttr.'msDS-AllowedToDelegateTo'){'Yes'}else{'No'})"
    } else {
        Write-Host "  ✓ User does not have administrative access" -ForegroundColor Green
    }
    
} catch {
    Write-Host "Error: Could not find user '$Username'" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

Write-Host ""
