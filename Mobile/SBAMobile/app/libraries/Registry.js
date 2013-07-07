/**
*	Simple registry, based on the registry design pattern.
*	Used for temporary storage of application data (such as users that sign up for the first time);
*/
var Registry = {

	data : [],
	
	set : function(key, value){
		
		this.data[key] = value;
	
	},
	
	get : function(key){
		
		return this.data[key]
		
	},
	
	remove : function(key){
		
		this.data[key] = false;
		delete(this.data[key]);
		
	},
	
	dump : function(key){
	
		if(key){
			
			console.log("Registry: " + this.data[key]);
			
		} else {
			
			console.log("Registry: " + this.data)
			
		}
	
	},
	
	flush : function(){
	
		delete(this.data);
		this.data = [];

	}

}
