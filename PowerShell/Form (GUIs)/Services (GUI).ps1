Add-Type -AssemblyName System.Windows.Forms

$FormObject = [System.Windows.Forms.Form]
$LabelObject = [System.Windows.Forms.Label]
$ComboBoxObject = [System.Windows.Forms.ComboBox]

$DefaultFont = 'Verdana,12'

#Base Form/Window
$AppForm = New-Object $FormObject
$AppForm.ClientSize = '500,300'
$AppForm.Text = 'Service Inspector'
$AppForm.BackColor = '#ffffff'
$AppForm.Font = $DefaultFont

#Building The Form / GUI
$LabelService = New-Object $LabelObject
$LabelService.Text = 'Services:'
$LabelService.AutoSize = $True
$LabelService.Location = New-Object System.Drawing.Point(20,20)

#Building the ComboBox / DropDown
$ComboService = New-Object $ComboBoxObject
$ComboService.Width = '300'
$ComboService.Location = New-Object System.Drawing.Point(120,20)
$ComboService.Text = 'Pick A Service'

#Grab services for the drop down list
Get-Service | ForEach-Object {$ComboService.Items.Add($_.Name)}

#Label Friendly Name
$LabelFormName = New-Object $LabelObject
$LabelFormName.Text = 'Service Friendly Name:'
$LabelFormName.AutoSize = $True
$LabelFormName.Location = New-Object System.Drawing.Point(20,80)

#Label Name
$LabelName = New-Object $LabelObject
$LabelName.Text = '(Select a Service)'
$LabelName.AutoSize = $True
$LabelName.Location = New-Object System.Drawing.Point(240,80)

#Status Name
$LabelForStatus = New-Object $LabelObject
$LabelForStatus.Text = 'Status:'
$LabelForStatus.AutoSize = $True
$LabelForStatus.Location = New-Object System.Drawing.Point(20,120)

#Status Name
$LabelStatus = New-Object $LabelObject
$LabelStatus.Text = '(Select a Service)'
$LabelStatus.AutoSize = $True
$LabelStatus.Location = New-Object System.Drawing.Point(240,120)

#Add Functions to Form#
function GetServiceDetails{
    $ServiceName = $ComboService.SelectedItem
    $Details = Get-Service -Name $ServiceName | Select-Object *
    $LabelName.Text = $Details.Name
    $LabelStatus.Text = $Details.Status

    If($LabelStatus.Text -eq 'Running'){
        $LabelStatus.ForeColor = 'Green'
    }else{
        $LabelStatus.ForeColor = 'Red'
    }
}

#Add Functions to the Controls#
$ComboService.Add_SelectedIndexChanged({GetServiceDetails})

#Add the Above, to the form
$AppForm.Controls.AddRange(@($LabelService,$ComboService,$LabelFormName,$LabelName,$LabelForStatus,$LabelStatus))

#Displays the Form#
$AppForm.ShowDialog()

#Cleans Up the Form#
$AppForm.Dispose()