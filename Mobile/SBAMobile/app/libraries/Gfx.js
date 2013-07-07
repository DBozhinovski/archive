var Gfx = {

	footerIsVisible : false,
	
	headerIsVisible : false,
	
	active : false,
	

	hideFooter : function(){
	
		if(this.footerIsVisible){
		
			$("#footer").anim({height: "0px", opacity: "0"}, 0, 'ease-out');
			this.footerIsVisible = false;
		
		} else {
			
			return false;
			
		}
		
	
	},
	
	showFooter : function(html){
	
		$("#footer").html(html);

		if(!this.footerIsVisible){
			
			$("#footer").anim({height: "49px", opacity: "1"}, .4, 'ease-out');
			this.footerIsVisible = true;
			
		} else {
			
			return false;
			
		}
		
	
	},
	
	hideHeader : function(){
	
		if(this.headerIsVisible){
			
			$("#header").anim({height: "0px", opacity: "0"}, .4, 'ease-out');
			this.headerIsVisible = false;
			
		} else {
			
			return false;
			
		}
		
	
	},
	
	showHeader : function(html){
	
		$("#header").html(html);

		$("#header #back").bind("click", function(event){

			event.preventDefault();
			history.back();

		});

		if(!this.headerIsVisible){
			
			$("#header").anim({height: "44px", opacity: "1"}, .4, 'ease-out');
			this.headerIsVisible = true;
			
		} else {
			
			return false;
			
		}

	
	},
	
	transitionIn : function(callback){

//		var self = this;
	
//		$("#content").anim({ translateX: '-1000px'}, 0, '', function(){
//		
//			$("#content").anim({ translateX: '0'}, .4, 'ease-out', function(){
//				
//				if(callback){
//					callback();
//				}
//				
//			});
//		
//		});

		if(callback){
				callback();
		}
	
	},
	
	transitionOut : function(callback){
	
//		var self = this;
//	
//		$("#content").anim({ translateX: '1000px'}, .4, 'ease-out', function(){
//			
//			if(callback){
//				callback();
//			}
//			
//		});

		if(callback){
				callback();
		}
	
	},
	
	showLoader : function(){
		$("#loader").show();
	},
	
	hideLoader : function(){
		$("#loader").hide();
	},
	
	setActive : function(selector){
		
		if(this.active){
			$("#navigation #"+this.active).find("img").attr("src","assets/images/"+this.active+".png");
			$("#navigation #"+this.active).find("a").removeClass("active");
		}
		
		$("#navigation #"+selector).find("img").attr("src","assets/images/"+selector+"-active.png");
		$("#navigation #"+selector).find("a").addClass("active");
		
		this.active = selector;
		
	},
	
	removeActive : function(){
		
		if(this.active){
			$("#navigation #"+this.active).find("img").attr("src","assets/images/"+this.active+".png");
			$("#navigation #"+this.active).find("a").removeClass("active");
			
			this.active = false;
		}
		
		
		
	}
	
	


}
