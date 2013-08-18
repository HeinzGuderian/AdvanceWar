<?php

$functionOnFalseMonad = function($f, $errorFunction, $successFunction) {
	return array($f, 0, $errorFunction, $successFunction);	
};

$functionOnFalseMonadValue =  function($functionOnFalseMonadInstance) {
	return $functionOnFalseMonadInstance[0];	
};

$functionOnFalseMonadErrorCode =  function($functionOnFalseMonadInstance) {
	return $functionOnFalseMonadInstance[2];	
};

$functionOnFalseMonadSuccessCode =  function($functionOnFalseMonadInstance) {
	return $functionOnFalseMonadInstance[3];	
};


$FOFbind = function($left_monad, $right_monad) use($functionOnFalseMonad, $functionOnFalseMonadValue,$functionOnFalseMonadErrorCode,$functionOnFalseMonadSuccessCode ) {
	if($right_monad[1] == 1){
		return array( false, 1, $left_monad[2], $left_monad[3]) ;	
	}
    else if( $functionOnFalseMonadValue($right_monad) == false){
	    $errorFunction = $functionOnFalseMonadErrorCode($right_monad);
	    $errorFunction();
		return array( false, 1, $functionOnFalseMonadErrorCode($left_monad), $functionOnFalseMonadSuccessCode($left_monad) ) ;
    }
    else if( $left_monad[1] == 2){
	    return array( true, 2, $functionOnFalseMonadErrorCode($left_monad), $functionOnFalseMonadSuccessCode($left_monad) ) ; 
    }
    else{
	    $successFunction = $functionOnFalseMonadSuccessCode($right_monad);
	    $successFunction();
        return array( true, 2, $functionOnFalseMonadErrorCode($left_monad), $functionOnFalseMonadSuccessCode($left_monad) ) ;
	}
};

/*
$isTrue = function($abool){
	return $abool==true;	
};

$a = function() use($isTrue) { return true ; } ;
$b = function() use($isTrue) { return true ; } ;
$c = function() use($isTrue) { return true ; } ;
$aMonad = $maybeMonad($a);
$bMonad = $maybeMonad($b);
$cMonad = $maybeMonad($c);

$dMonad = $bind($cMonad,$bind($aMonad, $bMonad));
if($maybeMonadReturnValue($dMonad) == true){
	print("true");	
}
else{
	print("false");	
}
//print(  $maybeMonadReturnValue($cMonad));
*/

/*
$isTrue = function($abool){
	return $abool==true;	
};

$a1 = $isTrue(true);
$b1 = $isTrue(true);
$c1 = $isTrue(false);

$d = $bind($c1, $bind($a1,$b1));

if( $d == true){
	print("true");	
}
else{
	print("false");	
}
*/
?>