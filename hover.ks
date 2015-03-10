DECLARE PARAMETER TargetAlt.

DECLARE e.

DECLARE Kp. Set Kp to 0.7. //0.005 pretty good

DECLARE Ki. Set Ki to 0.

DECLARE Kd. Set Kd to 0.

//SET TargAlt to 500. // This is the reference!

//DECLARE PARAMETER TargAlt.

SET T to 0.
set I to 0.

LOCK Throttle to T.

LOCK steering TO up + R(0,0,180).
STAGE.
PRINT "Launch!".

SET oldTime to 0. 
SET curTime to 0. 

SET olde to 0. 
SET e to 0.

UNTIL (stage:liquidfuel < 5) {

	SET TargAlt to (TargetAlt - Altitude).
	SET oldTime to curtime.
	SET curTime to MISSIONTIME.
	SET dt to curTime - oldTime.

	SET olde to e.
	SET e to (TargAlt - VERTICALSPEED).

	SET P to e.
	SET I to I + e*dt.
	SET D to (e - olde) / (dt + 0.0000000000001).

	SET T To (P*kp + I*Ki + D*Kd). //should be between 0 & 1

	IF T > 1 {
		Set T to 1.
	}.
	
	IF T < 0 {
		SET T to 0.
	}.

	//lock THROTTLE to T.

	// Print info
	ClearScreen.
	Print "T" at (1,1).
	Print "Error" at  (1,2).
	Print "P" at (1,3).
	Print "I" at (1,4).
	Print "Speed" at (1,5).

	Print THROTTLE at (10,1).
	Print Floor(e) at (10,2).
	Print (P*kp) at (10,3).
	Print (I*Ki) at (10,4).
	Print VERTICALSPEED at (10,5).
	WAIT 0.1.
}.
