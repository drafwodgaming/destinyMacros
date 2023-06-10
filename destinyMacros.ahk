TrayMenu()
#Include Neutron.ahk
#Include JSON.ahk
#Persistent
#SingleInstance, Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
CoordMode, Pixel, Screen
SetBatchLines -1
SetTimer, CheckGitHubUpdates, 10000 ; Проверять обновления каждую минуту (60000 миллисекунд)

appdata = %A_AppData%

global ultButton, interactButton, jumpButton
global buttons := ["ultButton", "interactButton", "jumpButton"]
global folderPath := appdata . "\DestinyMacros"
global configPath := folderPath . "\config.ini"
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

GuiClose:
ExitApp

Clicked(neutron, event)
{
    if (!FileExist(folderPath))
        FileCreateDir, % folderPath
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
    Menu, Tray, Icon, Main\Assets\icon.png 
    Menu, Tray, Add, GitHub, OpenLink
return
}

OpenLink:
    Run, https://github.com/drafwodgaming/destinyMacros/releases
return

CheckGitHubUpdates:
    ; Отправить запрос к GitHub API для получения информации о последнем релизе
    url := "https://api.github.com/repos/drafwodgaming/destinyMacros/releases/latest"
    response := GetWebContent(url)
    release := JSON.Parse(response)

    ; Проверить версию последнего релиза
    latestVersion := release.tag_name

    ; Вставьте вашу текущую версию релиза здесь
    currentVersion := "0.0.6"

    ; Сравнить текущую версию с последней версией
    if (currentVersion < latestVersion)
    {
        MsgBox, Обновление доступно! Пожалуйста, скачайте новый релиз.
    }
return

; Функция для получения содержимого веб-страницы
GetWebContent(url)
{
    WinHttp := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    WinHttp.Open("GET", url)
    WinHttp.Send()
    WinHttp.WaitForResponse()

return WinHttp.ResponseText
}
