/**
 * Save `Str` to system clipboard **temporarily** and paste it. (So this function doesn't pollute your clipboard.)
 * @param {String} Str
 * @param {Integer} Num
 */
Paste(Str, Num := 0) {
  backup := A_Clipboard
  A_Clipboard := Str
  Send("^v")
  Sleep(100)
  A_Clipboard := backup

  Send("{Left " Num "}")
}
