﻿#Include Libraries\Neutron.ahk
#Include Libraries\JSON.ahk
#Persistent
#SingleInstance, Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
CoordMode, Pixel, Screen
SetBatchLines -1
CheckGitHubUpdates()

appdata = %A_AppData%

global ultButton, interactButton, jumpButton, neutron, folderPath, configPath, section, buttons
folderPath := appdata . "\DestinyMacros"
configPath := folderPath . "\config.ini"
section := "Section"
buttons := ["ultButton", "interactButton", "jumpButton"]

TrayMenu()
neutron := new NeutronWindow()
neutron.Load("Main/main.html")
neutron.Gui("-Resize +LastFound")
neutron.Show()
LoadConfigValues()
return

; =================================================================
FileInstall, Main/main.html, main.html
FileInstall, Main/mainStyles.css, mainStyles.css
FileInstall, Main/Assets/icon.png, icon.png
FileInstall, Main/mainScripts.js, mainScripts.js
; =================================================================

GuiClose:
CloseApp:
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
    if (!FileExist(folderPath))
        FileCreateDir, % folderPath
    for index, button in buttons
        IniWrite, % %button%, %configPath%, %section%, %button%

    MsgBox, Значения переменных сохранены в файле и обновлены.
}

LoadConfigValues()
{
    for index, button in buttons
    { 
        if (!FileExist(configPath))
            return
        IniRead, %button%, %configPath%, %section%, %button%
        neutron.doc.getElementById(button).value := %button%

    }
}

#IfWinActive ahk_exe destiny2.exe
WarlockSkating:
F3::
    SendInput, {3 down}{3 up}
    Sleep, 600
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
#If

F5::Reload
F6::ExitApp

TrayMenu()
{
    Menu, Tray, NoStandard
    Menu, Tray, Tip, DESTINY 2 MACROS ; Установка всплывающей подсказки
    Menu, Tray, Add, GitHub, OpenLink
    Menu, Tray, Add, Выйти, CloseApp
return
}

OpenLink:
    Run, https://github.com/drafwodgaming/destinyMacros/releases
return

CheckGitHubUpdates()
{
    ; Отправить запрос к GitHub API для получения информации о последнем релизе
    url := "https://api.github.com/repos/drafwodgaming/destinyMacros/releases/latest"
    response := GetWebContent(url)
    release := JSON.Load(response)

    latestVersion := release.tag_name

    ; Вставьте вашу текущую версию релиза здесь
    currentVersion := "0.0.7"
    ; Сравнить текущую версию с последней версией
    if (currentVersion < latestVersion)
    {
        MsgBox, 4,, Обновление доступно! Хотие посмотреть?
        IfMsgBox Yes
        {
            Run, % release.html_url
            ExitApp
        }
    } 
    else
    {
        SetTimer, CheckGitHubUpdates, -3600000
    }
return
}

; Функция для получения содержимого веб-страницы
GetWebContent(url)
{
    WinHttp := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    WinHttp.Open("GET", url)
    WinHttp.Send()
    WinHttp.WaitForResponse()

return WinHttp.ResponseText
}