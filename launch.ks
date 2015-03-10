set t to 4.
set tVal to 1.
set SHIP:CONTROL:PILOTMAINTHROTTLE to 0.
set mode to 1.
set txtMode to "".
set nodeAdded to false.
SAS off.
RCS off.
GEAR off.

lock vel to floor(SHIP:VELOCITY:SURFACE:MAG).
lock alt to round(SHIP:ALTITUDE, 2).
lock STEERING to HEADING(90, 90) + R(0, 0, 270).
lock THROTTLE to tVal.
lock pitch to round(90 - 90 * alt/40000, 2).
lock OrbVel to SHIP:VELOCITY:ORBIT.

clearscreen.

print "Launch in:".
until t < 0 {
	print round(t)+"   " at (11, 0).
	if (t < 1) {
		print "Main Engine Start" at (0, 1).
		stage.
	}
	set t to t-0.5.
	wait 0.5.
}
stage.

until (mode = 0) {

	if (pitch < 5){
		set pitch to 5.
	}.
	
	if (mode = 1){//Ascent to 1000m
		set txtMode to "Ascent to 1000m.".
		set tVal to 1.
		if (alt > 1000){
			set mode to 2.
		}
		wait 0.2.
	} else if (mode = 2) {//Grav. turn to 40Km
		set txtMode to "Grav turn to 40Km".

		if (alt > 30000){
			set tVal to 1.
		} else {
			set tVal to 0.5.
		}
		lock STEERING to HEADING(90, pitch) + R(0, 0, 270).
		if (SHIP:APOAPSIS > 75000){
			set mode to 3.
		}
		wait 0.2.
	} else if (mode = 3) {
		set txtMode to "Coast to Apoapsis.".
		set tVal to 0.
		lock STEERING to OrbVel:DIRECTION + R(0, 0, 270).
		if (alt > 70000){
			set mode to 4.
		}
		wait 0.2.
	} else if (mode = 4) {
		set txtMode to "Create Node.".
		if (nodeAdded = false){
			set myNode to NODE(TIME:SECONDS+ETA:APOAPSIS, 0, 0, 300).
			add myNode.
			set nodeAdded to true.
		} else {
			set mode to 5.
			set nodeAdded to false.
		}
	} else if (mode = 5) {
		set txtMode to "Execute Node.".
		lock steering to myNode:DELTAV:DIRECTION + R(0, 0, 270).
		wait 2.
		set mode to 6.
	} else if (mode = 6){
		run execNode.ks.
		set mode to 0.
	}

	if (STAGE:LIQUIDFUEL < 0.2){
		set tVal to 0.
		lock THROTTLE to tVal.
		wait 0.5.
		stage.
		wait 1.
	}.		
	
	clearscreen.
	print "==========================".
	print "Mode:  "+ txtMode at (0, 1).
	print "Alt:   "+ alt at (0, 2).
	print "Pitch: "+ pitch at (0, 3).
	print "tVal:  "+ tVal at (0, 4).
	print "AP:    "+ round(APOAPSIS, 2) at (0, 5).
	print "PE:    "+ round(PERIAPSIS, 2) at (0, 6).
	print "==========================" at (0, 7).
}

//panels on.

wait 10.
clearscreen.
