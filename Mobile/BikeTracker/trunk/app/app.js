$(document).ready(function(){
	//Override.browser.browserMode = true;
	Override.links();
	Override.scroll();
	Override.navbar();
	//Test.viewport();
	var router = new AppRouter();
	Backbone.history.start();
	Storage.Credentials.setId('30201314');
});

var Storage = {

	Credentials : {

		setId : function(id){

			window.localStorage.setItem('id',id);
			return this;

		},

		getId : function(){

			return window.localStorage.getItem('id');

		}

	},

	Ride : {

		saveRide : function(data){
//			alert(window.localStorage);
//			if (window.localStorage){
//				alert("in save ride");
		        window.localStorage.setItem('pending',JSON.stringify(data));
//				alert("in save ride after set LS");
//		    }			
			return this;

		},

		getRide : function(){
//			alert("check");
			alert(window.localStorage.length);
			alert(window.localStorage["pending"]);
			if (!window.localStorage || window.localStorage["pending"]==undefined /*window.localStorage.length < 2*/ ){
			        return null;
		    }
			return JSON.parse(window.localStorage.getItem('pending'));
		}

	}



}


var Override = {

	links : function(){

		$('#navigation li').each(function(){

			var event = '';

			if(Override.browser.browserMode === true){
				event = Override.browser.browserEvent;
			} else {
				event = Override.browser.mobileEvent;
			}

			var _this = $(this);
			_this.bind(event, function(event){
				$('#navigation li').removeClass('active');
				$(this).addClass('active');
				window.location.href = $(this).children('a').first().attr('href');
			});

		});

		$('#navigation a').each(function(){
			var _this = $(this);
			_this.bind('touchstart touchend mouseup',function(event){
				event.preventDefault();
				return false;
			})
		})

	},

	scroll : function(){

		$('body').bind('touchmove',function(event){
			event.preventDefault();
			return false;
		})

	},

	navbar : function(){
		window.scrollTo(0, 1);
	},

	browser : {

		browserMode : false,

		mobileEvent : 'touchend',

		browserEvent : 'mouseup'

	}


}

var Test = {

	viewport : function(){

		alert('width: ' + window.innerWidth + ', height: ' + window.innerHeight);

	}

}

var Utilities = {

	scroller : '',

	formatTime : function(string){

			string = parseInt(string);
			var hours = Math.floor(string / (60*60));
			if(hours < 10){
				hours = '0'+hours;
			}

			var minutesDiv = string % (60 * 60);
			var minutes = Math.floor(minutesDiv / 60);
			if(minutes < 10){
				minutes = '0'+minutes;
			}

			var secondsDiv = minutesDiv % 60;
			var seconds = Math.ceil(secondsDiv);
			if(seconds < 10){
				seconds = '0'+seconds;
			}

			return hours + ':' + minutes + ':' + seconds;

	},

	formatDistance : function(string){

			string = parseInt(string);

			string = string/1000;

			string = string.toString().substring(0,5);

			if(string.length < 3){
				string = string + ',00';
			}

			return string.replace('.',',') + ' KM';

	},

	calculateDistance : function(set1, set2){

		Number.prototype.toRad = function() {
    		return this * Math.PI / 180;
  		}

		if(set1 && set2){

			var R = 6371; // km
			var d = Math.acos(Math.sin(set1.latitude)*Math.sin(set2.latitude) +
                  Math.cos(set1.latitude)*Math.cos(set2.latitude) *
                  Math.cos(set2.longitude-set1.longitude)) * R;

			if(d < .5){
				return 0;
			} else {
				return d;
			}


		} else {
			return false;
		}


	},

	calculateDistance : function(v){

		var t = 3;

		var s = v * t;

		return s;

	},

	getCurrentTime : function(){

		var time = new Date();

		return twoDigit(time.getHours())+':'+twoDigit(time.getMinutes())+':'+twoDigit(time.getSeconds())+' '+twoDigit(time.getDate())+'.'+twoDigit(time.getMonth())+'.'+time.getFullYear();


		function twoDigit(number){

			if(number < 10){
				return '0'+number;
			} else {
				return number;
			}

		}

	},

	getUnixTime : function(){

		return Math.round((new Date()).getTime() / 1000);

	},

	enableScroll : function(){

		this.scroller = new iScroll('content');

	},

	disableScroll : function(){

		this.scroller.destroy();
		this.scroller = null;

	}


}

