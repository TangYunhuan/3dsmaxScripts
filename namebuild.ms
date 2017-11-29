/*****************************************
2017.11.23 本插件只为贴图名称修改 材质名称修改
by 唐云焕
*****************************************/

global nameBuilderinst = undefined

struct nameBuilder 
(
	fn getGuidStr = 
	(
		local guid_string = ""
		local guid_class = dotnetclass "system.guid"
		local guid = guid_class.newguid()
		local guid_to = guid.tostring("n")
		if guid_to.count > 8 do
		(
			for i = 1 to 8 do 
			(
				guid_string+= guid_to[i]
			)
		)
		return guid_string;
	),
	fn rebuildName objMat fstStr sedStr= 
	(
		if superClassOf objMat ==material do 
		(
			objMat.name = fstStr+"_"+sedStr+"_"+getGuidStr()
			local allPropertyName = getPropNames objMat
			for proName in allPropertyName do
			(
				if proName == #ConvertToGeneric do continue
				local propertyValue = getProperty objMat proName
				local Test = superClassOf propertyValue
				if Test==MAXObject then 
				(
					for i = 1 to propertyValue.count do 
					(
						if superClassOf propertyValue[i] ==material do 
						(
							rebuildName propertyValue[i] fstStr sedStr
						)
					)
				)else if superClassOf propertyValue ==material do 
				(
					rebuildName propertyValue fstStr sedStr
				)
			)
		)
	),
	fn functionForName fstStr sedStr= 
	(
		for i in scenematerials do 
		(
			try(rebuildName i fstStr sedStr)catch(print i)
		)
	),
	fn reName oldStr useInfo= 
	(
		local oldType = getFilenameType oldStr
		local oldPaht = getFilenamePath oldStr
		local newName = getGuidStr()
		local newStr = pathConfig.appendPath oldPaht (useInfo+"_"+newName+oldType)
		fi = dotNetObject "System.IO.FileInfo" oldStr
		fi.MoveTo(newStr) 
		return newStr
	)
)

rollout nameBuiderUi "version1.0" width:234 height:189
(
	edittext edt1 "首位字符名" pos:[16,19] width:200 height:15
	edittext edt2 "自定义字符" pos:[16,40] width:200 height:15
	button btn1 "点击" pos:[16,62] width:200 height:20
	groupBox grp1 "材质名字" pos:[8,2] width:214 height:85
	groupBox grp2 "图片名字" pos:[9,103] width:216 height:76
	editText edt3 "首位字符名" pos:[15,122] width:200 height:15
	button btn2 "点击" pos:[15,147] width:200 height:20
	
	on nameBuiderUi open do 
	(
		if nameBuilderinst==undefined do 
		(
			nameBuilderinst = nameBuilder()
		)
	)
	
	on btn1 pressed do 
	(
		if not (matchPattern edt1.text pattern:"") do 
		(
			nameBuilderinst.functionForName edt1.text edt2.text
		)
		
	)
	on btn2 pressed do 
	(
		local picSel = getClassInstances Bitmaptexture target:rootnode 
		for i in picSel do 
		(
			try(i.filename = nameBuilderinst.reName i.filename edt3.text)catch(print i)
		)
	)
	
)
try(DestroyDialog nameBuiderUi)catch()
CreateDialog nameBuiderUi




