

Add-Type -AssemblyName System.Windows.Forms

$FormObject = [System.Windows.Forms.Form]
$LabelObject = [System.Windows.Forms.Label]
$ButtonObject = [System.Windows.Forms.Button]


#This is to create the Window#
$HelloWorldForm = New-Object $FormObject
$HelloWorldForm.ClientSize = '500,300'
$HelloWorldForm.Text = 'Hello World - Testing'
$HelloWorldForm.BackColor = "#121212"

###Colors###
#White = #ffffff#
#Dark Mode = #121212#

#Help Desk (Title)#
$LabelTitle = New-Object $LabelObject
$LabelTitle.text = 'Help Desk (Toolset)'
$LabelTitle.AutoSize = $True
$LabelTitle.Font = 'Verdana,24,Style=Bold'
$LabelTitle.ForeColor = "#ffffff"
$LabelTitle.Location = New-Object System.Drawing.Point(120,0)

#Say Hello! (Button)#
$ButtonHello = New-Object $ButtonObject
$ButtonHello.Text ='Say Hello!'
$ButtonHello.AutoSize = $True
$ButtonHello.Font = 'Verdana,14'
$ButtonHello.ForeColor = "#ffffff"
$ButtonHello.Location = New-Object System.Drawing.Point(150,150)

#This adds the material#
$HelloWorldForm.Controls.AddRange(@($LabelTitle,$ButtonHello))

#Logic Section/Functions#

Function SayHello{
    if($LabelTitle.Text -eq ''){
    $LabelTitle.Text = "Hello World!"
    }else{
        $LabelTitle.Text = ''
    }
}

#Add the functions to the form#
$ButtonHello.Add_Click({SayHello})

#Displays the Form#
$HelloWorldForm.ShowDialog()

#Cleans Up the Form#
$HelloWorldForm.Dispose()



