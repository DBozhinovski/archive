var Tracker = {

	ride : {},

	currentSpeed : 0,

	timer : 0,

	distance : 0,

	start : function(){

		var _parent = this;
		this.watcher = navigator.geolocation.watchPosition(onSuccess, onError, {frequency: 3000});

		function onSuccess(position){

			_parent.currentSpeed = position.coords.speed;
			$('#connectivity').addClass('connected');
			if((_parent.currentSpeed * 3.6) >= 40){
				//issue warning, going too fast
				alert('Du kører hurtigere end 40km/t. Din tur kan ikke logges.');
				_parent.stop();
			} else if(_parent.currentSpeed === 0){
				$('#speed > .value').text('0');
				return;
			} else {
				$('#speed > .value').text(_parent.currentSpeed * 3.6);
				var set = {'latitude':position.coords.latitude, 'longitude':position.coords.longitude};

	//			calculation by coordinates - not accurate / fast enough

	//			points = _parent.ride.getLastPoints();

	//			if(!points){
	//				_parent.ride.addPoint(set);
	//				return;
	//			} else {
	//				_parent.ride.addPoint(set);
	//				points = _parent.ride.getLastPoints();
	//				var distance = Utilities.calculateDistance(points.set1, points.set2);
	//				if(distance !== false && distance !== 0){
	//					_parent.distance = _parent.distance + distance;
	//					$('#distance > .value').text(_parent.distance);
	//				}
	//				return;
	//			}

				_parent.ride.addPoint(set);

				_parent.distance = _parent.distance + Utilities.calculateDistance(_parent.currentSpeed);
				$('#distance > .value').text(_parent.distance);

			}

		}

		function onError(error){
			alert('Der var et problem med GPS forbindelsen. Tjek venligst at GPS er slået til på din enhed.');
			console.log(error);
		}

		var seconds = 0;
		var time = '';
		_parent.timer = setInterval(function(){

			seconds++;

			time = Utilities.formatTime(seconds);

			$('#timer > .value').text(time);

		},1000);

	},

	stop : function(){
		_parent = this;
		navigator.geolocation.clearWatch(_parent.watcher);
		clearInterval(_parent.timer);
		_parent.ride.set({'distance':_parent.distance, 'stop':Utilities.getUnixTime()});
		//console.log(_parent.ride);

		//Check for connection, send if present
		if(navigator.onLine){
			_parent.ride.send();
		} else {
			alert('En internetforbindelse er krævet for at gemme din tur. Den bliver gemt på enheden indtil der opnås en internetforbindelse.');
			Storage.Ride.saveRide(_parent.ride);
		}


		//If connection not present, store locally to send once connected (with pending flag)



		_parent.ride = new Models.Ride();
		//console.log(Storage.Ride.getRide());
		_parent.distance = 0;
		_parent.currentSpeed = 0;
		$('#distance > .value').text('0');
		$('#speed > .value').text('0');

	}

}

