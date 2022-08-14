# Microsoft Developer Studio Project File - Name="PmacSetupSaveIVar" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Dynamic-Link Library" 0x0102

CFG=PmacSetupSaveIVar - Win32 PmacCIN
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "PmacSetupSaveIVar.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "PmacSetupSaveIVar.mak" CFG="PmacSetupSaveIVar - Win32 PmacCIN"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "PmacSetupSaveIVar - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "PmacSetupSaveIVar - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "PmacSetupSaveIVar - Win32 PmacCIN" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "PmacSetupSaveIVar - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /Zp1 /MD /W3 /GX /O2 /I "$(CINTOOLSDIR)\win32" /I "$(CINTOOLSDIR)" /I "d:\LabView\PmacView.lib\PmacInc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /o "NUL" /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /o "NUL" /win32
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /machine:I386
# Begin Custom Build - PmacView CIN Build
OutDir=.\Release
WkspDir=.
TargetName=PmacSetupSaveIVar
InputPath=.\Release\PmacSetupSaveIVar.dll
SOURCE="$(InputPath)"

"$(OutDir)$(TargetName).lsb" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	$(CINTOOLSDIR)\win32\lvsbutil $(TargetName) -d $(WkspDir)\$(OutDir)

# End Custom Build

!ELSEIF  "$(CFG)" == "PmacSetupSaveIVar - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MTd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /Zp1 /MD /W3 /Gm /GX /ZI /Od /I "$(CINTOOLSDIR)" /I "d:\LabView\PmacPanel.lib\PmacInc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /FD /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /o "NUL" /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /o "NUL" /win32
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /debug /machine:I386 /pdbtype:sept
# Begin Custom Build - PmacView CIN Build
OutDir=.\Debug
WkspDir=.
TargetName=PmacSetupSaveIVar
InputPath=.\Debug\PmacSetupSaveIVar.dll
SOURCE="$(InputPath)"

"$(OutDir)$(TargetName).lsb" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	$(CINTOOLSDIR)\win32\lvsbutil $(TargetName) -d $(WkspDir)\$(OutDir)

# End Custom Build

!ELSEIF  "$(CFG)" == "PmacSetupSaveIVar - Win32 PmacCIN"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "PmacDPR_"
# PROP BASE Intermediate_Dir "PmacDPR_"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "PmacDPR_"
# PROP Intermediate_Dir "PmacDPR_"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /Zp1 /MD /W3 /Gm /GX /Zi /Od /I "$(CINTOOLSDIR)" /I "d:\LabView\PmacView.lib\PmacInc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /FD /c
# SUBTRACT BASE CPP /X
# ADD CPP /nologo /Zp1 /MD /W3 /Gm /GX /ZI /Od /I "$(CINTOOLSDIR)" /I "$(DTDRIVER)\Pcomm32W" /I "$(DTDRIVER)\Include" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /FD /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /o "NUL" /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /o "NUL" /win32
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /debug /machine:I386 /def:"$(CINTOOLSDIR)\lvsbmain.def" /pdbtype:sept
# SUBTRACT LINK32 /pdb:none
# Begin Custom Build - PmacView CIN Build
OutDir=.\PmacDPR_
TargetName=PmacSetupSaveIVar
InputPath=.\PmacDPR_\PmacSetupSaveIVar.dll
SOURCE="$(InputPath)"

"$(OutDir)\$(TargetName).lsb" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	$(CINTOOLSDIR)\lvsbutil  -c PmacSetupSaveIVar  -d d:\softwa~1\pmacpanelpro\pmacpanel.lib\pmacsetup\pmacdpr_

# End Custom Build

!ENDIF 

# Begin Target

# Name "PmacSetupSaveIVar - Win32 Release"
# Name "PmacSetupSaveIVar - Win32 Debug"
# Name "PmacSetupSaveIVar - Win32 PmacCIN"
# Begin Source File

SOURCE="C:\Program Files\National Instruments\LabVIEW 8.2\cintools\lvsbmain.def"

!IF  "$(CFG)" == "PmacSetupSaveIVar - Win32 Release"

!ELSEIF  "$(CFG)" == "PmacSetupSaveIVar - Win32 Debug"

!ELSEIF  "$(CFG)" == "PmacSetupSaveIVar - Win32 PmacCIN"

# PROP Exclude_From_Build 1

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\PmacSetupSaveIVar.c
# End Source File
# Begin Source File

SOURCE="C:\Program Files\National Instruments\LabVIEW 8.2\cintools\cin.obj"
# End Source File
# Begin Source File

SOURCE=C:\WINDOWS\system32\PComm32W.lib
# End Source File
# Begin Source File

SOURCE="C:\Program Files\National Instruments\LabVIEW 8.2\cintools\lvsb.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\National Instruments\LabVIEW 8.2\cintools\labview.lib"
# End Source File
# End Target
# End Project
