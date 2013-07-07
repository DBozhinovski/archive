function inv_NewUserAuthorizationScreen()
    
    this = CreateObject("roAssociativeArray")
    this.Register=inv_UserAuthorizationScreen_Register
    this.Login=inv_UserAuthorizationScreen_Login
    return this
    
end function

function inv_UserAuthorizationScreen_Register() as object

    inputScreen=inv_NewInputScreen("Sign up:")
    
    invFullname=""
    invEMail=""
    invUsername=""
    invPassword=""
    invRePassword=""
        
    pageIndex=0
    
    while pageIndex>=0 and pageIndex<5
        
        if pageIndex=0 then
            fullnameInput=inputScreen.GetInputText("Enter fullname:", invFullname, ["Next", "Back"])
            if fullnameInput.result then
	            if fullnameInput.button=0 then
	                pageIndex=pageIndex+1
	                invFullname=fullnameInput.value
	            else if fullnameInput.button=1 then
	                 pageIndex=pageIndex-1
	            endif
	        else
	        	pageIndex=pageIndex-1
	        endif
        else if pageIndex=1 then
            emailInput=inputScreen.GetInputText("Enter email address:", invEMail, ["Next","Back"])
            if emailInput.result then
            	if emailInput.button=0 then
	                pageIndex=pageIndex+1
	                invEMail=emailInput.value
	            else if emailInput.button=1 then
	                pageIndex=pageIndex-1
	            endif
			else
				pageIndex=pageIndex-1
			endif
        else if pageIndex=2 then
            usernameInput=inputScreen.GetInputText("Enter username:", invUsername, ["Next","Back"])
            if usernameInput.result then
	            if usernameInput.button=0 then
	                pageIndex=pageIndex+1
	                invUsername=usernameInput.value
	            else if usernameInput.button=1 then
	                pageIndex=pageIndex-1
	            endif
			else
				pageIndex=pageIndex-1
			endif
        else if pageIndex=3 then
            passwordInput=inputScreen.GetInputText("Enter password:", invPassword, ["Next","Back"], true)
            if passwordInput.result then
	            if passwordInput.button=0 then
	                pageIndex=pageIndex+1
	                invPassword=passwordInput.value
	            else if passwordInput.button=1 then
	                pageIndex=pageIndex-1
	            endif
			else
				pageIndex=pageIndex-1
			endif
        else if pageIndex=4 then
            repasswordInput=inputScreen.GetInputText("Repeat password:", invRePassword, ["Sign up","Back"], true)
            if repasswordInput.result then
	            if repasswordInput.button=0 then
	                pageIndex=pageIndex+1
	                invRePassword=repasswordInput.value
	            else if repasswordInput.button=1 then
	                pageIndex=pageIndex-1
	            endif
			else
				pageIndex=pageIndex-1
			endif
        endif
    end while
    
    if pageIndex<0 then
        return {
            result: -1,
            message: "",
            user: invalid,
            password:""
        }
    endif
        
    invUser=inv_NewUser()
    registerResult=invUser.Register(invFullname, invEMail, invUsername, invPassword, invRePassword)
    
    if not registerResult.result then
        return {
            result: 100,
            message:registerResult.message,
            user:invalid,
            password:""
        }
    endif
    
    return {
        result:0,
        message:registerResult.message,
        user:invUser,
        password:invPassword
    }
end function

function inv_UserAuthorizationScreen_Login() as object

    inputScreen=inv_NewInputScreen("Sign in")
    
    errorScreen=inv_NewInputScreen("Error")
    
    invUsername=""
    invPassword=""
    
    pageIndex=0
    
    while true
    	while pageIndex>=0 and pageIndex<2
	        if pageIndex=0 then
	            usernameInput=inputScreen.GetInputText("Enter username:", invUsername, ["Next", "Back", "Cancel"])
	            
	            if usernameInput.result then
		            if usernameInput.button=0 then
		                pageIndex=pageIndex+1
		                invUsername=usernameInput.value
		            else if usernameInput.button=1 then
		                pageIndex=pageIndex-1
		            else
		            	exit while		            			            	
		            endif
				else
					pageIndex=pageIndex-1
				endif
	        else if pageIndex=1 then
	            passwordInput=inputScreen.GetInputText("Enter password:", invPassword, ["Sign in","Back", "Cancel"], true)
	            if passwordInput.result then
		            if passwordInput.button=0 then
		                pageIndex=pageIndex+1
		                invPassword=passwordInput.value
		            else if passwordInput.button=1 then
		                pageIndex=pageIndex-1
		            else
		            	exit while
		            endif
				else
					pageIndex=pageIndex-1
				endif
	        endif
	    end while
    
	    if pageIndex<0 then
	        return {
	            result: -1,
	            message: "",
	            user: invalid,
	            password:""
	        }
	    else if pageIndex<2 then
	    	return {
	            result: 200,
	            message: "Canceled",
	            user: invalid,
	            password:""
	        }
	    endif
        
	    invUser=inv_NewUser()
	    loginResult=invUser.Login(invUsername, invPassword)
	    
	    if loginResult.result then
	    	exit while
	    else
	    	errorScreen.GetInputChoice("Wrong username or password", ["Next"])
	    	pageIndex=0
	    	invUsername=""
    		invPassword=""
	    endif
	    
	end while
    
    return {
        result:0,
        message:loginResult.message,
        user:invUser,
        password:invPassword
    }
end function
