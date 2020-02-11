Meetup {
	classvar lol="Niklas";
	var <>numberOfParticipants=8;	
	var weather="nice";

	*new{|whatIsTheWeatherLikeToday, numParticipants|

		// Return an instance
		^super.new.init(whatIsTheWeatherLikeToday, numParticipants);
	}	

	init{|whatIsTheWeatherLikeToday, numParticipants|
		weather = whatIsTheWeatherLikeToday ?? weather;
		numberOfParticipants = numParticipants ?? numberOfParticipants;
	}

	welcome{
		"Hello everyone, welcome to this meetup on the date of %".format(Date.getDate).postln;
		"There are % people here today. Great!".format(numberOfParticipants).postln;
		"The weather is % today!".format(weather).postln;
	}

}
