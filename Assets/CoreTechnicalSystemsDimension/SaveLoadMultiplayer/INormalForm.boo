interface INormalForm (): 
	
	PropertyInfo as Boo.Lang.Hash:
		get

	def ProduceNormalForm() as SaveLoadMultiplayerAspectClass.SaveLoadMultiplayerInfoStruct
	def LoadFromNormalForm(propertyHash as SaveLoadMultiplayerAspectClass.SaveLoadMultiplayerInfoStruct) as void
