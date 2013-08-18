import UnityEngine

partial class LoginScreen (INormalForm): 

	static PropertyInfoFieldsLogin as Boo.Lang.Hash:
		get:
			properties as Boo.Lang.Hash = {}
			properties["Name"] = ""
			properties["Password"] = ""
			return properties
	
	PropertyInfo as Boo.Lang.Hash:
		get:
			properties as Boo.Lang.Hash = {}
			properties["Name"] = Name
			properties["Password"] = Password
			return properties

	def ProduceNormalForm():
		return SaveLoadMultiplayerAspectClass.SaveLoadMultiplayerInfoStruct(propertyInfo: {"Name": Name, "Password" : Password}, metaInfo: {}, type: "LoginScreen")
		
	virtual def LoadFromNormalForm(propertyHash as Boo.Lang.Hash):
		 for pair in propertyHash: 
		 	currentProperty = self.GetType().GetProperty(pair.Key.ToString())
		 	if currentProperty != null:
		 		currentProperty.SetValue(self, pair.Value, null);
		 		
	virtual def LoadFromNormalForm(propertyStruct as SaveLoadMultiplayerAspectClass.SaveLoadMultiplayerInfoStruct):
		 for pair in propertyStruct.propertyInfo as Boo.Lang.Hash: 
		 	currentProperty = self.GetType().GetProperty(pair.Key.ToString())
		 	if currentProperty != null:
		 		currentProperty.SetValue(self, pair.Value, null);
