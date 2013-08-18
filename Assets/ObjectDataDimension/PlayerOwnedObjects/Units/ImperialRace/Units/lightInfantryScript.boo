#import UnityEngine
#
#class lightInfantryScript (MonoBehaviour, ITroop): 
#	final _weapon as Boo.Lang.Hash = {"softDamage" : 50.0, "hardDamage" : 10.0}
#	_number as System.Int32 = 100
#	_softness as double = 1 
#//	_troopType as LandCombatScript.troopTypes
#	_toughness as double = 0.5
#//	_combatRules as LandCombatScript
#	//targetPriority as LandCombatScript.targetPriority
#	final _speed as double = 50
#	final _className as string = "Light Infantry"
#	
#	
#	
#	ClassName as string:
#		get:
#			return _className
#	
#	Speed as double:
#    	get:
#    		return _speed
#    	
#	Softness as double:
#		get:
#			return _softness
#		set:
#			_softness = value
#			
#	Toughness as double:
#		get:
#			return _toughness
#		set:
#			_toughness = value
#		
#	Number as System.Int32:
#		get:
#			return _number
#		set:
#			_number = value
#	
#	WeaponSoftDamage as double:
#		get:
#			return _weapon["softDamage"] cast double
#		set:
#			_weapon["softDamage"] = value
#		
#	WeaponHardDamage as double:
#		get:
#			return _weapon["hardDamage"] cast double
#		set:
#			_weapon["hardDamage"] = value
#		
#		/*
#	TargetPriority as LandCombatScript.targetPriority:
#		get:
#			return targetPriority
#			*/
#	TroopGameObject as GameObject:
#		get:
#			return gameObject
#	
#	_gameState as GameState
#	def Start ():
#		_gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
#		//_combatRules = _gameState.LandCombatScript
#		//_troopType = _combatRules.troopTypes.infantry
#		//targetPriority = LandCombatScript.targetPriority.higherSoftness
#		checkInit()
#		
#	def checkInit():
#		pass
#	def Update ():
#		pass