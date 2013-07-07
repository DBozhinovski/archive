function inv_NewUser() as object
    this = CreateObject("roAssociativeArray")
    
    ' state
    this.logged_in=false
    
    ' input
    this.username=""
        
    ' output
    this.session_id=""
    this.random=""
    this.checksum=""
    this.user_id=-1
    this.guest=true
    this.fullname=""
    this.email=""
    
    this.balance=0.0
    this.system_balance=0.0
    this.country_code=""
    this.saved_cards=[]
    this.impaytient_registered=false
    
    ' methods
    this.InitFromJSON=inv_User_InitFromJSON
    
    this.Register=inv_User_Register
    this.Login=inv_User_Login
    this.UpdateInfo=inv_User_UpdateInfo
    this.GetInfo=inv_User_GetInfo
    this.Logout=inv_User_Logout
    this.GetPurchasedItems=inv_User_GetPurchasedItems
    this.GetPaidSubscriptions=inv_User_GetPaidSubscriptions
    this.GetSubscriptionsWithPublishers=inv_User_GetSubscriptionsWithPublishers
    this.ListVideoAccess=inv_User_ListVideoAccess
    this.MakeCardPayment=inv_User_MakeCardPayment
    this.MakeSavedCardPayment=inv_User_MakeSavedCardPayment
    this.ImpaytientRegister=inv_User_ImpaytientRegister
    this.ImpaytientConfirm=inv_User_ImpaytientConfirm
    this.ImpaytientMakePayment=inv_User_ImpaytientMakePayment
    
    ' to delete
    'this.AddSubscription=inv_User_AddSubscription
    'this.IsSubscribed=inv_User_IsSubscribed
    return this
end function

function inv_User_InitFromJSON(jsonResponse as object) as object

    if jsonResponse=invalid then
        return { result:false, message:"no response" }
    endif
    
    if jsonResponse.response.status <> "success" then
        return { result:false, message:jsonResponse.response.message }
    endif
    
    if len(jsonResponse.response.result.user_info.session_id) <=0 then
        return { result:false, message:"invalid session" }
    endif
    
    if len(jsonResponse.response.result.user_info.random) <=0 then
        return { result:false, message:"invalid random" }
    endif
    
    if len(jsonResponse.response.result.user_info.checksum) <=0 then
        return { result:false, message:"invalid checksum" }
    endif
    
    m.fullname=jsonResponse.response.result.user_info.fullname
    m.email=jsonResponse.response.result.user_info.email
    m.username=jsonResponse.response.result.user_info.username
    m.user_id=jsonResponse.response.result.user_info.id
    m.guest=jsonResponse.response.result.user_info.guest="1"
    m.session_id=jsonResponse.response.result.user_info.session_id
    m.random=jsonResponse.response.result.user_info.random
    m.checksum=jsonResponse.response.result.user_info.checksum
    m.balance=jsonResponse.response.result.balance
    m.system_balance=jsonResponse.response.result.system_balance
    m.country_code=jsonResponse.response.result.country_code
    m.saved_cards=jsonResponse.response.result.user_info.saved_cards
    m.impaytient_registered=jsonResponse.response.result.user_info.impaytient_registered<>invalid and jsonResponse.response.result.user_info.impaytient_registered="1"
    'print "m.impaytient_registered=";m.impaytient_registered
    m.logged_in=true
    
    return { result:true, message:jsonResponse.response.message }
end function

function inv_User_Register(fullname as string, email as string, username as string, password as string, repassword as string) as object

    if m.logged_in then
        return { result:false, message:"already logged in" }
    endif
        
    registerReq=NewHTTP("http://api.invideous.com/plugin/register")
    registerReq.AddParam("fullname", fullname)
    registerReq.AddParam("email", email)
    registerReq.AddParam("username", username)
    registerReq.AddParam("password", password)
    registerReq.AddParam("repeat_password", repassword)
    registerResp=registerReq.GetToStringWithTimeout(10)
    
    ' print registerResp
    
    jsonResp=inv_ParseJSON(registerResp)
    
    return m.InitFromJSON(jsonResp)
end function


function inv_User_Login(username as string, password as string) as object

    if m.logged_in then
        return { result:false, message:"already logged in" }
    endif
    
    loginReq=NewHTTP("http://api.invideous.com/plugin/login")
    loginReq.AddParam("username", username)
    loginReq.AddParam("password", password)
    loginReq.AddParam("platform", "web")
        
    loginResp=loginReq.GetToStringWithTimeout(10)
    
    'print "loginResp="; loginResp
    
    jsonResp=inv_ParseJSON(loginResp)
    
    return m.InitFromJSON(jsonResp)
end function

function inv_User_UpdateInfo() as boolean
    
    if not m.logged_in then
        return false
    endif
    
    getUserInfoReq=NewHTTP("http://api.invideous.com/plugin/get_user_info")
    getUserInfoReq.AddParam("session_id", m.session_id)
    
    ' print getPurchasedItemsReq.Http.GetUrl()
    
    getUserInfoResp=getUserInfoReq.GetToStringWithTimeout(10)
    
    'print getUserInfoResp
    
    jsonResp=inv_ParseJSON(getUserInfoResp)
    
    if not m.InitFromJSON(jsonResp).result then
        return false
    endif
    return true

end function

function inv_User_GetInfo(session_id=invalid as object) as boolean
    
    if m.logged_in then
        return false
    endif
    
	getUserInfoReq=NewHTTP("http://api.invideous.com/plugin/get_user_info")
	'getUserInfoReq=NewHTTP("https://api.invideous.com/plugin/get_user_info")
	'getUserInfoReq.Http.SetCertificatesFile("pkg:/assets/invideous/api_invideous_com.pem")
	'getUserInfoReq.Http.SetCertificatesFile("common:/certs/ca-bundle.crt")
    'getUserInfoReq.Http.EnableEncodings(true)
	'getUserInfoReq.Http.InitClientCertificates()
	'getUserInfoReq.Http.AddHeader("X-Roku-Reserved-Dev-Id", "")
	'getUserInfoReq.Http.EnableFreshConnection(true)
	'getUserInfoReq.Http.EnablePeerVerification(false)
	'getUserInfoReq.Http.EnableHostVerification(false)
	
	if session_id<>invalid and len(session_id)>0 then
		getUserInfoReq.AddParam("session_id", session_id)
	endif
    
    ' print getPurchasedItemsReq.Http.GetUrl()
    
    getUserInfoResp=getUserInfoReq.GetToStringWithTimeout(100)
    
    'print "getUserInfoResp=";getUserInfoResp
    
    jsonResp=inv_ParseJSON(getUserInfoResp)
    
    if not m.InitFromJSON(jsonResp).result then
        return false
    endif
    return true

end function

function inv_User_Logout() as boolean

    if not m.logged_in then
        return false
    endif
    
    logoutReq=NewHTTP("http://api.invideous.com/plugin/logout")
    logoutReq.AddParam("session_id", m.session_id)
    logoutResp=logoutReq.GetToStringWithTimeout(10)
    
    jsonResp=inv_ParseJSON(logoutResp)
    
    if jsonResp = invalid then
        return false
    endif
    
    if jsonResp.response.status <> "success" then
        return false
    endif
    
    if jsonResp.response.result <> true then
        return false
    endif
    
    m.session_id=""
    m.random=""
    m.checksum=""
    m.logged_in=false
    
    return true
end function

function inv_User_GetPurchasedItems() as object
    
    if not m.logged_in then
        return invalid
    endif
    
    getPurchasedItemsReq=NewHTTP("http://api.invideous.com/plugin/get_purchased_items")
    getPurchasedItemsReq.AddParam("user_id", m.user_id)
    getPurchasedItemsReq.AddParam("session_id", m.session_id)
    
    ' print getPurchasedItemsReq.Http.GetUrl()
    
    getPurchasedItemsResp=getPurchasedItemsReq.GetToStringWithTimeout(10)
    
    ' print "user_id=";m.user_id
    
    ' print getPurchasedItemsResp
    
    jsonResp=inv_ParseJSON(getPurchasedItemsResp)
    
    if jsonResp = invalid then
        return invalid
    endif
    
    if jsonResp.response.status <> "success" then
        return invalid
    endif
    
    if jsonResp.response.result = invalid then
        return invalid
    endif
    
    return jsonResp.response.result

end function



function inv_User_GetPaidSubscriptions() as object
    
    if not m.logged_in then
        return invalid
    endif
    
    getPaidSubscriptionsReq=NewHTTP("http://api.invideous.com/plugin/get_user_paid_subscriptions")
    getPaidSubscriptionsReq.AddParam("user_id", m.user_id)
    getPaidSubscriptionsReq.AddParam("session_id", m.session_id)
    
    ' print getPurchasedItemsReq.Http.GetUrl()
    
    getPaidSubscriptionsResp=getPaidSubscriptionsReq.GetToStringWithTimeout(10)
    
    ' print "user_id=";m.user_id
    
    ' print getPurchasedItemsResp
    
    jsonResp=inv_ParseJSON(getPaidSubscriptionsResp)
    
    if jsonResp = invalid then
        return invalid
    endif
    
    if jsonResp.response.status <> "success" then
        return invalid
    endif
    
    if jsonResp.response.result = invalid then
        return invalid
    endif
    
    return jsonResp.response.result

end function

function inv_User_GetSubscriptionsWithPublishers() as object
    
    if not m.logged_in then
        return invalid
    endif
    
    getSubWPublishersReq=NewHTTP("http://api.invideous.com/plugin/get_subscriptions_with_publishers")
    getSubWPublishersReq.AddParam("user_id", m.user_id)
    getSubWPublishersReq.AddParam("session_id", m.session_id)
    
    ' print getPurchasedItemsReq.Http.GetUrl()
    
    getSubWPublishersResp=getSubWPublishersReq.GetToStringWithTimeout(10)
    
    ' print "user_id=";m.user_id
    
    ' print getSubWPublishersResp
    
    jsonResp=inv_ParseJSON(getSubWPublishersResp)
    
    if jsonResp = invalid then
        return invalid
    endif
    
    if jsonResp.response.status <> "success" then
        return invalid
    endif
    
    if jsonResp.response.result = invalid then
        return invalid
    endif
    
    return jsonResp.response.result

end function

function inv_User_ListVideoAccess(publisher="all" as string) as object
    
    if not m.logged_in then
        return invalid
    endif
    
    listVideoAccessReq=NewHTTP("http://api.invideous.com/plugin/list_video_access")
    listVideoAccessReq.AddParam("session_id", m.session_id)
    listVideoAccessReq.AddParam("publisher", publisher)
    listVideoAccessResp=listVideoAccessReq.GetToStringWithTimeout(10)
    
    ' print "user_id=";m.user_id
    
    ' print listVideoAccessResp
    
    jsonResp=inv_ParseJSON(listVideoAccessResp)
    
    if jsonResp = invalid then
        return invalid
    endif
    
    if jsonResp.response.status <> "success" then
        return invalid
    endif
    
    if jsonResp.response.result = invalid then
        return invalid
    endif
    return jsonResp.response.result
end function

function inv_User_MakeCardPayment(invItemOrder as object, invCard as object, invReferrer="" as string) as object
	
	if not m.logged_in then
        return {
        	result: 100,
        	message: "User is not signed in",
        	details: invalid
        }
    endif
    
    if m.guest and len(m.email)=0 then
       	return {
    		result: 101,
    		message: "Guest's email is required",
    		details: invalid
    	}
   	endif
   	
    if invItemOrder=invalid or invCard=invalid then
    	return {
        	result: 102,
        	message: "Invalid arguments",
        	details: invalid
        }
	endif
	
	
	makeCardPaymentReq=NewHTTP("http://pay.invideous.com/plugin/make_card_payment")
    makeCardPaymentReq.AddParam("session_id", m.session_id)
	if len(invReferrer)>0 then
		makeCardPaymentReq.AddParam("referrer", invReferrer)
	endif
    makeCardPaymentReq.AddParam("item_id", invItemOrder.id)
    makeCardPaymentReq.AddParam("item_type", invItemOrder.item_type)
    makeCardPaymentReq.AddParam("name_on_card", invCard.holders_name)
    makeCardPaymentReq.AddParam("card_number", invCard.number)
    makeCardPaymentReq.AddParam("cvv_code", invCard.cvv_code)
    makeCardPaymentReq.AddParam("expiry_month", invCard.expiry_month)
    makeCardPaymentReq.AddParam("expiry_year", invCard.expiry_year)
    if invCard.is_debit then
    	 makeCardPaymentReq.AddParam("is_debit", "1")
    	 makeCardPaymentReq.AddParam("issuing_bank", invCard.issuing_bank)
   	endif
   	if m.guest then
   		makeCardPaymentReq.AddParam("email", m.email)
   	endif
   	
   	'print makeCardPaymentReq.Http.GetUrl()
    
    makeCardPaymentResp=makeCardPaymentReq.GetToStringWithTimeout(100)
    
    'print "makeCardPaymentResp=";makeCardPaymentResp
    
    jsonResp=inv_ParseJSON(makeCardPaymentResp)
    
    if jsonResp=invalid then
        return {
        	result: 103,
        	message: "Connection error!",
        	details: invalid
        }
    endif
    
    if jsonResp.response.status <> "success" then
        return {
        	result: 104,
        	message: jsonResp.response.message,
        	details: invalid
        }
    endif
    
    return {
    	result: 0,
    	message: jsonResp.response.message,
    	details: jsonResp.response.result
	}
end function

function inv_User_MakeSavedCardPayment(invItemOrder as object, invSavedCard as object, invReferrer="" as string) as object
	if not m.logged_in then
        return {
        	result: 100,
        	message: "User is not signed in",
        	details: invalid
        }
    endif
    
    if m.guest and len(m.email)=0 then
       	return {
    		result: 101,
    		message: "Guest's email is required",
    		details: invalid
    	}
   	endif
   	
    if invItemOrder=invalid or invSavedCard=invalid then
    	return {
        	result: 102,
        	message: "Invalid arguments",
        	details: invalid
        }
	endif
	
	
	makeSavedCardPaymentReq=NewHTTP("http://pay.invideous.com/plugin/make_card_payment")
    makeSavedCardPaymentReq.AddParam("session_id", m.session_id)
	if len(invReferrer)>0 then
		makeSavedCardPaymentReq.AddParam("referrer", invReferrer)
	endif
    makeSavedCardPaymentReq.AddParam("item_id", invItemOrder.id)
    makeSavedCardPaymentReq.AddParam("item_type", invItemOrder.item_type)
    makeSavedCardPaymentReq.AddParam("use_saved_card", "1")
    makeSavedCardPaymentReq.AddParam("saved_card_id", invSavedCard.id)
    if m.guest then
   		makeSavedCardPaymentReq.AddParam("email", m.email)
   	endif
   	
   	'print makeSavedCardPaymentReq.Http.GetUrl()
    
    makeSavedCardPaymentResp=makeSavedCardPaymentReq.GetToStringWithTimeout(100)
    
    'print "makeSavedCardPaymentResp=";makeSavedCardPaymentResp
    
    jsonResp=inv_ParseJSON(makeSavedCardPaymentResp)
    
    if jsonResp=invalid then
        return {
        	result: 103,
        	message: "Connection error!",
        	details: invalid
        }
    endif
    
    if jsonResp.response.status <> "success" then
        return {
        	result: 104,
        	message: jsonResp.response.message,
        	details: invalid
        }
    endif
    
    return {
    	result: 0,
    	message: jsonResp.response.message,
    	details: jsonResp.response.result
	}
end function

function inv_User_SaveSession(session_id as string) as boolean
    RegWrite("session_id", session_id, "com.invideous.user")
    return true
end function

function inv_User_LoadSession() as object
    return RegRead("session_id", "com.invideous.user")
end function

function inv_User_ClearSession() as boolean
    RegDelete("session_id", "com.invideous.user")
    return true
end function

function inv_User_SaveCredential(invUserCredential as object) as boolean
	RegWrite("username", invUserCredential.username, "com.invideous.user")
	RegWrite("password", invUserCredential.password, "com.invideous.user")
	return true
end function

function inv_User_LoadCredential() as object
	invUserUsername=RegRead("username", "com.invideous.user")
	invUserPassword=RegRead("password", "com.invideous.user")
	
	if invUserUsername<>invalid and invUserPassword<>invalid then
		return {
			username: invUserUsername,
			password: invUserPassword
		}
	endif
	return invalid
end function

function inv_User_ClearCredential()
	RegDelete("username", "com.invideous.user")
	RegDelete("password", "com.invideous.user")
end function

function inv_User_ImpaytientRegister(impPhoneNumber as string, invReferrer="" as string) as object
	
	if not m.logged_in then
        return {
        	result: 100,
        	message: "User is not signed in",
        	details: invalid
        }
    endif
    
    if m.guest then
       	return {
    		result: 101,
    		message: "Guest's can not be register at Impaytient",
    		details: invalid
    	}
   	endif
   	
    if m.impaytient_registered then
    	return {
        	result: 102,
        	message: "Already registered at Impaytient",
        	details: invalid
        }
	endif
	
	impaytientRegisterReq=NewHTTP("http://api.invideous.com/plugin/register_impaytient_user")
    impaytientRegisterReq.AddParam("session_id", m.session_id)
    impaytientRegisterReq.AddParam("phone_number", impPhoneNumber)
    impaytientRegisterReq.AddParam("referrer", invReferrer)
	
    impaytientRegisterResp=impaytientRegisterReq.GetToStringWithTimeout(100)
    
    'print "impaytientRegisterResp=";impaytientRegisterResp
    
    jsonResp=inv_ParseJSON(impaytientRegisterResp)
    
    if jsonResp=invalid then
        return {
        	result: 103,
        	message: "Connection error!",
        	details: invalid
        }
    endif
    
    if jsonResp.response.status <> "success" then
        return {
        	result: 104,
        	message: jsonResp.response.message,
        	details: invalid
        }
    endif
    
    return {
    	result: 0,
    	message: jsonResp.response.message,
    	details: jsonResp.response.result
	}
	
end function

function inv_User_ImpaytientConfirm(impPhoneNumber as string, impPinCode as string, invReferrer="" as string) as object
	if not m.logged_in then
        return {
        	result: 100,
        	message: "User is not signed in",
        	details: invalid
        }
    endif
    
    if m.guest then
       	return {
    		result: 101,
    		message: "Guest's can not be register at Impaytient",
    		details: invalid
    	}
   	endif
   	
    if m.impaytient_registered then
    	return {
        	result: 102,
        	message: "Already registered at Impaytient",
        	details: invalid
        }
	endif
	
	impaytientConfirmReq=NewHTTP("http://api.invideous.com/plugin/confirm_impaytient_user")
    impaytientConfirmReq.AddParam("session_id", m.session_id)
    impaytientConfirmReq.AddParam("phone_number", impPhoneNumber)
    impaytientConfirmReq.AddParam("pin_code", impPinCode)
    impaytientConfirmReq.AddParam("referrer", invReferrer)
	
    impaytientConfirmResp=impaytientConfirmReq.GetToStringWithTimeout(100)
    
    'print "impaytientConfirmResp=";impaytientConfirmResp
    
    jsonResp=inv_ParseJSON(impaytientConfirmResp)
    
    if jsonResp=invalid then
        return {
        	result: 103,
        	message: "Connection error!",
        	details: invalid
        }
    endif
    
    if jsonResp.response.status <> "success" then
        return {
        	result: 104,
        	message: jsonResp.response.message,
        	details: invalid
        }
    endif
    
    return {
    	result: 0,
    	message: jsonResp.response.message,
    	details: jsonResp.response.result
	}
end function

function inv_User_ImpaytientMakePayment(invItemOrder as object, invReferrer="" as string) as object
	
	if not m.logged_in then
        return {
        	result: 100,
        	message: "User is not signed in",
        	details: invalid
        }
    endif
    
    if m.guest then
       	return {
    		result: 101,
    		message: "Guest's can not be register at Impaytient",
    		details: invalid
    	}
   	endif
   	
    if not m.impaytient_registered then
    	return {
        	result: 102,
        	message: "Not registered at Impaytient",
        	details: invalid
        }
	endif
	
	if invItemOrder=invalid then
    	return {
        	result: 103,
        	message: "Invalid arguments",
        	details: invalid
        }
	endif
	
	impaytientMakePaymentReq=NewHTTP("http://api.invideous.com/plugin/make_impaytient_payment")
    impaytientMakePaymentReq.AddParam("session_id", m.session_id)
    impaytientMakePaymentReq.AddParam("referrer", invReferrer)
    impaytientMakePaymentReq.AddParam("item_id", invItemOrder.id)
    impaytientMakePaymentReq.AddParam("item_type", invItemOrder.item_type)
    
	
    impaytientMakePaymentResp=impaytientMakePaymentReq.GetToStringWithTimeout(100)
    
    'print "impaytientMakePaymentResp=";impaytientMakePaymentResp
    
    jsonResp=inv_ParseJSON(impaytientMakePaymentResp)
    
    if jsonResp=invalid then
        return {
        	result: 104,
        	message: "Connection error!",
        	details: invalid
        }
    endif
    
    if jsonResp.response.status <> "success" then
        return {
        	result: 105,
        	message: jsonResp.response.message,
        	details: invalid
        }
    endif
    
    return {
    	result: 0,
    	message: jsonResp.response.message,
    	details: jsonResp.response.result
	}
end function