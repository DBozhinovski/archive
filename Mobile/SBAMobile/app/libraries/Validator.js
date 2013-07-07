var Validator = {

	notEmpty : function(string){
		
		if(string){
			return true;
		} else {
			return false;
		}
		
	},
	
	isEmail : function(string){
		
		//Mostly RFC2822 compliant - will cover every use case though
		var re = /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/;

		return re.test(string);
		
	},
	
	isNumber : function(string){
		
		return !isNaN(parseFloat(string)) && isFinite(string);
		
	},
	
	isEqual : function(stringOne, stringTwo){
		
		return stringOne === stringTwo;
		
	},
	
	isLongerThan : function(string, number){
		
		return string.length >= number;
		
	},
	
	isAlphaNumeric : function(string){
		
		var re = /^[a-zA-Z0-9]+$/;
		
		return re.test(string);
		
	}
	
	

}
