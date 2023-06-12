#Include Libraries\Neutron.ahk
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

global ultButton, interactButton, jumpButton, neutron, folderPath, configPath, section, buttons, themeClass
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
FileInstall, Main/mainScripts.js, mainScripts.js
FileInstall, Main/Assets/Themes/icon_dark-theme.png, icon_dark-theme.png
FileInstall, Main/Assets/Themes/icon_light-theme.png, icon_light-theme.png
FileInstall, Main/Assets/Themes/dark-theme.png, dark-theme.png
FileInstall, Main/Assets/Themes/light-theme.png, light-theme.png
; =================================================================

GuiClose:
CloseApp:
ExitApp

Clicked(neutron, event)
{
    themeClass := neutron.qs("body").className
    ultButton := neutron.doc.getElementById("ultButton").innerText
    interactButton := neutron.doc.getElementById("interactButton").innerText
    jumpButton := neutron.doc.getElementById("jumpButton").innerText

    SaveConfig()
}

SaveConfig()
{
    if (!FileExist(folderPath))
        FileCreateDir, % folderPath
    for index, button in buttons
        IniWrite, % %button%, % configPath, % section, % button

    IniWrite, % themeClass, % configPath, % section, ThemeClass

    MsgBox, Значения переменных сохранены в файле и обновлены.
}

LoadConfigValues()
{
    if (!FileExist(configPath))
        return
    for index, button in buttons
    { 
        IniRead, %button%, %configPath%, %section%, %button%
        neutron.doc.getElementById(button).innerText := %button%
    }
    IniRead, themeClass, % configPath, % section, ThemeClass
    neutron.qs("body").className := themeClass
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
    try {
        ; Отправить запрос к GitHub API для получения информации о последнем релизе
        url := "https://api.github.com/repos/drafwodgaming/destinyMacros/releases/latest"
        response := GetWebContent(url)
        release := JSON.Load(response)

        latestVersion := release.tag_name

        ; Вставьте вашу текущую версию релиза здесь
        currentVersion := "0.0.8"

        ; Сравнить текущую версию с последней версией
        if (currentVersion < latestVersion)
        {
            MsgBox, 4, Новая версия, Обновление до %latestVersion% доступно! Хотие посмотреть?
            IfMsgBox Yes
            {
                Run, % release.html_url
                ExitApp
            }
        } 
    }
    SetTimer, CheckGitHubUpdates, 3600000
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
