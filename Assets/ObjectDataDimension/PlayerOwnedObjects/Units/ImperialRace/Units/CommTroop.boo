partial class CommTroop (TroopClass ): 
	
	[SerializeField]
	_supplyPetrol as int 
	SupplyPetrol as int:
		get:
			return _supplyPetrol
		set:
			if(value<0):
				print("Error: New Petrol value is under zero!")
				_supplyPetrol = 0
			else:
				_supplyPetrol = value
	[SerializeField]
	_supplyAmmo as int 
	SupplyAmmo as int:
		get:
			return _supplyAmmo
		set:
			if(value<0):
				print("Error: New Petrol value is under zero!")
				_supplyAmmo = 0
			else:
				_supplyAmmo = value
	
	override def Awake ():
		WeaponList = [WeaponSystem(Name: "Infantry close range", Range: 1, HardDamage: 2, HardMinimumDamage: 0, SoftDamage: 2, SoftMinimumDamage: 0 )]
		super()
