<?php



function load_table_on_gameid($tableName, $dbhandle, $WhereClause){
	
	
	$SQL = "SELECT * FROM {$tableName} ";
	if($WhereClause != NULL or  $WhereClause != ""){
		$SQL .= $WhereClause ;
	}
	
	$result = mysqli_query($dbhandle,$SQL);
	$newArray = array();
	$index = 0;
	if($result == false){
		printf("error: %s\n", mysqli_error($dbhandle));
		print("\n{$SQL}");
		return null;
	}
	
	
	while ($db_field = mysqli_fetch_assoc($result)) 
	{
		/*
		if($IsGamesTable == true){	}
		else{
			$newArray[$index]['GameID'] = $db_field['GameID'];
		}
		*/
		//print($db_field['GameID'] . $gameID);
		//$insertString = "";
		//$valueString = "";
		foreach($db_field as $name => $value) {	//print "$name : $value \n";
			//$insertString .= $name.",";
			//$valueString .= "'{$value}'".",";
			$newArray[$index][$name] = $value;
			//print( $newArray[$index][$name]."\n");
		}
		
		//if($IsGamesTable == true){	
		//	unset($newArray[$index]['games_id']);
		//}
		$index += 1;
	}
	//printf("error: %s\n", mysqli_error($dbhandle));
	return $newArray;
}

function delete_from_table($tableName, $dbhandle,$whereClause){
	$sqlString = "delete from {$tableName} ";
	$sqlString .= $whereClause; //  where GameID = '{$gameID}'";
	$result = mysqli_query($dbhandle, $sqlString);
	if($result == false)
	{
		printf("error: %s\n", mysqli_error($dbhandle));
		print("Error1");
	}
	return $result;
}

function insert_array_in_table_on_gameid($tableName, $newArray, $dbhandle){
	$insertString = "";
	$valueString = "";
	$updateClause = "";
	foreach($newArray as $name => $value) {	//print "$name : $value \n";
		$insertString .= $name.",";
		$valueString .= "'{$value}'".",";
		$updateClause .= $name."=VALUES(".$name."),";
		//print( $value."\n");
	}
	$updateClause = rtrim($updateClause, ",");	
	$insertString = rtrim($insertString, ",");
	$valueString = rtrim($valueString, ",");
	//print( $insertString."\n");
	//print( $valueString."\n");
	//print " $newArray[PositionX] $newArray[PositionY] $newArray[PositionZ] $newArray[Team] $newArray[Name] \n"; 
	if (true){
		$array = array();
		$sqlString = "INSERT INTO {$tableName} ( {$insertString}  ) 
		VALUES ({$valueString})  ON DUPLICATE KEY UPDATE {$updateClause}  
		";
		
		//print( "\n".$sqlString."\n");
		$result = mysqli_query($dbhandle,$sqlString);
		if($result == false){
			printf("error: %s\n", mysqli_error($dbhandle));
			print("\n{$sqlString}");
			return false;
		}
		else {
			return true;
		}
	}
	else{
		echo("Wrong");
		return false;
	}
}

function insert_subclass_on_gameid($newID, $tableName, $newArray, $dbhandle){
	$insertString = "";
	$valueString = "";
	$updateClause = "";
	foreach($newArray as $name => $value) {	//print "$name : $value \n";
		$insertString .= $name.",";
		$valueString .= "'{$value}'".",";
		$updateClause .= $name."=VALUES(".$name."),";
		print( $value."\n");
	}	
	$updateClause = rtrim($updateClause, ",");	
	$insertString = rtrim($insertString, ",");
	$valueString = rtrim($valueString, ",");
	//print( $insertString."\n");
	//print( $valueString."\n");
	//print " $newArray[PositionX] $newArray[PositionY] $newArray[PositionZ] $newArray[Team] $newArray[Name] \n"; 
	if (true){
		$array = array();
		$sqlString = "INSERT INTO {$tableName} ( {$tableName}_id , {$insertString}  ) 
		VALUES ({$newID} ,{$valueString})  ON DUPLICATE KEY UPDATE {$updateClause}  
		";
		//$sqlString = "INSERT INTO {$tableName} (troop_class_id,SupplyPetrol ,SupplyAmmo, VictoryResources, LoadWeight, MaxWeight) 
		//VALUES ('{$supplyID}','{$newArray['SupplyPetrol']}' ,'{$newArray['SupplyAmmo']}' , '{$newArray['VictoryResources']}' , '{$newArray['LoadWeight']}', '{$newArray['MaxWeight']}') 
		//";
		$result = mysqli_query($dbhandle,$sqlString);
		if($result == false){
			printf("error: %s\n", mysqli_error($dbhandle));
			printf("\nsql: %s\n", $sqlString);
			return false;
		}
		return true;
	}
	else{
		echo("Wrong");
		return false;
	}
}

?>