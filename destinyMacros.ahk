#Requires AutoHotkey v2.0
#Include Libraries/Neutron.ahk
#Include Libraries/JXON.ahk
#SingleInstance force

SendMode("Input")
SetWorkingDir(A_ScriptDir)
CoordMode("Pixel", "Screen")

CheckGitHubUpdates()

appdata := A_AppData
folderPath := appdata . "\DestinyMacros"
configPath := folderPath . "\config.ini"
buttons := ["ultButton", "interactButton", "jumpButton"]

neutron := NeutronWindow().Load("Main/main.html")
neutron.OnEvent("Close", (neutron) => ExitApp())

TrayMenu()
neutron.Opt("-Resize")
neutron.Show(,"destinyMacros")

LoadConfigValues()

if false {

    FileInstall "Main/main.html", "*"
    FileInstall "Main/mainStyles.css", "*"
    FileInstall "Main/mainScripts.js", "*"
    FileInstall "Main/Assets/Themes/icon_dark-theme.png","*"
    FileInstall "Main/Assets/Themes/icon_light-theme.png", "*"
    FileInstall "Main/Assets/Themes/dark-theme.png", "*"
    FileInstall "Main/Assets/Themes/light-theme.png","*"
}
return

Clicked(neutron, event)
{ 
    SaveConfig()
}

SaveConfig()
{
    if (!FileExist(folderPath))
        DirCreate(folderPath)
    for index, button in buttons 
        IniWrite(neutron.doc.getElementById(button).innerText, configPath, "Buttons", button)
    IniWrite(neutron.qs("body").className, configPath, "General", "Theme")

    MsgBox("Значения переменных сохранены в файле и обновлены.")
    global ultButton:= IniRead(configPath, "Buttons", "ultButton")
    global jumpButton:= IniRead(configPath, "Buttons", "jumpButton")
}

LoadConfigValues()
{
    if (FileExist(configPath))
    {
        for index, button in buttons
            neutron.doc.getElementById(button).innerText := IniRead(configPath, "Buttons", button)
        neutron.qs("body").className := IniRead( configPath, "General", "Theme")
    }
}

#HotIf WinActive("ahk_exe destiny2.exe") && (FileExist(configPath))

WarlockSkating:
    ultButton := IniRead(configPath, "Buttons", "ultButton")
    jumpButton := IniRead(configPath, "Buttons", "jumpButton")
F3::
    {

        SendInput("{3 down}{3 up}")
        Sleep(600)
        SendInput("{RButton down}{RButton up}")
        Sleep(50)
        SendInput("{" . jumpButton . " down}")
        Sleep(50)
        SendInput("{" . ultButton . " down}")
        Sleep(50)
        SendInput("{" . jumpButton . " up}")
        Sleep(50)
        SendInput("{" . ultButton . " up}")
    } 
return

#HotIf

F5::Reload()
F6::ExitApp()

TrayMenu()
{
    Tray:= A_TrayMenu
    Tray.Delete() ; V1toV2: not 100% replacement of NoStandard, Only if NoStandard is used at the beginning
    Tray.Add("GitHub", OpenLink)
    Tray.Add("Выход", CloseApp)
return
}

OpenLink(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ 
    Run("https://github.com/drafwodgaming/destinyMacros/releases")
} 

CloseApp(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{
ExitApp()
}

CheckGitHubUpdates()
{
    try {
        ; Отправить запрос к GitHub API для получения информации о последнем релизе
        url := "https://api.github.com/repos/drafwodgaming/destinyMacros/releases/latest"

        response := GetWebContent(url)
        release := jxon_Load(&response)

        latestVersion := release["tag_name"]

        ; Вставьте вашу текущую версию релиза здесь
        currentVersion := "0.0.9"

        ; Сравнить текущую версию с последней версией
        if (StrCompare(currentVersion, latestVersion) < 0)
        {
            msgResult := MsgBox("Обновление до " . latestVersion . " доступно! Хотите посмотреть?", "Новая версия", 4)
            if (msgResult = "Yes")
            {
                Run(release["html_url"])
                ExitApp()
            }
        }
    }
    SetTimer(CheckGitHubUpdates,3600000)
}

; Функция для получения содержимого веб-страницы
GetWebContent(url)
{
    WinHttp := ComObject("WinHttp.WinHttpRequest.5.1")
    WinHttp.Open("GET", url)
    WinHttp.Send()
    WinHttp.WaitForResponse()

    responseText := WinHttp.ResponseText

return responseText
}