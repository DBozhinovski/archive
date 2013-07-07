var Views = {

	TrackView : Backbone.View.extend({

		el : '#content',

		initialize : function(){

			if(Utilities.scroller){
				Utilities.disableScroll();
			}

			$('#navigation > li').removeClass('active');
			$('#navigation > li').eq(0).addClass('active');

		},

		events : function(){

		},

		render : function(){
			_el = $(this.el);
			_parent = this;
			console.log('CykelScore: attempting to render...');
			_el.anim({translate3d : window.innerWidth + 'px, 0, 0'}, .2, 'ease-out', function(){

				_el.empty();
				_el.html($('#templates > #trackerTemplate').html());
				_el.anim({translate3d : '-' + window.innerWidth + 'px, 0, 0'},0,'ease-out', function(){
					_el.anim({translate3d : '0, 0, 0'},.2,'ease-in');
					_parent.bindStart();
				});
				console.log('CykelScore: template loaded');


			});




		},

		bindStart : function(){

			var event = '';

			if(Override.browser.browserMode === true){
				event = Override.browser.browserEvent;
			} else {
				event = Override.browser.mobileEvent;
			}

			var _parent = this;

			$('#content > #startButton').bind(event,function(){

				if(!Storage.Credentials.getId()){
					alert('Et bruger-id er krævet for at benytte denne applikation. Log venligst ind.');
					window.location.hash='/settings';
					return;
				}

				$(this).unbind(event);
				var ride = new Models.Ride();
				Tracker.ride = ride;
				Tracker.start();

				$('#startButton > span').text('STOP TRACKING');

				_parent.bindStop();


			});

		},

		bindStop : function(){

			var event = '';

			if(Override.browser.browserMode === true){
				event = Override.browser.browserEvent;
			} else {
				event = Override.browser.mobileEvent;
			}

			var _parent = this;

			$('#content > #startButton').bind(event,function(){

				$(this).unbind(event);
				Tracker.stop();

				$('#startButton > span').text('START TRACKING');


				_parent.bindStart();

			});

		}

	}),

	SettingsView : Backbone.View.extend({

		el : '#content',

		initialize : function(){
			if(Utilities.scroller){
				Utilities.disableScroll();
			}

			$('#navigation > li').removeClass('active');
			$('#navigation > li').eq(2).addClass('active');
		},

		events : function(){

		},

		render : function(){

			_el = $(this.el);
			_parent = this;
			console.log('CykelScore: attempting to render...');
			_el.anim({translate3d : window.innerWidth + 'px, 0, 0'}, .2, 'ease-out', function(){
				_el.empty();
				_el.html($('#templates > #settingsTemplate').html());
				_el.anim({translate3d : '-' + window.innerWidth + 'px, 0, 0'},0,'ease-out', function(){
					_el.anim({translate3d : '0, 0, 0'},.2,'ease-in');
					_parent.bind();
					if(Storage.Credentials.getId() !== ''){
						$('#idInput').val(Storage.Credentials.getId());
					}
				});
				console.log('CykelScore: template loaded');
			});

		},

		bind : function(){

			console.log('CykelScore: Binding event to loginButton');

			var event = '';

			if(Override.browser.browserMode === true){
				event = Override.browser.browserEvent;
			} else {
				event = Override.browser.mobileEvent;
			}

			$('#loginButton').bind(event, function(){

				var id = $('#idInput').val();
				$.ajax({
					url : 'http://cykelscore.dk/_gateways/getlog.gate.asp?userid='+id,
					success : function(data){
						$("#response").html(data);
						var response = $('#response').children('xml').first().children('status').first().text();
						if(response === 'OK'){
							Storage.Credentials.setId(id);
							alert('Du er nu logged ind.');
						} else {
							alert('Bruger-id’et der blev indtastet er ikke fundet på CykelScore. Det kan skyldes du endnu ikke er oprettet. Skynd dig at besøge www.cykelscore.dk og opret en bruger.')
							$('#idInput').val('');
							Storage.Credentials.setId('');
						}
					}
				});

			});

		}

	}),

	LogView : Backbone.View.extend({

		el: '#content',

		initialize : function(){

			$('#navigation > li').removeClass('active');
			$('#navigation > li').eq(1).addClass('active');

		},

		events : function(){

		},

		render : function(){
			if(!Storage.Credentials.getId()){
				alert('Et bruger-id er krævet for at benytte denne applikation. Log venligst ind.')
				window.location.hash = '/settings';
			} else {

				_el = $(this.el);
				_parent = this;
				$('#preloader').show();
				var ridelog = new Collections.Log();
				ridelog.fetch(function(){
					console.log('CykelScore: attempting to render...');
					_el.anim({translate3d : window.innerWidth + 'px, 0, 0'}, .2, 'ease-out 1ms', function(){
						_el.empty();

						var list = '';

						$('#response > xml > rute').each(function(){
							list += " <li> \
		                        <img src='images/biker-icon.png' /> \
		                        <span class='item'>"+_parent.formatDistance($(this).children('distance').first().text())+" - "+_parent.formatTime($(this).children('time').first().text())+"</span> \
		                        <span class='date'>"+$(this).children('start').first().text().substring(0,10)+"</span> \
		                        <div class='clearfix'></div> \
		                    </li>"
						});

						list += '<li><div class="spacer"></div></li>'

						_el.html($('#templates > #logTemplate').html());
						$('#log').empty();
						$('#log').append(list);
						_el.anim({translate3d : '-' + window.innerWidth + 'px, 0, 0'},0,'ease-out', function(){
							_el.anim({translate3d : '0, 0, 0'},.2,'ease-in');

						});
						Utilities.enableScroll();
						$('#preloader').hide();
						console.log('CykelScore: template loaded');
					});
				});


			}


		},

		formatTime : function(string){

			return Utilities.formatTime(string);

		},

		formatDistance : function(string){

			return Utilities.formatDistance(string);

		}

	})

}

