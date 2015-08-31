;SetKeyDelay, 50, 80

PROGRAM_NAME := "AHK Game Helper"
HUD_NAME := "AHKGameHUD"
VERSION := "1.0.1"
KEYBINDS := []
BINDABLE_KEYS := "F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12"
BINDABLE_KEYS := BINDABLE_KEYS . "|A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z"
BINDABLE_KEYS := BINDABLE_KEYS . "|1|2|3|4|5|6|7|8|9|0"
BINDABLE_KEYS := BINDABLE_KEYS . "|Numpad0|Numpad1|Numpad2|Numpad3|Numpad4|Numpad5|Numpad6|Numpad7|Numpad8|Numpad9|Numpad0"
BINDABLE_KEYS := BINDABLE_KEYS . "|LButton|MButton|RButton|XButton1|XButton2|WheelUp|WheelDown"
BINDABLE_KEYS := BINDABLE_KEYS . "|`|-|=|\|[|]|;|'|,|.|/|Space"
ALL_HOTKEYS := []
KEYBINDS_ON_HOLD := []
STATUS_MESSAGE := ""
AUTO_FIRE_SEQUENCE := ""
LOADED_PROFILE := "NEW_PROFILE.ini"
SETTING_ENABLE_HUD := false
SETTING_ENABLE_CROSSHAIR := false
SETTING_MATCH_WINDOW_TITLE := false
SETTING_MATCH_WINDOW_TITLE_NAME := "Window Title To Match"
SETTING_CROSSHAIR_WIDTH := 4
SETTING_CROSSHAIR_HEIGHT := 20
SETTING_CROSSHAIR_BORDER_WIDTH := 1
SETTING_CROSSHAIR_OFFSET_X := 0
SETTING_CROSSHAIR_OFFSET_Y := 0
SETTING_CROSSHAIR_BORDER_COLOR := "000000"
SETTING_CROSSHAIR_COLOR := "ffffff"
HELPER_DISABLED := false

GUI.Reload()
GUI.UpdateStatus("GUI LOADED")
SetTimer, ACTIVE_WINDOW_CHECK, 333

^+!r::Reload

class GUI {
    __New() {
        global
        _modifier := Array.MaxIndex(KEYBINDS) - 1
        _modifier < 0 ? _modifier := 0
        _height := 180 + (_modifier * 110)
        _height := "h" . _height
        Gui,Main:Destroy
        Gui,Main:Add, Tab2, w300 %_height%, Binds|HUD|Misc
        Gui,Main:Tab, Binds
            Gui,Main:Font, cBlack
            Gui,Main:Font, s12 w900
            Gui,Main:Add, Text, section h30 w200, Game Helper Key Binds
            Gui,Main:Font, s11 w0
            Gui,Main:Add, Button, ys h25 gKEYBIND_ADD, Add Bind
            Gui,Main:Font, s9
            Loop, % KEYBINDS._MaxIndex()
            {
                Gui,Main:Font, s12 w900
                Gui,Main:Add, Text, section xs w245, Key Bind # %A_Index%
                Gui,Main:Font, s9 w900
                Gui,Main:Add, Button, ys w25 gKEYBIND_REMOVE vKEYBIND_REMOVE_%A_INDEX%,X
                Gui,Main:Font, w0
                Gui,Main:Add, DropDownList, section xs w170 vKEYBIND_INPUT_%A_INDEX% gHOTKEY_SETTINGS_CHANGED, %BINDABLE_KEYS%
                Gui,Main:Default
                GuiControl, Choose, KEYBIND_INPUT_%A_INDEX%, % KEYBINDS[A_INDEX].KEYBIND_INPUT
                _ctrl := KEYBINDS[A_INDEX].KEYBIND_MODIFIER_CTRL
                Gui,Main:Add, CheckBox, ys w25 vKEYBIND_MODIFIER_CTRL_%A_INDEX% gHOTKEY_SETTINGS_CHANGED Checked%_ctrl%, C
                _alt := KEYBINDS[A_INDEX].KEYBIND_MODIFIER_ALT
                Gui,Main:Add, CheckBox, ys w25 vKEYBIND_MODIFIER_ALT_%A_INDEX% gHOTKEY_SETTINGS_CHANGED Checked%_alt%, A
                _shift := KEYBINDS[A_INDEX].KEYBIND_MODIFIER_SHIFT
                Gui,Main:Add, CheckBox, ys w25 vKEYBIND_MODIFIER_SHIFT_%A_INDEX% gHOTKEY_SETTINGS_CHANGED Checked%_shift%, S
                Gui,Main:Add, DropDownList, section xs w120 vKEYBIND_ACTION_%A_INDEX% gHOTKEY_SETTINGS_CHANGED, Send Text|Send Keys|Hold Down|Rapid Fire|Auto Fire
                Gui,Main:Default
                GuiControl, Choose, KEYBIND_ACTION_%A_INDEX%, % KEYBINDS[A_INDEX].KEYBIND_ACTION
                Gui,Main:Add, Edit, ys w150 vKEYBIND_OUTPUT_%A_INDEX% gHOTKEY_SETTINGS_CHANGED, % KEYBINDS[A_INDEX].KEYBIND_OUTPUT
                Gui,Main:Font, s9 w0
                _enabled := KEYBINDS[A_INDEX].KEYBIND_ENABLED
                if (_enabled)
                    _color := "cGreen"
                Else
                    _color := "cRed"
                Gui,Main:Font, % _color
                Gui,Main:Add, Checkbox, section xs w160 vKEYBIND_ENABLED_%A_INDEX% gHOTKEY_SETTINGS_CHANGED Checked%_enabled%, Enabled?
                Gui,Main:Font, cBlack
                Gui,Main:Add, Text, ys w70, Keybind Delay
                Gui,Main:Add, Edit, ys w30 h18 vKEYBIND_DELAY_%A_INDEX% gHOTKEY_SETTINGS_CHANGED, % KEYBINDS[A_INDEX].KEYBIND_DELAY
            }
        Gui,Main:Tab, HUD
            Gui,Main:Font, s12 w900
            Gui,Main:Add, Text, section, Crosshair / HUD Options
            Gui,Main:Font, s9 w0
            Gui,Main:Add, Checkbox, section xs h20 vSETTING_ENABLE_HUD Checked%SETTING_ENABLE_HUD% gSETTINGS_CHANGED, Enable HUD?
            Gui,Main:Add, Checkbox, section xs h20 w135 vSETTING_ENABLE_CROSSHAIR Checked%SETTING_ENABLE_CROSSHAIR% gSETTINGS_CHANGED, Enable Crosshair?
            Gui,Main:Add, Text, ys h20 w80, Crosshair Color
            Gui,Main:Add, Edit, ys h20 w45 vSETTING_CROSSHAIR_COLOR gSETTINGS_CHANGED, % SETTING_CROSSHAIR_COLOR
            Gui,Main:Add, Text, section xs h20 w80, Crosshair Width
            Gui,Main:Add, Edit, ys h18 w45 vSETTING_CROSSHAIR_WIDTH gSETTINGS_CHANGED, % SETTING_CROSSHAIR_WIDTH
            Gui,Main:Add, Text, ys h18 w80, Crosshair Height
            Gui,Main:Add, Edit, ys h18 w45 vSETTING_CROSSHAIR_HEIGHT gSETTINGS_CHANGED, % SETTING_CROSSHAIR_HEIGHT
            Gui,Main:Add, Text, section xs h18 w80, CH Border Width
            Gui,Main:Add, Edit, ys h18 w45 vSETTING_CROSSHAIR_BORDER_WIDTH gSETTINGS_CHANGED, % SETTING_CROSSHAIR_BORDER_WIDTH
            Gui,Main:Add, Text, ys h18 w80, CH Border Color
            Gui,Main:Add, Edit, ys h18 w45 vSETTING_CROSSHAIR_BORDER_COLOR gSETTINGS_CHANGED, % SETTING_CROSSHAIR_BORDER_COLOR
            Gui,Main:Add, Text, section xs h18 w80, CH X Offset
            Gui,Main:Add, Edit, ys h18 w45 vSETTING_CROSSHAIR_OFFSET_X gSETTINGS_CHANGED, % SETTING_CROSSHAIR_OFFSET_X
            Gui,Main:Add, Text, ys h18 w80, CH Y Offset
            Gui,Main:Add, Edit, ys h18 w45 vSETTING_CROSSHAIR_OFFSET_Y gSETTINGS_CHANGED, % SETTING_CROSSHAIR_OFFSET_Y
        Gui,Main:Tab, Misc
            Gui,Main:Font, s12 w900
            Gui,Main:Add, Text, section, Configuration / Options
            Gui,Main:Font, s9 w0
            Gui,Main:Add, Checkbox, section xs h20 vSETTING_MATCH_WINDOW_TITLE Checked%SETTING_MATCH_WINDOW_TITLE% gSETTINGS_CHANGED, Match Window Title:
            Gui,Main:Add, Edit, section xs h20 w280 vSETTING_MATCH_WINDOW_TITLE_NAME gSETTINGS_CHANGED, % SETTING_MATCH_WINDOW_TITLE_NAME
            ;Gui,Main:Add, Button, ys h20 w30, Get
            Gui,Main:Add, Text, section xs, Profile:
            Gui,Main:Add, Edit, section xs w155 vLOADED_PROFILE, % LOADED_PROFILE
            Gui,Main:Add, Button, ys h22 w47 gSAVE_CONFIG, Save
            Gui,Main:Add, Button, ys h22 w57 gLOAD_CONFIG, Load
        Gui,Main:Add, StatusBar,
        Gui,Main:Default
        Gui,Main:Show, x%GUI_X% y%GUI_Y% , %PROGRAM_NAME% v%VERSION%
        GUI.UpdateStatus(STATUS_MESSAGE)
    }

    UpdateStatus(message) {
        global STATUS_MESSAGE
        STATUS_MESSAGE := message
        SB_SetText(STATUS_MESSAGE)
    }

    Reload() {
        global GUI_X
        global GUI_Y
        WinGetPos, GUI_X, GUI_Y, _w, _h, %PROGRAM_NAME%
        if (!GUI_X)
            GUI_X := "Center"
        if (!GUI_Y)
            GUI_Y := "Center"
        global GUI := new GUI()
    }
}

class HUD 
{
    __New() {
        global HUD_NAME
        global HUD_STATUS
        global KEYBINDS
        Gui,Hud:Destroy
        Gui,Hud:+LastFound +ToolWindow -Caption +AlwaysOnTop
        WinSet, TransColor, Black
        Gui,Hud:Font,s12 Consolas w900
        Gui,Hud:Color, Black
        Gui,Hud:Font, c99CC00
        Gui,Hud:Add, Text, vHUD_STATUS w%A_ScreenWidth%, HUD Loaded
        Loop, % Array.MaxIndex(KEYBINDS)
        {
            if(KEYBINDS[A_Index].KEYBIND_ENABLED) {
                _name := KEYBINDS[A_Index].HotKeyName()
                _action := KEYBINDS[A_Index].KEYBIND_ACTION
                StringReplace, _name, _name, *$, , All
                StringUpper, _name, _name
                StringUpper, _action, _action
                Gui,Hud:Font, c33B5E5 w900
                Gui,Hud:Add, Text, section xs w100, % _name 
                Gui,Hud:Font, cDDDDDD
                Gui,Hud:Add, Text, ys,=
                Gui,Hud:Font, cFF4444
                Gui,Hud:Add, Text, ys w110, % _action
                Gui,Hud:Font, cDDDDDD
                Gui,Hud:Add, Text, ys,->
                Gui,Hud:Font, cFFBB33
                Gui,Hud:Add, Text, ys, % KEYBINDS[A_Index].KEYBIND_OUTPUT
                Gui,Hud:Font, cDDDDDD w0
            }
        }
        Gui,Hud:Show, xCenter yCenter NoActivate, % HUD_NAME
        SetTimer, HUD_UPDATE, 500
    }

    Disable() {
        Gui,Hud:Destroy
        SetTimer, HUD_UPDATE, Off
    }

    Reload() {
        global SETTING_ENABLE_HUD
        global HUD
        if (SETTING_ENABLE_HUD)
            HUD := new HUD()
        else
            HUD.Disable()
    }
}

class CrossHairOverlay
{
    __New(thickness,height,border_width,offset_x,offset_y,outline,inner) {
        if SETTING_MATCH_WINDOW_TITLE
            WinGetPos, _x, _y, _w, _h, % SETTING_MATCH_WINDOW_TITLE_NAME
        if not _x
            _x := 0
        if not _y
            _y := 0
        if not _w
            _w := A_ScreenWidth
        if not _h
            _h := A_ScreenHeight
        _thickness := thickness + (border_width * 2)
        _height := height + (border_width * 2)
        ; -- vertical outer part
        x := (_x + _w + offset_x - _thickness) / 2 
        y := (_y + _h + offset_y - _height) / 2
        CrossHairOverlay.DrawBar("CH_OUTER_V",x,y,_thickness,_height,outline)
        ; -- horizontal outer part
        x := (_x + _w + offset_x - _height) / 2 
        y := (_y + _h + offset_y - _thickness) / 2
        CrossHairOverlay.DrawBar("CH_OUTER_H",x,y,_height,_thickness,outline)
        ; -- vertical inner part
        x := (_x + _w + offset_x - thickness) / 2 
        y := (_y + _h + offset_y - height) / 2
        CrossHairOverlay.DrawBar("CH_INNER_V",x,y,thickness,height,inner)
        ; -- horizontal inner part
        x := (_x + _w + offset_x - height) / 2 
        y := (_y + _h + offset_y - thickness) / 2
        CrossHairOverlay.DrawBar("CH_INNER_H",x,y,height,thickness,inner)
        SetTimer, CROSSHAIR_UPDATE, 500
    }

    DrawBar(name,x,y,width,height,color) {
        Gui, %name%:Destroy
        Gui, %name%:+E0x20 +LastFound +ToolWindow -Caption +AlwaysOnTop +Disabled
        Gui, %name%:Color, %color%
        Gui, %name%:Show, x%x% y%y% h%height% w%width% NoActivate,%name%
        WinSet, Transparent, 128
    }

    Reload() {
        global
        if SETTING_CROSSHAIR_HEIGHT is not number
            SETTING_CROSSHAIR_HEIGHT := 0
        if SETTING_CROSSHAIR_WIDTH is not number
            SETTING_CROSSHAIR_WIDTH := 0
        if SETTING_CROSSHAIR_BORDER_WIDTH is not number
            SETTING_CROSSHAIR_BORDER_WIDTH := 0
        if SETTING_CROSSHAIR_OFFSET_X is not number
            SETTING_CROSSHAIR_OFFSET_X := 0
        if SETTING_CROSSHAIR_OFFSET_Y is not number
            SETTING_CROSSHAIR_OFFSET_Y := 0
        if (SETTING_ENABLE_CROSSHAIR)
            CROSSHAIR_OVERLAY := new CrossHairOverlay(SETTING_CROSSHAIR_WIDTH,SETTING_CROSSHAIR_HEIGHT,SETTING_CROSSHAIR_BORDER_WIDTH,SETTING_CROSSHAIR_OFFSET_X,SETTING_CROSSHAIR_OFFSET_Y,SETTING_CROSSHAIR_BORDER_COLOR,SETTING_CROSSHAIR_COLOR)
        else
            CROSSHAIR_OVERLAY.Disable()
    }

    Disable() {
        Gui,CH_OUTER_V:Destroy
        Gui,CH_OUTER_H:Destroy
        Gui,CH_INNER_V:Destroy
        Gui,CH_INNER_H:Destroy
        SetTimer, CROSSHAIR_UPDATE, Off
    }

    Show() {
        Gui,CH_OUTER_V:Show,NoActivate
        Gui,CH_OUTER_H:Show,NoActivate
        Gui,CH_INNER_V:Show,NoActivate
        Gui,CH_INNER_H:Show,NoActivate
    }

    Hide() {
        Gui,CH_OUTER_V:Hide
        Gui,CH_OUTER_H:Hide
        Gui,CH_INNER_V:Hide
        Gui,CH_INNER_H:Hide
    }
}

class AdvancedKeyBind 
{
    __New(keyIn,keyModifiers,keyAction,keysOut,keyDelay,enabled) {
        global ALL_HOTKEYS
        this.KEYBIND_INPUT := keyIn
        this.KEYBIND_MODIFIER_CTRL := keyModifiers[1]
        this.KEYBIND_MODIFIER_ALT := keyModifiers[2]
        this.KEYBIND_MODIFIER_SHIFT := keyModifiers[3]
        this.KEYBIND_ACTION := keyAction
        this.KEYBIND_OUTPUT := keysOut
        this.KEYBIND_DELAY := keyDelay
        this.KEYBIND_ENABLED := enabled
        this.HELD_DOWN := false
        this.AUTO_FIRE := false
        Array.Add(ALL_HOTKEYS,this)
        GUI.UpdateStatus("NEW KEYBIND -> " . this.HotKeyName())
    }

    HotKeyPressed() {
        if(this.KEYBIND_ACTION == "Send Text")
            this.SendText()
        if(this.KEYBIND_ACTION == "Send Keys")
            this.SendKeys()
        if(this.KEYBIND_ACTION == "Hold Down")
            this.HoldDown()
        if(this.KEYBIND_ACTION == "Rapid Fire")
            this.RapidFire()
        if(this.KEYBIND_ACTION == "Auto Fire")
            this.AutoFire()
    }

    SendText() {
        SendRaw, % this.KEYBIND_OUTPUT
        GUI.UpdateStatus("SEND TEXT -> " . this.KEYBIND_OUTPUT)
    }

    SendKeys() {
        _buttonCheck := this.KEYBIND_OUTPUT
        StringUpper, _buttonCheck, _buttonCheck
        if (_buttonCheck == "{LBUTTON}") {
            SendInput, {LBUTTON DOWN}
            Sleep, 65
            SendInput, {LBUTTON UP}
        } Else
            SendInput, % this.KEYBIND_OUTPUT
        GUI.UpdateStatus("SEND KEYS -> " . this.KEYBIND_OUTPUT)
    }

    HoldDown() {
        this.HELD_DOWN := !this.HELD_DOWN
        SendInput, % "{" . this.KEYBIND_OUTPUT . " " . (this.HELD_DOWN ? "DOWN" : "UP") . "}"
        GUI.UpdateStatus((this.HELD_DOWN ? "HOLD DOWN -> " : "RELEASE -> ") . this.KEYBIND_OUTPUT)
    }

    RapidFire() {
        While, % GetKeyState(this.KEYBIND_INPUT,"P")
        {
            this.SendKeys()
            Sleep, % this.KEYBIND_DELAY
        }
    }

    AutoFire() {
        global AUTO_FIRE_SEQUENCE
        this.AUTO_FIRE := !this.AUTO_FIRE
        if (this.AUTO_FIRE) {
            AUTO_FIRE_SEQUENCE := this.KEYBIND_OUTPUT
            SetTimer, AUTO_FIRE, % this.KEYBIND_DELAY
        } else {
            AUTO_FIRE_SEQUENCE := ""
            SetTimer, AUTO_FIRE, Off
        }
    }

    ModifiersToString() {
        r := ""
        if(this.KEYBIND_MODIFIER_CTRL)
            r := r . "^"
        if(this.KEYBIND_MODIFIER_ALT)
            r := r . "!"
        if(this.KEYBIND_MODIFIER_SHIFT)
            r := r . "+"
        return r
    }

    ToString() {
        r := ""
        r := r . "this.KEYBIND_INPUT := " . this.KEYBIND_INPUT . "`n"
        r := r . "this.KEYBIND_MODIFIER_CTRL := " . this.KEYBIND_MODIFIER_CTRL . "`n"
        r := r . "this.KEYBIND_MODIFIER_ALT := " . this.KEYBIND_MODIFIER_ALT . "`n"
        r := r . "this.KEYBIND_MODIFIER_SHIFT := " . this.KEYBIND_MODIFIER_SHIFT . "`n"
        r := r . "this.KEYBIND_ACTION := " . this.KEYBIND_ACTION . "`n"
        r := r . "this.KEYBIND_OUTPUT := " . this.KEYBIND_OUTPUT . "`n"
        r := r . "this.KEYBIND_ENABLED := " . this.KEYBIND_ENABLED . "`n"
        r := r . "this.KEYBIND_DELAY := " . this.KEYBIND_DELAY . "`n"
        return r
    }

    Serialize() {
        r := ""
        r := r . this.KEYBIND_INPUT          . "|"
        r := r . this.KEYBIND_MODIFIER_CTRL  . "|"
        r := r . this.KEYBIND_MODIFIER_ALT   . "|"
        r := r . this.KEYBIND_MODIFIER_SHIFT . "|"
        r := r . this.KEYBIND_ACTION         . "|"
        r := r . this.KEYBIND_OUTPUT         . "|"
        r := r . this.KEYBIND_DELAY          . "|"
        r := r . this.KEYBIND_ENABLED
        return r
    }

    Unserialize(str) {
        vars := StrSplit(str,"|")
        return new AdvancedKeyBind(vars[1],[vars[2],vars[3],vars[4]],vars[5],vars[6],vars[7],vars[8])
    }

    HotKeyName() {
        return "*$" . this.ModifiersToString() . this.KEYBIND_INPUT
    }

    Equals(other) {
        return this.KEYBIND_INPUT == other.KEYBIND_INPUT
            and this.KEYBIND_MODIFIER_CTRL == other.KEYBIND_MODIFIER_CTRL
            and this.KEYBIND_MODIFIER_ALT == other.KEYBIND_MODIFIER_ALT
            and this.KEYBIND_MODIFIER_SHIFT == other.KEYBIND_MODIFIER_SHIFT
            and this.KEYBIND_ACTION == other.KEYBIND_ACTION
            and this.KEYBIND_OUTPUT == other.KEYBIND_OUTPUT
            and this.KEYBIND_ENABLED == other.KEYBIND_ENABLED
            and this.KEYBIND_DELAY == other.KEYBIND_DELAY
    }

    Enable() {
        ;GUI.UpdateStatus("HOTKEY ENABLED -> " . this.HotKeyName())
        Hotkey, % this.HotKeyName(), HOTKEY_PRESSED, On
    }

    Disable() {
        ;GUI.UpdateStatus("HOTKEY DISABLED -> " . this.HotKeyName())
        Hotkey, % this.HotKeyName(), HOTKEY_PRESSED, Off
    }
}

class Array {
    MaxIndex(arr) {
        index := arr._MaxIndex()
        if !index
            index := 0
        return index
    }

    Add(arr,item) {
        arr._Insert(Array.MaxIndex(arr)+1,item)
    }
}

UpdateKeybinds() {
    global
    Loop, % Array.MaxIndex(ALL_HOTKEYS)
    {
        ALL_HOTKEYS[A_Index].Disable()
    }
    ALL_HOTKEYS := []
    Loop, % Array.MaxIndex(KEYBINDS) 
    {
        Array.Add(ALL_HOTKEYS,KEYBINDS[A_Index])
        if KEYBINDS[A_Index].KEYBIND_ENABLED
            KEYBINDS[A_Index].Enable()
    }
    SetTimer, AUTO_FIRE, Off
}

GetHotKeyByName(name) {
    global KEYBINDS
    Loop, % Array.MaxIndex(KEYBINDS)
    {
        if (KEYBINDS[A_Index].HotKeyName() == name)
            return KEYBINDS[A_Index]
    }
}

KEYBIND_ADD:
    Array.Add(KEYBINDS,new AdvancedKeyBind("F1",[false,false,false],"Send Text","Output Sequence",75,false))
    UpdateKeybinds()
    GUI.Reload()
    HUD.Reload()
    CrossHairOverlay.Reload()
    return

KEYBIND_REMOVE:
    StringRight, _index, A_GuiControl, 2
    StringReplace, _index, _index, % "_", % "", All
    KEYBINDS._Remove(_index)
    UpdateKeybinds()
    GUI.Reload()
    HUD.Reload()
    CrossHairOverlay.Reload()
    return

HOTKEY_SETTINGS_CHANGED:
    Gui,Main:Submit, NoHide
    StringRight, _index, A_GuiControl, 2
    StringReplace, _index, _index, % "_", % "", All
    IfNotInString, A_GuiControl, KEYBIND_ENABLED
    {
        Gui,Main:Default
        GuiControl, , KEYBIND_ENABLED_%_index%, 0
        Gui,Main:Font, cRed
        GuiControl, Font, KEYBIND_ENABLED_%_index%,
    }
    KEYBINDS[_index] := new AdvancedKeyBind(KEYBIND_INPUT_%_index%,[KEYBIND_MODIFIER_CTRL_%_index%,KEYBIND_MODIFIER_ALT_%_index%,KEYBIND_MODIFIER_SHIFT_%_index%],KEYBIND_ACTION_%_index%,KEYBIND_OUTPUT_%_index%,KEYBIND_DELAY_%_index%,KEYBIND_ENABLED_%_index%)
    UpdateKeybinds()
    GUI.UpdateStatus("SETTINGS: " . A_GuiControl . " -> " . %A_GuiControl%)
    IfInString, A_GuiControl, KEYBIND_ENABLED
    {
        if (KEYBIND_ENABLED_%_index%)
            _color := "cGreen"
        Else
            _color := "cRed"
        Gui,Main:Font, % _color
        Gui,Main:Default
        GuiControl, Font, KEYBIND_ENABLED_%_index%,
    }
    HUD.Reload()
    CrossHairOverlay.Reload()
    return

SETTINGS_CHANGED:
    Gui,Main:Submit, NoHide
    HUD.Reload()
    CrossHairOverlay.Reload()
    return

HOTKEY_PRESSED:
    GetHotKeyByName(A_ThisHotkey).HotKeyPressed()
    return

AUTO_FIRE:
    SendInput, % AUTO_FIRE_SEQUENCE
    return

LOAD_CONFIG:
    FileSelectFile, _file, , % A_WorkingDir . "\" . LOADED_PROFILE, Select Config File, *.ini
    if (_file) {
        KEYBINDS := []
        Loop, 99
        {
            IniRead, _serializedKeyBind, % _file, Keybinds, % A_Index
            if(_serializedKeyBind == "ERROR")
                break
            _bind := AdvancedKeyBind.Unserialize(_serializedKeyBind)
            Keybinds[A_Index] := _bind
        }
        UpdateKeybinds()
        HELPER_DISABLED := false
        IniRead, SETTING_ENABLE_HUD, % _file, Options, SETTING_ENABLE_HUD, 0
        HUD.Reload()
        IniRead, SETTING_ENABLE_CROSSHAIR      , % _file, Options, SETTING_ENABLE_CROSSHAIR      , % SETTING_ENABLE_CROSSHAIR
        IniRead, SETTING_CROSSHAIR_WIDTH       , % _file, Options, SETTING_CROSSHAIR_WIDTH       , % SETTING_CROSSHAIR_WIDTH
        IniRead, SETTING_CROSSHAIR_HEIGHT      , % _file, Options, SETTING_CROSSHAIR_HEIGHT      , % SETTING_CROSSHAIR_HEIGHT
        IniRead, SETTING_CROSSHAIR_BORDER_WIDTH, % _file, Options, SETTING_CROSSHAIR_BORDER_WIDTH, % SETTING_CROSSHAIR_BORDER_WIDTH
        IniRead, SETTING_CROSSHAIR_OFFSET_X    , % _file, Options, SETTING_CROSSHAIR_OFFSET_X    , % SETTING_CROSSHAIR_OFFSET_X
        IniRead, SETTING_CROSSHAIR_OFFSET_Y    , % _file, Options, SETTING_CROSSHAIR_OFFSET_Y    , % SETTING_CROSSHAIR_OFFSET_Y
        IniRead, SETTING_CROSSHAIR_BORDER_COLOR, % _file, Options, SETTING_CROSSHAIR_BORDER_COLOR, % SETTING_CROSSHAIR_BORDER_COLOR
        IniRead, SETTING_CROSSHAIR_COLOR       , % _file, Options, SETTING_CROSSHAIR_COLOR       , % SETTING_CROSSHAIR_COLOR
        CrossHairOverlay.Reload()
        IniRead, SETTING_MATCH_WINDOW_TITLE, % _file, Options, SETTING_MATCH_WINDOW_TITLE, 0
        IniRead, SETTING_MATCH_WINDOW_TITLE_NAME, % _file, Options, SETTING_MATCH_WINDOW_TITLE_NAME, % "No Window Title"
        StringReplace, _file, _file, % A_WorkingDir . "\", , 
        LOADED_PROFILE := _file
        GUI.Reload()
    }
    return

SAVE_CONFIG:
    Gui,Main:Submit, NoHide
    _cancel := false
    if (Array.MaxIndex(KEYBINDS) == 0) {
        MsgBox, , KEYBIND REQUIRED, At least one keybind required to save profile!, 5 
        _cancel := true
    }
    if (!_cancel) {
        _profile := LOADED_PROFILE
        StringRight, _ext, _profile, 4
        if (_ext != ".ini")
            _profile := _profile . ".ini" 
        if FileExist(_profile) {
            MsgBox, 4, Config File Already Exists, %_profile% already exists.`n`nOverwrite It?, 2
            IfMsgBox, Yes
                FileDelete, % _profile
            IfMsgBox, No
                _cancel := true
        }
    }
    if (!_cancel) {
        Loop, % Array.MaxIndex(KEYBINDS)
        {
            _serialized := KEYBINDS[A_Index].Serialize()
            IniWrite, % _serialized, % _profile, Keybinds, % A_Index
        }
        IniWrite, % SETTING_ENABLE_HUD             , % _profile, Options, SETTING_ENABLE_HUD
        IniWrite, % SETTING_ENABLE_CROSSHAIR       , % _profile, Options, SETTING_ENABLE_CROSSHAIR
        IniWrite, % SETTING_MATCH_WINDOW_TITLE     , % _profile, Options, SETTING_MATCH_WINDOW_TITLE
        IniWrite, % SETTING_MATCH_WINDOW_TITLE_NAME, % _profile, Options, SETTING_MATCH_WINDOW_TITLE_NAME
        IniWrite, % SETTING_CROSSHAIR_WIDTH        , % _profile, Options, SETTING_CROSSHAIR_WIDTH
        IniWrite, % SETTING_CROSSHAIR_HEIGHT       , % _profile, Options, SETTING_CROSSHAIR_HEIGHT
        IniWrite, % SETTING_CROSSHAIR_BORDER_WIDTH , % _profile, Options, SETTING_CROSSHAIR_BORDER_WIDTH
        IniWrite, % SETTING_CROSSHAIR_OFFSET_X     , % _profile, Options, SETTING_CROSSHAIR_OFFSET_X
        IniWrite, % SETTING_CROSSHAIR_OFFSET_Y     , % _profile, Options, SETTING_CROSSHAIR_OFFSET_Y
        IniWrite, % SETTING_CROSSHAIR_BORDER_COLOR , % _profile, Options, SETTING_CROSSHAIR_BORDER_COLOR
        IniWrite, % SETTING_CROSSHAIR_COLOR        , % _profile, Options, SETTING_CROSSHAIR_COLOR
        GUI.UpdateStatus("SETTINGS SAVED -> " . _profile)
    }
    return

ACTIVE_WINDOW_CHECK:
    if(!HELPER_DISABLED and SETTING_MATCH_WINDOW_TITLE and !(WinActive(SETTING_MATCH_WINDOW_TITLE_NAME))) {
        HELPER_DISABLED := true
        KEYBINDS_ON_HOLD := []
        Loop, % Array.MaxIndex(ALL_HOTKEYS)
        {
            ALL_HOTKEYS[A_Index].Disable()
        }
        Loop, % Array.MaxIndex(KEYBINDS)
        {
            Array.Add(KEYBINDS_ON_HOLD,A_Index)
        }
        GUI.UpdateStatus("WINDOW INACTIVE -> KEYBINDS DISABLED")
    } else {
        if(HELPER_DISABLED and SETTING_MATCH_WINDOW_TITLE and WinActive(SETTING_MATCH_WINDOW_TITLE_NAME)) {
            HELPER_DISABLED := false
            Loop, % Array.MaxIndex(KEYBINDS_ON_HOLD)
            {
                KEYBINDS[KEYBINDS_ON_HOLD[A_Index]].Enable()
            }
            GUI.UpdateStatus("WINDOW REACTIVATED -> KEYBINDS ENABLED")
        }
    }

    HUD_UPDATE:
        if(SETTING_MATCH_WINDOW_TITLE) {
            WinGetPos, _X, _y, _w, _h, % SETTING_MATCH_WINDOW_TITLE_NAME
            WinMove, % HUD_NAME, , % _x, % (_y + 25), , , , 
            if((WinActive(SETTING_MATCH_WINDOW_TITLE_NAME) or WinActive(PROGRAM_NAME)) and !WinExist(HUD_NAME))
                Gui,Hud:Show,NoActivate
            Else
                If WinExist(HUD_NAME) and !WinActive(SETTING_MATCH_WINDOW_TITLE_NAME) and !WinActive(PROGRAM_NAME)
                    Gui,Hud:Hide
            Gui,Hud:Default
            GuiControl, , HUD_STATUS, % STATUS_MESSAGE
        } else {
            SetTimer, HUD_UPDATE, Off
        }
        return

    CROSSHAIR_UPDATE:

        if(SETTING_MATCH_WINDOW_TITLE) {
            WinGetPos, _x, _y, _w, _h, % SETTING_MATCH_WINDOW_TITLE_NAME
            if not _x
                _x := 0
            if not _y
                _y := 0
            if not _w
                _w := A_ScreenWidth
            if not _h
                _h := A_ScreenHeight

            _thickness := SETTING_CROSSHAIR_WIDTH + (SETTING_CROSSHAIR_BORDER_WIDTH * 2)
            _height := SETTING_CROSSHAIR_HEIGHT + (SETTING_CROSSHAIR_BORDER_WIDTH * 2)

            ; -- vertical outer part
            x := _x + ((_w + SETTING_CROSSHAIR_OFFSET_X - _thickness) / 2)
            y := _y + ((_h + SETTING_CROSSHAIR_OFFSET_Y - _height) / 2)
            WinMove, CH_OUTER_V, , % x, % y
            x := _x + ((_w + SETTING_CROSSHAIR_OFFSET_X - _height) / 2)
            y := _y + ((_h + SETTING_CROSSHAIR_OFFSET_Y - _thickness) / 2)
            WinMove, CH_OUTER_H, , % x, % y
            ; -- vertical inner part
            x := _x + ((_w + SETTING_CROSSHAIR_OFFSET_X - SETTING_CROSSHAIR_WIDTH) / 2)
            y := _y + ((_h + SETTING_CROSSHAIR_OFFSET_Y - SETTING_CROSSHAIR_HEIGHT) / 2)
            WinMove, CH_INNER_V, , % x, % y
            ; -- horizontal inner part
            x := _x + ((_w + SETTING_CROSSHAIR_OFFSET_X - SETTING_CROSSHAIR_HEIGHT) / 2)
            y := _y + ((_h + SETTING_CROSSHAIR_OFFSET_Y - SETTING_CROSSHAIR_WIDTH) / 2)
            WinMove, CH_INNER_H, , % x, % y

            if(WinActive(SETTING_MATCH_WINDOW_TITLE_NAME) and !WinExist("CH_OUTER_V"))
                CrossHairOverlay.Show()
            Else
                If WinExist("CH_OUTER_V") and !WinActive(SETTING_MATCH_WINDOW_TITLE_NAME)
                    CrossHairOverlay.Hide()
        } else {
            SetTimer, CROSSHAIR_UPDATE, Off
        }
        return

    MainGuiClose:
        ExitApp
        return