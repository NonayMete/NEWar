<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="8608001">
	<Item Name="My Computer" Type="My Computer">
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="NUWAR_Master" Type="Folder" URL="..">
			<Property Name="NI.DISK" Type="Bool">true</Property>
		</Item>
		<Item Name="Dependencies" Type="Dependencies">
			<Item Name="vi.lib" Type="Folder">
				<Item Name="Beep.vi" Type="VI" URL="/&lt;vilib&gt;/Platform/system.llb/Beep.vi"/>
				<Item Name="Open File+.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Open File+.vi"/>
				<Item Name="Read File+ (string).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Read File+ (string).vi"/>
				<Item Name="compatReadText.vi" Type="VI" URL="/&lt;vilib&gt;/_oldvers/_oldvers.llb/compatReadText.vi"/>
				<Item Name="Merge Errors.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Merge Errors.vi"/>
				<Item Name="Close File+.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Close File+.vi"/>
				<Item Name="Find First Error.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Find First Error.vi"/>
				<Item Name="Write Characters To File.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write Characters To File.vi"/>
				<Item Name="Open_Create_Replace File.vi" Type="VI" URL="/&lt;vilib&gt;/_oldvers/_oldvers.llb/Open_Create_Replace File.vi"/>
				<Item Name="compatFileDialog.vi" Type="VI" URL="/&lt;vilib&gt;/_oldvers/_oldvers.llb/compatFileDialog.vi"/>
				<Item Name="compatOpenFileOperation.vi" Type="VI" URL="/&lt;vilib&gt;/_oldvers/_oldvers.llb/compatOpenFileOperation.vi"/>
				<Item Name="compatCalcOffset.vi" Type="VI" URL="/&lt;vilib&gt;/_oldvers/_oldvers.llb/compatCalcOffset.vi"/>
				<Item Name="Write File+ (string).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write File+ (string).vi"/>
				<Item Name="compatWriteText.vi" Type="VI" URL="/&lt;vilib&gt;/_oldvers/_oldvers.llb/compatWriteText.vi"/>
				<Item Name="General Error Handler.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/General Error Handler.vi"/>
				<Item Name="General Error Handler CORE.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/General Error Handler CORE.vi"/>
				<Item Name="Check Special Tags.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Check Special Tags.vi"/>
				<Item Name="TagReturnType.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/TagReturnType.ctl"/>
				<Item Name="Set String Value.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Set String Value.vi"/>
				<Item Name="GetRTHostConnectedProp.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/GetRTHostConnectedProp.vi"/>
				<Item Name="Error Code Database.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Code Database.vi"/>
				<Item Name="Trim Whitespace.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Trim Whitespace.vi"/>
				<Item Name="whitespace.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/whitespace.ctl"/>
				<Item Name="Format Message String.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Format Message String.vi"/>
				<Item Name="Find Tag.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Find Tag.vi"/>
				<Item Name="Search and Replace Pattern.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Search and Replace Pattern.vi"/>
				<Item Name="Set Bold Text.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Set Bold Text.vi"/>
				<Item Name="Details Display Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Details Display Dialog.vi"/>
				<Item Name="Clear Errors.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Clear Errors.vi"/>
				<Item Name="DialogTypeEnum.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/DialogTypeEnum.ctl"/>
				<Item Name="ErrWarn.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/ErrWarn.ctl"/>
				<Item Name="eventvkey.ctl" Type="VI" URL="/&lt;vilib&gt;/event_ctls.llb/eventvkey.ctl"/>
				<Item Name="Not Found Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Not Found Dialog.vi"/>
				<Item Name="Three Button Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Three Button Dialog.vi"/>
				<Item Name="Three Button Dialog CORE.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Three Button Dialog CORE.vi"/>
				<Item Name="Longest Line Length in Pixels.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Longest Line Length in Pixels.vi"/>
				<Item Name="Convert property node font to graphics font.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Convert property node font to graphics font.vi"/>
				<Item Name="Get Text Rect.vi" Type="VI" URL="/&lt;vilib&gt;/picture/picture.llb/Get Text Rect.vi"/>
				<Item Name="Get String Text Bounds.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Get String Text Bounds.vi"/>
				<Item Name="LVBoundsTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVBoundsTypeDef.ctl"/>
				<Item Name="BuildHelpPath.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/BuildHelpPath.vi"/>
				<Item Name="GetHelpDir.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/GetHelpDir.vi"/>
				<Item Name="DialogType.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/DialogType.ctl"/>
				<Item Name="Open Panel.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/victl.llb/Open Panel.vi"/>
				<Item Name="Get Instrument State.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/victl.llb/Get Instrument State.vi"/>
				<Item Name="Close Panel No Abort.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/victl.llb/Close Panel No Abort.vi"/>
				<Item Name="viRef buffer.vi" Type="VI" URL="/&lt;vilib&gt;/UTILITY/victl.llb/viRef buffer.vi"/>
				<Item Name="Write To Spreadsheet File.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write To Spreadsheet File.vi"/>
				<Item Name="Write To Spreadsheet File (DBL).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write To Spreadsheet File (DBL).vi"/>
				<Item Name="Write Spreadsheet String.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write Spreadsheet String.vi"/>
				<Item Name="Write To Spreadsheet File (I64).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write To Spreadsheet File (I64).vi"/>
				<Item Name="Write To Spreadsheet File (string).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write To Spreadsheet File (string).vi"/>
			</Item>
			<Item Name="PmacIVarDbl.vi" Type="VI" URL="../../Program Files/Delta Tau/PmacPanelPRO2/PmacPanelPro2.Lib/PmacIVar/PmacIVarDbl.vi"/>
			<Item Name="PmacFileDownLoad.vi" Type="VI" URL="../PmacFile/PmacFileDownLoad.vi"/>
			<Item Name="PathExt.vi" Type="VI" URL="../PmacUtility/PathExt.vi"/>
			<Item Name="PmacFileDownLoadLog.vi" Type="VI" URL="../Dependancies/PmacFileDownLoadLog.vi"/>
			<Item Name="PComm32W.dll" Type="Document" URL="/WINDOWS/system32/PComm32W.dll"/>
			<Item Name="PComm32W.dll" Type="Document" URL="../../WINDOWS/system32/PComm32W.dll"/>
			<Item Name="AI Config.vi" Type="VI" URL="../Dependancies/PmacPanelPro2.Lib/PmacDAQ/PmacDAQSync.vi/AI Config.vi"/>
			<Item Name="AI Start.vi" Type="VI" URL="../Dependancies/PmacPanelPro2.Lib/PmacDAQ/PmacDAQSync.vi/AI Start.vi"/>
			<Item Name="AI Control.vi" Type="VI" URL="../Dependancies/PmacPanelPro2.Lib/PmacDAQ/PmacDAQSync.vi/AI Control.vi"/>
			<Item Name="AI Clear.vi" Type="VI" URL="../Dependancies/PmacPanelPro2.Lib/PmacDAQ/PmacDAQSync.vi/AI Clear.vi"/>
			<Item Name="AI Read.vi" Type="VI" URL="../Dependancies/PmacPanelPro2.Lib/PmacDAQ/PmacDAQSync.vi/AI Read.vi"/>
			<Item Name="AI Read (scaled array).vi" Type="VI" URL="../Dependancies/PmacPanelPro2.Lib/PmacDAQ/PmacDAQSync.vi/AI Read (scaled array).vi"/>
			<Item Name="AI Config.vi" Type="VI" URL="../Dependancies/PmacPanelPro2.Lib/PmacDAQ/PmacDAQSyncServo.vi/AI Config.vi"/>
			<Item Name="AI Start.vi" Type="VI" URL="../Dependancies/PmacPanelPro2.Lib/PmacDAQ/PmacDAQSyncServo.vi/AI Start.vi"/>
			<Item Name="AI Control.vi" Type="VI" URL="../Dependancies/PmacPanelPro2.Lib/PmacDAQ/PmacDAQSyncServo.vi/AI Control.vi"/>
			<Item Name="AI Clear.vi" Type="VI" URL="../Dependancies/PmacPanelPro2.Lib/PmacDAQ/PmacDAQSyncServo.vi/AI Clear.vi"/>
			<Item Name="AI Read.vi" Type="VI" URL="../Dependancies/PmacPanelPro2.Lib/PmacDAQ/PmacDAQSyncServo.vi/AI Read.vi"/>
			<Item Name="AI Read (scaled array).vi" Type="VI" URL="../Dependancies/PmacPanelPro2.Lib/PmacDAQ/PmacDAQSyncServo.vi/AI Read (scaled array).vi"/>
			<Item Name="AI Config.vi" Type="VI" URL="../Dependancies/PmacPanelPro2.Lib/PmacDAQ/PmacDAQTrigger.vi/AI Config.vi"/>
			<Item Name="AI Start.vi" Type="VI" URL="../Dependancies/PmacPanelPro2.Lib/PmacDAQ/PmacDAQTrigger.vi/AI Start.vi"/>
			<Item Name="AI Clear.vi" Type="VI" URL="../Dependancies/PmacPanelPro2.Lib/PmacDAQ/PmacDAQTrigger.vi/AI Clear.vi"/>
			<Item Name="AI Read.vi" Type="VI" URL="../Dependancies/PmacPanelPro2.Lib/PmacDAQ/PmacDAQTrigger.vi/AI Read.vi"/>
			<Item Name="AI Read (scaled array).vi" Type="VI" URL="../Dependancies/PmacPanelPro2.Lib/PmacDAQ/PmacDAQTrigger.vi/AI Read (scaled array).vi"/>
			<Item Name="PComm32W.dll" Type="Document" URL="/../../WINDOWS/system32/PComm32W.dll"/>
		</Item>
		<Item Name="Build Specifications" Type="Build">
			<Item Name="NUWARMaster5-8-13" Type="EXE">
				<Property Name="App_applicationGUID" Type="Str">{1D8C2724-610F-4106-899D-C2700071DCE3}</Property>
				<Property Name="App_applicationName" Type="Str">NUWARMaster5-8-13.exe</Property>
				<Property Name="App_companyName" Type="Str">UWA</Property>
				<Property Name="App_fileDescription" Type="Str">NUWARMaster5-8-13</Property>
				<Property Name="App_fileVersion.major" Type="Int">1</Property>
				<Property Name="App_INI_aliasGUID" Type="Str">{1C827350-7873-4E41-B8DC-947106909754}</Property>
				<Property Name="App_INI_GUID" Type="Str">{8C185F6E-4EB7-43A1-9735-DAEA5B56B55E}</Property>
				<Property Name="App_internalName" Type="Str">NUWARMaster5-8-13</Property>
				<Property Name="App_legalCopyright" Type="Str">Copyright © 2013 UWA</Property>
				<Property Name="App_productName" Type="Str">NUWARMaster5-8-13</Property>
				<Property Name="Bld_buildSpecName" Type="Str">NUWARMaster5-8-13</Property>
				<Property Name="Bld_excludeLibraryItems" Type="Bool">true</Property>
				<Property Name="Bld_excludePolymorphicVIs" Type="Bool">true</Property>
				<Property Name="Bld_modifyLibraryFile" Type="Bool">true</Property>
				<Property Name="Destination[0].destName" Type="Str">NUWARMaster5-8-13.exe</Property>
				<Property Name="Destination[0].path" Type="Path">../NUWAR_Master/Builds/internal.llb</Property>
				<Property Name="Destination[0].type" Type="Str">App</Property>
				<Property Name="Destination[1].destName" Type="Str">Support Directory</Property>
				<Property Name="Destination[1].path" Type="Path">../NUWAR_Master/Builds/data</Property>
				<Property Name="DestinationCount" Type="Int">2</Property>
				<Property Name="Source[0].itemID" Type="Str">{B2CFDA83-AED5-4553-8ECB-80DB5B572573}</Property>
				<Property Name="Source[0].type" Type="Str">Container</Property>
				<Property Name="Source[1].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[1].itemID" Type="Ref">/My Computer/NUWAR_Master/NUWARMaster.vi</Property>
				<Property Name="Source[1].sourceInclusion" Type="Str">TopLevel</Property>
				<Property Name="Source[1].type" Type="Str">VI</Property>
				<Property Name="SourceCount" Type="Int">2</Property>
			</Item>
		</Item>
	</Item>
</Project>
