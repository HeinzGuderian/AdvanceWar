import UnityEngine

partial class DataScript (MonoBehaviour, IData): 
	public IsSelected = false
	
	def OnMouseDown():
		SetSelected()

	def SetSelected():
		currentPlayersGameObject = LibraryScript.FindCamera()
		//currentPlayer = currentPlayersGameObject.GetComponent[of PlayerScript]()
		currentPlayerGUI = currentPlayersGameObject.GetComponent[of GuiScript]()
		currentPlayerGUI.SetSelected(gameObject)