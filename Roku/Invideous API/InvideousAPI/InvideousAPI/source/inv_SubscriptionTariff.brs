function inv_NewSubscriptionTariff(subscriptionTariffData as object) as object
    this = CreateObject("roAssociativeArray")
    this.id=subscriptionTariffData.id
    this.price=subscriptionTariffData.price
    this.name=subscriptionTariffData.name
    this.period=subscriptionTariffData.period
    this.item_type=subscriptionTariffData.item_type
    this.paypal_comission=subscriptionTariffData.paypal_comission
    this.system_price=subscriptionTariffData.system_price
    this.currency=subscriptionTariffData.currency
    this.currency_symbol=subscriptionTariffData.currency_symbol
    return this
end function