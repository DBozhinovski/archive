var LogInView = Backbone.View.extend({

	attributes : {
		"id" : "login",
		"class" : "wrapper"
	},

	initialize : function(){

		this.render();

	},

	render : function(){

		var self = this;

		require(["text!templates/register/login.tpl", "text!templates/header/header-logo.tpl"], function(template, header){

			self.$el.html(Mustache.render(template, ""));

			$("#content").html(self.$el);

			Gfx.showHeader(Mustache.render(header, ""));
			Gfx.hideFooter();

			return self;

		});

	},

	events : {
		"click #dologin" : "login"	
	},

	login : function(e){

		var email = $("#email").val();
		var password = $("#password").val();

		if(Validator.notEmpty(email) && Validator.notEmpty(password) && Validator.isEmail(email)){
												
			$.ajax({

				 url : "http://mvp-sba.herokuapp.com/login/",
				 type : "POST",
				 dataType: "json",
    			 contentType: "application/json",
				 data : JSON.stringify({
		
					 	email: email,
						password: password,                   
						partnerId: Registry.get("partnerId")
				
				}),
				 success : function(data){
			 	
				 	var token = data.token;
				 	
				 	console.log(token);
				 	
				 	//move to invoice
				 	localStorage.setItem("credentials", JSON.stringify({
		
					 	email: email,
						password: password,                   
						partnerId: Registry.get("partnerId")
				
					}));
				 	localStorage.setItem("token", data.token);
				 	console.log("SBAMobile: Log - Login successfull. ");
				 	location.hash = "/home/"
			 
	 			 },
				 error : function(error){
				 
				 	//remain at login, show an error
				 	console.error("SBAMobile: Error - Bad login. " + error);
				 
				 }

			});
			
		} else {	
		
			console.error("SBAMobile: Error - Email and password fields should be filled and valid in order to login. ");
			alert("Email and password fields should be filled and valid in order to login.");
		
		}

	}

});