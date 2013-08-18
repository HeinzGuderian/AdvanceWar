<?php

$maybeMonad = function($f) {
	return array($f, true);	
};

$maybeMonadFunction = function($maybe_a_monad) {
	return $maybe_a_monad[0];
};

$maybeMonadReturnValue = function($maybe_a_monad) {
	return $maybe_a_monad[1];
};

$bind = function($left_monad, $right_monad) use($maybeMonadFunction, $maybeMonad,$maybeMonadReturnValue  ) {
	$resultFunction = $maybeMonadFunction($right_monad);
	$result = $resultFunction();
    if( $maybeMonadReturnValue($right_monad) == false || $result == false){
		return array($maybeMonadFunction($left_monad), false);
    }
    else{
        $left_monad_return = $maybeMonadFunction($left_monad);
    	return array( $maybeMonadFunction($left_monad), $left_monad_return() );
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
*/
//print(  $maybeMonadReturnValue($cMonad));


?>