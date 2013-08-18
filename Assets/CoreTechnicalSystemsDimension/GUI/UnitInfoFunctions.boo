import UnityEngine

static class UnitInfoFunctions (MonoBehaviour): 
	
	StandardUnitInfoPicture as Texture

	def Start ():
		StandardUnitInfoPicture = Resources.Load("Textures/tx_unit_info_screen", Texture)
	
	def Update ():
		pass

	
		
		