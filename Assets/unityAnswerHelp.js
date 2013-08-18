#pragma strict
import System.Collections.Generic;
var _score : int = 4;
var CurrentResponse : ResponseEnum = ResponseEnum.responeNice;
var _responseHash : Hashtable = new Hashtable(); 

function Start () {
	PlayerTappedTarget();
}

function Update () {

}

function TellPlayerSomethingNice (){
	print("Hello");
	print(_score);
}

function addScore (newValue : int){
	_score += newValue;
}

enum ResponseEnum {
     responeNice,
     responseNasty
     }
class ResponseStruct extends System.ValueType
{
    var response : ResponseEnum; 
    
    var functionList : List.<Function>;
    public function ResponseStruct(response:ResponseEnum, functionList: List.<Function>){
     	this.response = response;
     	this.functionList = functionList;
  	}
  	/*
    OR      
    */
    /*
  	var codeBlock : Function;
  	public function ResponseStruct(response:ResponseEnum, codeBlock:Function){
     	this.response = response;
     	this.codeBlock = codeBlock;
  	}
  	*/
  	
}


var code1 : List.<Function> = new List.<Function>();
code1.Add(TellPlayerSomethingNice);
code1.Add(function() { addScore(1); });
code1.Add(function() { WaitForSeconds (6); });
code1.Add(function() { StartCoroutine("TellPlayerSomethingNice"); });
//OR

/*
var code1  = 
function() 
{ 
	TellPlayerSomethingNice(); 
	//yield WaitForSeconds (20);
	//yield;
	addScore(1);
};
*/

var responseStruct1 : ResponseStruct = new ResponseStruct(ResponseEnum.responeNice, code1);
_responseHash.Add(responseStruct1.response, responseStruct1);

function PlayerTappedTarget(){
	ExecuteResponse(CurrentResponse);
}

function ExecuteResponse(currentResponseEnum : ResponseEnum){
	var correctResponse : ResponseStruct = _responseHash[currentResponseEnum];
	
	for (var functionInList : Function in correctResponse.functionList) 
	{ 
		yield functionInList();
	}
	
	// OR
	/*
	correctResponse.codeBlock();
	*/
}
	