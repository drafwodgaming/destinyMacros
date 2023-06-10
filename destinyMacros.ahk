TrayMenu()
#Include Neutron.ahk
#Persistent
#SingleInstance, Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
CoordMode, Pixel, Screen
SetBatchLines -1
SetTimer, CheckGitHubRelease, 600000

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

CheckGitHubRelease:
    githubRepo := "drafwodgaming/destinyMacros" ; Замените на имя владельца и название репозитория
    currentRelease := "0.6" ; Здесь хранится текущая версия, можете установить начальное значение

    ; Получение информации о последнем релизе с GitHub API
    url := "https://api.github.com/repos/" . githubRepo . "/releases/latest"
    json := GetUrlData(url)
    latestRelease := Json.ValueFromKey(json, "tag_name")

    ; Сравнение текущей и последней версий
    if (latestRelease != currentRelease)
    {
        ; Вывод уведомления
        MsgBox, Новое обновление, скачайте
        currentRelease := latestRelease
    }
return

; Функция для получения данных по URL
GetUrlData(url)
{
    WinHttp := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    WinHttp.Open("GET", url, false)
    WinHttp.Send()
return WinHttp.ResponseText
}
