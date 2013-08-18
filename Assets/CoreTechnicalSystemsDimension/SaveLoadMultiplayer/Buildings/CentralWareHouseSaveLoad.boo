import UnityEngine

partial class CentralWarehouseScript (): 

	override def ProduceNormalForm():
		return SaveLoadMultiplayerAspectClass.ProduceNormalForm(self)

	static PropertyInfoFieldsCW as Boo.Lang.Hash:
		get:
			properties as Boo.Lang.Hash = {}
			properties["Health"] = null
			properties["SupplyPetrol"] = null
			properties["SupplyAmmo"] = null
			properties["VictoryResources"] = null
			properties["LoadWeight"] = null
			properties["MaxWeight"] = null
			return properties
	
	PropertyInfo as Boo.Lang.Hash:
		get:
			properties as Boo.Lang.Hash = {}
			properties["Health"] = Health
			properties["SupplyPetrol"] = SupplyPetrol
			properties["SupplyAmmo"] = SupplyAmmo
			properties["VictoryResources"] = VictoryResources
			properties["LoadWeight"] = LoadWeight
			properties["MaxWeight"] = MaxWeight
			return properties
