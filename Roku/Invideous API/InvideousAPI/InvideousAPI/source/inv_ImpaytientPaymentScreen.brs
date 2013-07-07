function inv_NewImpaytientPaymentScreen(invItemOrder as object) as object
    this = CreateObject("roAssociativeArray")
    this.description="Impaytient"
    this.item_order=invItemOrder
    
    this.MakePayment=inv_ImpaytientPaymentScreen_MakePayment
    this.RegisterUser=inv_ImpaytientPaymentScreen_RegisterUser
    return this
end function

function inv_ImpaytientPaymentScreen_MakePayment() as object
	invPlatform=inv_Platform_Get()
	
	
	if not invPlatform.user.impaytient_registered then
		impRegisterUserRes=m.RegisterUser()
		if impRegisterUserRes.result<0 then
			return {
				result: -1
			}
		endif
	endif
		
	if not invPlatform.user.impaytient_registered then
		return {
			result: 100
		}
	endif
	
	impMakePaymentRes=invPlatform.user.ImpaytientMakePayment(m.item_order,invPlatform.referrer)
	
	if impMakePaymentRes.result>0 then
		return {
			result: impMakePaymentRes.result
		}
	endif
	
	return {
		result: 0
	}

end function

function inv_ImpaytientPaymentScreen_RegisterUser() as object

	invPlatform=inv_Platform_Get()
	
	impaytientRegisterUserScreen=inv_NewInputScreen("Impaytient registration")
	errorScreen=inv_NewInputScreen("Error")
	
	phoneNumber=""
	
	while true
    	phoneNumberResult=impaytientRegisterUserScreen.GetInputText("Please enter your phone number:", "", ["Register", "Back"])
		if not phoneNumberResult.result or phoneNumberResult.button=1 then
	        return {
	            result: -1
	        }
		endif
	    
    	if len(phoneNumberResult.value)>0 then
    		impaytientRegisterRes=invPlatform.user.ImpaytientRegister(phoneNumberResult.value,invPlatform.referrer)
    		if impaytientRegisterRes.result=0 then
    			phoneNumber=phoneNumberResult.value
    			exit while
    		else
    			errorScreen.GetInputChoice(impaytientRegisterRes.message, ["Next"])
    		endif
    	else
    		errorScreen.GetInputChoice("Please enter a valid phone number", ["Next"])
    	endif
	end while
	
	impaytientPinConfirmScreen=inv_NewInputScreen("Pin confirm")
	
	while true
    	pinEntryResult=impaytientPinConfirmScreen.GetInputPin(["Confirm"], 4)
		'if not pinEntryResult.result then
	    '    return {
	    '        result: -1
	    '    }
		'endif
	    
	    if len(pinEntryResult.pin)=4 then
    		impaytientPinConfirmRes=invPlatform.user.ImpaytientConfirm(phoneNumber,pinEntryResult.pin,invPlatform.referrer)
    		if impaytientPinConfirmRes.result=0 then
    			exit while
    		else
    			errorScreen.GetInputChoice(impaytientPinConfirmRes.message, ["Next"])
    		endif
    	else
    		errorScreen.GetInputChoice("Please enter a valid pin code", ["Next"])
    	endif
	end while
	
	invPlatform.user.UpdateInfo()
	
	return {
		result: 0
	}
	
end function
