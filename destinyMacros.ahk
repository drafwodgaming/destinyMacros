#Include Neutron.ahk
#Persistent
#SingleInstance, Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
CoordMode, Pixel, Screen
SetBatchLines -1

global ultButton, interactButton, jumpButton
global buttons := ["ultButton", "interactButton", "jumpButton"]
global configPath := "Config/config.ini"
global section := "Section"

LoadConfigValues()
neutron := new NeutronWindow()
neutron.Load("Main/main.html")
neutron.Gui("-Resize")
neutron.Show()
return

; =================================================================
FileInstall, Main/main.html, Main/main.html
FileInstall, Main/mainStyles.css, Main/mainStyles.css
; =================================================================

NeutronClose:
GuiClose:
ExitApp

Clicked(neutron, event)
{
    ultButton := neutron.doc.getElementById("ultButton").value
    interactButton := neutron.doc.getElementById("interactButton").value
    jumpButton := neutron.doc.getElementById("jumpButton").value
    SaveConfig()
}

SaveConfig()
{
    for index, button in buttons
        IniWrite, % %button%, %configPath%, %section%, %button%

    MsgBox, Значения переменных сохранены в файле и обновлены.
}
LoadConfigValues()
{
    for index, button in buttons
        IniRead, %button%, %configPath%, %section%, %button%
}

WarlockSkating:
F3::
    SendInput, {3 down}{3 up}
    Sleep, 750
    SendInput, {RButton down}{RButton up}
    Sleep, 50
    SendInput, {%jumpButton% down}
    Sleep, 50
    SendInput, {%ultButton% down}
    Sleep, 50
    SendInput, {%jumpButton% up}
    Sleep, 50
    SendInput, {%ultButton% up}
return

F5::Reload
F6::ExitApp
