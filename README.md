How to Run These Scripts
Prerequisites:

1. Run as Domain Admin or a user with read access to Active Directory
2. The Active Directory PowerShell module must be installed
3. The user must have Network connectivity to the domain controller, permission/firewall/etc.


Full Audit (Recommended) script:
# Open PowerShell as Administrator
# Navigate to script directory
cd C:\Scripts
# Run full audit
.\AD_Admin_Audit.ps1


Quick Admin Check script:
# Quick list of Domain Admins only
.\Quick_Admin_Check.ps1
