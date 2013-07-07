function inv_NewPaywall(paywallData as object) As Object

    this = CreateObject("roAssociativeArray")
    
    this.id=paywallData.id
    this.name="paywall"
    this.paywall_enabled=paywallData.data.paywall_enabled<>"0"
    this.marketing_opt=paywallData.data.marketing_opt<>"0"
    this.paywall_time=paywallData.data.paywall_time.ToInt()
    this.payment_options=paywallData.data.payment_options
    this.subscription_tariffs=[]
    for each subscriptionTariffData in paywallData.data.subscription_tariffs
        this.subscription_tariffs.Push(inv_NewSubscriptionTariff(subscriptionTariffData))
    next
    
    
    this.Start=inv_Paywall_Start
    this.Update=inv_Paywall_Update
    this.Stop=inv_Paywall_Stop
    
    this.HasAccess=inv_Paywall_HasAccess
    
    this.BuyAccess=inv_Paywall_BuyAccess
    this.AlreadyHaveAccess=inv_Paywall_AlreadyHaveAccess
    return this
end function

function inv_Paywall_Start() as boolean
    return true
end function

function inv_Paywall_Update(invVideoScreen as object, videoProgress as integer) as boolean

	'if not m.paywall_enabled then
	'	return true
	'endif

	if not m.paywall_enabled or videoProgress<m.paywall_time then
	'if not m.paywall_enabled or videoProgress<5 then
		return true
	endif
	
    invPlatform=inv_Platform_Get()
    
    ' never should happen
    if invPlatform.video=invalid then
        ' print "Paywall: invPlatform.video is invalid"
        return false
    endif
    
    
    'if not m.paywall_enabled or invPlatform.video.is_paid then
   	if not m.paywall_enabled or m.HasAccess(invPlatform.video, invPlatform.user) then
        return true
    end if
    
    if invPlatform.user=invalid then
        if invPlatform.LoginSavedUser() then
            invPlatform.video.UpdateIsPaid(invPlatform.user)
        endif
    endif
    
    'if m.paywall_enabled and not invPlatform.video.is_paid then
    if not m.HasAccess(invPlatform.video,invPlatform.user) then
    	invVideoScreen.Stop()
    	invInputScreen=inv_NewInputScreen("Choose an option below to continue")
		while true
			accessChoices=[]
			accessChoicesText=""
			if invPlatform.user=invalid or invPlatform.user.guest then
				accessChoices.Push("Already have access?")
			else if invPlatform.user<>invalid and not invPlatform.user.guest then
				accessChoicesText="Logged in as "+invPlatform.user.username
				accessChoices.Push("Logout")
			endif
			accessChoices.Push("Buy Access")
			accessChoices.Push("Cancel")
				
            accessChoice=invInputScreen.GetInputChoice(accessChoicesText, accessChoices)
            if accessChoice.result and accessChoice.choice<accessChoices.Count()-1 then
            	if accessChoice.choice=accessChoices.Count()-2 then
                	buyAccessResult=m.BuyAccess()
                    if buyAccessResult>=0 then
                    	exit while
                    endif
                else if accessChoice.choice=0 then
                	if invPlatform.user=invalid or invPlatform.user.guest then
                		alreadyHaveResult=m.AlreadyHaveAccess()
                		if alreadyHaveResult>=0 then
                    		exit while
						endif
					else if invPlatform.user<>invalid and not invPlatform.user.guest then
						invPlatform.LogoutUser()
                    endif
                endif
            else
                exit while
            endif
        end while
        
        'if invPlatform.video.is_paid then
        if m.HasAccess(invPlatform.video, invPlatform.user) then
        	invVideoScreen.Play(videoProgress)
        endif
        
    endif
    
    'print "access choice ended"
    
    'return not m.paywall_enabled or invPlatform.video.is_paid
    return m.HasAccess(invPlatform.video, invPlatform.user)

end function

function inv_Paywall_Stop() as void
end function

function inv_Paywall_BuyAccess() as integer
    
    invPlatform=inv_Platform_Get()
    
    if invPlatform.user=invalid then
    	if not invPlatform.LoginAsNewGuest() then
    		return 100
    	endif
    endif
    
    invChooseOrderOptionsScreens=[]
    
    if m.subscription_tariffs.Count()>0 then
        invChooseOrderOptionsScreens.Push(inv_NewSubscriptionScreen(m.subscription_tariffs))
    endif
    
    if invChooseOrderOptionsScreens.Count()=0 then
        return 101
    endif
    
    paymentDone=false
    retVal=-1
    
    
    while not paymentDone
    
    	choosenOrderOption=0
    	
    	if invChooseOrderOptionsScreens.Count()>1 then
    		
    		invChooseOrderOptions=[]
		    for mos=0 to invChooseOrderOptionsScreens.Count()-1 step 1
		        invChooseOrderOptions.Push(invChooseOrderOptionsScreens[mos].title)
		    end for
		    
		    
		    
		    invChooseOrderOptions.Push("Back")
		    invChooseOrderOptions.Push("Cancel")
		    
		    invChooseOrderOptionScreen=inv_NewInputScreen("Choose an option below to continue")
    		
        
        	invChooseOrderOptionResult=invChooseOrderOptionScreen.GetInputChoice("", invChooseOrderOptions)
        	
        	
        
        	if not invChooseOrderOptionResult.result or invChooseOrderOptionResult.choice=invChooseOrderOptions.Count()-2 then
        		paymentDone=true
            	retVal=-1
            else if invChooseOrderOptionResult.choice=invChooseOrderOptions.Count()-1 then
            	retVal=200
        		paymentDone=true
        	else
        		choosenOrderOption=invChooseOrderOptionResult.choice
            endif	
        endif
        
        
        while not paymentDone
			invItemOrderResult=invChooseOrderOptionsScreens[choosenOrderOption].ChooseOrder()
            
            if invItemOrderResult.result=0 then
                invPaymentScreen=inv_NewPaymentScreen(invItemOrderResult.item_order, m.payment_options)
                while not paymentDone
                    invPaymentResult=invPaymentScreen.PayItemOrder()
                    if invPaymentResult.result=0 then
                    	invPlatform.video.UpdateIsPaid(invPlatform.user)
                        paymentDone=true
                        retVal=0
                    else if invPaymentResult.result<0 then
                    	exit while
                    else
                        paymentDone=true
                        retVal=invPaymentResult.result
                    endif
                end while
            else if invItemOrderResult.result<0 then
            	if invChooseOrderOptionsScreens.Count()=1 then
            		paymentDone=true
            	endif
                exit while
            else
                paymentDone=true
                retVal=103
            endif
        end while
    end while
    return retVal
end function

function inv_Paywall_AlreadyHaveAccess() as integer
    
    invPlatform=inv_Platform_Get()
    invAuthScreen=inv_NewUserAuthorizationScreen()
    loginResult=invAuthScreen.Login()
    
    if loginResult.result<0 then
        return -1
    endif
    
    if loginResult.result=0 then
    	
    	if loginResult.user.guest then
    		inv_User_SaveSession(loginResult.user.session_id)
    	else
    		inv_User_SaveCredential({ username: loginResult.user.username, password: loginResult.password } )
    	endif
    	
    	invPlatform.user=loginResult.user
        invPlatform.video.UpdateIsPaid(invPlatform.user)
        
        if invPlatform.video.is_paid then
        	return 0
       	else
       		return m.BuyAccess()
       	endif
    endif
    
    if loginResult.result=101 then
        invErrorScreen=inv_NewInputScreen("Login error!")
        invErrorScreen.GetInputChoice(loginResult.message, ["Continue"])
        return 100
    endif
    
    return 100
    
end function

function inv_Paywall_HasAccess(invVideo as object, invUser=invalid as object) as boolean
	
	if m.paywall_enabled then
		if invVideo.HasAccess(invUser) then
			return true
		endif
		
		if invVideo.subscription_excluded then
			return true
		endif
	else
		return true
	endif
	
	return false
end function