# SubState

An audio player set on a lunar space station.

Features:

1. Listen to the tracks
2. Add log entries associated with each track you are listening to
3. View saved log entries

Core State Objects:

1. SubStatePlayer 
	A. Plays each audio file
	B. Publishes sound sample values for metering levels
	
2. SubState-Evaluator
	A. Loads tracks with a @DataLoader property wrapper
	B. Publishes player values used across app. playPause, playerTime, selectedKey, etc
	
3. LogEntries
	A. Create log entries
	B. Persist log entries
	C. Display log entries


