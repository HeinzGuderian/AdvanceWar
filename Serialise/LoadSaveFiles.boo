import UnityEngine

class SaveLoadGameSerialisable (ISaveLoadGame): 
	
	_troopFolderName as string = "Troops"
	_logiFolderName as string = "Logi"
	_factoryFolderName as string = "Factory"
	_oilfieldFolderName as string = "Oilfield"
	_centralWarehouseFolderName as string = "CenralWareHouse"
	//final _gameFolder = Application.persistentDataPath +"/"+GameName 
	//final _troopFolderPath = _gameFolder()+"/"+_troopFolderName
	
	def constructor(gameName as string):
		_gameName = gameName
	
	[SerializeField]
	_gameName as string
	GameName as string:
		get:
			return _gameName
		set:
			_gameName = value



	def DeleteFilesInDirectory(path as string):
		for file as FileInfo in GetFilesInDirectory(path):
			file.Delete()
		
			
	def GetFilesInDirectory(path as string):
		info = DirectoryInfo(path)
		fileInfo = info.GetFiles()
		return fileInfo
		
	
	def _gameFolder(): // Becouse of "ArgumentException: get_persistentDataPath  can only be called from the main thread."
		return Application.persistentDataPath +"/"+GameName
	
	def _troopFolderPath() as string:
		return _gameFolder()+"/"+_troopFolderName
	def _logiFolderPath() as string:
		return _gameFolder()+"/"+_logiFolderName
	def _factoryFolderPath() as string:
		return _gameFolder()+"/"+_factoryFolderName
	def _oilfieldFolderPath() as string:
		return _gameFolder()+"/"+_oilfieldFolderName
	def _centralWarehouseFolderPath() as string:
		return _gameFolder()+"/"+_centralWarehouseFolderName
		
	def SaveGame():
		a = Application.persistentDataPath
		print(Application.persistentDataPath)
		if not Directory.Exists(_gameFolder()):
			Directory.CreateDirectory(_gameFolder())
		if not Directory.Exists(_troopFolderPath()):
			Directory.CreateDirectory(_troopFolderPath())
		if not Directory.Exists(_logiFolderPath()):
			Directory.CreateDirectory(_logiFolderPath())
		if not Directory.Exists(_factoryFolderPath()):
			Directory.CreateDirectory(_factoryFolderPath())
		if not Directory.Exists(_oilfieldFolderPath()):
			Directory.CreateDirectory(_oilfieldFolderPath())
		if not Directory.Exists(_centralWarehouseFolderPath()):
			Directory.CreateDirectory(_centralWarehouseFolderPath())
		
		DeleteFilesInDirectory(_troopFolderPath())
				
		count = 0
		gameFilePath as string = _troopFolderPath()+"/"+"troop"+count+".saveFile"
		for currentGameObject in (GameObject.FindObjectsOfType(TroopClass) as (TroopClass)):
			currentGameObject.GetComponent[of TroopClass]().SaveUnit(gameFilePath)    
			count += 1
			gameFilePath = _troopFolderPath()+"/"+"troop"+count+".saveFile"
		
		count = 0
		gameFilePath = _logiFolderPath()+"/"+"logi"+count+".saveFile"
		for currentGameObject in (GameObject.FindObjectsOfType(LogiTroop) as (LogiTroop)):
			currentGameObject.GetComponent[of LogiTroop]().SaveUnit(gameFilePath)    
			count += 1
			gameFilePath = _logiFolderPath()+"/"+"logi"+count+".saveFile"
			
		count = 0
		gameFilePath = _factoryFolderPath()+"/"+"factory"+count+".saveFile"
		for currentGameObject in (GameObject.FindObjectsOfType(FactoryScript) as (FactoryScript)):
			currentGameObject.GetComponent[of FactoryScript]().SaveUnit(gameFilePath)    
			count += 1
			gameFilePath = _factoryFolderPath()+"/"+"factory"+count+".saveFile"
			
		count = 0
		gameFilePath = _oilfieldFolderPath()+"/"+"oilfield"+count+".saveFile"
		for currentGameObject in (GameObject.FindObjectsOfType(OilfieldScript) as (OilfieldScript)):
			currentGameObject.GetComponent[of OilfieldScript]().SaveUnit(gameFilePath)    
			count += 1
			gameFilePath = _oilfieldFolderPath()+"/"+"oilfield"+count+".saveFile"
			
		count = 0
		gameFilePath = _centralWarehouseFolderPath()+"/"+"centralWarehouse"+count+".saveFile"
		for currentGameObject in (GameObject.FindObjectsOfType(CentralWarehouseScript) as (CentralWarehouseScript)):
			currentGameObject.GetComponent[of CentralWarehouseScript]().SaveUnit(gameFilePath)    
			count += 1
			gameFilePath = _centralWarehouseFolderPath()+"/"+"centralWarehouse"+count+".saveFile"
			
	def constructTypeHash(typeScript as INormalForm) as Boo.Lang.Hash:
			//typeScript = currentGameObject.GetComponent[of type]()
			sendHash = {}
			normalForm = typeScript.ProduceNormalForm()
			LibraryScript.ExtendHash(sendHash, normalForm.propertyInfo)
			LibraryScript.ExtendHash(sendHash, normalForm.metaInfo)
			
			sendHash["Type"] = normalForm.type
			return sendHash
		
	def LoadGame():
		print(Application.persistentDataPath)
		
		//count = 0
		//gameFilePath as string = _troopFolderPath()+"/"+"troop"+count+".saveFile"

		for currentGameObject in (GameObject.FindObjectsOfType(TroopClass) as (TroopClass)):
			Destroy(currentGameObject.gameObject)
		for currentGameObject in (GameObject.FindObjectsOfType(FactoryScript) as (FactoryScript)):
			Destroy(currentGameObject.gameObject)
		for currentGameObject in (GameObject.FindObjectsOfType(OilfieldScript) as (OilfieldScript)):
			Destroy(currentGameObject.gameObject)
		for currentGameObject in (GameObject.FindObjectsOfType(CentralWarehouseScript) as (CentralWarehouseScript)):
			Destroy(currentGameObject.gameObject)
	

		for file in GetFilesInDirectory(_troopFolderPath()):
			TroopClass.CreateUnit( TroopClass.LoadUnit( file.FullName ) )
		for file in GetFilesInDirectory(_logiFolderPath()):
			TroopClass.CreateUnit( TroopClass.LoadUnit( file.FullName ) )
		for file in GetFilesInDirectory(_factoryFolderPath()):
			BuildingScript.CreateUnit( BuildingScript.LoadUnit( file.FullName ) )
		for file in GetFilesInDirectory(_oilfieldFolderPath()):
			BuildingScript.CreateUnit( BuildingScript.LoadUnit( file.FullName ) )
		for file in GetFilesInDirectory(_centralWarehouseFolderPath()):
			BuildingScript.CreateUnit( BuildingScript.LoadUnit( file.FullName ) )