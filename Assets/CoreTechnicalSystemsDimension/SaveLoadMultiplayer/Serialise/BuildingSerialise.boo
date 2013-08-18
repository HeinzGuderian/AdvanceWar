import UnityEngine

partial class BuildingScript (MonoBehaviour): 
	
	
	def InitialiseSerialize(script as MonoBehaviour) as void:
		ResourcesLoadTable = {
		CentralWarehouseScript :  UnityEngine.Resources.Load("Buildings/CentralWarehousePreFab") ,
		FactoryScript : UnityEngine.Resources.Load("Buildings/FactoryPreFab") ,
		OilfieldScript: UnityEngine.Resources.Load("Buildings/OilfieldPreFab")
		}
		_saveClass = SaveLoadUnitSerialisable(script)

	_saveClass as ISaveLoadUnit
		
	def SaveUnit(path as string):
		_saveClass.SaveUnit(path)
		
	public static def LoadUnit(path as string):
		return SaveLoadUnitSerialisable().LoadUnit(path)
		
	def InitialiseSerialize() as void:
		ResourcesLoadTable = {
		CentralWarehouseScript :  UnityEngine.Resources.Load("Buildings/CentralWarehousePreFab") ,
		FactoryScript : UnityEngine.Resources.Load("Buildings/FactoryPreFab") ,
		OilfieldScript: UnityEngine.Resources.Load("Buildings/OilfieldPreFab")
		}
		_saveClass = SaveLoadUnitSerialisable(self)


