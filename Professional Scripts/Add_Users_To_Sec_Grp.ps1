$Members = "IMPORT A LIST OF USERNAMES OR TYPE OUT SEPERATED BY COMMA"

$Group = "Office 365 M365 License With Intune"


foreach ($User in $Members){

Add-ADGroupMember -Identity $Group -Members $User

}