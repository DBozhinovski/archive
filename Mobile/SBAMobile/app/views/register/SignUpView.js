var SignUpView = Backbone.View.extend({

	attributes : {
		"id" : "signup-create",
		"class" : "wrapper"
	},

	initialize : function(){

		this.render();

	},

	render : function(){

		var self = this;

		require(["text!templates/register/signup.tpl", "text!templates/header/header-logo.tpl"], function(template, header){

			self.$el.html(Mustache.render(template, ""));

			$("#content").html(self.$el);

			Gfx.showHeader(Mustache.render(header, ""));
			Gfx.hideFooter();

			return self;

		});

	},

	events : {

		"click #signup" : "signup"

	},

	signup : function(e){
		
		var email = $("#email").val();
		var password = $("#password").val();
		var confirmation = $("#confirm-password").val();
		var tos = $("#tos");

		if(Validator.notEmpty(email) && Validator.notEmpty(password) && Validator.notEmpty(confirmation) && Validator.isEmail(email) && Validator.isLongerThan(password, 8) && Validator.isAlphaNumeric(password) && Validator.isEqual(password, confirmation) && tos.is(":checked")){
				
			$.ajax({

				url : Registry.get("apiRoot") + "/signup/",
				type : "post",
				data : {

					"email" : email,
					"password" : password,
					"partnerId" : Registry.get("partnerId")

				},
				success : function(data){

					location.hash = "#/home/"

				},
				error : function(error){
					console.error(error);	
				}

			});
				
		} else {
		
			console.error("SBAMobile: Error - Signup fields should not be empty and should be valid to proceed.");
			alert("Signup fields should not be empty and should be valid to proceed.")	
		
		}
		
	}


});