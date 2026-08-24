global g_ExifTool := ""
; ─────────────────────────────────────────────────────────────
; FilmTagger (AutoHotkey Edition)
; 
; Author: JOAO FERNANDES
; GitHub: https://github.com/MrBroccoliJP/FilmTagger
; Version: 1.0.0
; Year: 2026
;
; Description:
; Desktop tool for editing and organizing EXIF metadata for film scans.
; Predecessor to the FilmTagger web version.
;
; License:
; MIT License
; https://opensource.org/licenses/MIT
;
; Dependencies:
; - ExifTool (https://exiftool.org/)
;   This script requires ExifTool to be installed separately.
;
; Notes:
; This script does not include ExifTool. Please download it from the
; official website and ensure it is available in your system PATH
; or in the expected local directory.
; ─────────────────────────────────────────────────────────────

;@Ahk2Exe-SetName FilmTagger
;@Ahk2Exe-SetDescription FilmTagger — EXIF tagging tool for film scans
;@Ahk2Exe-SetVersion 1.0.0
;@Ahk2Exe-SetCompanyName Joao Fernandes
;@Ahk2Exe-SetCopyright © 2026 YOUR_NAME
;@Ahk2Exe-SetOrigFilename FilmTagger-Desktop.exe
#Requires AutoHotkey v2.0
#SingleInstance Force

; ── Globals ─────────────────────────────────────────────────
global g_files   := []
global g_filmNames := [
    "Kodak Gold 200",
    "Kodak ColorPlus 200",
    "Kodak UltraMax 400",
    "Kodak Pro Image 100",
    "Kodak Ektar 100",
    "Kodak Portra 160",
    "Kodak Portra 400",
    "Kodak Portra 800",
    "Kodak Tri-X 400",
    "Kodak T-Max 100",
    "Kodak T-Max 400",
    "Kodak Ektachrome E100",
    "Fujifilm 200",
    "Fujicolor 100",
    "Fujifilm Neopan Acros II 100",
    "Ilford HP5 Plus 400",
    "Ilford FP4 Plus 125",
    "Ilford Delta 100",
    "Ilford Delta 400",
    "Ilford Delta 3200",
    "Ilford XP2 Super 400",
    "Kentmere Pan 100",
    "Kentmere Pan 200",
    "Kentmere Pan 400",
    "CineStill 50D",
    "CineStill 400D",
    "CineStill 800T",
    "CineStill BwXX",
    "Harman Phoenix II 200",
    "Harman Red 125",
    "Lomography Color Negative 100",
    "Lomography Color Negative 400",
    "Lomography Color Negative 800",
    "Fomapan 100 Classic",
    "Fomapan 200 Creative",
    "Fomapan 400 Action"
]
global g_filmMap := Map(
    "Kodak ColorPlus 200",    "KCP200",
    "Kodak Gold 200",         "KG200",
    "Kodak UltraMax 400",     "KUM400",
    "Kodak ProImage 100",     "KPI100",
    "Kodak Ektar 100",        "KE100",
    "Kodak Portra 160",       "KP160",
    "Kodak Portra 400",       "KP400",
    "Kodak Portra 800",       "KP800",
    "Fuji C200",              "FC200",
    "Fuji Superia 200",       "FSU200",
    "Fuji Superia 400",       "FSU400",
    "Fuji Superia X-TRA 400", "FSXT400",
    "Fuji Pro 400H",          "FP400H",
    "Ilford HP5 Plus 400",    "IHP400",
    "Ilford Delta 400",       "ID400",
    "Ilford FP4 Plus 125",    "IFP125",
    "Kodak T-Max 100",        "KTM100",
    "Kodak T-Max 400",        "KTM400",
    "Lomography Color 100",   "LC100",
    "Lomography Color 400",   "LC400",
    "Kodak Tri-X 400",        "KTX400",
    "Kodak Ektachrome E100",  "KE100S",
    "Fujifilm 200",           "FF200",
    "Fujicolor 100",          "FFC100",
    "Fujifilm Neopan Acros II 100", "FA100",
    "Ilford Delta 100",       "ID100",
    "Ilford Delta 3200",      "ID3200",
    "Ilford XP2 Super 400",   "IXP2400",
    "Kentmere Pan 100",       "KPAN100",
    "Kentmere Pan 200",       "KPAN200",
    "Kentmere Pan 400",       "KPAN400",
    "CineStill 50D",          "CS50D",
    "CineStill 400D",         "CS400D",
    "CineStill 800T",         "CS800T",
    "CineStill BwXX",         "CSBWXX",
    "Harman Phoenix II 200",  "HPX2200",
    "Harman Red 125",         "HRED125",
    "Lomography Color Negative 100", "LCN100",
    "Lomography Color Negative 400", "LCN400",
    "Lomography Color Negative 800", "LCN800",
    "Fomapan 100 Classic",    "F100C",
    "Fomapan 200 Creative",   "F200C",
    "Fomapan 400 Action",     "F400A"
)


global g_cameraNames := [
    "Canon AE-1",
    "Canon AE-1 Program",
    "Canon A-1",
    "Canon AV-1",
    "Canon FTb",
    "Canon AF35-ML",
    "Canon Sure Shot Max",
    "Canon Prima BF-8",
    "Nikon FM",
    "Nikon FM2",
    "Nikon FE",
    "Nikon FE2",
    "Nikon F3",
    "Pentax K1000",
    "Pentax MX",
    "Pentax ME Super",
    "Pentax Spotmatic SP",
    "Olympus OM-1",
    "Olympus OM-2",
    "Olympus Mju II",
    "Olympus XA",
    "Olympus Trip 35",
    "Minolta X-700",
    "Minolta XD-7",
    "Contax T2",
    "Ricoh GR1",
    "Pentax 17"
]
global g_cameraMap := Map(
    "Canon AE-1",      "CAE1",
    "Canon A-1",       "CA1",
    "Canon AF35-ML",   "CAF35ML",
    "Canon Prima BF-8", "CPBF8",
    "Olympus Mju II",  "OMJUII"
)

global g_filmIsoMap := Map(
    "Kodak ColorPlus 200",    "200",
    "Kodak Gold 200",         "200",
    "Kodak UltraMax 400",     "400",
    "Kodak ProImage 100",     "100",
    "Kodak Ektar 100",        "100",
    "Kodak Portra 160",       "160",
    "Kodak Portra 400",       "400",
    "Kodak Portra 800",       "800",
    "Fuji C200",              "200",
    "Fuji Superia 200",       "200",
    "Fuji Superia 400",       "400",
    "Fuji Superia X-TRA 400", "400",
    "Fuji Pro 400H",          "400",
    "Ilford HP5 Plus 400",    "400",
    "Ilford Delta 400",       "400",
    "Ilford FP4 Plus 125",    "125",
    "Kodak T-Max 100",        "100",
    "Kodak T-Max 400",        "400",
    "Lomography Color 100",   "100",
    "Lomography Color 400",   "400",
    "Kodak Tri-X 400",        "400",
    "Kodak Ektachrome E100",  "100",
    "Fujifilm 200",           "200",
    "Fujicolor 100",          "100",
    "Fujifilm Neopan Acros II 100", "100",
    "Ilford Delta 100",       "100",
    "Ilford Delta 3200",      "3200",
    "Ilford XP2 Super 400",   "400",
    "Kentmere Pan 100",       "100",
    "Kentmere Pan 200",       "200",
    "Kentmere Pan 400",       "400",
    "CineStill 50D",          "50",
    "CineStill 400D",         "400",
    "CineStill 800T",         "800",
    "CineStill BwXX",         "250",
    "Harman Phoenix II 200",  "200",
    "Harman Red 125",         "125",
    "Lomography Color Negative 100", "100",
    "Lomography Color Negative 400", "400",
    "Lomography Color Negative 800", "800",
    "Fomapan 100 Classic",    "100",
    "Fomapan 200 Creative",   "200",
    "Fomapan 400 Action",     "400"
)

global g_Gui      := 0
global g_lv       := 0
global g_preview  := 0
global g_status   := 0
global g_lblName  := 0
global g_progress := 0
global g_previewFrameX := 0
global g_previewFrameY := 0
global g_previewFrameW := 0
global g_previewFrameH := 0
global g_rotationNames := Map(1, "0°", 3, "180°", 6, "90° CW", 8, "90° CCW")
global g_selectedRow := 0
global g_lensNames := [
    "Canon FD 50mm f/1.4 S.S.C.",
    "Canon FD 50mm f/1.8",
    "Canon FD 35mm f/3.5",
    "Canon FD 28mm f/2.8",
    "Canon FD 35mm f/2",
    "Canon FD 85mm f/1.8",
    "Canon FD 135mm f/2.8",
    "Canon 38mm f/2.8 (AF35-ML)",
    "Olympus 35mm f/2.8 (Mju II)",
    "Olympus 35mm f/2.8 (Trip 35)",
    "Ricoh 28mm f/2.8 (GR1)",
    "45mm f/3.5 (Pentax 17)"
]

; Add this to your Globals section
global g_GdipToken := 0
StartGdip()

StartGdip() {
    global g_GdipToken
    si := Buffer(24, 0)
    NumPut("UInt", 1, si)
    if !DllCall("gdiplus\GdiplusStartup", "Ptr*", &g_GdipToken, "Ptr", si, "Ptr", 0)
        return true
    return false
}

; ── Colour palette (dark modern theme) ──────────────────────
; We paint these via WM_CTLCOLOR messages and direct HWND calls
; AHK doesn't support CSS, so we use native controls + custom bg

; ── Entry point ─────────────────────────────────────────────
BuildGUI()
return

; ============================================================
;  GUI  — Dark modern layout
;  Left panel: 340px  |  Right panel: fills rest
;  Total window: 980 wide × 760 tall
; ============================================================
BuildGUI() {
    global
    global g_Gui, g_lv, g_preview, g_status, g_lblName, g_progress
    global g_previewFrameX, g_previewFrameY, g_previewFrameW, g_previewFrameH

    cBG     := "0F0F14"
    cPanel  := "16161E"
    cPanel2 := "111118"
    cAccent := "BB86FC"
    cText   := "E0E0E0"
    cDim    := "7A7A8C"
    cGood   := "50FA7B"
    cBad    := "FF5555"

    g_Gui := Gui("+Resize +MinSize1280x1100 -DPIScale", "Film EXIF Tagger")
    g_Gui.BackColor := cBG
    g_Gui.SetFont("s9 c" cText, "Segoe UI")

    g_Gui.Add("Text", "x0 y0 w1360 h62 Background1A1A24")
    g_Gui.SetFont("s18 w700 cFFFFFF", "Segoe UI Semibold")
    g_Gui.Add("Text", "x24 y15 w620 h24 Background1A1A24", "Film EXIF Tagger")

    etStatus := FindExifTool()
    etColor  := InStr(etStatus, "NOT") ? cBad : cGood
    g_Gui.SetFont("s9 w600 c" etColor, "Segoe UI Variable Text")
    g_Gui.Add("Text", "x980 y21 w320 +Right +BackgroundTrans", "● SYSTEM: " etStatus)

    PX := 28, PW := 360, Y := 84

    ; ── Hardware / Emulsion ──────────────────────────────────────
    ; Content: label(19) + combo(38) + label(19) + combo(38) + label(19) + edit/combo(38) + save(28) + padding(14) = 213 → h=230
    g_Gui.Add("GroupBox", "x" PX-8 " y" Y-8 " w" PW+16 " h240 c" cDim, "Hardware / Emulsion")
    Y += 20
    g_Gui.SetFont("s8 c" cDim, "Segoe UI Variable Text")
    g_Gui.Add("Text", "x" PX " y" Y " w" PW, "CAMERA BODY")
    Y += 19
    g_Gui.SetFont("s10 c" cText, "Segoe UI Variable Text")
    camCB := g_Gui.Add("ComboBox", "x" PX " y" Y " w" PW " vfCamera Background" cPanel, BuildCameraDDLItems())
    camCB.OnEvent("Change", OnCameraChanged)
    Y += 38

    g_Gui.SetFont("s8 c" cDim, "Segoe UI Variable Text")
    g_Gui.Add("Text", "x" PX " y" Y " w" PW, "LENS OPTICS")
    Y += 19
    g_Gui.SetFont("s10 c" cText, "Segoe UI Variable Text")
    lensCB := g_Gui.Add("ComboBox", "x" PX " y" Y " w" PW " vfLens Background" cPanel, BuildLensItems())
    lensCB.Text := "Canon FD 50mm f/1.4 S.S.C."
    lensCB.OnEvent("Change", UpdatePreviewName)
    Y += 38

    g_Gui.SetFont("s8 c" cDim, "Segoe UI Variable Text")
    g_Gui.Add("Text", "x" PX " y" Y " w50", "ISO")
    g_Gui.Add("Text", "x" (PX+72) " y" Y " w268", "FILM STOCK")
    Y += 19
    g_Gui.SetFont("s10 c" cText, "Segoe UI Variable Text")
    g_Gui.Add("Edit", "x" PX " y" Y " w62 h28 vfISO +Center Background" cPanel " +0x400", "400").OnEvent("Change", UpdatePreviewName)
    filmCB := g_Gui.Add("ComboBox", "x" (PX+72) " y" Y " w268 vfFilm Background" cPanel, BuildFilmDDLItems())
    filmCB.OnEvent("Change", OnFilmChanged)
    filmCB.Text := "Kodak UltraMax 400"
    Y += 36
    g_Gui.Add("Button", "x" PX " y" Y " w" PW " h28", "SAVE").OnEvent("Click", SaveHardwareSection)
    Y += 46   ; 28 button + 18 gap to next GroupBox

    ; ── Custom Tag ───────────────────────────────────────────────
    ; Content: top-pad(20) + label(19) + edit(28) + gap(10) + checkbox(22) + gap(10) + save(28) + bottom-pad(12) = 149 → h=149
    g_Gui.Add("GroupBox", "x" PX-8 " y" Y-8 " w" PW+16 " h152 c" cDim, "Custom Tag")
    Y += 20
    g_Gui.SetFont("s8 c" cDim, "Segoe UI Variable Text")
    g_Gui.Add("Text", "x" PX " y" Y " w" PW, "CUSTOM TEXT TO EMBED")
    Y += 19
    g_Gui.SetFont("s10 c" cText, "Segoe UI Variable Text")
    g_Gui.Add("Edit", "x" PX " y" Y " w" PW " h28 vfCustomTag Background" cPanel " +0x400", "").OnEvent("Change", UpdatePreviewName)
    Y += 36
    g_Gui.SetFont("s9 c" cAccent, "Segoe UI Variable Text")
    g_Gui.Add("CheckBox", "x" PX " y" Y " w" PW " vfTag35 Checked", "Include 35mm film scan")
    Y += 28
    g_Gui.Add("Button", "x" PX " y" Y " w" PW " h28", "SAVE").OnEvent("Click", SaveCustomSection)
    Y += 46   ; 28 button + 18 gap

    ; ── Temporal Data ────────────────────────────────────────────
    ; Content: top-pad(20) + labels(19) + edits(30) + gap(12) + save(28) + bottom-pad(12) = 121 → h=121
    g_Gui.Add("GroupBox", "x" PX-8 " y" Y-8 " w" PW+16 " h130 c" cDim, "Temporal Data")
    Y += 20
    g_Gui.SetFont("s8 c" cDim, "Segoe UI Variable Text")
    g_Gui.Add("Text", "x" PX " y" Y " w32", "DAY")
    g_Gui.Add("Text", "x" (PX+72) " y" Y " w60", "MONTH")
    g_Gui.Add("Text", "x" (PX+144) " y" Y " w72", "YEAR")
    g_Gui.Add("Text", "x" (PX+228) " y" Y " w112", "QUICK PICK")
    Y += 19
    g_Gui.SetFont("s10 c" cText, "Segoe UI Variable Text")
    ddCtrl := g_Gui.Add("Edit", "x" PX " y" Y " w60 h30 vfDD +Center Background" cPanel " +0x400 Limit2 Number", FormatTime(, "dd"))
    mmCtrl := g_Gui.Add("Edit", "x" (PX+72) " y" Y " w60 h30 vfMM +Center Background" cPanel " +0x400 Limit2 Number", FormatTime(, "MM"))
    yyyyCtrl := g_Gui.Add("Edit", "x" (PX+144) " y" Y " w72 h30 vfYYYY +Center Background" cPanel " +0x400 Limit4 Number", FormatTime(, "yyyy"))
    g_Gui.Add("Button", "x" (PX+228) " y" Y " w112 h30", "SELECT").OnEvent("Click", PickDate)
    ddCtrl.OnEvent("Change", UpdatePreviewName)
    mmCtrl.OnEvent("Change", UpdatePreviewName)
    yyyyCtrl.OnEvent("Change", UpdatePreviewName)
    Y += 38
    g_Gui.Add("Button", "x" PX " y" Y " w" PW " h28", "SAVE").OnEvent("Click", SaveTemporalSection)
    Y += 46   ; 28 button + 18 gap

    ; ── GPS / Location ───────────────────────────────────────────
    ; Content: top-pad(20) + label(19) + row1(28) + gap(12) + labels(19) + row2(28) + gap(12) + save(28) + bottom-pad(14) = 180 → h=188
    g_Gui.Add("GroupBox", "x" PX-8 " y" Y-8 " w" PW+16 " h196 c" cDim, "GPS / Location")
    Y += 20
    g_Gui.SetFont("s8 c" cDim, "Segoe UI Variable Text")
    g_Gui.Add("Text", "x" PX " y" Y " w" PW, "PASTE DECIMAL COORDINATES FROM GOOGLE MAPS")
    Y += 19
    g_Gui.SetFont("s10 c" cText, "Segoe UI Variable Text")
    g_Gui.Add("Edit", "x" PX " y" Y " w246 h28 vfGPS +Center Background" cPanel " +0x400", "")
    g_Gui.Add("Button", "x" (PX+254) " y" Y " w106 h28", "VERIFY").OnEvent("Click", ParseGPS)
    Y += 38
    g_Gui.SetFont("s8 c" cDim, "Segoe UI Variable Text")
    g_Gui.Add("Text", "x" PX " y" Y " w108", "CITY")
    g_Gui.Add("Text", "x" (PX+120) " y" Y " w112", "STATE / REGION")
    g_Gui.Add("Text", "x" (PX+240) " y" Y " w108", "COUNTRY")
    Y += 19
    g_Gui.SetFont("s10 c" cText, "Segoe UI Variable Text")
    g_Gui.Add("Edit", "x" PX " y" Y " w108 h28 vfCity +Center Background" cPanel " +0x400", "")
    g_Gui.Add("Edit", "x" (PX+120) " y" Y " w112 h28 vfState +Center Background" cPanel " +0x400", "")
    g_Gui.Add("Edit", "x" (PX+240) " y" Y " w120 h28 vfCountry +Center Background" cPanel " +0x400", "")
    Y += 38
    g_Gui.Add("Button", "x" PX " y" Y " w" PW " h28", "SAVE").OnEvent("Click", SaveLocationSection)
    Y += 46   ; 28 button + 18 gap

    ; ── Rotation ─────────────────────────────────────────────────
    ; Content: top-pad(20) + row1(28) + gap(12) + row2(28) + bottom-pad(14) = 102 → h=110
    g_Gui.Add("GroupBox", "x" PX-8 " y" Y-8 " w" PW+16 " h118 c" cDim, "Rotation")
    Y += 20
    g_Gui.SetFont("s10 c" cText, "Segoe UI Variable Text")
    g_Gui.Add("Button", "x" PX " y" Y " w94 h28", "↶ LEFT").OnEvent("Click", RotateLeft)
    g_Gui.Add("Edit", "x" (PX+102) " y" Y " w152 h28 vfOrientation ReadOnly +Center Background" cPanel, "0°")
    g_Gui.Add("Button", "x" (PX+262) " y" Y " w98 h28", "RIGHT ↷").OnEvent("Click", RotateRight)
    Y += 38
    g_Gui.Add("Button", "x" PX " y" Y " w175 h28", "RESET").OnEvent("Click", RotateReset)
    g_Gui.Add("Button", "x" (PX+185) " y" Y " w175 h28", "SAVE").OnEvent("Click", SaveRotationSection)
    Y += 46   ; 28 button + 18 gap

    ; ── Renaming ─────────────────────────────────────────────────
    ; Content: top-pad(20) + checkbox(22) + gap(12) + labels(19) + edits(30) + gap(10) + previewName(20) + format(18) + bottom-pad(14) = 165 → h=172
    g_Gui.Add("GroupBox", "x" PX-8 " y" Y-8 " w" PW+16 " h178 c" cDim, "Renaming")
    Y += 20
    g_Gui.SetFont("s10 c" cAccent, "Segoe UI Variable Text")
    g_Gui.Add("CheckBox", "x" PX " y" Y " w" PW " vfRename Checked", "ENABLE AUTO-RENAME FOR WRITTEN FILES").OnEvent("Click", UpdatePreviewName)
    Y += 30
    g_Gui.SetFont("s8 c" cDim, "Segoe UI Variable Text")
    g_Gui.Add("Text", "x" PX " y" Y " w156", "PREFIX (OPTIONAL)")
    g_Gui.Add("Text", "x" (PX+172) " y" Y " w156", "SUFFIX (OPTIONAL)")
    Y += 19
    g_Gui.SetFont("s10 c" cText, "Segoe UI Variable Text")
    g_Gui.Add("Edit", "x" PX " y" Y " w156 h30 vfPrefix +Center Background" cPanel " +0x400", "").OnEvent("Change", UpdatePreviewName)
    g_Gui.Add("Edit", "x" (PX+172) " y" Y " w168 h30 vfSuffix +Center Background" cPanel " +0x400", "").OnEvent("Change", UpdatePreviewName)
    Y += 38
    g_Gui.SetFont("s9 c" cAccent, "Segoe UI Variable Text")
    g_lblName := g_Gui.Add("Text", "x" PX " y" Y " w" PW " +Center", "---")
    Y += 22
    g_Gui.SetFont("s8 c" cDim, "Segoe UI Variable Text")
    g_Gui.Add("Text", "x" PX " y" Y " w" PW " +Center", "[PREFIX_]YYYYMMDD_CAM_FILM_NNN[_SUFFIX].JPG")

    RX := 402, RW := 860
    g_Gui.SetFont("s10 c" cText, "Segoe UI Variable Text")
    g_Gui.Add("Button", "x" RX " y86 w118 h30", "+ FOLDER").OnEvent("Click", AddFolder)
    g_Gui.Add("Button", "x" (RX+128) " y86 w118 h30", "+ FILES").OnEvent("Click", AddFiles)
    g_Gui.Add("Button", "x" (RX+256) " y86 w118 h30", "CLEAR").OnEvent("Click", ClearList)
    g_Gui.Add("Button", "x" RX " y126 w118 h30", "CHECK ALL").OnEvent("Click", (*) => CheckAll(true))
    g_Gui.Add("Button", "x" (RX+128) " y126 w118 h30", "CHECK NONE").OnEvent("Click", (*) => CheckAll(false))

    g_lv := g_Gui.Add("ListView", "x" RX " y162 w" RW " h292 Checked -Multi +LV0x14000 Background" cPanel " c" cText, ["#", "FILE", "CAMERA", "LENS", "FILM", "GPS", "DATE", "TAGS", "ROT", "STATUS"])
    g_lv.ModifyCol(1, 54)
    g_lv.ModifyCol(2, 150)
    g_lv.ModifyCol(3, 118)
    g_lv.ModifyCol(4, 138)
    g_lv.ModifyCol(5, 132)
    g_lv.ModifyCol(6, 126)
    g_lv.ModifyCol(7, 82)
    g_lv.ModifyCol(8, 128)
    g_lv.ModifyCol(9, 68)
    g_lv.ModifyCol(10, 108)
    g_lv.OnEvent("ItemSelect", OnSelect)
    g_lv.OnEvent("Click", OnLVClick)

    g_Gui.SetFont("s8 c" cDim, "Segoe UI Variable Text")
    g_Gui.Add("Text", "x" RX " y462 w" RW, "CLICK A FILE TO PREVIEW  ·  STAGED VALUES OVERRIDE EXISTING EXIF IN THE PANEL")

    g_previewFrameX := RX
    g_previewFrameY := 484
    g_previewFrameW := RW
    g_previewFrameH := 300
    g_Gui.Add("Progress", "x" RX " y" g_previewFrameY " w" RW " h" g_previewFrameH " Background" cPanel2, 0)
    g_preview := g_Gui.Add("Pic", "x" RX " y" g_previewFrameY " w" RW " h" g_previewFrameH " +BackgroundTrans", "")

    actionY := g_previewFrameY + g_previewFrameH + 12
    g_Gui.SetFont("s10 c" cText, "Segoe UI Variable Text")
    g_Gui.Add("Button", "x" RX " y" actionY " w200 h34", "CLEAR CHECKED STAGING").OnEvent("Click", ClearStaged)

    writeY := actionY + 56
    g_Gui.SetFont("s11 w700 c" cText, "Segoe UI Variable Text")
    g_Gui.Add("Button", "x" RX " y" writeY " w" RW " h42 Default", "✦  WRITE ALL STAGED CHANGES").OnEvent("Click", ApplyExif)
    g_progress := g_Gui.Add("Progress", "x" RX " y" (writeY + 48) " w" RW " h18 c" cAccent " Background" cPanel, 0)

    g_status := g_Gui.Add("StatusBar")
    g_status.SetText("  Ready")

    g_Gui.OnEvent("Close", (*) => ExitApp())
    g_Gui.OnEvent("DropFiles", OnDrop)
    g_Gui.Show("w1360 h1140 Center")
    g_Gui["fRename"].Value := 1
    UpdatePreviewName()
}

BuildFilmDDLItems() {
    global g_filmNames
    items := []
    for _, name in g_filmNames
        items.Push(name)
    return items
}

BuildCameraDDLItems() {
    global g_cameraNames
    items := []
    for _, name in g_cameraNames
        items.Push(name)
    return items
}

BuildLensItems() {
    global g_lensNames
    items := []
    for _, name in g_lensNames
        items.Push(name)
    return items
}


; ── Section label helper ─────────────────────────────────────
AddSectionLabel(gui, x, y, w, txt) {
    gui.SetFont("s8 w700 cBB86FC", "Segoe UI Variable Text")
    gui.Add("Text", "x" x " y" y " w" w, txt)
    gui.SetFont("s9 cE0E0E0", "Segoe UI Variable Text")
}

; ============================================================
;  DATE PICKER  — opens a MonthCal in a popup Gui
; ============================================================
PickDate(*) {
    global g_Gui, g_DatePicker, g_DatePickerCal

    if IsSet(g_DatePicker) && g_DatePicker {
        try g_DatePicker.Destroy()
    }

    g_DatePicker := Gui("+Owner" g_Gui.Hwnd " +ToolWindow", "Pick Date")
    g_DatePicker.BackColor := "1E1E2E"
    g_DatePicker.SetFont("s9 cE0E0E0", "Segoe UI")
    g_DatePicker.MarginX := 12
    g_DatePicker.MarginY := 12

    g_DatePickerCal := g_DatePicker.Add("MonthCal", "w260 h180")

    ; prefill from current fields when possible
    dd := Trim(g_Gui["fDD"].Value)
    mm := Trim(g_Gui["fMM"].Value)
    yyyy := Trim(g_Gui["fYYYY"].Value)
    if (RegExMatch(dd, "^\d{1,2}$") && RegExMatch(mm, "^\d{1,2}$") && RegExMatch(yyyy, "^\d{4}$")) {
        try g_DatePickerCal.Value := Format("{:04}{:02}{:02}", Integer(yyyy), Integer(mm), Integer(dd))
    }

    btnOK := g_DatePicker.Add("Button", "xm w120 h28 Default", "OK")
    btnCancel := g_DatePicker.Add("Button", "x+8 w90 h28", "Cancel")

    btnOK.OnEvent("Click", PickDate_OK)
    btnCancel.OnEvent("Click", PickDate_Cancel)
    g_DatePicker.OnEvent("Escape", PickDate_Cancel)
    g_DatePicker.OnEvent("Close", PickDate_Cancel)

    g_DatePicker.Show("AutoSize Center")
}

PickDate_OK(*) {
    global g_Gui, g_DatePicker, g_DatePickerCal

    raw := ""
    try raw := g_DatePickerCal.Value

    raw := String(raw)
    if !RegExMatch(raw, "^\d{8}$") {
        try g_DatePicker.Destroy()
        return
    }

    g_Gui["fDD"].Value   := SubStr(raw, 7, 2)
    g_Gui["fMM"].Value   := SubStr(raw, 5, 2)
    g_Gui["fYYYY"].Value := SubStr(raw, 1, 4)

    UpdatePreviewName()

    try g_DatePicker.Destroy()
}

PickDate_Cancel(*) {
    global g_DatePicker
    try g_DatePicker.Destroy()
}
; ============================================================
;  EXIFTOOL
; ============================================================
FindExifTool() {
    path := ResolveExifToolPath()
    if path = ""
        return "NOT FOUND"
    return path
}

ResolveExifToolPath() {
    global g_ExifTool

    if g_ExifTool != "" && FileExist(g_ExifTool)
        return g_ExifTool

    localPath := A_ScriptDir "\exiftool.exe"
    if FileExist(localPath) {
        g_ExifTool := localPath
        return g_ExifTool
    }

    whereOut := ""
    try {
        shell := ComObject("WScript.Shell")
        exec := shell.Exec(A_ComSpec ' /C where exiftool')
        whereOut := Trim(exec.StdOut.ReadAll(), "`r`n`t ")
    } catch {
        whereOut := ""
    }

    if whereOut != "" {
        for _, line in StrSplit(whereOut, "`n", "`r") {
            line := Trim(line)
            if line != "" && FileExist(line) {
                g_ExifTool := line
                return g_ExifTool
            }
        }
    }

    return ""
}

ExifToolPath() {
    path := ResolveExifToolPath()
    return (path != "" ? '"' . path . '"' : "")
}

ExifArg(value) {
    value := String(value)
    value := StrReplace(value, '"', '""')
    return '"' . value . '"'
}

RunExifTool(args, &stdOut := "", &stdErr := "") {
    stdOut := ""
    stdErr := ""

    exifPath := ResolveExifToolPath()
    if exifPath = "" || !FileExist(exifPath)
        return -1

    stamp := A_TickCount "_" . A_NowUTC
    outFile := A_Temp "\film_exif_out_" . stamp . ".txt"
    errFile := A_Temp "\film_exif_err_" . stamp . ".txt"

    cmd := '"' A_ComSpec '" /C ""' exifPath '" ' . args . ' >"' outFile '" 2>"' errFile '""'
    exitCode := RunWait(cmd, , "Hide")

    try stdOut := FileExist(outFile) ? FileRead(outFile, "UTF-8") : ""
    catch
        stdOut := ""

    try stdErr := FileExist(errFile) ? FileRead(errFile, "UTF-8") : ""
    catch
        stdErr := ""

    try FileDelete(outFile)
    try FileDelete(errFile)

    return exitCode
}

SetMainProgress(value := 0, label := "") {
    global g_progress, g_status
    if g_progress
        g_progress.Value := value
    if label != "" && g_status
        g_status.SetText("  " . label)
}

BatchAddFiles(paths, sourceLabel := "files") {
    global g_files
    total := paths.Length
    if total = 0
        return

    SetMainProgress(0, "Loading " . total . " " . sourceLabel . "...")
    for idx, path in paths {
        AddFileToList(path)
        pct := Round((idx / total) * 100)
        SetMainProgress(pct, "Parsing " . idx . "/" . total . " " . sourceLabel . "...")
    }
    ResortLoadedFiles()
    SetMainProgress(100, total . " " . sourceLabel . " loaded")
    Sleep(150)
    SetMainProgress(0)
    UpdateStatus()
}

; ============================================================
;  FILE LIST
; ============================================================
AddFolder(*) {
    global
    folder := DirSelect("", 3, "Select folder with scanned JPEGs")
    if folder = ""
        return
    
    tempList := []
    loop files folder "\*.jpg",  "F"
        tempList.Push(A_LoopFileFullPath)
    loop files folder "\*.jpeg", "F"
        tempList.Push(A_LoopFileFullPath)
    
    tempList.Default := ""
    SortArray(&tempList)
    BatchAddFiles(tempList, "files from folder")
}

AddFiles(*) {
    global
    files := FileSelect("M3", , "Select JPEG files", "Images (*.jpg; *.jpeg)")
    if files = ""
        return

    tempList := []
    if IsObject(files) {
        for f in files
            tempList.Push(f)
    } else {
        for line in StrSplit(files, "`n", "`r")
            if line != ""
                tempList.Push(line)
    }

    SortArray(&tempList)
    BatchAddFiles(tempList, "selected files")
}

SortArray(&arr) {
    if arr.Length <= 1
        return

    sortLines := ""
    for idx, item in arr
        sortLines .= FilenameSequenceSortKey(item) . "`t" . Format("{:06}", idx) . "`n"

    sorted := Sort(Trim(sortLines, "`n"), "C")
    newArr := []
    for _, line in StrSplit(sorted, "`n") {
        if line = ""
            continue
        parts := StrSplit(line, "`t")
        oldIdx := parts[2] + 0
        newArr.Push(arr[oldIdx])
    }
    arr := newArr
}

AddFileToList(path) {
    global
    for f in g_files
        if f.path = path
            return
    g_files.Push({path: path, status: "Pending", exif: Map(), sourceExif: 0, checked: false})
    MySplitPath(path, &name)
    rowNum := g_lv.Add("Check", Format("{:03d}", g_files.Length), name, "", "", "", "", "", "", "", "Pending")
    try LoadExifForRow(rowNum)
}

ClearList(*) {
    global
    g_files := []
    g_lv.Delete()
    try g_preview.Value := ""
    UpdateStatus()
}

CheckAll(state) {
    global
    n := g_lv.GetCount()
    loop n {
        g_lv.Modify(A_Index, state ? "Check" : "-Check")
        g_files[A_Index].checked := state
    }
}

; ── DRAG & DROP FIX ─────────────────────────────────────────
; The Gui DropFiles callback in AHK v2 receives:
;   (guiObj, droppedCtrl, fileArray, x, y)
; We ignore droppedCtrl here and iterate the Array directly.
OnDrop(gui, droppedCtrl, paths, x, y) {
    tempList := []
    for _, f in paths {
        if f ~= "i)\.(jpg|jpeg)$"
            tempList.Push(f)
    }
    SortArray(&tempList)
    BatchAddFiles(tempList, "dropped files")
}

UpdateStatus() {
    global
    g_status.SetText("  " . g_files.Length . " file(s) loaded")
}

SyncCheckedStateFromList() {
    global g_lv, g_files
    checkedRows := Map()
    row := g_lv.GetNext(0, "C")
    while row > 0 {
        checkedRows[row] := true
        row := g_lv.GetNext(row, "C")
    }
    for idx, rowItem in g_files
        rowItem.checked := checkedRows.Has(idx)
}

NaturalSortKey(value) {
    value := StrLower(Trim(value))
    key := ""
    pos := 1
    while RegExMatch(value, "\d+", &m, pos) {
        if m.Pos > pos
            key .= SubStr(value, pos, m.Pos - pos)
        key .= Format("{:010}", m[0] + 0)
        pos := m.Pos + StrLen(m[0])
    }
    if pos <= StrLen(value)
        key .= SubStr(value, pos)
    return key
}

FilenameSequenceSortKey(pathOrName) {
    MySplitPath(pathOrName, &name)
    base := RegExReplace(name, "\.[^.]+$", "")
    baseLower := StrLower(base)

    ; Primary sort: last numeric block in the filename, which usually matches
    ; scanner/slide sequence or the frame number suffix.
    seqNum := 0
    if RegExMatch(baseLower, ".*?(\d+)(?!.*\d)", &m)
        seqNum := m[1] + 0

    ; Secondary sort: natural filename ordering to keep a stable, readable list.
    return Format("{:010}", seqNum) . "|" . NaturalSortKey(baseLower)
}

ResortLoadedFiles() {
    global g_files
    if g_files.Length <= 1 {
        RebuildListView()
        return
    }

    SyncCheckedStateFromList()

    sortLines := ""
    for idx, rowItem in g_files {
        sortLines .= BuildRowSortKey(rowItem) . "`t" . Format("{:06}", idx) . "`n"
    }

    sorted := Sort(Trim(sortLines, "`n"), "C")
    newFiles := []
    for _, line in StrSplit(sorted, "`n") {
        if line = ""
            continue
        parts := StrSplit(line, "`t")
        oldIdx := parts[2] + 0
        newFiles.Push(g_files[oldIdx])
    }
    g_files := newFiles
    RebuildListView()
}

RebuildListView() {
    global g_lv, g_files
    g_lv.Delete()
    for rowNum, rowItem in g_files
        RefreshRow(rowNum)
}

FormatRotation(orientation) {
    global g_rotationNames
    orientation := IsNumber(orientation) ? orientation + 0 : 1
    return g_rotationNames.Has(orientation) ? g_rotationNames[orientation] : (orientation . "")
}

MarkIfStaged(rowNum, key, value) {
    global g_files
    staged := g_files[rowNum].exif
    if staged.Has(key) && Trim(value) != ""
        return "*" . value
    if staged.Has(key) && value = ""
        return "*"
    return value
}

GetTagsDisplay(data) {
    tags := []
    if data.Has("film") && Trim(data["film"]) != ""
        tags.Push(data["film"])
    if data.Has("custom") && Trim(data["custom"]) != ""
        tags.Push(data["custom"])
    if data.Has("tag35") && data["tag35"] != ""
        tags.Push("35mm film scan")
    return tags.Length ? JoinArray(tags, " | ") : ""
}

BuildRowSortKey(rowItem) {
    eff := Map()
    if IsObject(rowItem.sourceExif)
        for k, v in rowItem.sourceExif
            eff[k] := v
    for k, v in rowItem.exif
        eff[k] := v

    dateKey := eff.Has("date") && eff["date"] != "" ? BuildFileDate(eff["date"]) : "99999999"
    MySplitPath(rowItem.path, &name)
    return dateKey . "|" . FilenameSequenceSortKey(name)
}

JoinArray(arr, sep := ", ") {
    out := ""
    for idx, item in arr
        out .= (idx > 1 ? sep : "") . item
    return out
}

RefreshRow(rowNum) {
    global g_lv, g_files
    if rowNum < 1 || rowNum > g_files.Length
        return

    file := g_files[rowNum]
    merged := Map()
    if IsObject(file.sourceExif) {
        for k, v in file.sourceExif
            merged[k] := v
    }
    for k, v in file.exif
        merged[k] := v

    MySplitPath(file.path, &name)
    camCol := MarkIfStaged(rowNum, "camera", merged.Has("camera") ? merged["camera"] : "")
    lensCol := MarkIfStaged(rowNum, "lens", merged.Has("lens") ? merged["lens"] : "")
    filmCol := MarkIfStaged(rowNum, "film", merged.Has("film") ? merged["film"] : "")
    gpsCol := MarkIfStaged(rowNum, "gps", merged.Has("gps") ? merged["gps"] : "")
    dateRaw := (merged.Has("date") && merged["date"] != "") ? SubStr(merged["date"], 1, 10) : ""
    dateCol := MarkIfStaged(rowNum, "date", dateRaw)
    rotCol := MarkIfStaged(rowNum, "orientation", FormatRotation(merged.Has("orientation") ? merged["orientation"] : 1))
    tagCol := ((file.exif.Has("custom") || file.exif.Has("tag35")) ? "*" : "") . GetTagsDisplay(merged)
    statusCol := file.status
    opts := file.checked ? "Check" : "-Check"

    seqCol := Format("{:03d}", rowNum)
    if rowNum <= g_lv.GetCount()
        g_lv.Modify(rowNum, opts, seqCol, name, camCol, lensCol, filmCol, gpsCol, dateCol, tagCol, rotCol, statusCol)
    else
        g_lv.Add(opts, seqCol, name, camCol, lensCol, filmCol, gpsCol, dateCol, tagCol, rotCol, statusCol)
}

LV_CustomDraw(wParam, lParam, msg, hwnd) {
    return
}

; ============================================================
;  PER-FILE STAGING
; ============================================================
BuildDateStr(saved) {
    ; Returns "YYYY:MM:DD 09:00:00"
    dd   := Format("{:02d}", ((saved.fDD = "" ? 1 : saved.fDD) + 0))
    mm   := Format("{:02d}", ((saved.fMM = "" ? 1 : saved.fMM) + 0))
    yyyy := (saved.fYYYY = "" ? FormatTime(, "yyyy") : saved.fYYYY)
    return yyyy . ":" . mm . ":" . dd . " 09:00:00"
}

CheckAllWrites(*) {
    global g_Gui
    g_Gui["fRename"].Value := 1
    UpdatePreviewName()
}

UncheckAllWrites(*) {
    global g_Gui
    g_Gui["fRename"].Value := 0
    UpdatePreviewName()
}

ShouldWrite(saved, key) {
    switch key {
        case "camera":   return saved.fWriteCamera
        case "lens":     return saved.fWriteLens
        case "iso":      return saved.fWriteISO
        case "film":     return saved.fWriteFilm
        case "date":     return saved.fWriteDate
        case "gps":      return saved.fWriteGPS
        case "location": return saved.fWriteLocation
        case "rotation": return saved.fWriteRotation
        case "rename":   return saved.fRename
        default: return 0
    }
}

BuildEffectiveRowData(row, panelSaved := 0) {
    src := GetMergedDataForRow(row)

    if IsObject(panelSaved) {
        if ShouldWrite(panelSaved, "camera")
            src["camera"] := ResolveCamera(panelSaved)
        if ShouldWrite(panelSaved, "lens")
            src["lens"] := panelSaved.fLens
        if ShouldWrite(panelSaved, "iso")
            src["iso"] := panelSaved.fISO
        if ShouldWrite(panelSaved, "film")
            src["film"] := ResolveFilm(panelSaved)
        if ShouldWrite(panelSaved, "date")
            src["date"] := BuildDateStr(panelSaved)
        if ShouldWrite(panelSaved, "gps")
            src["gps"] := panelSaved.fGPS
        if ShouldWrite(panelSaved, "location") {
            src["city"] := panelSaved.fCity
            src["state"] := panelSaved.fState
            src["country"] := panelSaved.fCountry
        }
        if ShouldWrite(panelSaved, "rotation")
            src["orientation"] := NormalizeOrientationValue(panelSaved.fOrientation)
    }
    return src
}

StageSection(section) {
    global
    saved := g_Gui.Submit(false)
    SyncCheckedStateFromList()
    count := 0
    row := g_lv.GetNext(0, "C")
    while row > 0 {
        e := g_files[row].exif
        switch section {
            case "hardware":
                camera := ResolveCamera(saved)
                if Trim(camera) != ""
                    e["camera"] := camera
                if Trim(saved.fLens) != "" && Trim(saved.fLens) != "-"
                    e["lens"] := saved.fLens
                if Trim(saved.fISO) != ""
                    e["iso"] := saved.fISO
                film := ResolveFilm(saved)
                if Trim(film) != ""
                    e["film"] := film
            case "temporal":
                if RegExMatch(Trim(saved.fDD), "^\d{1,2}$") && RegExMatch(Trim(saved.fMM), "^\d{1,2}$") && RegExMatch(Trim(saved.fYYYY), "^\d{4}$")
                    e["date"] := BuildDateStr(saved)
            case "location":
                if Trim(saved.fGPS) != ""
                    e["gps"] := saved.fGPS
                if Trim(saved.fCity) != "" && Trim(saved.fCity) != "-"
                    e["city"] := saved.fCity
                if Trim(saved.fState) != "" && Trim(saved.fState) != "-"
                    e["state"] := saved.fState
                if Trim(saved.fCountry) != "" && Trim(saved.fCountry) != "-"
                    e["country"] := saved.fCountry
            case "rotation":
                e["orientation"] := NormalizeOrientationValue(saved.fOrientation)
            case "custom":
                if saved.fTag35
                    e["tag35"] := "1"
                else if e.Has("tag35")
                    e.Delete("tag35")
                if Trim(saved.fCustomTag) != ""
                    e["custom"] := saved.fCustomTag
                else if e.Has("custom")
                    e.Delete("custom")
        }
        g_files[row].status := "Staged"
        RefreshRow(row)
        count++
        row := g_lv.GetNext(row, "C")
    }
    if count = 0 {
        g_status.SetText("  No checked files.")
        return
    }
    label := section = "hardware" ? "hardware / emulsion" : section = "temporal" ? "temporal data" : section = "location" ? "GPS / location" : section = "custom" ? "custom tag" : "rotation"
    g_status.SetText("  Staged " . label . " for " . count . " file(s).")
}

SaveHardwareSection(*) {
    StageSection("hardware")
}

SaveTemporalSection(*) {
    StageSection("temporal")
    ResortLoadedFiles()
}

SaveLocationSection(*) {
    StageSection("location")
}

SaveRotationSection(*) {
    StageSection("rotation")
}

SaveCustomSection(*) {
    StageSection("custom")
}

ClearStaged(*) {
    global
    row := g_lv.GetNext(0, "C")
    while row > 0 {
        g_files[row].exif := Map()
        src := LoadExifForRow(row)
        g_files[row].status := "Pending"
        RefreshRow(row)
        row := g_lv.GetNext(row, "C")
    }
    g_status.SetText("  Staged data cleared.")
}

; ============================================================
;  PREVIEW
; ============================================================
OnSelect(ctrl, rowNum, *) {
    global g_files, g_selectedRow
    if rowNum < 1 || rowNum > g_files.Length
        return
    g_selectedRow := rowNum
    ShowPreview(g_files[rowNum].path, rowNum)
    ShowStagedForRow(rowNum)
}

OnLVClick(ctrl, rowNum, *) {
    global g_files, g_selectedRow
    if rowNum < 1 || rowNum > g_files.Length
        return
    g_selectedRow := rowNum
    ShowPreview(g_files[rowNum].path, rowNum)
    ShowStagedForRow(rowNum)
}


ShowStagedForRow(rowNum) {
    global
    if rowNum < 1 || rowNum > g_files.Length
        return

    src := GetMergedDataForRow(rowNum)
    LoadPanelFromData(src)

    stagedCount := g_files[rowNum].exif.Count
    if stagedCount > 0
        g_status.SetText("  Showing selected file with staged values applied over existing EXIF.")
    else
        g_status.SetText("  Showing existing EXIF from selected file.")
}

GetMergedDataForRow(rowNum) {
    global
    rowFile := g_files[rowNum]
    src     := LoadExifForRow(rowNum)
    e       := rowFile.exif

    for k, v in e
        src[k] := v

    return src
}

LoadExifForRow(rowNum) {
    global
    rowFile := g_files[rowNum]
    if IsObject(rowFile.sourceExif)
        return rowFile.sourceExif

    src := ReadExifData(rowFile.path)
    g_files[rowNum].sourceExif := src

    ; also populate the list columns from real file EXIF when no staged override exists
    RefreshRow(rowNum)

    return src
}

ReadExifData(path) {
    src := Map(
        "camera", "",
        "lens", "",
        "iso", "",
        "film", "",
        "date", "",
        "gps", "",
        "city", "",
        "state", "",
        "country", "",
        "code", "",
        "orientation", 1,
        "custom", ""
    )

    raw := ""
    err := ""
    tags := '-T -Model -LensModel -ISO -DateTimeOriginal -CreateDate -UserComment -Keywords -GPSLatitude# -GPSLongitude# -XMP:LocationShownCity -City -XMP:LocationShownProvinceState -State -XMP:LocationShownCountryName -Country -XMP:LocationShownCountryCode -CountryCode -Orientation# ' . ExifArg(path)

    try {
        RunExifTool(tags, &raw, &err)
        raw := Trim(raw, "`r`n`t ")
    } catch {
        raw := ""
    }

    if raw != "" {
        cols := StrSplit(raw, "`t")
        while cols.Length < 18
            cols.Push("")

        model        := Trim(cols[1])
        lens         := Trim(cols[2])
        iso          := Trim(cols[3])
        dateOriginal := Trim(cols[4])
        createDate   := Trim(cols[5])
        userComment  := Trim(cols[6])
        keywords     := Trim(cols[7])
        gpsLat       := Trim(cols[8])
        gpsLon       := Trim(cols[9])
        xCity        := Trim(cols[10])
        city         := Trim(cols[11])
        xState       := Trim(cols[12])
        state        := Trim(cols[13])
        xCountry     := Trim(cols[14])
        country      := Trim(cols[15])
        xCode        := Trim(cols[16])
        code         := Trim(cols[17])
        orientation  := Trim(cols[18])

        src["camera"]  := model
        src["lens"]    := lens
        src["iso"]     := iso
        src["date"]    := (dateOriginal != "" ? dateOriginal : createDate)
        src["city"]    := (xCity != "" ? xCity : city)
        src["state"]   := (xState != "" ? xState : state)
        src["country"] := (xCountry != "" ? xCountry : country)
        src["code"]    := (xCode != "" ? xCode : code)
        src["orientation"] := IsNumber(orientation) ? orientation + 0 : 1

        if gpsLat != "" && gpsLon != ""
            src["gps"] := gpsLat . ", " . gpsLon

        film := ExtractFilmName(userComment, keywords)
        src["film"] := film
    }

    return src
}

ExtractFilmName(userComment, keywords) {
    candidates := []

    uc := Trim(userComment)
    kw := Trim(keywords)

    if uc != "" {
        if RegExMatch(uc, "i)\|\s*(.+)$", &m)
            candidates.Push(Trim(m[1]))
        candidates.Push(uc)
        ucSplit := RegExReplace(uc, "[|;/]", ",")
        for _, part in StrSplit(ucSplit, ",") {
            part := Trim(part)
            if part != ""
                candidates.Push(part)
        }
    }

    if kw != "" {
        kwSplit := RegExReplace(kw, "[|;/]", ",")
        for _, part in StrSplit(kwSplit, ",") {
            part := Trim(part)
            if part != ""
                candidates.Push(part)
        }
        candidates.Push(kw)
    }

    for _, candidate in candidates {
        candidate := Trim(candidate)
        if candidate = ""
            continue
        canonical := CanonicalFilmName(candidate)
        if canonical != ""
            return canonical
    }

    for _, candidate in candidates {
        candidate := Trim(candidate)
        if candidate != "" && NormalizeFilmName(candidate) != ""
            return candidate
    }

    return ""
}

OnFilmChanged(*) {
    global g_Gui, g_filmIsoMap

    saved := g_Gui.Submit(false)
    film := ResolveFilm(saved)
    canonicalFilm := CanonicalFilmName(film)
    if canonicalFilm != "" && g_filmIsoMap.Has(canonicalFilm)
        g_Gui["fISO"].Value := g_filmIsoMap[canonicalFilm]

    UpdatePreviewName()
}

OnCameraChanged(*) {
    UpdatePreviewName()
}

LoadPanelFromData(src) {
    global
    camera := src.Has("camera") ? src["camera"] : ""
    SetCameraControl(camera)

    if src.Has("lens")
        g_Gui["fLens"].Text := src["lens"]
    else
        g_Gui["fLens"].Text := ""

    if src.Has("iso")
        g_Gui["fISO"].Value := src["iso"]
    else
        g_Gui["fISO"].Value := ""

    film := src.Has("film") ? src["film"] : ""
    SetFilmControl(film)
    if g_Gui["fISO"].Value = "" {
        knownFilm := CanonicalFilmName(film)
        if knownFilm != "" && g_filmIsoMap.Has(knownFilm)
            g_Gui["fISO"].Value := g_filmIsoMap[knownFilm]
    }

    dateVal := src.Has("date") ? src["date"] : ""
    if dateVal != "" && RegExMatch(dateVal, "^(\d{4}):(\d{2}):(\d{2})", &m) {
        g_Gui["fYYYY"].Value := m[1]
        g_Gui["fMM"].Value   := m[2]
        g_Gui["fDD"].Value   := m[3]
    } else {
        g_Gui["fYYYY"].Value := ""
        g_Gui["fMM"].Value   := ""
        g_Gui["fDD"].Value   := ""
    }

    g_Gui["fOrientation"].Value := FormatRotation(src.Has("orientation") ? src["orientation"] : 1)
    g_Gui["fGPS"].Value     := src.Has("gps") ? src["gps"] : ""
    g_Gui["fCity"].Value    := src.Has("city") ? src["city"] : ""
    g_Gui["fState"].Value   := src.Has("state") ? src["state"] : ""
    g_Gui["fCountry"].Value := src.Has("country") ? src["country"] : ""
    g_Gui["fCustomTag"].Value := src.Has("custom") ? src["custom"] : ""
    g_Gui["fTag35"].Value := src.Has("tag35") ? 1 : 0

    UpdatePreviewName()
}

SetCameraControl(camera) {
    global g_Gui
    canonicalCamera := CanonicalCameraName(camera)
    if canonicalCamera != ""
        camera := canonicalCamera
    g_Gui["fCamera"].Text := Trim(camera)
}

SetFilmControl(film) {
    global g_Gui
    canonicalFilm := CanonicalFilmName(film)
    if canonicalFilm != ""
        film := canonicalFilm
    g_Gui["fFilm"].Text := Trim(film)
}

CanonicalCameraName(camera) {
    global g_cameraNames
    raw := Trim(camera)
    if raw = ""
        return ""

    norm := NormalizeCameraName(raw)
    if norm = ""
        return ""

    aliasMap := Map(
        "canonae1", "Canon AE-1",
        "canonae1program", "Canon AE-1",
        "canona1", "Canon A-1",
        "canonae1program", "Canon AE-1 Program",
        "canonav1", "Canon AV-1",
        "canonftb", "Canon FTb",
        "canonaf35ml", "Canon AF35-ML",
        "af35ml", "Canon AF35-ML",
        "olympusmjuii", "Olympus Mju II",
        "olympusmju2", "Olympus Mju II",
        "olympusom1", "Olympus OM-1",
        "olympusom2", "Olympus OM-2",
        "olympusxa", "Olympus XA",
        "olympustrip35", "Olympus Trip 35",
        "nikonfm", "Nikon FM",
        "nikonfm2", "Nikon FM2",
        "nikonfe", "Nikon FE",
        "nikonfe2", "Nikon FE2",
        "nikonf3", "Nikon F3",
        "pentaxk1000", "Pentax K1000",
        "pentaxmx", "Pentax MX",
        "pentaxmesuper", "Pentax ME Super",
        "pentaxspotmaticsp", "Pentax Spotmatic SP",
        "minoltax700", "Minolta X-700",
        "minoltaxd7", "Minolta XD-7",
        "contaxt2", "Contax T2",
        "ricohgr1", "Ricoh GR1",
        "pentax17", "Pentax 17",
        "mjuii", "Olympus Mju II",
        "mju2", "Olympus Mju II"
    )
    if aliasMap.Has(norm)
        return aliasMap[norm]

    for _, knownName in g_cameraNames {
        if NormalizeCameraName(knownName) = norm
            return knownName
    }
    return ""
}

NormalizeCameraName(value) {
    value := StrLower(Trim(value))
    value := RegExReplace(value, "i)program", "")
    value := RegExReplace(value, "[^a-z0-9]+")
    return value
}

CanonicalFilmName(film) {
    global g_filmNames, g_filmMap
    raw := Trim(film)
    if raw = ""
        return ""

    norm := NormalizeFilmName(raw)
    if norm = ""
        return ""

    aliasMap := Map(
        "kodakcolorplus200", "Kodak ColorPlus 200",
        "colorplus200", "Kodak ColorPlus 200",
        "kodakgold200", "Kodak Gold 200",
        "gold200", "Kodak Gold 200",
        "kodakultramax400", "Kodak UltraMax 400",
        "kodakultramax", "Kodak UltraMax 400",
        "ultramax400", "Kodak UltraMax 400",
        "ultramax", "Kodak UltraMax 400",
        "kodakproimage100", "Kodak ProImage 100",
        "proimage100", "Kodak ProImage 100",
        "kodakektar100", "Kodak Ektar 100",
        "ektar100", "Kodak Ektar 100",
        "kodakportra160", "Kodak Portra 160",
        "portra160", "Kodak Portra 160",
        "kodakportra400", "Kodak Portra 400",
        "portra400", "Kodak Portra 400",
        "kodakportra800", "Kodak Portra 800",
        "portra800", "Kodak Portra 800",
        "fujic200", "Fuji C200",
        "c200", "Fuji C200",
        "fujisuperia200", "Fuji Superia 200",
        "superia200", "Fuji Superia 200",
        "fujisuperia400", "Fuji Superia 400",
        "superia400", "Fuji Superia 400",
        "fujisuperiaxtra400", "Fuji Superia X-TRA 400",
        "superiaxtra400", "Fuji Superia X-TRA 400",
        "superiaxtra", "Fuji Superia X-TRA 400",
        "fujipro400h", "Fuji Pro 400H",
        "pro400h", "Fuji Pro 400H",
        "ilfordhp5plus400", "Ilford HP5 Plus 400",
        "hp5plus400", "Ilford HP5 Plus 400",
        "hp5400", "Ilford HP5 Plus 400",
        "ilforddelta400", "Ilford Delta 400",
        "delta400", "Ilford Delta 400",
        "ilfordfp4plus125", "Ilford FP4 Plus 125",
        "fp4plus125", "Ilford FP4 Plus 125",
        "kodaktmax100", "Kodak T-Max 100",
        "tmax100", "Kodak T-Max 100",
        "kodaktmax400", "Kodak T-Max 400",
        "tmax400", "Kodak T-Max 400",
        "lomographycolor100", "Lomography Color 100",
        "lomographycolor400", "Lomography Color 400"
    )
    if aliasMap.Has(norm)
        return aliasMap[norm]

    for _, knownName in g_filmNames {
        if NormalizeFilmName(knownName) = norm
            return knownName
    }
    return ""
}


NormalizeFilmName(value) {
    value := StrLower(Trim(value))
    value := RegExReplace(value, "i)35mm\s*film", "")
    value := RegExReplace(value, "i)film\s*scan", "")
    value := RegExReplace(value, "i)kodak\s+ultra\s*max", "kodak ultramax")
    value := RegExReplace(value, "i)ultra\s*max", "ultramax")
    value := RegExReplace(value, "i)t\s*[- ]?max", "tmax")
    value := RegExReplace(value, "i)x\s*[- ]?tra", "xtra")
    value := RegExReplace(value, "[^a-z0-9]+")
    return value
}

NormalizeOrientationValue(value) {
    value := Trim(value)
    switch value {
        case "0°", "1": return 1
        case "180°", "3": return 3
        case "90° CW", "6": return 6
        case "90° CCW", "8": return 8
        default:
            if IsNumber(value)
                return value + 0
            return 1
    }
}

RotateOrientation(current, direction) {
    mapRight := Map(1, 6, 6, 3, 3, 8, 8, 1)
    mapLeft := Map(1, 8, 8, 3, 3, 6, 6, 1)
    current := NormalizeOrientationValue(current)
    return direction = "R" ? mapRight[current] : mapLeft[current]
}

GetSelectedRow() {
    global g_lv
    row := g_lv.GetNext(0, "F")
    if row < 1
        row := g_lv.GetNext(0, "C")
    return row
}

RotateLeft(*) {
    global g_Gui, g_files
    row := GetSelectedRow()
    g_Gui["fOrientation"].Value := FormatRotation(RotateOrientation(g_Gui["fOrientation"].Value, "L"))
    if row > 0
        ShowPreview(g_files[row].path, row)
}

RotateRight(*) {
    global g_Gui, g_files
    row := GetSelectedRow()
    g_Gui["fOrientation"].Value := FormatRotation(RotateOrientation(g_Gui["fOrientation"].Value, "R"))
    if row > 0
        ShowPreview(g_files[row].path, row)
}

RotateReset(*) {
    global g_Gui, g_files
    row := GetSelectedRow()
    orient := 1
    if row > 0 {
        src := LoadExifForRow(row)
        orient := src.Has("orientation") ? src["orientation"] : 1
    }
    g_Gui["fOrientation"].Value := FormatRotation(orient)
    if row > 0
        ShowPreview(g_files[row].path, row)
}

GetEffectiveOrientationForRow(rowNum) {
    global g_Gui, g_files, g_selectedRow
    if rowNum > 0 && rowNum <= g_files.Length {
        if rowNum = g_selectedRow
            return NormalizeOrientationValue(g_Gui["fOrientation"].Value)
        if g_files[rowNum].exif.Has("orientation")
            return NormalizeOrientationValue(g_files[rowNum].exif["orientation"])
        if IsObject(g_files[rowNum].sourceExif) && g_files[rowNum].sourceExif.Has("orientation")
            return NormalizeOrientationValue(g_files[rowNum].sourceExif["orientation"])
    }
    return NormalizeOrientationValue(g_Gui["fOrientation"].Value)
}

GetImageDimensions(path, &imgW, &imgH) {
    imgW := 0
    imgH := 0
    pBitmap := 0
    
    ; Load the image via GDI+ DllCall since we need dimensions
    if DllCall("gdiplus\GdipCreateBitmapFromFile", "Str", path, "Ptr*", &pBitmap) != 0
        return false
        
    DllCall("gdiplus\GdipGetImageWidth", "Ptr", pBitmap, "UInt*", &imgW)
    DllCall("gdiplus\GdipGetImageHeight", "Ptr", pBitmap, "UInt*", &imgH)
    DllCall("gdiplus\GdipDisposeImage", "Ptr", pBitmap)
    
    return (imgW > 0 && imgH > 0)
}

ShowPreview(path, rowNum := 0) {
    global g_preview, g_status, g_previewFrameX, g_previewFrameY, g_previewFrameW, g_previewFrameH

    if !FileExist(path)
        return

    try {
        pBitmap := 0
        if DllCall("gdiplus\GdipCreateBitmapFromFile", "Str", path, "Ptr*", &pBitmap) != 0 || !pBitmap {
            g_preview.Value := ""
            g_status.SetText("  Preview failed to load.")
            return
        }

        orient := GetEffectiveOrientationForRow(rowNum)
        if (orient = 3)
            DllCall("gdiplus\GdipImageRotateFlip", "Ptr", pBitmap, "Int", 2)
        else if (orient = 6)
            DllCall("gdiplus\GdipImageRotateFlip", "Ptr", pBitmap, "Int", 1)
        else if (orient = 8)
            DllCall("gdiplus\GdipImageRotateFlip", "Ptr", pBitmap, "Int", 3)

        imgW := 0, imgH := 0
        DllCall("gdiplus\GdipGetImageWidth", "Ptr", pBitmap, "UInt*", &imgW)
        DllCall("gdiplus\GdipGetImageHeight", "Ptr", pBitmap, "UInt*", &imgH)

        scaleW := g_previewFrameW / imgW
        scaleH := g_previewFrameH / imgH
        scale  := (scaleW < scaleH) ? scaleW : scaleH
        drawW := Round(imgW * scale)
        drawH := Round(imgH * scale)
        posX  := g_previewFrameX + (g_previewFrameW - drawW) // 2
        posY  := g_previewFrameY + (g_previewFrameH - drawH) // 2

        hBitmap := 0
        DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "Ptr*", &hBitmap, "Int", 0)

        g_preview.Visible := false
        g_preview.Move(posX, posY, drawW, drawH)
        g_preview.Value := "HBITMAP:" . hBitmap
        g_preview.Visible := true
        DllCall("gdiplus\GdipDisposeImage", "Ptr", pBitmap)
    } catch {
        g_preview.Value := ""
        g_status.SetText("  Preview failed to load.")
    }
}

; ============================================================
;  REAL-TIME NAME PREVIEW
; ============================================================
UpdatePreviewName(*) {
    global
    saved := g_Gui.Submit(false)
    if !saved.fRename {
        g_lblName.Value := "(rename disabled)"
        return
    }

    film := ResolveFilm(saved)
    if film = ""
        film := "FILM"

    camera := ResolveCamera(saved)
    if camera = ""
        camera := "CAM"

    dd := Format("{:02d}", ((saved.fDD = "" ? 1 : saved.fDD) + 0))
    mm := Format("{:02d}", ((saved.fMM = "" ? 1 : saved.fMM) + 0))
    yyyy := (saved.fYYYY = "" ? FormatTime(, "yyyy") : saved.fYYYY)
    ymd := yyyy . mm . dd

    core := ymd . "_" . CameraInitials(camera) . "_" . FilmInitials(film) . "_NNN"
    pre  := Trim(saved.fPrefix)
    suf  := Trim(saved.fSuffix)

    g_lblName.Value := (pre != "" ? pre . "_" : "") . core . (suf != "" ? "_" . suf : "") . ".jpg"
}

; ============================================================
;  GPS
; ============================================================
ParseGPS(*) {
    saved := g_Gui.Submit(false)
    raw   := Trim(saved.fGPS)
    if raw = "" {
        MsgBox("Paste GPS coordinates first.", "GPS", 48)
        return
    }
    g := DecimalGPS(raw)
    if g {
        MsgBox("Parsed OK!`n`nLat: " . g.lat . "° " . g.latRef
             . "`nLon: " . g.lon . "° " . g.lonRef
             . "`n`nVerify: https://maps.google.com/?q=" . g.lat . "," . g.lon,
             "GPS Verified", 64)
    } else {
        MsgBox("Could not parse.`n`nExpected:  34.9675, 135.7737`n`n"
             . "In Google Maps: right-click → first line = decimal coords.",
             "GPS Error", 48)
    }
}

DecimalGPS(raw) {
    raw := Trim(raw)
    if raw ~= "^-?\d+\.?\d*\s*,\s*-?\d+\.?\d*$" {
        parts := StrSplit(raw, ",")
        lat   := Trim(parts[1]) + 0
        lon   := Trim(parts[2]) + 0
        return {lat: Abs(lat), lon: Abs(lon),
                latRef: (lat >= 0 ? "N" : "S"),
                lonRef: (lon >= 0 ? "E" : "W")}
    }
    return false
}

; ============================================================
;  NAMING HELPERS
; ============================================================
AbbreviateCode(value, fallback := "CODE") {
    clean := RegExReplace(Trim(value), "[^A-Za-z0-9]+", " ")
    clean := Trim(clean)
    if clean = ""
        return fallback

    parts := StrSplit(clean, A_Space)
    code := ""

    for _, p in parts {
        if p = ""
            continue

        upper := StrUpper(p)

        if RegExMatch(upper, "^\d+$") {
            code .= upper
            continue
        }

        if RegExMatch(upper, "^[A-Z]+\d+[A-Z0-9]*$") || RegExMatch(upper, "^\d+[A-Z]+[A-Z0-9]*$") {
            code .= upper
            continue
        }

        if StrLen(upper) <= 3
            code .= upper
        else
            code .= SubStr(upper, 1, 1)
    }

    code := RegExReplace(code, "[^A-Z0-9]")
    if code = ""
        code := RegExReplace(StrUpper(value), "[^A-Z0-9]")
    if code = ""
        code := fallback
    return SubStr(code, 1, 16)
}

FilmInitials(film) {
    global g_filmMap

    canonicalFilm := CanonicalFilmName(film)
    if canonicalFilm != "" && g_filmMap.Has(canonicalFilm)
        return g_filmMap[canonicalFilm]

    return AbbreviateCode(film, "FILM")
}

CameraInitials(model) {
    global g_cameraMap

    canonicalCamera := CanonicalCameraName(model)
    if canonicalCamera != "" && g_cameraMap.Has(canonicalCamera)
        return g_cameraMap[canonicalCamera]

    return AbbreviateCode(model, "CAM")
}

BuildFileDate(dateStr) {
    if RegExMatch(dateStr, "^(\d{4}):(\d{2}):(\d{2})", &m)
        return m[1] . m[2] . m[3]
    return FormatTime(, "yyyyMMdd")
}

BuildNewName(path, model, film, dateStr, counter, prefix, suffix) {
    MySplitPath(path, , , &ext)
    ymd  := BuildFileDate(dateStr)
    pad  := Format("{:03d}", counter)
    core := ymd . "_" . CameraInitials(model) . "_" . FilmInitials(film) . "_" . pad
    pre  := Trim(prefix)
    suf  := Trim(suffix)
    return (pre != "" ? pre . "_" : "") . core . (suf != "" ? "_" . suf : "") . "." . ext
}

ResolveCamera(saved) {
    camera := Trim(saved.fCamera)
    canonicalCamera := CanonicalCameraName(camera)
    return (canonicalCamera != "" ? canonicalCamera : camera)
}

ResolveFilm(saved) {
    film := Trim(saved.fFilm)
    canonicalFilm := CanonicalFilmName(film)
    return (canonicalFilm != "" ? canonicalFilm : film)
}

GetMake(model) {
    static brands := ["Canon","Nikon","Pentax","Minolta","Olympus",
                      "Contax","Leica","Fuji","Voigtlander","Rollei"]
    for b in brands {
        if InStr(model, b)
            return (b = "Fuji" ? "Fujifilm" : b)
    }
    return StrSplit(model, " ")[1]
}

; ============================================================
;  WRITE ALL CHECKED
; ============================================================
ShowWriteConfirm(stagedRows, panelSaved, doRename := true) {
    if stagedRows.Length = 0
        return false

    confirmGui := Gui("+Owner" g_Gui.Hwnd " +ToolWindow", "Review staged changes")
    confirmGui.BackColor := "F3F3F3"
    confirmGui.SetFont("s9 c111111", "Segoe UI")
    confirmGui.Add("Text", "x16 y14 w760 c111111", "Review the staged rows below before writing.")
    lv := confirmGui.Add("ListView", "x16 y40 w760 h360", ["#", "Current file", "New file", "Write"])
    lv.ModifyCol(1, 40)
    lv.ModifyCol(2, 220)
    lv.ModifyCol(3, 250)
    lv.ModifyCol(4, 230)

    for _, row in stagedRows {
        rowItem := g_files[row]
        path := rowItem.path
        eff := GetMergedDataForRow(row)
        MySplitPath(path, &oldName)
        newName := oldName
        if doRename {
            cam  := eff.Has("camera") ? eff["camera"] : ResolveCamera(panelSaved)
            film := eff.Has("film")   ? eff["film"]   : ResolveFilm(panelSaved)
            date := eff.Has("date")   ? eff["date"]   : BuildDateStr(panelSaved)
            newName := BuildNewName(path, cam, film, date, row, panelSaved.fPrefix, panelSaved.fSuffix)
            MySplitPath(path, , &dir)
            if StrLower(dir . "\" . newName) != StrLower(path) && FileExist(dir . "\" . newName)
                newName .= "  [conflict]"
        }
        writeParts := []
        for key, _ in rowItem.exif
            writeParts.Push(key)
        lv.Add("", Format("{:03d}", row), oldName, newName, JoinArray(writeParts, ", "))
    }

    result := false
    okBtn := confirmGui.Add("Button", "x396 y414 w180 h32 Default", "WRITE")
    backBtn := confirmGui.Add("Button", "x596 y414 w180 h32", "GO BACK")
    okBtn.OnEvent("Click", (*) => (result := true, confirmGui.Destroy()))
    backBtn.OnEvent("Click", (*) => (result := false, confirmGui.Destroy()))
    confirmGui.OnEvent("Close", (*) => (result := false))
    confirmGui.Show("w792 h460 Center")
    WinWaitClose(confirmGui.Hwnd)
    return result
}

ApplyExif(*) {
    global
    panelSaved := g_Gui.Submit(false)

    ResortLoadedFiles()

    stagedRows := []
    for row, rowItem in g_files {
        hasRealStage := false
        for k, v in rowItem.exif {
            if k != "orientation" || NormalizeOrientationValue(v) != 1 {
                hasRealStage := true
                break
            }
        }
        if hasRealStage
            stagedRows.Push(row)
    }

    if stagedRows.Length = 0 {
        MsgBox("No staged changes found!", "Apply", 48)
        return
    }

    doRename := panelSaved.fRename
    if !ShowWriteConfirm(stagedRows, panelSaved, doRename)
        return

    total := stagedRows.Length
    done := 0
    if g_progress
        g_progress.Value := 0

    for row in stagedRows {
        path := g_files[row].path
        MySplitPath(path, , &dir)
        eff := GetMergedDataForRow(row)
        staged := g_files[row].exif

        cam     := eff.Has("camera")  ? eff["camera"]  : ""
        lens    := eff.Has("lens")    ? eff["lens"]    : ""
        iso     := eff.Has("iso")     ? eff["iso"]     : ""
        film    := eff.Has("film")    ? eff["film"]    : ""
        date    := eff.Has("date")    ? eff["date"]    : ""
        gps     := eff.Has("gps")     ? eff["gps"]     : ""
        city    := eff.Has("city")    ? eff["city"]    : ""
        state   := eff.Has("state")   ? eff["state"]   : ""
        country := eff.Has("country") ? eff["country"] : ""
        custom  := eff.Has("custom")  ? eff["custom"]  : ""
        tag35   := eff.Has("tag35")   ? eff["tag35"]   : ""

        hasStagedLocation := staged.Has("city") || staged.Has("state") || staged.Has("country")
        shouldWriteCamera   := staged.Has("camera")
        shouldWriteLens     := staged.Has("lens")
        shouldWriteISO      := staged.Has("iso")
        shouldWriteFilm     := staged.Has("film")
        shouldWriteDate     := staged.Has("date")
        shouldWriteGPS      := staged.Has("gps")
        shouldWriteLocation := hasStagedLocation
        shouldWriteRotation := staged.Has("orientation")
        shouldWriteCustom   := staged.Has("custom") || staged.Has("tag35")

        args := " -overwrite_original"
        if shouldWriteCamera && cam != "" {
            args .= " -Make=" . ExifArg(GetMake(cam))
            args .= " -Model=" . ExifArg(cam)
        }
        if shouldWriteLens && lens != ""
            args .= " -LensModel=" . ExifArg(lens)
        if shouldWriteISO && iso != ""
            args .= " -ISO=" . iso
        if shouldWriteDate && date != "" {
            args .= " -DateTimeOriginal=" . ExifArg(date)
            args .= " -CreateDate=" . ExifArg(date)
        }
        if shouldWriteFilm && film != "" {
            args .= " -UserComment=" . ExifArg(((tag35 != "") ? "35mm film scan | " : "") . film)
            args .= " -Keywords=" . ExifArg(film)
            if tag35 != ""
                args .= " -Keywords=" . ExifArg("35mm film scan")
        }
        if shouldWriteCustom {
            if tag35 != "" {
                args .= " -Keywords=" . ExifArg("35mm film scan")
                args .= " -Subject=" . ExifArg("35mm film scan")
                if !(shouldWriteFilm && film != "") && Trim(custom) = ""
                    args .= " -UserComment=" . ExifArg("35mm film scan")
            }
            if Trim(custom) != "" {
                args .= " -Keywords=" . ExifArg(custom)
                args .= " -Subject=" . ExifArg(custom)
                if !(shouldWriteFilm && film != "")
                    args .= " -UserComment=" . ExifArg(custom)
            }
        }
        if shouldWriteGPS {
            g := DecimalGPS(gps)
            if g {
                args .= " -GPSLatitude=" . g.lat
                args .= " -GPSLatitudeRef=" . g.latRef
                args .= " -GPSLongitude=" . g.lon
                args .= " -GPSLongitudeRef=" . g.lonRef
            }
        }
        if shouldWriteLocation {
            if staged.Has("city") && Trim(city) != "" {
                args .= " -XMP:LocationShownCity=" . ExifArg(city)
                args .= " -City=" . ExifArg(city)
            }
            if staged.Has("state") && Trim(state) != "" {
                args .= " -XMP:LocationShownProvinceState=" . ExifArg(state)
                args .= " -State=" . ExifArg(state)
            }
            if staged.Has("country") && Trim(country) != "" {
                args .= " -XMP:LocationShownCountryName=" . ExifArg(country)
                args .= " -Country=" . ExifArg(country)
            }
        }
        if shouldWriteRotation
            args .= " -Orientation#=" . NormalizeOrientationValue(staged["orientation"])

        didWrite := (args != " -overwrite_original")
        result := 0
        resultStdOut := ""
        resultStdErr := ""
        if didWrite {
            args .= " " . ExifArg(path)
            result := RunExifTool(args, &resultStdOut, &resultStdErr)
        }

        if doRename {
            renameCam  := cam != "" ? cam : ResolveCamera(panelSaved)
            renameFilm := film != "" ? film : ResolveFilm(panelSaved)
            renameDate := date != "" ? date : BuildDateStr(panelSaved)
            newName := BuildNewName(path, renameCam, renameFilm, renameDate, row, panelSaved.fPrefix, panelSaved.fSuffix)
            newPath := dir . "\" . newName
            if StrLower(newPath) != StrLower(path) && FileExist(newPath) {
                g_files[row].status := "Rename conflict"
            } else {
                try {
                    FileMove(path, newPath)
                    g_files[row].path := newPath
                } catch {
                    g_files[row].status := "Rename failed"
                }
            }
        }

        txt := didWrite ? ((result = 0) ? "Done" : "Err " . result) : (doRename ? "Renamed" : "Skipped")
        if didWrite && result != 0 && Trim(resultStdErr) != ""
            txt .= ": " . SubStr(StrReplace(StrReplace(Trim(resultStdErr), "`r", " "), "`n", " | "), 1, 180)
        g_files[row].status := txt
        if result = 0 && didWrite {
            g_files[row].sourceExif := eff
            g_files[row].exif := Map()
        }
        RefreshRow(row)
        done++
        pct := Round((done / total) * 100)
        if g_progress
            g_progress.Value := pct
        g_status.SetText("  Writing staged changes... " . done . "/" . total)
    }

    g_status.SetText("  Done — " . done . " staged file(s) processed.")
    MsgBox(done . " staged file(s) processed successfully!", "EXIF Tagger", 64)
}

; ============================================================
;  UTILITY
; ============================================================
MySplitPath(path, &name := "", &dir := "", &ext := "", &nameNoExt := "") {
    name      := RegExReplace(path, ".*[\\/]")
    dir       := RegExReplace(path, "[\\/][^\\/]*$")
    ext       := RegExMatch(path, "\.([^.]+)$", &m) ? m[1] : ""
    nameNoExt := RegExReplace(name, "\.[^.]+$")
    return name
}

GetOriginalDate(filePath) {
    exifDate := GetExifDateOriginal(filePath)
    if (exifDate != "")
        return exifDate

    ts := ""
    try ts := FileGetTime(filePath, "M")
    if (ts != "")
        return SubStr(ts, 1, 8) ; YYYYMMDD

    return "00000000"
}

GetExifDateOriginal(filePath) {
    output := ""
    err := ""
    args := '-s3 -DateTimeOriginal -d "%Y%m%d" ' . ExifArg(filePath)

    try {
        RunExifTool(args, &output, &err)
        output := Trim(output)
    } catch {
        output := ""
    }

    if RegExMatch(output, "^\d{8}$")
        return output

    return ""
}
