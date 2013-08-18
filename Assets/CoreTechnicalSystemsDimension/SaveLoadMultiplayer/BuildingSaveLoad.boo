
partial class BuildingScript (INormalForm): 
	
	public static ResourcesLoadTable as Boo.Lang.Hash
	/* = {
		CentralWarehouseScript :  UnityEngine.Resources.Load("Buildings/CentralWarehousePreFab") ,
		FactoryScript : UnityEngine.Resources.Load("Buildings/FactoryPreFab") ,
		OilfieldScript: UnityEngine.Resources.Load("Buildings/OilfieldPreFab")
		}
	*/
	

	
	virtual PropertyInfo as Boo.Lang.Hash:
		get:
			properties as Boo.Lang.Hash = {}
			return properties
			
	
	virtual def ProduceNormalForm():
		return SaveLoadMultiplayerAspectClass.ProduceNormalForm(self)
		
	static def CreateUnit(normalStruct as SaveLoadMultiplayerAspectClass.SaveLoadMultiplayerInfoStruct):
		
		//normalStruct = SaveLoadMultiplayerAspectClass.ProduceTroopNormalStruct(infoHash)
		/*
		ab = Type.GetType(normalStruct.type as string)
		ba = ResourcesLoadTable[Type.GetType(normalStruct.type as string)]
		cd = normalStruct.metaInfo["Team"] as string
		dc = TeamScript.StringToPlayerNumber( normalStruct.metaInfo["Team"] as string )
		*/
		resourcesLoadTable as Boo.Lang.Hash = {
			CentralWarehouseScript :  UnityEngine.Resources.Load("Buildings/CentralWarehousePreFab") ,
			FactoryScript : UnityEngine.Resources.Load("Buildings/FactoryPreFab") ,
			OilfieldScript: UnityEngine.Resources.Load("Buildings/OilfieldPreFab")
			}
		newUnit = FactoryEconomy.CreateBuilding(resourcesLoadTable[Type.GetType(normalStruct.type as string)], 
			Vector3(normalStruct.metaInfo["PositionX"],normalStruct.metaInfo["PositionY"],normalStruct.metaInfo["PositionZ"]), 
			TeamScript.StringToPlayerNumber( normalStruct.metaInfo["Team"] as string ))
		newUnit.GetComponent[of BuildingScript]().LoadFromNormalForm(normalStruct)	
		
	static def CreateUnit(infoHash as Boo.Lang.Hash):
		
		normalStruct = SaveLoadMultiplayerAspectClass.ProduceTroopNormalStruct(infoHash)
		
		
		resourcesLoadTable as Boo.Lang.Hash = {
			CentralWarehouseScript :  UnityEngine.Resources.Load("Buildings/CentralWarehousePreFab") ,
			FactoryScript : UnityEngine.Resources.Load("Buildings/FactoryPreFab") ,
			OilfieldScript: UnityEngine.Resources.Load("Buildings/OilfieldPreFab")
			}
		/*
		ab = Type.GetType(normalStruct.type as string)
		ba = resourcesLoadTable[Type.GetType(normalStruct.type as string)]
		cd = normalStruct.metaInfo["Team"] as string
		dc = TeamScript.StringToPlayerNumber( normalStruct.metaInfo["Team"] as string )
		*/
		newUnit = FactoryEconomy.CreateBuilding(resourcesLoadTable[Type.GetType(normalStruct.type as string)], 
			Vector3(normalStruct.metaInfo["PositionX"],normalStruct.metaInfo["PositionY"],normalStruct.metaInfo["PositionZ"]), 
			TeamScript.StringToPlayerNumber( normalStruct.metaInfo["Team"] as string ))
		newUnit.GetComponent[of BuildingScript]().LoadFromNormalForm(infoHash)
		
	def CreateUnit(caller as MonoBehaviour, propertyInfo as SaveLoadMultiplayerAspectClass.SaveLoadMultiplayerInfoStruct):
		
		normalStruct = propertyInfo//SaveLoadMultiplayerAspectClass.LoadFromNormalForm(caller, propertyInfo)
		
		newUnit = FactoryEconomy.CreateBuilding(ResourcesLoadTable[Type.GetType(normalStruct.type as string)], 
			Vector3(normalStruct.metaInfo["PositionX"],normalStruct.metaInfo["PositionY"],normalStruct.metaInfo["PositionZ"]), 
			TeamScript.StringToPlayerNumber( normalStruct.metaInfo["Team"] as string ))
		newUnit.GetComponent[of BuildingScript]().LoadFromNormalForm(normalStruct)
		

	/*
	virtual def ProduceNormalForm():
		returnHash as Boo.Lang.Hash = {}
		for component as PropertyInfo  in self.GetType().GetProperties() : 
			if false == component.ToString().Contains("UnityEngine") and component.CanWrite == true:
				a = component
				returnHash[component.ToString().Split()[1]] = component.GetValue(self, null);
		//print(returnHash)
		return returnHash
				
				//writer.WriteStartElement(component.ToString());
		
	*/	
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
	