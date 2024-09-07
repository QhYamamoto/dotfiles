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

ENV_REGISTRY_KEY := "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"

/**
 * Set new value to system environment variable.
 * NOTE: This function requires Administrator's permission.
 * @param {String} EnvKey
 * @param {String} EnvValue
 * @param {String} ValueType
 */
SetSystemEnv(EnvKey, EnvValue, ValueType := "REG_SZ") {
  RegWrite(EnvValue, ValueType, ENV_REGISTRY_KEY, EnvKey)
}

/**
 * Set new value to system environment variable.
 * NOTE: This function requires Administrator's permission.
 * @param {String} EnvKey
 * @returns {String} By default, returns `""`
 */
GetSystemEnv(EnvKey) {
  return RegRead(ENV_REGISTRY_KEY, EnvKey, "")
}
