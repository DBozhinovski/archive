var Collections = {

	Log : Backbone.Collection.extend({

		model : Models.LogItem,

		fetch : function(callback){

		    var id = Storage.Credentials.getId();

			$.ajax({

				url : 'LogProxy.ashx?userid='+id+"&sdfsdf=2354235&dfgfdg=34",
				type : 'post',
				success : function(response){
					$('#response').html(response);
					callback();
				}

			});

		}

	})





}

