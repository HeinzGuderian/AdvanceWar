partial class EngyTroop (TroopClass ): 
	
	override def Awake ():
		_productionCost = 100
		WeaponList = [WeaponSystem(Name: "Infantry close range", Range: 1, HardDamage: 2, HardMinimumDamage: 0, SoftDamage: 2, SoftMinimumDamage: 0 )]
		super()
