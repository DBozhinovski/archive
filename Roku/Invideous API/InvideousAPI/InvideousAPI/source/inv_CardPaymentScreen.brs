function inv_NewCardPaymentScreen(invItemOrder as object) as object
    this = CreateObject("roAssociativeArray")
    this.description="Credit or Debit Card"
    this.item_order=invItemOrder
    this.MakePayment=inv_CardPaymentScreen_MakePayment
    this.MakeNewCardPayment=inv_CardPaymentScreen_MakeNewCardPayment
    this.MakeSavedCardPayment=inv_CardPaymentScreen_MakeSavedCardPayment
    return this
end function

function inv_CardPaymentScreen_MakePayment() as object
    
    invPlatform=inv_Platform_Get()
    
    invChooseCardOptions=inv_NewInputScreen("Choose an option below to continue")
    
    invCardOptions=[]
    
    ' print "inv_CardPaymentScreen_MakePayment user.saved_cards.Count()=";invPlatform.user.saved_cards.Count()
    if invPlatform.user.saved_cards.Count()>0 then
        invCardOptions.Push("Saved Card")
    endif
    invCardOptions.Push("New Credit Card")
    invCardOptions.Push("New Debit Card")
    invCardOptions.Push("Back")
    invCardOptions.Push("Cancel")
    
    retVal={
    	result:0
    }
    
    while true
	    cardChoiceResult=invChooseCardOptions.GetInputChoice("", invCardOptions)
	    
	    if not cardChoiceResult.result or cardChoiceResult.choice=invCardOptions.Count()-2 then
	    	retVal.result=-1
		    exit while
		else if cardChoiceResult.choice=invCardOptions.Count()-1 then
			retVal.result=200
			exit while
		endif
	    
        if cardChoiceResult.choice=invCardOptions.Count()-3 or cardChoiceResult.choice=invCardOptions.Count()-4 then
	    	isDebit=cardChoiceResult.choice=invCardOptions.Count()-3
			cardPaymentResult=m.MakeNewCardPayment(isDebit)
			if cardPaymentResult.result=0 then
	    		retVal.result=0
	    		exit while
	    	else if cardPaymentResult.result>0 then
	    		retVal.result=cardPaymentResult.result
	    		exit while
			endif
		else if cardChoiceResult.choice=0 then
			savedCardPymentResult=m.MakeSavedCardPayment()
			if savedCardPymentResult.result=0 then
	    		retVal.result=0
	    		exit while
	    	else if savedCardPymentResult.result>0 then
	    		retVal.result=savedCardPymentResult.result
	    		exit while
			endif
	    endif
		
	end while
    return retVal
end function

function inv_CardPaymentScreen_MakeNewCardPayment(isDebit as boolean) as object

	invPlatform=inv_Platform_Get()

    newCardScreenTitle=""
    if isDebit then
        cardScreenTitle="Debit card payment"
    else
        cardScreenTitle="Credit card payment"
    endif
    
    cardInputScreen=inv_NewInputScreen(newCardScreenTitle)
    errorScreen=inv_NewInputScreen("Error")
    
    invCardInfo=inv_NewCardInfo(isDebit)

    numPages=5
    if isDebit then
        numPages=numPages+1
    endif
        
    currentPage=0
    
    while currentPage>=0 and currentPage<numPages
        
        if currentPage=0 then
            cardHoldersNameInput=cardInputScreen.GetInputText("Enter card holder's name:", invCardInfo.holders_name, ["Next", "Back", "Cancel"])
             if cardHoldersNameInput.result and cardHoldersNameInput.button=2 then
            	return {
            		result: 200
        		}
        	else if not cardHoldersNameInput.result or cardHoldersNameInput.button=1 then
        		currentPage=currentPage-1
        	else
        		if len(cardHoldersNameInput.value)>0 then
                    currentPage=currentPage+1
                    invCardInfo.holders_name=cardHoldersNameInput.value
                else
                    errorScreen.GetInputChoice("Please enter a valid card holder's name", ["Next"])
                endif
            endif
        else if currentPage=1 then
            cardNumberInput=cardInputScreen.GetInputText("Enter card number:", invCardInfo.number, ["Next", "Back", "Cancel"], true)
            if cardNumberInput.result and cardNumberInput.button=2 then
            	return {
            		result: 200
        		}
        	else if not cardNumberInput.result or cardNumberInput.button=1 then
        		currentPage=currentPage-1
        	else
    	        if inv_Utils_ValidateCardNumber(cardNumberInput.value) then
                    currentPage=currentPage+1
                    invCardInfo.number=cardNumberInput.value
                else
                    errorScreen.GetInputChoice("Please enter a valid card number", ["Next"])
                endif
            endif
        else if currentPage=2 then
            cardCVVCodeInput=cardInputScreen.GetInputText("Enter CVV code:", invCardInfo.cvv_code, ["Next", "Back", "Cancel"], true)
            if cardCVVCodeInput.result and cardCVVCodeInput.button=2 then
            	return {
            		result: 200
        		}
        	else if not cardCVVCodeInput.result or cardCVVCodeInput.button=1 then
        		currentPage=currentPage-1
        	else
        	    if inv_Utils_ValidateCVV(cardCVVCodeInput.value) then
                    currentPage=currentPage+1
                    invCardInfo.cvv_code=cardCVVCodeInput.value
                else
                    errorScreen.GetInputChoice("Please enter a valid CVV code", ["Next"])
                endif
            endif
        else if currentPage=3 then
            cardExpiryMonthInput=cardInputScreen.GetInputText("Enter card expiry month:", invCardInfo.expiry_month, ["Next", "Back", "Cancel"])
            
            if cardExpiryMonthInput.result and cardExpiryMonthInput.button=2 then
            	return {
            		result: 200
        		}
        	else if not cardExpiryMonthInput.result or cardExpiryMonthInput.button=1 then
        		currentPage=currentPage-1
        	else
    	        if inv_Utils_ValidateMonth(cardExpiryMonthInput.value) then
                    currentPage=currentPage+1
                    invCardInfo.expiry_month=cardExpiryMonthInput.value
                else
                    errorScreen.GetInputChoice("Please enter a valid expiry month in MM format", ["Next"])
                endif
            endif 
        else if currentPage=4 then
            cardExpiryYearInput=cardInputScreen.GetInputText("Enter card expiry year:", invCardInfo.expiry_year, ["Next", "Back", "Cancel"])
            
            if cardExpiryYearInput.result and cardExpiryYearInput.button=2 then
            	return {
            		result: 200
        		}
        	else if not cardExpiryYearInput.result or cardExpiryYearInput.button=1 then
        		currentPage=currentPage-1
        	else
    	        if inv_Utils_ValidateYear(cardExpiryYearInput.value) then
                    currentPage=currentPage+1
                    invCardInfo.expiry_year=cardExpiryYearInput.value
                else
                    errorScreen.GetInputChoice("Please enter a valid expiry year in YYYY format", ["Next"])
                endif
            endif    
        else if currentPage=5 then
            cardDebitBankInput=cardInputScreen.GetInputText("Enter Issuing Bank name:", invCardInfo.issuing_bank, ["Next", "Back", "Cancel"])
            
            if cardDebitBankInput.result and cardDebitBankInput.button=2 then
            	return {
            		result: 200
        		}
        	else if not cardDebitBankInput.result or cardDebitBankInput.button=1 then
        		currentPage=currentPage-1
        	else
                if len(cardDebitBankInput.value)>0 then
                    currentPage=currentPage+1
                    invCardInfo.issuing_bank=cardDebitBankInput.value
                else
                    errorScreen.GetInputChoice("Please enter a valid Issuing Bank name", ["Next"])
                endif
            endif
        endif
    end while
    
    if currentPage<0 then
        return {
            result: -1
        }
    endif
    
    invMakeCardPaymentResult=invPlatform.user.MakeCardPayment(m.item_order, invCardInfo, invPlatform.referrer)
    
    if invMakeCardPaymentResult.result=0 then
    	return {
        	result: 0
    	}
   	endif
   	
   	return {
   		result: invMakeCardPaymentResult.result
   	}

end function

function inv_CardPaymentScreen_MakeSavedCardPayment() as object
	
	invPlatform=inv_Platform_Get()
	
	invChooseSavedCard=inv_NewInputScreen("Choose how you want to pay")
	
	invSavedCardsOptions=[]
    
    for sc=0 to invPlatform.user.saved_cards.Count()-1 step 1
    	invSavedCardsOptions.Push(invPlatform.user.saved_cards[sc].card_number)
   	end for
    
    invSavedCardsOptions.Push("Back")
    invSavedCardsOptions.Push("Cancel")
    
    retVal={
    	result: 0
	}
	
	while true
	    savedCardChoiceResult=invChooseSavedCard.GetInputChoice("", invSavedCardsOptions)
	    
	    if savedCardChoiceResult.result and savedCardChoiceResult.choice=invSavedCardsOptions.Count()-1 then
	    	retVal.result=200
			exit while
		else if not savedCardChoiceResult.result or savedCardChoiceResult.choice=invSavedCardsOptions.Count()-2 then
			retVal.result=-1
			exit while
		else
        	savedCardPaymentResult=invPlatform.user.MakeSavedCardPayment(m.item_order, invPlatform.user.saved_cards[savedCardChoiceResult.choice], invPlatform.referrer)
	    	
	    	if savedCardPaymentResult.result=0 then
	    		retVal.result=0
	    		exit while
	    	else
	    		retVal.result=100
	    		exit while
	    	endif
		endif
	end while
	
	return retVal
end function