var Models = {

	Ride : Backbone.Model.extend({

		defaults : {
			start : '',
			stop : '',
			distance : 0,
			route : []
		},

		initialize : function(){


			this.set({'start': Utilities.getUnixTime()});
		},

		addPoint : function(point){
			var arrayLength = this.get('route').length;

			point.longitude = point.longitude.toString().substring(0,5);
			point.latitude = point.latitude.toString().substring(0,5);

//			console.log(point.latitude + ', '+point.longitude);

			this.get('route').push(point);
//			if(arrayLength > 0){
//				if(point.latitude === this.get('route')[arrayLength-1].latitude || point.longitude === this.get('route')[arrayLength-1].longitude){
//					//console.log('CykelScore: no movement.');
//					return false; //no movement done, motionless
//				} else {
//					this.get('route').push(point); //add point;
//					//console.log('CykelScore: point added.');
//				}
//			} else {

//				this.get('route').push(point);
//				//console.log('CykelScore: point added.');

//			}

		},

		send : function(flag){
			//http://cykelscore.dk/_gateways/sendlog.gate.asp?userid=30201314&start=1314761304&stop=1314784581&distance=97555&rute=161.46,45.464;56.46,45.644
			if(flag === 'pending'){

			}
			var _parent = this;
			var postData ='';
			var routeChunk = '';
			var fullRoute = this.get('route');
			var url = 'http://cykelscore.dk/_gateways/sendlog.gate.asp';

			for(;;){

				for(var i = 0; i < 200; i++){

					if(fullRoute[i]){
						routeChunk += fullRoute[i].longitude+','+fullRoute[i].latitude+';';
					} else {
						break;
					}


				}

				if(fullRoute.length <= 0){
					alert('Din tur blev gemt.');
					break;

				} else {

					routeChunk = routeChunk.substring(0,routeChunk.length-1);
					postData = 'userid='+Storage.Credentials.getId()+'&start='+_parent.get('start')+'&stop='+_parent.get('stop')+'&distance='+_parent.get('distance')+'&rute='+routeChunk;
					console.log(postData);

					$.ajax({
						type: 'post',
						url: url,
						data : postData,
						success : function(data){
							console.log('CykelScore: '+data);
						}

					});

					fullRoute.splice(0, 200);

				}

			}
		},

		getLastPoints : function(){

			var set = {
				set1 : this.get('route')[this.get('route').length-1],
				set2 : this.get('route')[this.get('route').length-2]
			}

			if(!set.set1 || !set.set2){
				console.log('CykelScore: not enough points recorded.');
				return false;
			}

			return set;

		}

	}),

	LogItem : Backbone.Model.extend({

		defaults : {
			distance : '',
			time : '',
			date : ''
		},

		initialize : function(userId){
			this.userId = userId;
		}

	})

}

