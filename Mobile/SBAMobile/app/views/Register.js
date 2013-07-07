var RegisterView = Backbone.View.extend({

	initialize : function(action, view){
			
		if(action || view){
			switch (action) {
			
				case "sign-up" : {
					this.signUp(view);
					break;
				}
			
				case "log-in" : {
					this.logIn();
					break;
				}
			
				default : {
					console.error("SBAMobile: Error - invalid action string. [Views, Register.js, initialize]");
					break;
				}
			
			}
		} else {
			
			this.home();
			
		}
		
	},
	
	home : function(){
		
		var self = this;
		
		Gfx.hideHeader();
		Gfx.hideFooter();
		
		Gfx.transitionOut(function(){
		
			require(["text!templates/register.tpl"], function(template){
			
				var output = Mustache.render(template, "");
				
				$("#content").html(output);
			
				Gfx.transitionIn();
				
				Gfx.hideLoader();
			
			});
		
		});
		
		
		
	},
	
	signUp : function(view){
		
		var self = this;
		
		if(!view){
			
			console.error("SBAMobile: Error - invalid sub-view string. [Views, Register.js, home]");
			
		} else {
		
			require(["text!templates/header-logo.tpl"], function(header){
			
				var output = Mustache.render(header, "");
				$("#header").html(output);
				Gfx.showHeader();
				Gfx.hideFooter();
				
				Gfx.hideLoader();
			
			});
		
			
		
			Gfx.transitionOut(
			
				function(){
				
					switch (view) {
				
						case "create" : {
					
							require(["text!templates/signup-create.tpl"], function(template){
					
								var output = Mustache.render(template, "");
								$("#content").html(output);
								
								self.bind();
						
								Gfx.transitionIn();
								
								Gfx.hideLoader();
					
							});
							break;
					
						}
				
						case "setup" : {
					
							require(["text!templates/signup-setup.tpl"], function(template){
					
								var output = Mustache.render(template, "");
								$("#content").html(output);
								
								self.bind();
						
								Gfx.transitionIn();
								
								Gfx.hideLoader();
					
							});
							break;
					
						}
				
						case "finalize" : {
					
							require(["text!templates/signup-finalize.tpl"], function(template){
					
								var output = Mustache.render(template, "");
								$("#content").html(output);
								
								self.bind();
						
								Gfx.transitionIn();
								
								Gfx.hideLoader();
					
							});
							break;
					
						}
				
						default : {
					
							console.error("SBAMobile: Error - invalid sub-view string. [Views, Register.js, home]");
							break;
					
						}
				
					}
				
				}
			
			
			);
			
			
			
		}
		
		
		
	},
	
	logIn : function(){
	
		var self = this;
	
		Gfx.transitionOut(function(){
		
			require(["text!templates/header-logo.tpl", "text!templates/login.tpl"], function(header, template){
			
				var output = Mustache.render(header, "");
				$("#header").html(output);
				Gfx.showHeader();
				Gfx.hideFooter();
			
					
				output = Mustache.render(template, "");
				$("#content").html(output);
				Gfx.showHeader();
				Gfx.hideFooter();
				self.bind();
			
				Gfx.transitionIn();
				
				Gfx.hideLoader();
			
			});
		
		});
	
		
	
	
	},
	
	bind : function(){
	
		var actionType = "";
	
		//a switcher for touch / click?
		$("#action").bind("tap", function(){
		
		
			var $this = $(this);
		
			var actionType = $this.attr("data-action");
			
			switch (actionType) {
			
				case "login" : {
					
					var email = $("#email").val();
					var password = $("#password").val();
				
					if(Validator.notEmpty(email) && Validator.notEmpty(password) && Validator.isEmail(email)){
						
						var credentials = {
					
						 	email: email,
							password: password,                   
							partnerId: '58d1f7fc358c4ae995a1ee94a758e7f3' // Debitoor DK - What's this used for??
					
						}
															
						$.ajax({

							 url : "http://mvp-sba.herokuapp.com/login/",
							 type : "POST",
							 dataType: "json",
							 data : credentials,
							 success : function(data){
						 	
							 	var token = data.token;
							 	
							 	console.log(token);
							 	
							 	//move to invoice
							 	localStorage.setItem("credentials", JSON.stringify(credentials));
							 	localStorage.setItem("token", data.token);
							 	console.log("SBAMobile: Log - Login successfull. ");
							 	setTimeout(function(){
							 		window.location.hash = "/invoice/";
							 	}, 200);
						 
				 			 },
							 error : function(){
							 
							 	//remain at login, show an error
							 	console.error("SBAMobile: Error - Bad login.");
							 
							 }

						});
						
					} else {	
					
						console.error("SBAMobile: Error - Email and password fields should be filled and valid in order to login. ");
						alert("Email and password fields should be filled and valid in order to login.");
					
					}
				
					
					
					break;
				
				}
				
				case "signup:create" : {
					
					var email = $("#email").val();
					var password = $("#password").val();
					var confirmation = $("#confirm-password").val();
					
					var tos = $("#tos");
				
					if(Validator.notEmpty(email) && Validator.notEmpty(password) && Validator.notEmpty(confirmation) && Validator.isEmail(email) && Validator.isLongerThan(password, 8) && Validator.isAlphaNumeric(password) && Validator.isEqual(password, confirmation) && tos.is(":checked")){
				
						var credentials = { Email : email, Password : password };
		
						Registry.set("credentials", credentials);
				
						window.location.hash = "/register/sign-up/setup/";
				
					} else {
					
						console.error("SBAMobile: Error - Signup fields should not be empty and should be valid to proceed.");
						alert("Signup fields should not be empty and should be valid to proceed.")	
					
					}
					
					
					break;
				
				}
				
				case "signup:finalize" : {
				
					var companyName = $("#company-name").val();
					var address = $("#address").val() + " " + $("#address-l2").val();
					
					if(Validator.notEmpty(companyName) && Validator.notEmpty(address)){
						
						var credentials = Registry.get("credentials");
						
						credentials.CompanyName = companyName;
						credentials.Address = address;
						
						Registry.set("credentials", credentials);
						
						console.log(Registry.get("credentials"));
						
					} else {
						
						console.error("SBAMobile: Error - Signup fields should not be empty and should be valid to proceed.");
						alert("Signup fields should not be empty and should be valid to proceed");
						
					}
				
					break;
				
				}
				
				case "signup:setup" : {
				
					window.location.hash = "/register/sign-up/finalize/";
				
					break;
				
				}
			
			} 
				
		});
	
	}	

});
