import UnityEngine

partial class LoginScreen (): 

	def InitialiseSerialize() as void:
		_saveClass = SaveLoadUnitSerialisable(self)
		
	def LoadUnit(path as string):
		//normalStruct = SaveLoadUnitSerialisable(TroopClass).LoadUnit(path)
		return SaveLoadUnitSerialisable(self).LoadUnit(path)
		
	def SaveUnit(path as string) as void:
		//normalStruct = SaveLoadUnitSerialisable(TroopClass).LoadUnit(path)
		SaveLoadUnitSerialisable(self).SaveUnit(path)

