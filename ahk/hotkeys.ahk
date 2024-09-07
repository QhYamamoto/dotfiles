#Include "./utils.ahk"

; Reload this script: <C-M-r>
^!r:: Reload()

; Edit this script: <C-M-e>
^!e:: Edit()

; Shutdown host machine: <Win-Esc>
#Esc:: Shutdown(1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Hot keys for switching wallpaper
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DefaultWallpaperPath := ""
WallpaperPaths := []
WallPaperEnvKey := "WALLPAPER_INDEX"

; Get WALLPAPER_INDEX value
WallpaperIndex := GetSystemEnv(WallPaperEnvKey)

; If it's not set, initialize by 0
if (WallpaperIndex = "") {
  SetSystemEnv(WallPaperEnvKey, 0)
  WallpaperIndex := 0
}

For ext in ["jpg", "jpeg", "png", "bmp", "tiff"] {
  Dir := A_WorkingDir . "\..\wallpapers\*." . ext
  Loop Files, Dir, "FR"  ; Recurse into subfolders.
  {
    ; Remove file extension.
    FileNameWithoutExt := RegExReplace(A_LoopFileName, "\.[^.]*$")
    if (FileNameWithoutExt = "default") {
      ; Assign default file path to `DefaultWallpaperPath`
      DefaultWallpaperPath := A_LoopFileFullPath
      continue
    }

    ; Push other file paths to `WallpaperPaths`
    WallpaperPaths.Push(A_LoopFileFullPath)
  }
}


/**
 * Set the image file at the path specified by the argument as the system wallpaper.
 * @param {String} WallpaperPath
 */
SetWallpaper(WallpaperPath) {
  SPIF_UPDATEINIFILE := 0x0001
  SPI_SETDESKWALLPAPER := 0x0014
  DllCall("SystemParametersInfo", "UInt", SPI_SETDESKWALLPAPER, "UInt", 0, "Str", wallpaperPath, "UInt", SPIF_UPDATEINIFILE)
}

; Set wallpaper to default: <C-M-d>
^!d:: {
  if DefaultWallpaperPath != "" {
    SetWallpaper(DefaultWallpaperPath)
  } else {
    MsgBox("There is no image file for default wallpaper. Place it in the `C:/Users/your-user-name/wallpapers` directory and name it `default.{jpg,jpeg,png,bmp,tiff}`.")
  }
}

MsgNoWallpaperImages := "There are no image files for wallpaper. Place them in the `C:/Users/your-user-name/wallpapers` directory."
; Switch wallpaper: <C-M-s>
^!s:: {
  if WallpaperPaths.Length {
    global WallpaperIndex
    ; Increment the index and loop back to 0 if it exceeds the array length
    WallpaperIndex := Mod(WallpaperIndex + 1, WallpaperPaths.Length)
    SetWallpaper(WallpaperPaths[WallpaperIndex + 1])  ; +1 because array index starts from 1 in ahk
    SetSystemEnv(WallPaperEnvKey, WallpaperIndex)
  } else {
    global MsgNoWallpaperImages
    MsgBox(MsgNoWallpaperImages)
  }
}

; Switch wallpaper (reversed order): <C-M-S>
^!+s::
{
  if WallpaperPaths.Length {
    global WallpaperIndex
    ; Decrement the index and loop back to 0 if it exceeds the array length
    WallpaperIndex := Mod(WallpaperIndex - 1, WallpaperPaths.Length)
    if WallpaperIndex < 0 {
      WallpaperIndex := WallpaperPaths.Length - 1
    }
    SetWallpaper(WallpaperPaths[WallpaperIndex + 1])  ; +1 because array index starts from 1 in ahk
    SetSystemEnv(WallPaperEnvKey, WallpaperIndex)
  } else {
    global MsgNoWallpaperImages
    MsgBox(MsgNoWallpaperImages)
  }
}
