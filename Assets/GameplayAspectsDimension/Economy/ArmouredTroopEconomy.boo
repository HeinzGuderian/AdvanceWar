partial class ArmoredTroop (TroopClass ): 
	static virtual _productionCost as int = 200
	static ProductionCost as int:
		get:
			return _productionCost
		set:
			if(value<0):
				print("Error: New ProductionCost value is under zero!")
				_productionCost = 0
			else:
				_productionCost = value

