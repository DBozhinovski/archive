function inv_NewCardInfo(invIsDebit=false as boolean) as object
	this = CreateObject("roAssociativeArray")
	this.is_debit=invIsDebit
	this.holders_name=""
	this.number=""
	this.cvv_code=""
	this.expiry_month=""
	this.expiry_year=""
	this.issuing_bank=""
	return this
end function

