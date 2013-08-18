import UnityEngine

static class SupplyAspectClass (MonoBehaviour): 
	
	enum SupplyTypes:
		VR
		Petrol
		Ammo 
		
	public final SupplyCostTable = {
		SupplyTypes.Petrol : 10,
		SupplyTypes.Ammo : 10
	}
		

	def Start ():
		pass
	
	def Update ():
		pass
		
	def CalculateSupplyCost(troop as TroopClass, targetTerrain as GameObject):
		targetTerrainScript as TerrainScript = TerrainScript.FindTerrainScript(targetTerrain)
		cost = MoveAspectClass.terrainMoveCost(troop, targetTerrainScript.TerrainType)
		return cost
