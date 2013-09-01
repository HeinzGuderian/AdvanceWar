interface IMove(): 
	def AllowedToMove(targetTerrain as GameObject, troopClass as TroopClass) as bool
