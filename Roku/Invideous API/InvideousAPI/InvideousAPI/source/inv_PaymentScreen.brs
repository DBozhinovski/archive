function inv_NewPaymentScreen(invItemOrder as object, paymentOptions as object) as object
    this = CreateObject("roAssociativeArray")
    this.item_order=invItemOrder
    this.payment_options=paymentOptions
    this.PayItemOrder=inv_PaymentScreen_PayItemOrder
    
    return this
end function

function inv_PaymentScreen_PayItemOrder() as object
    
    invPlatform=inv_Platform_Get()
    
    ' remove after debugging is finished
    ' invPlatform.user.email="baldzar@gmail.com"
    
    if invPlatform.user.guest and not len(invPlatform.user.email)>0 then
        
        invInvalidGuestEmailScreen=inv_NewInputScreen("Invalid guest email address")
        'invGuestEmailRequestScreen=inv_NewInputScreen("Guest email request")
        invGuestEmailRequestScreen=inv_NewInputScreen("Email request")
        'infoResult=invGuestEmailRequestScreen.GetInputChoice("To proceed with your 'guest' payment we need your email address. We will only email you if there is query with your payment transaction", ["Continue", "Back"])
        
        'if not infoResult.result then
        '    return {
        '        result: -1
        '    }
        'endif
        
        'if infoResult.choice=1 then
        '    return {
        '        result: -1
        '    }
        'endif
        
        while true
            emailResult=invGuestEmailRequestScreen.GetInputText("Enter your email to proceed with payment *no unsolicited mail", "", ["Next", "Back", "Cancel"])
            if not emailResult.result or emailResult.button=1 then
                return {
                    result: -1
                }
            endif
            
            if emailResult.button=2 then
            	return {
                    result: 200
                }
            endif
            
            if emailResult.button=0 and inv_Utils_ValidateEmail(emailResult.value) then
                exit while
            endif

            invInvalidGuestEmailScreen.GetInputChoice("Enter a valid email address", ["Next"])
        end while
        invPlatform.user.email=emailResult.value
    endif
    
	invPaymentOptionTable=[]
    
	'if not invPlatform.user.guest then
	'	invPaymentOptionTable.Push(inv_NewImpaytientPaymentScreen(m.item_order))
	'endif
        
	for po=0 to m.payment_options.Count()-1 step 1
		if m.payment_options[po]="card" then
			invPaymentOptionTable.Push( inv_NewCardPaymentScreen(m.item_order) )
		'else if m.payment_options[po]="paypal" then
		'	print "paypal payment option not supported"
			'invPaymentOptionTable.Push( {caption:"PayPal", index: po} )
		endif
	next
    
    retVal={
        result: 0
    }
    
   
    while true
    	makePaymentResult=invalid
    	
    	if invPaymentOptionTable.Count()>1 then
    	
    		invPaymentOptionScreen=inv_NewInputScreen("Select how you want to pay")

			invPaymentOptions=[]
			for poc=0 to invPaymentOptionTable.Count()-1 step 1
				invPaymentOptions.Push(invPaymentOptionTable[poc].description)
			end for
    
			invPaymentOptions.Push("Back")
			invPaymentOptions.Push("Cancel")
			
			invPaymentOptionChoice=invPaymentOptionScreen.GetInputChoice("", invPaymentOptions)
        
			if not invPaymentOptionChoice.result or invPaymentOptionChoice.result=invPaymentOptions.Count()-2 then
				retVal.result=-1
				exit while
			endif
			
			if invPaymentOptionChoice.result=invPaymentOptions.Count()-1 then
				retVal.result=200
				exit while
			endif
			
			if invPaymentOptionChoice.choice=invPaymentOptions.Count()-2 then
				retVal.result=-1
				exit while
			endif
        
			makePaymentResult=invPaymentOptionTable[invPaymentOptionChoice.choice].MakePayment()
		else
			makePaymentResult=invPaymentOptionTable[0].MakePayment()
		endif
		
		if makePaymentResult=invalid then
			retVal.result=100
			exit while
		endif
	         
        if makePaymentResult.result=0 then
        	if invPlatform.user.guest then
        		successScreen=inv_NewInputScreen("Thank you")
				successScreen.GetInputChoice("For discount codes, updated content and a full history of your transactions please register at www.classicaltv.com with the same email address", ["Resume playback"])
			endif
			retVal.result=0
			exit while
        else if makePaymentResult.result>0 then
        	if makePaymentResult.result<>200 then
        		failedScreen=inv_NewInputScreen("Sorry")
				failedScreen.GetInputChoice("Your payment has been declined", ["Select a different payment option"])
			else
				retVal.result=makePaymentResult.result
				exit while
			endif
		else if makePaymentResult.result<0 then
			if invPaymentOptionTable.Count()=1 then
				retVal.result=-1
				exit while
			endif
		endif
    end while
    return retVal
end function