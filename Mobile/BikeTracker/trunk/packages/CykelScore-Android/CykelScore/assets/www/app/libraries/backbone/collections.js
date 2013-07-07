var Collections = {

	Log : Backbone.Collection.extend({

		model : Models.LogItem,

		fetch : function(callback){

			var id = Storage.Credentials.getId();

			$.ajax({

				url : 'http://cykelscore.dk/_gateways/getlog.gate.asp?userid='+id,
				type : 'post',
				success : function(response){
					$('#response').html(response);
					callback();
				}

			});

		}

	})





}

