import UnityEngine

partial public class TroopClass (MonoBehaviour, IHighlight, IGUI, IUseTerrain, IGameState): 
	// Class variables
	
	_library as LibraryScript
	_gameState as GameState
	public materials as (Material)
	_currentPlayerGUI as GuiScript
	OurDataScript as DataScript 
	
	_unitInfoMenu as BasicMenu
	_showUnitInfo as bool = false
	StandardUnitInfoPicture as Texture
	UnitInfoButton as Texture
	UnitInfoImage as Texture
	_infoStruct as UnitInfoStruct
	
	
	
	static count = 0
	
	def Info():
		return ""
	
	def Actions():
		actions = [{"name"  : "Unit Info", "image": UnitInfoButton, "object": self as MonoBehaviour, "function"  : self.SetShowUnitInfoScreen as callable , "requireMouseClick" : 0, "requireSelected" : false , "RunWaitFunction" : false ,"ShouldRevertWaitFunction":false}]
		return actions
		
	def SetShowUnitInfoScreen():
		_showUnitInfo = true
	
		
	struct UnitInfoStruct:
		name as string
		startCoordinates as List
		unitInfo as List
		weaponList as List
		
		
	virtual def Awake():
		OurDataScript = gameObject.GetComponent[of DataScript]()
		gameRules = GameObject.Find('GameRules')
		_library = gameRules.GetComponent[of LibraryScript]()
		_gameState = gameRules.GetComponent[of GameState]()
		
		
		
		assert null != OurDataScript
		assert null != gameRules
		assert null != _library
		assert null != _gameState
		
		
		
		
		SetUpImagesProcedure()
		SetUpStructProcedure()
		_unitInfoMenu = gameObject.AddComponent[of BasicMenu]()
		
		//InitialiseSerialize()
		
	        
	virtual def Start():
		currentPlayersGameObject = _library.FindCamera()
		assert null != currentPlayersGameObject
		_currentPlayerGUI = currentPlayersGameObject.GetComponent[of GuiScript]()
		assert null != _currentPlayerGUI
		team as TeamScript = TeamScript.FindTeamScript(gameObject)
		_library.checkInit(_gameState, team)
		//Save()
		
		
		/*
		stream as Stream = File.Open("EmployeeInfo"+count.ToString()+".osl", FileMode.Create);
		count += 1
		bformatter as BinaryFormatter = BinaryFormatter();
            
		Console.WriteLine("Writing Employee Information");
		bformatter.Serialize(stream, self);
		stream.Close();
		*/
		//ProduceNormalForm()
		
		//SaveNormalForm()
		
		// Scaffolding
		//returnHash as Boo.Lang.Hash = {}
		//returnHash["Health"] = 58	
		//LoadFromNormalForm(returnHash

			
	virtual def SetUpImagesProcedure():
		StandardUnitInfoPicture = UnityEngine.Resources.Load("Textures/tx_unit_info_screen", Texture)
		UnitInfoButton = UnityEngine.Resources.Load("Textures/Buttons/tx_button_unitInfo", Texture)
		UnitInfoImage = UnityEngine.Resources.Load("Textures/tx_ui_selected_unit_indicator", Texture)
		
	// Used in in unit info SCREEN, not info box
	virtual def SetUpStructProcedure():
	   // Set up dispaly info
		_infoStruct = UnitInfoStruct()
		//_infoStruct.Add( gameObject.GetComponent[of DataScript]().Name as string )
		_infoStruct.name = gameObject.GetComponent[of DataScript]().Name as string 
		//infoString = UpdateUnitInfo()
		_infoStruct.startCoordinates = [119,84]
		_infoStruct.unitInfo = UpdateUnitInfo()
		//_infoStruct.Add([[119,84], infoString])
		//_infoStruct.Add(DisplayWeaponSystems())
		_infoStruct.weaponList = DisplayWeaponSystems()
		//BasicMenu.SetupBasicMenu(_unitInfoMenu, "", [BasicMenu.BasicMenuItemStruct(ItemsValue:_infoStruct)], 100, 100, 750, 451, 451, gameObject, self.StandardInfoCode)
	
	// Used in in unit info SCREEN, not info box
	virtual def UpdateUnitInfo() as List:
		infoString = []
		infoString.Add( Health.ToString() )
		infoString.Add( ActionPoints.ToString() )
		infoString.Add( Initiative.ToString() )
		infoString.Add( Petrol.ToString() )
		infoString.Add( Ammo.ToString() )
		return infoString
		
	// USed in unit info box
	virtual def InfoGUI():
		//return ""
		
		health = Health.ToString()
		actionPoints = ActionPoints.ToString()
		petrol = Petrol.ToString()
		ammo = Ammo.ToString()
		
		returnString = ""+actionPoints+" / "+health+" / "+petrol+" / "+ammo
		//return "" 
		return returnString
			
	virtual def OnGUI():
		
		if OurDataScript.IsSelected == true:
			GUI.Label(Rect (170,0,128,64), UnitInfoImage,"")
			GUI.Label(Rect (170+5,0+36,128,128), InfoGUI())
		ShowUnitScreenProcedure()
		
	// Used in in unit info SCREEN, not info box
	def ShowUnitScreenProcedure():
		if _showUnitInfo == false:
			return
		//_unitInfoMenu.RunMenu()
		
		GUI.BeginGroup(Rect (0,0,750,451))
		if GUI.Button(Rect(670,380,100,100),"Close"):
			_showUnitInfo = false
		//screenRect = Rect (0,0,750,451)
		StandardInfoCode(_infoStruct)
		
		GUI.EndGroup()	
		
	// Used in in unit info SCREEN, not info box
	virtual def StandardInfoCode(ref infoStruct as UnitInfoStruct):
		// Update recent unit info
		infoStruct.unitInfo = UpdateUnitInfo()
		//(_infoStruct[1] as List)[1] =UpdateUnitInfo()
		// Display background image
		GUI.Button(Rect (0,0,750,451),GUIContent(StandardUnitInfoPicture),"")
		// Display name
		GUI.Label(Rect(60,40,200,20),infoStruct.name as string)
		// Display unit info
		xChange = 0
		yChange = 0
		for infoString as string in infoStruct.unitInfo:
			GUI.Label(Rect(119,67+yChange,100,20),infoString as string)
			xChange += 20
			yChange += 20
		// Display unit weapons
		yChange = 0
		for weaponStringList as List in infoStruct.weaponList:
			xChange = 0
			for infoString as string in weaponStringList:
				GUI.Label(Rect(11+xChange,250+yChange,100,20),infoString as string)
				xChange += 140
			yChange += 40
/*
	def Write(writer as XmlTextWriter ):
		//Write local position, rotation and scale as attributes or whatever.
		for component as PropertyInfo  in self.GetType().GetProperties() : 
			//property.Name, property.GetValue(person, null)
			writer.WriteStartElement(component.ToString());
			// write the component type at minimum.
			writer.WriteEndElement();
			*/
			/*
		for  child as Transform in self:
			write.BeginElement("transform");
			Write(child, write);// recurse.
			write.EndElement();
			*/
	
	def OnDestroy():
		// If is to protect agaisnt errors while using destroy on the gameobject
		if OccupiedTerrain != null:
			OccupiedTerrain.RemoveUnit(gameObject)
			OccupiedTerrain.IsOccupied = false
		
	static def FindTroopScript(gameObjectToSearch as GameObject):
		troopScript as TroopClass = gameObjectToSearch.GetComponent[of TroopClass]()
		return troopScript
		
	def Highlight():
		renderer.material = materials[1]
		
	def DeHighlight():
		renderer.material = materials[0]
		
	def EndTurnActions():
		return
		
	def StartTurnActions():
		pass
		
	
	// Troop data
	[SerializeField] 
	_health as int  = 10
	Health as int:
		get:
			return _health
		set:
			if(value<0):
				print("Error: New health value is under zero!")
				_health = 0
			else:
				_health = value
	[SerializeField] 
	_maxHealth as int  = 10
	MaxHealth as int:
		get:
			return _maxHealth
		set:
			if(value<0):
				print("Error: New MaxHealth value is under zero!")
				_maxHealth = 0
			else:
				_maxHealth = value
	[SerializeField] 
	_actionPoints as int = 100
	ActionPoints as int:
		get:
			return _actionPoints
		set:
			if(value<0):
				print("Error: New actionPoint value is under zero!")
				_actionPoints = 0
			else:
				_actionPoints = value
	[SerializeField]
	_maxActionPoints as int = 100
	MaxActionPoints as int:
		get:
			return _maxActionPoints
	
	// Combat data
	struct WeaponSystem:
		Name as string
		Range as int
		HardDamage as int
		HardMinimumDamage as int
		SoftDamage as int
		SoftMinimumDamage as int
		
	def DisplayWeaponSystems() as List:
		returnString = []
		for weapon as WeaponSystem in WeaponList:
			weaponList = []
			weaponList.Add(weapon.Name)
			weaponList.Add(weapon.HardMinimumDamage.ToString() +" - " + weapon.HardDamage.ToString() )
			weaponList.Add(weapon.SoftMinimumDamage.ToString() +" - " +weapon.SoftDamage.ToString() )
			weaponList.Add(weapon.Range.ToString())
			returnString.Add(weaponList)
			//returnString.Add(" HardMinimumDamage: "+weapon.HardMinimumDamage.ToString()
			//returnString.Add(" SoftMinimumDamage: "+weapon.SoftMinimumDamage.ToString()
		return returnString
		
	[SerializeField]
	_baseInitiative as int
	BaseInitiative as int:
		get:
			return _baseInitiative
		set:
			if(value<0):
				print("Error: New BaseInitiative value is under zero!")
				_baseInitiative = 0
			else:
				_baseInitiative = value
				
	[SerializeField]
	_initiative as int
	Initiative as int:
		get:
			return _initiative
		set:
			if(value<0):
				print("Error: New Initiative value is under zero!")
				_initiative = 0
			else:
				_initiative = value
	[SerializeField]
	_combatInitiative as int
	CombatInitiative as int:
		get:
			return _combatInitiative
		set:
			if(value<0):
				print("Error: New CombatInitiative value is not in limit!")
				_combatInitiative = 0
			elif (value>10):
				print("Error: New CombatInitiative value is not in limit!")
				_combatInitiative = 10
			else:
				_combatInitiative = value
	[SerializeField]
	_entrenched as int
	Entrenched as int:
		get:
			return _entrenched
		set:
			if(value<0):
				print("Error: New Entrenched value is under zero!")
				_entrenched = 0
			else:
				_entrenched = value
	[SerializeField]
	_hardness as double // Max is 1.0 lowest is 0, represent percentage of vechicles
	Hardness as double:
		get:
			return _hardness
		set:
			if(value<0):
				print("Error: New actionPoint value is under zero!")
				_hardness = 0
			elif(value>1):
				print("Error: New Hardness value is above one!")
				_hardness = 0
			else:
				_hardness = value
	[SerializeField]
	_softDefence as int // Max is 1.0 lowest is 0, represent percentage of vechicles
	SoftDefence as int:
		get:
			return _softDefence
		set:
			if(value<0):
				print("Error: New SoftDefence value is under zero!")
				_softDefence = 0
			else:
				_softDefence = value
	[SerializeField]
	_hardDefence as int
	HardDefence as int:
		get:
			return _hardDefence
		set:
			if(value<0):
				print("Error: New HardDefence value is under zero!")
				_hardDefence = 0
			else:
				_hardDefence = value
	//[XmlArray("WeaponList")]	
	//[XmlArrayItem("WeaponSystem")]
	public WeaponList as List = []

	
	// Sight data
	[SerializeField]
	_sight as int
	Sight as int: // Sight range in grids
		get:
			return _sight
		set:
			if(value<0):
				print("Error: New Sight value is under zero!")
				_sight = 0
			else:
				_sight = value
	[SerializeField]
	public Spotted as bool = false
	public DetectionCapabilities as int
	[SerializeField]
	_groundSignature as double
	GroundSignature as int:
		get:
			return _groundSignature
		set:
			if(value<0):
				print("Error: New GroundSignature value is under zero!")
				_groundSignature = 0
			else:
				_groundSignature = value
	
	// Move DataScript
	enum MovementTypeEnum:
		walking
		tracked
		wheel
		flying
	public IsMoving as bool = false
	public MovementType as MovementTypeEnum
	_moved as int
	Moved as int:
		get:
			return _moved
		set:
			if(value<0):
				print("Error: New Moved value is under zero!")
				_moved = 0
			else:
				_moved = value
	[SerializeField]
	_occupiedTerrainGameObject as GameObject = null
	OccupiedTerrainGameObject as GameObject:
		get:
			return _occupiedTerrainGameObject
		set:
			_occupiedTerrainGameObject = value
	[SerializeField]
	_occupiedTerrain as TerrainScript
	OccupiedTerrain as TerrainScript:
		get:
			return _occupiedTerrain
		set:
			_occupiedTerrain = value
	[SerializeField]
	_clutterModifier as int
	ClutterModifier as int:
		get:
			return _clutterModifier
		set:
			if(value<0):
				print("Error: New ClutterModifier value is under zero!")
				_clutterModifier = 0
			else:
				_clutterModifier = value
				
	// Economy DataScript
	/*
	[SerializeField]
	static virtual _productionCost as int
	static ProductionCost as int:
		get:
			return _productionCost
		set:
			if(value<0):
				print("Error: New ProductionCost value is under zero!")
				_productionCost = 0
			else:
				_productionCost = value
				*/
	
	// Supply Data
	[SerializeField]
	_maxAmmo as int // Max is 1.0 lowest is 0, represent percentage of vechicles
	MaxAmmo as int:
		get:
			return _maxAmmo
		set:
			if(value<0):
				print("Error: New MaxAmmo value is under zero!")
				_maxAmmo = 0
			else:
				_maxAmmo = value
	[SerializeField]
	_ammo as int // Max is 1.0 lowest is 0, represent percentage of vechicles
	Ammo as int:
		get:
			return _ammo
		set:
			if(value<0):
				print("Error: New Ammo value is under zero!")
				_ammo = 0
			else:
				_ammo = value
	[SerializeField]
	_petrol as int 
	Petrol as int:
		get:
			return _petrol
		set:
			if(value<0):
				print("Error: New Petrol value is under zero!")
				_petrol = 0
			else:
				_petrol = value
	[SerializeField]
	_maxPetrol as int 
	MaxPetrol as int:
		get:
			return _maxPetrol
		set:
			if(value<0):
				print("Error: New MaxFeul value is under zero!")
				_maxPetrol = 0
			else:
				_maxPetrol = value
	

		/*
		WeaponList = [WeaponSystem(Name: "Infantry close range", Range: 3, HardDamage: 2, SoftDamage: 2 )
						, WeaponSystem(Name: "Infantry and IFV missiles", Range: 5, HardDamage: 5, SoftDamage: 0 )
						, WeaponSystem(Name: "Company Mortar Unit", Range: 6, HardDamage: 1, SoftDamage: 2 )
						, WeaponSystem(Name: "IFV Cannon", Range: 4, HardDamage: 3, SoftDamage: 4 )]
						
		WeaponList = [WeaponSystem(Name: "Close combat weapons", Range: 1, HardDamage: 5, SoftDamage: 4, Describtion: "heavy closecombat weapons" )
						, WeaponSystem(Name: "Bolters", Range: 5, HardDamage: 2, SoftDamage: 3 )
		*/
		
	
 
/*
static Transform Read(XML xml)

{

     System.Type[] components;

     {

         List<System.Type> componentNames = new List<string>();

         Parse all component elements out of the xml storing their type into the above list.

         components = componentNames.ToArray();

     }

     GameObject go = new GameObject( xml.Attribute("name"), components );

     Transform self = go.transform;

     // set local position, rotation, and scale from xml.

     foreach( element named transform in xml )

         Read( element ).parent = self; // recurse

     return self;

}
	*/
	/*		
		
	Hardness as double: // Max is 1.0 lowest is 0, represent percentage of vechicles
		get:
			return _hardness
			
	SoftDefence as int:
		get:
			return _softDefence
			
	HardDefence as int:
		get:
			return _hardDefence
	
	WeaponList as List: // List of struct CombatScript.WeaponSystem
		get:
			return _weaponList
		set:
			_weaponList = value
	

	
	
	OccupiedTerrain as ITerrain:
		get:
			return _occupiedTerrain
		set:
			_occupiedTerrain = value
    		
	Health as System.Int32:
		get:
			return _health
		set:
			_health = value
	
	TroopGameObject as GameObject:
		get:
			return gameObject
			
	OccupiedTerrainGameObject as GameObject:
		get:
			return _currentTerrainGameObject
		set:
			_currentTerrainGameObject = value
			
	MaxAmmo as int:
		get:
			
		set:
		
	Ammo as int:
		get
		set
		
	Sight as int:
		get
		set
		
	Moved as int:
		get
		set
		
	ClutterModifier as int:
		get
		set
		
	FeulConsumption as int:
		get
		set
	
	*/