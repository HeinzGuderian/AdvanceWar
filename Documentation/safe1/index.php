<?php
require "one_table_manipulation.php";
require "return_if_false_monad.php";
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

function delete_game_on_game_id($gameID , $dbHandle){
	$success = true;
	$success = delete_from_table("troop_class", $dbhandle, " where GameID = {$gameID}");
	if($success == false){	return false;}
	$success = delete_from_table("factory", $dbhandle, " where GameID = {$gameID}");
	if($success == false){	return false;}
	$success = delete_from_table("oilfield", $dbhandle, " where GameID = {$gameID}");
	if($success == false){	return false;}
	$success = delete_from_table("central_warehouse", $dbhandle, " where GameID = {$gameID}");
	if($success == false){	return false;}
	return true;
}




// API info
$start_map_commands = array();

$commands = array('ClearGame', 'RemoveGame', 'InsertGame',  'InsertPlayer',
'InsertTroop','InsertFactory', 'InsertOilfield', 'InsertCentralWarehouse', 
 'InsertSupplyTroop', 'Login', 'CreateAccount', 'GetGames','FindGames', 'LoadGame');
 


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
if($command == 'ClearGame')
{
	
	if( true == delete_game_on_game_id($array['GameID'],$dbhandle)){
		
	}
	else{
		
	}
	mysqli_commit($dbhandle);
}
else if($command == 'RemoveGame')
{
	delete_from_table("games" ,$dbhandle," WHERE games_id = {$array['GameID']}");
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
									'Player1HaveWon' => false  ,
									'Player2HaveWon' => false  ,
									'Player1HaveConceded' => false  ,
									'Player2HaveConceded' => false  ,
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
				echo json_encode( array(0 => array( 'FoundGame' => true, 'GameID' => $gameID, 'Message' => "An opponent was found! Game is available in the game list.")));	
				selectDB("game", $dbhandle);
				//insert_troop_on_gameid(0, $array, $dbhandle);
			}
			else {
				mysqli_rollback($dbhandle); 
				echo json_encode( array(0 => array( 'FoundGame' => false, 'GameID' => "-1", 'Message' => "Server error, game was found but unable to create session.")));	
			}
		}
		
	}
	mysqli_rollback($dbhandle);
	echo json_encode( array(0 => array( 'FoundGame' => false, 'GameID' => "-1", 'Message' => "Server error, game was found but unable to create session.")));
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