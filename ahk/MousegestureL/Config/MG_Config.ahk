MG_IniFileVersion=1.40
MG_8Dir=0
MG_ActiveAsTarget=0
MG_Interval=20
MG_AlwaysHook=0
MG_PrvntCtxtMenu=0
MG_Threshold=60
MG_LongThresholdX=800
MG_LongThresholdY=600
MG_LongThreshold=700
MG_TimeoutThreshold=12
MG_Timeout=400
MG_DGInterval=0
MG_TmReleaseTrigger=3
MG_ORangeDefault=3
MG_ORangeA=3
MG_ORangeB=3
MG_EdgeInterval=20
MG_EdgeIndiv=0
MG_CornerX=1
MG_CornerY=1
MG_DisableDefMB=0
MG_DisableDefX1B=0
MG_DisableDefX2B=0
MG_UseNavi=1
MG_UseExNavi=3
MG_NaviInterval=10
MG_NaviPersist=0
MG_ExNaviTransBG=1
MG_ExNaviFG=000000
MG_ExNaviBG=FFFFFF
MG_ExNaviTranspcy=255
MG_ExNaviSize=24
MG_ExNaviSpacing=2
MG_ExNaviPadding=4
MG_ExNaviMargin=8
MG_AdNaviFG=FFFFFF
MG_AdNaviNI=7F7F7F
MG_AdNaviBG=000000
MG_AdNaviTranspcy=220
MG_AdNaviSize=11
MG_AdNaviFont=メイリオ
MG_AdNaviPosition=0
MG_AdNaviPaddingL=6
MG_AdNaviPaddingR=6
MG_AdNaviPaddingT=3
MG_AdNaviPaddingB=3
MG_AdNaviRound=2
MG_AdNaviMargin=14
MG_AdNaviSpaceX=2
MG_AdNaviSpaceY=2
MG_AdNaviOnClick=0
MG_ShowTrail=0
MG_DrawTrailWnd=1
MG_TrailColor=0000FF
MG_TrailTranspcy=255
MG_TrailWidth=3
MG_TrailStartMove=3
MG_TrailInterval=10
MG_ShowLogs=0
MG_LogPosition=4
MG_LogPosX=0
MG_LogPosY=0
MG_LogMax=20
MG_LogSizeW=400
MG_LogInterval=500
MG_LogFG=FFFFFF
MG_LogBG=000000
MG_LogTranspcy=100
MG_LogFontSize=10
MG_LogFont=MS UI Gothic
MG_EditCommand=
MG_HotkeyEnable=
MG_HotkeyNavi=
MG_HotkeyReload=
MG_ScriptEditor=
MG_TraySubmenu=0
MG_AdjustDlg=0
MG_DlgHeightLimit=800
MG_FoldTarget=0
MG_DisableWarning=0
MG_ActvtExclud := []
MG_MaxLength=7
MG_Triggers=RB
MG_SubTriggers=LB


Goto, MG_RB_End

MG_RB_Enable:
	if (!MG_AlwaysHook) {
		MG_RB_HookEnabled := Func("MG_IsHookEnabled_RB")
		Hotkey, If, % MG_RB_HookEnabled
	}
	Hotkey, *RButton, MG_RB_DownHotkey, On
	Hotkey, *RButton up, MG_RB_UpHotkey, On
	Hotkey, If
	MG_RB_Enabled := 1
return

MG_RB_Disable:
	Hotkey, *RButton, MG_RB_DownHotkey, Off
	Hotkey, *RButton up, MG_RB_UpHotkey, Off
	MG_RB_Enabled := 0
return

MG_RB_DownHotkey:
	MG_TriggerDown("RB")
return

MG_RB_UpHotkey:
	MG_TriggerUp("RB")
return

MG_RB_Down:
	MG_SendButton("RB", "RButton", "Down")
return

MG_RB_Up:
	MG_SendButton("RB", "RButton", "Up")
return

MG_RB_Check:
	MG_CheckButton("RB", "RButton")
return

MG_RB_End:


Goto, MG_LB_End

MG_LB_Enable:
	if (!MG_AlwaysHook) {
		MG_LB_HookEnabled := Func("MG_IsHookEnabled_LB")
		Hotkey, If, % MG_LB_HookEnabled
	}
	Hotkey, *LButton, MG_LB_DownHotkey, On
	Hotkey, *LButton up, MG_LB_UpHotkey, On
	Hotkey, If
	MG_LB_Enabled := 1
return

MG_LB_Disable:
	Hotkey, *LButton, MG_LB_DownHotkey, Off
	Hotkey, *LButton up, MG_LB_UpHotkey, Off
	MG_LB_Enabled := 0
return

MG_LB_DownHotkey:
	MG_TriggerDown("LB")
return

MG_LB_UpHotkey:
	MG_TriggerUp("LB")
return

MG_LB_Down:
	MG_SendButton("LB", "LButton", "Down")
return

MG_LB_Up:
	MG_SendButton("LB", "LButton", "Up")
return

MG_LB_Check:
	MG_CheckButton("LB", "LButton")
return

MG_LB_End:


Goto, MG_Config_End


MG_IsDisable() {
	global
	return (0)
}

MG_IsTarget1() {
	global
	return ((MG_Exe="iexplore.exe") || (MG_Exe="msedge.exe") || (MG_Exe="chrome.exe") || (MG_Exe="firefox.exe"))
}

MG_IsTarget2() {
	global
	return ((MG_WClass="CabinetWClass") || (MG_WClass="ExploreWClass") || (MG_WClass="Progman") || (MG_WClass="WorkerW"))
}

MG_IsTarget3() {
	global
	return (MG_IsTarget2() && ((MG_TreeListHitTest())))
}

MG_IsExDefault() {
	return (0)
}

MG_Gesture_RB_:
	if (MG_IsTarget3()) {
		;ジェスチャーキャンセル
		MG_Abort()
	} else if (!MG_IsExDefault()){
		;アクティブ化
		if (MG_WClass != "Chrome_WidgetWin_2") {
			MG_WinActivate()
		}
	}
return

MG_GetAction_RB_:
	if (MG_IsTarget3()) {
		MG_ActionStr := "ジェスチャーキャンセル"
	} else if (!MG_IsExDefault()){
		MG_ActionStr := "アクティブ化"
	}
return

MG_Gesture_RB_LB__:
	if (!MG_IsExDefault()) {
		
	}
return

MG_GetAction_RB_LB__:
	if (!MG_IsExDefault()) {
		
	}
return

MG_Gesture_RB_L_:
	if (!MG_IsExDefault()) {
		;タブ移動(左)
		Send, ^+{Tab}
	}
return

MG_GetAction_RB_L_:
	if (!MG_IsExDefault()) {
		MG_ActionStr := "タブ移動(左)"
	}
return

MG_Gesture_RB_R_:
	if (!MG_IsExDefault()) {
		;タブ移動(右)
		Send, ^{Tab}
	}
return

MG_GetAction_RB_R_:
	if (!MG_IsExDefault()) {
		MG_ActionStr := "タブ移動(右)"
	}
return

MG_Gesture_RB_U_:
	if (!MG_IsExDefault()) {
		;直前のアクティブウィンドウを復元
		MG_ActivatePrevWin()
	}
return

MG_GetAction_RB_U_:
	if (!MG_IsExDefault()) {
		MG_ActionStr := "直前のアクティブウィンドウを復元"
	}
return

MG_Gesture_RB_D_:
	if (!MG_IsExDefault()) {
		;最小化
		PostMessage, 0x0112, 0xF020, 0
	}
return

MG_GetAction_RB_D_:
	if (!MG_IsExDefault()) {
		MG_ActionStr := "最小化"
	}
return

MG_Gesture_RB_LU_:
	if (!MG_IsExDefault()) {
		
	}
return

MG_GetAction_RB_LU_:
	if (!MG_IsExDefault()) {
		
	}
return

MG_Gesture_RB_LD_:
	if (!MG_IsExDefault()) {
		
	}
return

MG_GetAction_RB_LD_:
	if (!MG_IsExDefault()) {
		
	}
return

MG_Gesture_RB_RU_:
	if (!MG_IsExDefault()) {
		;最大化
		Send, #{Up}
	}
return

MG_GetAction_RB_RU_:
	if (!MG_IsExDefault()) {
		MG_ActionStr := "最大化"
	}
return

MG_Gesture_RB_RD_:
	if (!MG_IsExDefault()) {
		;ウィンドウを閉じる
		PostMessage, 0x0010
	}
return

MG_GetAction_RB_RD_:
	if (!MG_IsExDefault()) {
		MG_ActionStr := "ウィンドウを閉じる"
	}
return

MG_Gesture_RB_UL_:
	if (!MG_IsExDefault()) {
		;ウィンドウ間移動
		Send, +#{Left}
	}
return

MG_GetAction_RB_UL_:
	if (!MG_IsExDefault()) {
		MG_ActionStr := "ウィンドウ間移動"
	}
return

MG_Gesture_RB_UR_:
	if (!MG_IsExDefault()) {
		
	}
return

MG_GetAction_RB_UR_:
	if (!MG_IsExDefault()) {
		
	}
return

MG_Gesture_RB_DL_:
	if (!MG_IsExDefault()) {
		
	}
return

MG_GetAction_RB_DL_:
	if (!MG_IsExDefault()) {
		
	}
return

MG_Gesture_RB_DR_:
	if (!MG_IsExDefault()) {
		
	}
return

MG_GetAction_RB_DR_:
	if (!MG_IsExDefault()) {
		
	}
return

MG_Gesture_RB_LR_:
	if (!MG_IsExDefault()) {
		;タブ消去
		Send, ^w
	}
return

MG_GetAction_RB_LR_:
	if (!MG_IsExDefault()) {
		MG_ActionStr := "タブ消去"
	}
return

MG_Gesture_RB_RL_:
	if (!MG_IsExDefault()) {
		;タブ復元
		Send, +^t
	}
return

MG_GetAction_RB_RL_:
	if (!MG_IsExDefault()) {
		MG_ActionStr := "タブ復元"
	}
return


MG_IsHookEnabled_RB() {
	global
	MG_TriggerCount ? : MG_GetMousePosInfo()
	return (MG_RB_Enabled && (MG_TriggerCount || (!MG_IsDisable())))
}

MG_IsHookEnabled_LB() {
	global
	return (MG_LB_Enabled && MG_TriggerCount)
}



MG_Config_end: