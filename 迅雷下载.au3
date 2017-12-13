#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include <Crypt.au3>

Local $Link="ed2k://|file|cn_sql_server_2008_r2_enterprise_x86_x64_ia64_dvd_522233.iso|4662884352|1DB025218B01B48C6B76D6D88630F541|/"
Local $FileName="cn_sql_server_2008_r2_enterprise_x86_x64_ia64_dvd_522233.iso"
Local $SavePath="SQL安装包"
Local $Hash="0x0EEFF017B21635DF33F33C47E31E911CB23390F7" ;SHA1

Local $aArray = DriveGetDrive($DT_FIXED)
If @error Then
    ; An error occurred when retrieving the drives.
    MsgBox($MB_SYSTEMMODAL, "", "It appears an error occurred.")
Else
    For $i = 1 To $aArray[0]
		Local $max=DriveSpaceFree($aArray[1])
		Local $driveNum=1
		if $i>=2 then
			if DriveSpaceFree($aArray[$i])> DriveSpaceFree($aArray[$i-1]) then
			$max=DriveSpaceFree($aArray[$i])
			$driveNum=$i
			EndIf
		endif
    Next
EndIf

Func DownloadFile($Link)
	BlockInput($BI_DISABLE)
	WinActivate("迅雷精简版")
	ControlClick("迅雷精简版","",1081,"left",1,283,22)
	Sleep(500)
	ControlFocus ("新建任务", "", 1002 )
	Sleep(500)
	ControlSend ("新建任务", "", 1002, $Link , 1 )
	Sleep(200)
	ControlFocus ("新建任务", "", 1001 )
	Sleep(500)
	ControlSend ("新建任务", "", 1001, $aArray[$driveNum] & "\" & $SavePath , 1 )
	Sleep(500)
	ControlClick("新建任务","立即下载",1008)
	BlockInput($BI_ENABLE)
EndFunc

Func getHash()
	local	$fileRead=$aArray[$driveNum] & "\" & $SavePath & "\" & $FileName
	Local	$dHash=0
	$fHash=	_Crypt_HashFile($fileRead,$CALG_SHA1)
	Return $fHash
EndFunc

Func redownload()
	DownloadFile($Link)
	Sleep(500)
	ControlClick("消息","重新下载",1)
EndFunc

DownloadFile($Link)
Do
	sleep(60000)
Until FileExists($aArray[$driveNum] & "\" & $SavePath & "\" & $FileName)	
getHash()
if $fHash<>$Hash Then
	Do
	redownload()
		Do
			sleep(60000)
			Until FileExists($aArray[$driveNum] & "\" & $SavePath & "\" & $FileName)
	getHash()
	Until $fHash<>$Hash
EndIf
