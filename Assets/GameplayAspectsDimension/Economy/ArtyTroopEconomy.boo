partial class ArtyTroop (TroopClass ): 
	static virtual _productionCost as int = 300
	static ProductionCost as int:
		get:
			return _productionCost
		set:
			if(value<0):
				print("Error: New ProductionCost value is under zero!")
				_productionCost = 0
			else:
				_productionCost = value

