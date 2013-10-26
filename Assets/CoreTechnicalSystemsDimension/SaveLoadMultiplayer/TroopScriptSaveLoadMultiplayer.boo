import UnityEngine
import System

partial class TroopClass (INormalForm): 
	_saveClass as ISaveLoadUnit
	
	static PropertyInfoFields as Boo.Lang.Hash:
		get:
			properties as Boo.Lang.Hash = {}
			properties["Health"] = null
			properties["CombatInitiative"] = null
			properties["Spotted"] = null
			properties["Entrenched"] = null
			properties["Initiative"] = null
			properties["OverWhatchNumber"] = null
			properties["Ammo"] = null
			properties["Petrol"] = null
			properties["ActionPoints"] = null
			properties["IsMoving"] = null
			properties["OverWhatchNumber"] = null
			return properties
	
	virtual PropertyInfo as Boo.Lang.Hash:
		get:
			properties as Boo.Lang.Hash = {}
			properties["Health"] = Health
			properties["CombatInitiative"] = CombatInitiative
			properties["Spotted"] = Spotted
			properties["Entrenched"] = Entrenched
			properties["Initiative"] = Initiative
			properties["OverWhatchNumber"] = OverWhatchNumber
			properties["Ammo"] = Ammo
			properties["Petrol"] = Petrol
			properties["ActionPoints"] = ActionPoints
			properties["IsMoving"] = IsMoving
			properties["OverWhatchNumber"] = OverWhatchNumber
			return properties
			
	public static ResourcesLoadTable as Boo.Lang.Hash /* = {
		MechTroop :  UnityEngine.Resources.Load("Troops_land/MechTroopPreFab") ,
		ArmoredTroop : UnityEngine.Resources.Load("Troops_land/ArmoredTroopPreFab") ,
		ArtyTroop: UnityEngine.Resources.Load("Troops_land/ArtyTroopPreFab"),
		EngyTroop: UnityEngine.Resources.Load("Troops_land/EngineerTroopPreFab") ,
		AntiairTroop : UnityEngine.Resources.Load("Troops_land/AntiairTroopPreFab"),
		MotoTroop: UnityEngine.Resources.Load("Troops_land/MotoTroopPreFab") ,
		LogiTroop: UnityEngine.Resources.Load("Troops_land/LogisticsTroopPreFab") ,
		CommTroop: UnityEngine.Resources.Load("Troops_land/CommTroopPreFab")
		} */
	
	
	
		
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
		resourcesLoadTable = {
		MechTroop :  UnityEngine.Resources.Load("Troops_land/MechTroopPreFab") ,
		ArmoredTroop : UnityEngine.Resources.Load("Troops_land/ArmoredTroopPreFab") ,
		ArtyTroop : UnityEngine.Resources.Load("Troops_land/ArtyTroopPreFab"),
		EngyTroop: UnityEngine.Resources.Load("Troops_land/EngineerTroopPreFab") ,
		AntiairTroop: UnityEngine.Resources.Load("Troops_land/AntiairTroopPreFab"),
		MotoTroop: UnityEngine.Resources.Load("Troops_land/MotoTroopPreFab") ,
		LogiTroop: UnityEngine.Resources.Load("Troops_land/LogisticsTroopPreFab") ,
		CommTroop: UnityEngine.Resources.Load("Troops_land/CommTroopPreFab")
		}
		newUnit = FactoryEconomy.CreateUnit(resourcesLoadTable[Type.GetType(normalStruct.type as string)], 
			Vector3(normalStruct.metaInfo["PositionX"],normalStruct.metaInfo["PositionY"],normalStruct.metaInfo["PositionZ"]), 
			TeamScript.StringToPlayerNumber( normalStruct.metaInfo["Team"] as string ))
		newUnit.GetComponent[of TroopClass]().LoadFromNormalForm(normalStruct)	
		
	static def CreateUnit(infoHash as Boo.Lang.Hash):
		
		normalStruct = SaveLoadMultiplayerAspectClass.ProduceTroopNormalStruct(infoHash)
		resourcesLoadTable = {
		MechTroop :  UnityEngine.Resources.Load("Troops_land/MechTroopPreFab") ,
		ArmoredTroop : UnityEngine.Resources.Load("Troops_land/ArmoredTroopPreFab") ,
		ArtyTroop : UnityEngine.Resources.Load("Troops_land/ArtyTroopPreFab"),
		EngyTroop: UnityEngine.Resources.Load("Troops_land/EngineerTroopPreFab") ,
		AntiairTroop: UnityEngine.Resources.Load("Troops_land/AntiairTroopPreFab"),
		MotoTroop: UnityEngine.Resources.Load("Troops_land/MotoTroopPreFab") ,
		LogiTroop: UnityEngine.Resources.Load("Troops_land/LogisticsTroopPreFab") ,
		CommTroop: UnityEngine.Resources.Load("Troops_land/CommTroopPreFab")
		}
		/*
		ab = Type.GetType(normalStruct.type as string)
		ba = resourcesLoadTable[Type.GetType(normalStruct.type as string)]
		cd = normalStruct.metaInfo["Team"] as string
		dc = TeamScript.StringToPlayerNumber( normalStruct.metaInfo["Team"] as string )
		*/
		newUnit = FactoryEconomy.CreateUnit(resourcesLoadTable[Type.GetType(normalStruct.type as string)], 
			Vector3(normalStruct.metaInfo["PositionX"],normalStruct.metaInfo["PositionY"],normalStruct.metaInfo["PositionZ"]), 
			TeamScript.StringToPlayerNumber( normalStruct.metaInfo["Team"] as string ))
		newUnit.GetComponent[of TroopClass]().LoadFromNormalForm(infoHash)
		
	def CreateUnit(caller as MonoBehaviour, propertyInfo as SaveLoadMultiplayerAspectClass.SaveLoadMultiplayerInfoStruct):
		
		normalStruct = propertyInfo//SaveLoadMultiplayerAspectClass.LoadFromNormalForm(caller, propertyInfo)
		
		newUnit = FactoryEconomy.CreateUnit(ResourcesLoadTable[Type.GetType(normalStruct.type as string)], 
			Vector3(normalStruct.metaInfo["PositionX"],normalStruct.metaInfo["PositionY"],normalStruct.metaInfo["PositionZ"]), 
			TeamScript.StringToPlayerNumber( normalStruct.metaInfo["Team"] as string ))
		newUnit.GetComponent[of TroopClass]().LoadFromNormalForm(normalStruct)
		

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
	