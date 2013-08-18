import UnityEngine

partial class OilfieldScript (): 
	
	override def ProduceNormalForm():
		return SaveLoadMultiplayerAspectClass.ProduceNormalForm(self)

	static PropertyInfoFieldsSupply as Boo.Lang.Hash:
		get:
			properties as Boo.Lang.Hash = {}
			properties["ProducedVRPerTurn"] = null
			properties["CurrentVRHold"] = null
			properties["MaxVRHold"] = null
			return properties
	
	PropertyInfo as Boo.Lang.Hash:
		get:
			properties as Boo.Lang.Hash = {}
			properties["ProducedVRPerTurn"] = ProducedVRPerTurn
			properties["CurrentVRHold"] = CurrentVRHold
			properties["MaxVRHold"] = MaxVRHold
			return properties
