import UnityEngine

partial class LogiTroop (): 
	
	override def ProduceNormalForm():
		return SaveLoadMultiplayerAspectClass.ProduceNormalForm(self)

	static PropertyInfoFieldsSupply as Boo.Lang.Hash:
		get:
			properties as Boo.Lang.Hash = {}
			properties["Health"] = null
			properties["CombatInitiative"] = null
			properties["Spotted"] = null
			properties["Entrenched"] = null
			properties["Initiative"] = null
			properties["Ammo"] = null
			properties["Petrol"] = null
			properties["ActionPoints"] = null
			properties["IsMoving"] = null
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
			properties["CombatInitiative"] = CombatInitiative
			properties["Spotted"] = Spotted
			properties["Entrenched"] = Entrenched
			properties["Initiative"] = Initiative
			properties["Ammo"] = Ammo
			properties["Petrol"] = Petrol
			properties["ActionPoints"] = ActionPoints
			properties["IsMoving"] = IsMoving
			properties["SupplyPetrol"] = SupplyPetrol
			properties["SupplyAmmo"] = SupplyAmmo
			properties["VictoryResources"] = VictoryResources
			properties["LoadWeight"] = LoadWeight
			properties["MaxWeight"] = MaxWeight
			return properties
