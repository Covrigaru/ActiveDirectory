How to Run These Scripts
Prerequisites:

1. Run as Domain Admin or a user with read access to Active Directory
2. The Active Directory PowerShell module must be installed
3. The user must have Network connectivity to the domain controller, permission/firewall/etc.


updated: 1. web_form - An HTML form for a new user registration 
.        2. printer - get a list of all printers
.        3. security_group_list_co - Lists security groups that have Full Control, and all members with email addresses
.        4. AD_User_info - Simple AD Users Export Script
.        5. AD_Admin_Audit.ps1 - Check if a specific user has admin rights
.        6. Complete AD Resources Inventory - Server 2016 - Complete Active Directory Resources Inventory Script.
.        7. Contact - Export ALL AD Contacts with ALL Properties
.        8. Quick_Admin_Check.ps1 - Quick Active Directory Admin Check
.        9. computer - list of all computers
.        10. group_info - Groups with member list
.        11. group_security - Export All AD Groups with Full Control Permissions


Full Audit (Recommended) script:
# Open PowerShell as Administrator
# Navigate to script directory
cd C:\Scripts
# Run full audit
.\AD_Admin_Audit.ps1


Quick Admin Check script:
# Quick list of Domain Admins only
.\Quick_Admin_Check.ps1

https://claude.ai/public/artifacts/3b53fdfd-8d43-42ec-866b-db7e1255e04e

