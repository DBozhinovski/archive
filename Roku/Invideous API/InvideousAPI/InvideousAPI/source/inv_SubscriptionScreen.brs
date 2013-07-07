function inv_NewSubscriptionScreen(invSubscriptionTariffs as object) As Object
    this = CreateObject("roAssociativeArray")
    this.subscription_tariffs=invSubscriptionTariffs
    this.title="Subscription options"
    this.ChooseOrder=inv_SubscriptionScreen_ChooseOrder
    
    return this
end function

function inv_SubscriptionScreen_ChooseOrder() as object

    subscriptionOptions=[]
    
    for subTariff=0 to m.subscription_tariffs.Count()-1 step 1
        subscriptionOption=m.subscription_tariffs[subTariff].name+" "+m.subscription_tariffs[subTariff].system_price+m.subscription_tariffs[subTariff].currency_symbol
        subscriptionOptions.Push(subscriptionOption)
    end for
    
    subscriptionOptions.Push("Back")
    subscriptionOptions.Push("Cancel")
    
    chooseSubscriptionScreen=inv_NewInputScreen("Subscribe to all videos on channel")
    chooseResult=chooseSubscriptionScreen.GetInputChoice("", subscriptionOptions)
    
    if not chooseResult.result or chooseResult.choice=subscriptionOptions.Count()-2 then
        return {
            result: -1,
            item_order: invalid
        }
    endif
    
    if chooseResult.choice=subscriptionOptions.Count()-1 then
    	return {
            result: 200,
            item_order: invalid
        }
    endif
    
    invItemOrder={
        id: m.subscription_tariffs[chooseResult.choice].id,
        item_type: m.subscription_tariffs[chooseResult.choice].item_type
    }
    
    return {
        result: 0,
        item_order: invItemOrder
    }

end function