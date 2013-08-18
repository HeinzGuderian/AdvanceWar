import UnityEngine

class MainMenuScript (MonoBehaviour): 

	backgroundImage as Texture
	loadMenuImage as Texture
	exitMenuImage as Texture
	optionsMenuImage as Texture
	def Start ():
		backgroundImage = Resources.Load("Textures/tx_mainmenu_background")
		loadMenuImage = Resources.Load("Textures/Buttons/tx_mainmenu_newgame")
		optionsMenuImage = Resources.Load("Textures/Buttons/tx_mainmenu_options")
		exitMenuImage = Resources.Load("Textures/Buttons/tx_button_mainmenu_exit")
		//exitMenuImage = Resources.Load("Textures/Buttons/tx_mainmenu_exitgame")
	
	def Update ():
		pass
		
	def OnGUI():
		if GUI.Button(Rect(448,9,318,106),loadMenuImage,"") :
			Application.LoadLevel(0)
		if GUI.Button(Rect(448,124,318,106),optionsMenuImage,"") :
			Application.LoadLevel(0)
		if GUI.Button(Rect(448,237,318,106),exitMenuImage,"") :
			Application.Quit()
			/*
		if GUI.Button(Rect(448,354,318,106),loadMenuImage,"") :
			Application.LoadLevel(0)
			*/
		//GUI.Label(Rect(0,0,Screen.width,Screen.height),GUIContent(backgroundImage))
