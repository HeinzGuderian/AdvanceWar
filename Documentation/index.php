<?php

/*
$Pass = "Passwort";
$Clear = "Klartext";


$crypted = fnEncrypt($Clear, $Pass);
echo "Encrypred: ".$crypted."</br>";

$newClear = fnDecrypt($crypted, $Pass);
echo "Decrypred: ".$newClear."</br>";
*/


function fnEncrypt($sValue, $sSecretKey)
{
    return rtrim(
        base64_encode(
            mcrypt_encrypt(
                MCRYPT_RIJNDAEL_128,
                $sSecretKey, $sValue, 
                MCRYPT_MODE_ECB, 
                mcrypt_create_iv(
                    mcrypt_get_iv_size(
                        MCRYPT_RIJNDAEL_128, 
                        MCRYPT_MODE_ECB
                    ), 
                    MCRYPT_RAND)
                )
            )
        , "\0");
}

function fnDecrypt($sValue, $sSecretKey)
{
    return rtrim(
        mcrypt_decrypt(
            MCRYPT_RIJNDAEL_128, 
            $sSecretKey, 
            base64_decode($sValue), 
            MCRYPT_MODE_ECB,
            mcrypt_create_iv(
                mcrypt_get_iv_size(
                    MCRYPT_RIJNDAEL_128,
                    MCRYPT_MODE_ECB
                ), 
                MCRYPT_RAND
            )
        )
    , "\0");
}

function connect_to_db() {
	$username = "root";
	$password = "";
	$hostname = "localhost"; 

	//connection to the database
	$dbhandle = mysqli_connect($hostname, $username, $password);
	if (!$dbhandle)
	{
		echo mysql_error();
		die('Could not connect: ' . mysql_error());
	}
	return $dbhandle;
}

function selectDB($db_name, $db_handle){
	//print "derp \n";
	$selected = mysqli_select_db($db_handle, $db_name); 
	return $selected;
}

function login($user,$password, $dbhandle){
	$returnArray =load_table_on_gameid("accounts", $dbhandle, "WHERE AccountName = '{$user}'");
	//$localArray = array( 0 => array( login($user,$password, $dbhandle) ) )	;
	if($returnArray == null){
		return array( 0 => array( 'UserError' => true, 'PasswordError' => false, 'ErrorMessage' => 'User not found','Success' => false ));	
	}
	if($password == $returnArray[0]["Password"]){
		return array( 0 => array( 'UserError' => false, 'PasswordError' => false, 'ErrorMessage' => '', 'Success' => true));
	}
	else{
		return array( 0 => array( 'UserError' => true, 'PasswordError' => true, 'ErrorMessage' => 'Incorrect password','Success' => false));
	}
}

function create_account($user,$password,$newArray, $dbhandle){
	//$returnArray =load_table_on_gameid("accounts", $dbhandle, "WHERE AccountName = {$user}");
	//$localArray = array( 0 => array( login($user,$password, $dbhandle) ) )	;
	$accountArray = login($user,$password, $dbhandle);
	
	if($accountArray[0]["UserError"]  != true){
		return array( 0 => array( 'UserError' => true, 'PasswordError' => false, 'ErrorMessage' => 'User already exists','Success' => false ));	
	}
	else{
		if( true == insert_array_in_table_on_gameid("accounts", $newArray, $dbhandle)){
			mysqli_commit($dbhandle);
			return array( 0 => array( 'UserError' => false, 'PasswordError' => false, 'ErrorMessage' => '', 'Success' => true));
			//insert_troop_on_gameid(0, $array, $dbhandle);
		}
		else {
			mysqli_rollback($dbhandle); 
			return array( 0 => array( 'UserError' => false, 'PasswordError' => true, 'ErrorMessage' => 'Insert failed', 'Success' => true));
		}
	}
	
}

function load_and_create_game_from_startgames($dbHandle, $whereClause,$newGameArray ){
	$tables = array(0 => "troop_class",
					1 => "factory",
					2 => "oilfield",
					3 => "central_warehouse",
					4 => "player");
					
	$startGameArray = array();
					
	selectDB("start_game", $dbHandle);
	foreach($tables as $name => $value) {
		$startGameArray[$value] = load_table_on_gameid($value,$dbHandle,$whereClause);
	}
	$success = true;
	selectDB("game", $dbHandle);
	$success = insert_array_in_table_on_gameid("games", $newGameArray, $dbHandle);
	$gameID = mysqli_insert_id($dbHandle);
	foreach($tables as $name => $value) {
		//$startGameArray[$value] = load_table_on_gameid($value,$dbhandle,$whereClause);
		for($i=0; $i<count($startGameArray[$value]); $i++) { 
			unset($startGameArray[$value][$i]['MapID']);
			$startGameArray[$value][$i]["GameID"] = $gameID;
			unset($startGameArray[$value][$i][$value."_id"]);
			$success = insert_array_in_table_on_gameid($value, $startGameArray[$value][$i], $dbHandle);
			
		}
		
		
	}
	return $success;
	/*
	return array_merge(
			load_table_on_gameid("troop_class", $dbhandle,$whereClause ), 
			load_table_on_gameid("factory", $dbhandle,$whereClause ),  
			load_table_on_gameid("oilfield", $dbhandle,$whereClause ), 
			load_table_on_gameid("central_warehouse", $whereClause ), 
			load_table_on_gameid("player", $dbhandle,$whereClause ), 
			load_table_on_gameid("games", $dbhandle,$whereClause ) );
			
	insert_array_in_table_on_gameid($tableName, $newArray, $dbhandle)
	
	
			
	load_table_on_gameid("troop_class", $dbhandle,gameID_where_clause($array['GameID'], "troop_class")), 
			load_table_on_gameid("factory", $dbhandle,gameID_where_clause($array['GameID'], "factory")),  
			load_table_on_gameid("oilfield", $dbhandle,gameID_where_clause($array['GameID'], "oilfield")), 
			load_table_on_gameid("central_warehouse", $dbhandle,gameID_where_clause($array['GameID'], "central_warehouse")), 
			load_table_on_gameid("player", $dbhandle,gameID_where_clause($array['GameID'], "player")), 
			load_table_on_gameid("games", $dbhandle,gameID_where_clause($array['GameID'],"games")) )      );
			*/
}

function gameID_where_clause($gameID, $tableName){
	$SQLWhereClause = "";
	if($gameID > 0){
		$IsGamesTable = false;
		if($tableName == "games"){
			$IsGamesTable = true;
			$SQLWhereClause = "games_id = {$gameID}";
		}
		else{
			$SQLWhereClause = "GameID = {$gameID}";
		}
		$SQLWhereClause =  " WHERE ".$SQLWhereClause;
	}
	return $SQLWhereClause;
}

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

function load_troops_on_gameid($gameID, $dbhandle){

	$SQL = "SELECT * FROM troop_class ";
	$result = mysqli_query($dbhandle,$SQL);
	$newArray = array();
	$index = 0;
	if($result == false){
		printf("error: %s\n", mysqli_error($dbhandle));
		print("Error1");
	}
	
	while ($db_field = mysqli_fetch_assoc($result)) 
	{
		$newArray[$index]['GameID'] = $db_field['GameID'];
		//print($db_field['GameID'] . $gameID);
		if($db_field['GameID'] == $gameID)
		{
			$newArray[$index]['Health'] = $db_field['Health'];
			$newArray[$index]['CombatInitiative'] = $db_field['CombatInitiative'];
			$newArray[$index]['Spotted'] = $db_field['Spotted'];
			$newArray[$index]['Entrenched'] = $db_field['Entrenched'];
			$newArray[$index]['Initiative'] = $db_field['Initiative'];
			$newArray[$index]['Ammo'] = $db_field['Ammo'];
			$newArray[$index]['Petrol'] = $db_field['Petrol'];
			$newArray[$index]['ActionPoints'] = $db_field['ActionPoints'];
			$newArray[$index]['IsMoving'] = $db_field['IsMoving'];
			$newArray[$index]['PositionX'] = $db_field['PositionX'];
			$newArray[$index]['PositionY'] = $db_field['PositionY'];
			$newArray[$index]['PositionZ'] = 0;
			$newArray[$index]['Team'] = $db_field['Team'];
			$newArray[$index]['Name'] =  $db_field['Name'];
			$newArray[$index]['Type'] =  $db_field['Type'];
		}
		$index += 1;
	}
	return $newArray;
}

function delete_troop_on_gameid($gameID, $tableName, $dbhandle){
	$sqlString = "delete from {$tableName}  where GameID = '{$gameID}'";
	$result = mysqli_query($dbhandle, $sqlString);
	if($result == false)
	{
		printf("error: %s\n", mysqli_error($dbhandle));
		print("Error1");
	}
	return $result;
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

function insert_troop_on_gameid($gameID, $newArray, $dbhandle){
	//foreach($newArray as $name => $value) {	//print "$name : $value \n";}	
	//print " $newArray[PositionX] $newArray[PositionY] $newArray[PositionZ] $newArray[Team] $newArray[Name] \n"; 
	if (isset($newArray['Health']) and isset($newArray['CombatInitiative']) and isset($newArray['Spotted']) and isset($newArray['Entrenched']) and isset($newArray['Initiative']) and isset($newArray['Ammo']) and isset($newArray['Petrol']) and isset($newArray['ActionPoints']) and $newArray['IsMoving']   and $newArray['PositionX']  and $newArray['PositionY'] and $newArray['Team'] and $newArray['Name'] and $newArray['Type'] ){
		$array = array();
		$sqlString = "INSERT INTO troop_class (GameID,Health ,CombatInitiative , Spotted , Entrenched, Initiative, Ammo, Petrol, ActionPoints, IsMoving, PositionX, PositionY, PositionZ, Team, Name, Type  ) 
		VALUES ('{$newArray['GameID']}','{$newArray['Health']}' ,'{$newArray['CombatInitiative']}' , '{$newArray['Spotted']}' , '{$newArray['Entrenched']}', '{$newArray['Initiative']}', '{$newArray['Ammo']}', '{$newArray['Petrol']}', '{$newArray['ActionPoints']}', '{$newArray['IsMoving']}', '{$newArray['PositionX']}', '{$newArray['PositionY']}', 0, '{$newArray['Team']}', '{$newArray['Name']}', '{$newArray['Type']}'  ) 
		";
		$result = mysqli_query($dbhandle,$sqlString);
		if($result == false){
			printf("error: %s\n", mysqli_error($dbhandle));
			echo mysql_error();
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

function insert_supply_troop_on_gameid($supplyID, $newArray, $dbhandle){
	//foreach($newArray as $name => $value) {	//print "$name : $value \n";}	
	//print " $newArray[PositionX] $newArray[PositionY] $newArray[PositionZ] $newArray[Team] $newArray[Name] \n"; 
	if (isset($newArray['SupplyPetrol']) and isset($newArray['SupplyAmmo']) and isset($newArray['VictoryResources']) and isset($newArray['LoadWeight']) and isset($newArray['MaxWeight'])){
		$array = array();
		$sqlString = "INSERT INTO supply_unit (troop_class_id,SupplyPetrol ,SupplyAmmo, VictoryResources, LoadWeight, MaxWeight) 
		VALUES ('{$supplyID}','{$newArray['SupplyPetrol']}' ,'{$newArray['SupplyAmmo']}' , '{$newArray['VictoryResources']}' , '{$newArray['LoadWeight']}', '{$newArray['MaxWeight']}') 
		";
		$result = mysqli_query($dbhandle,$sqlString);
		if($result == false){
			print("Error3");
			return false;
		}
		return true;
	}
	else{
		echo("Wrong");
		return false;
	}
}

$array = array();
foreach($_POST as $name => $value) {

$array[$name] = $value;
//print "$name : $array[$name] \n";
}
$dbhandle = connect_to_db();
mysqli_autocommit($dbhandle, FALSE);
selectDB("game", $dbhandle);
if (isset($array['Command'] )){
$command = $array['Command'];
unset($array['Command']);
if($command == 'DeleteGame')
{
	delete_troop_on_gameid($array['GameID'],"troop_class", $dbhandle);
	delete_troop_on_gameid($array['GameID'],"factory", $dbhandle);
	delete_troop_on_gameid($array['GameID'],"oilfield", $dbhandle);
	delete_troop_on_gameid($array['GameID'],"central_warehouse", $dbhandle);
	
	mysqli_commit($dbhandle);
}
else if($command == 'InsertGame')
{
	//if( true == insert_troop_on_gameid($array['GameID'], $array, $dbhandle)){
	$array['games_id']	= $array['GameID'];
	unset($array['GameID']);
	//unset($array['games_id']);
	if( true == insert_array_in_table_on_gameid("games", $array, $dbhandle)){
		mysqli_commit($dbhandle);
		//insert_troop_on_gameid(0, $array, $dbhandle);
	}
	else {
		mysqli_rollback($dbhandle); 
	}
}
else if($command == 'InsertPlayer')
{
	//if( true == insert_troop_on_gameid($array['GameID'], $array, $dbhandle)){
	if( true == insert_array_in_table_on_gameid("player", $array, $dbhandle)){
		mysqli_commit($dbhandle);
		//insert_troop_on_gameid(0, $array, $dbhandle);
	}
	else {
		mysqli_rollback($dbhandle); 
	}
}

else if($command == 'InsertTroop')
{
	//if( true == insert_troop_on_gameid($array['GameID'], $array, $dbhandle)){
	if( true == insert_array_in_table_on_gameid("troop_class", $array, $dbhandle)){
		mysqli_commit($dbhandle);
		//insert_troop_on_gameid(0, $array, $dbhandle);
	}
	else {
		mysqli_rollback($dbhandle); 
	}
}

else if($command == 'InsertFactory')
{
	//if( true == insert_troop_on_gameid($array['GameID'], $array, $dbhandle)){
	if( true == insert_array_in_table_on_gameid("factory", $array, $dbhandle)){
		mysqli_commit($dbhandle);
		//insert_troop_on_gameid(0, $array, $dbhandle);
	}
	else {
		mysqli_rollback($dbhandle); 
	}
}
else if($command == 'InsertOilfield')
{
	//if( true == insert_troop_on_gameid($array['GameID'], $array, $dbhandle)){
	if( true == insert_array_in_table_on_gameid("oilfield", $array, $dbhandle)){
		mysqli_commit($dbhandle);
		//insert_troop_on_gameid(0, $array, $dbhandle);
	}
	else {
		mysqli_rollback($dbhandle); 
	}
}
else if($command == 'InsertCentralWarehouse')
{
	//if( true == insert_troop_on_gameid($array['GameID'], $array, $dbhandle)){
	if( true == insert_array_in_table_on_gameid("central_warehouse", $array, $dbhandle)){
		mysqli_commit($dbhandle);
		//insert_troop_on_gameid(0, $array, $dbhandle);
	}
	else {
		mysqli_rollback($dbhandle); 
	}
}
else if($command == 'InsertSupplyTroop')
{
	
	$subclassArray = array(
		"SupplyPetrol" => $array["SupplyPetrol"],
		"SupplyAmmo" => $array["SupplyAmmo"],
		"VictoryResources" => $array["VictoryResources"],
		"LoadWeight" => $array["LoadWeight" ],
		"MaxWeight" => $array["MaxWeight"]
	);
	foreach($subclassArray as $name => $value) {	//print "$name : $value \n";
		unset($array[$name]);
	}	
	if( true == insert_array_in_table_on_gameid("troop_class", $array, $dbhandle)){
		$id = mysqli_insert_id($dbhandle);
		insert_subclass_on_gameid($id, "supply_unit", $subclassArray, $dbhandle);
		mysqli_commit($dbhandle);
	}
	else {
		mysqli_rollback($dbhandle); 
	}
	
}
else if($command == 'Login')
{
	unset($array['GameID']);
	echo json_encode(  login($array['AccountName'],$array['Password'], $dbhandle)  );	
	 
}
else if($command == 'CreateAccount')
{
	unset($array['GameID']);
	echo json_encode(  create_account($array['AccountName'],$array['Password'], $array,  $dbhandle)  );	
	 
}
else if($command == 'GetGames')
{
	unset($array['GameID']);
	//print($array['AccountName']);
	echo json_encode(  load_table_on_gameid("games", $dbhandle, "WHERE Player1 = '{$array['AccountName']}' or Player2 = '{$array['AccountName']}' " )  );	
	 
}
else if($command == 'FindGames')
{
	unset($array['GameID']);
	$playerArray = load_table_on_gameid("game_searching_player", $dbhandle, "LIMIT 1" );
	//print($playerArray);
	if($playerArray == null){
		
		if (true ==insert_array_in_table_on_gameid("game_searching_player", $array, $dbhandle)){
			mysqli_commit($dbhandle);	
			echo json_encode( array(0 => array( 'FoundGame' => false, 'Game' =>  null, 'Message' => "Searching for game")));
		}
		else{
			mysqli_rollback($dbhandle);
			echo json_encode( array(0 => array( 'FoundGame' => false, 'Game' =>  null, 'Message' => "Insert search game failed, maybe database is in maintenence. \n Try again later.")));
		}
		
	}
	else{
		if($playerArray[0]["AccountName"] == $array['AccountName'])
		{
			echo json_encode( array(0 => array( 'FoundGame' => false, 'Game' =>  null, 'Message' => "You are already searching for a game.")));
		}
		else{
			$success = true;
			$success = delete_from_table("game_searching_player", $dbhandle, "WHERE AccountName = '{$playerArray[0]['AccountName']}' ");
			$newGameArray = array( 'Player1' => $array['AccountName'] ,
									'Player2' => $playerArray[0]['AccountName']	 ,
									'WhosTurn' => 0, 
									'TurnHasEnded' => false,
									'HaveWon' => false  ,
									'TurnNumber' => 0 ,
									'MapID' => $array['MapID'] ,
									'Type' => "GameState" );
			//$success == insert_array_in_table_on_gameid("games", $newGameArray, $dbhandle);
			$success= load_and_create_game_from_startgames($dbhandle," WHERE MapID = {$array['MapID']}", $newGameArray) ;
			if($success	== true){
				$gameID = mysqli_insert_id($dbhandle);
				mysqli_commit($dbhandle);
				//selectDB("start_game", $dbhandle);
				//load_table_on_gameid("game_searching_player", $dbhandle, "LIMIT 1");
				//$gameStartArray = load_game_from_startgames($dbhandle," WHERE MapID = {$array['MapID']}", $newGameArray) ;
				echo json_encode( array(0 => array( 'FoundGame' => true, 'GameID' => $gameID, 'Message' => "An opponent was found! Game is available in teh game list.")));	
				selectDB("game", $dbhandle);
				//insert_troop_on_gameid(0, $array, $dbhandle);
			}
			else {
				mysqli_rollback($dbhandle); 
				echo json_encode( array(0 => array( 'FoundGame' => false, 'GameID' => "-1", 'Message' => "Server error, game was found but unable to create session.")));	
			}
		}
		
	}
	//echo json_encode(  load_table_on_gameid("games", $dbhandle, "WHERE Player1 = {$array['AccountName']} or Player2 = {$array['AccountName']} " )  );	
	 
}
else if($command == 'LoadGame')
{
	
	//load_table_on_gameid($tableName, $dbhandle, $WhereClause)
	//array_merge(load_table_on_gameid($array['GameID'], "troop_class", $dbhandle), load_table_on_gameid($array['GameID'], "factory", $dbhandle)) 
	//print($array['GameID']);
	//print("\n".$array);
	echo json_encode( 
		array_merge(
			load_table_on_gameid("troop_class", $dbhandle,gameID_where_clause($array['GameID'], "troop_class")), 
			load_table_on_gameid("factory", $dbhandle,gameID_where_clause($array['GameID'], "factory")),  
			load_table_on_gameid("oilfield", $dbhandle,gameID_where_clause($array['GameID'], "oilfield")), 
			load_table_on_gameid("central_warehouse", $dbhandle,gameID_where_clause($array['GameID'], "central_warehouse")), 
			load_table_on_gameid("player", $dbhandle,gameID_where_clause($array['GameID'], "player")), 
			load_table_on_gameid("games", $dbhandle,gameID_where_clause($array['GameID'],"games")) )      );
	
	
}
}
mysqli_close($dbhandle);
//print "hi";



?>