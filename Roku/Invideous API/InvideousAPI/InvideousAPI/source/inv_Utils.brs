function inv_Utils_ValidateCardNumber(invCardNumber as string) as boolean
	cardNumberRegex=CreateObject("roRegex","^[1-9]\d{12,15}$","i")
	return cardNumberRegex.IsMatch(invCardNumber)
end function

function inv_Utils_ValidateMonth(invMonth as string) as boolean
	monthRegex=CreateObject("roRegex","^((0[1-9])|(1[0-2]))$","i")
	return monthRegex.IsMatch(invMonth)
end function

function inv_Utils_ValidateYear(invYear as string) as boolean
	yearRegex=CreateObject("roRegex","^(19|20|21)\d\d$","i")
	return yearRegex.IsMatch(invYear)
end function

function inv_Utils_ValidateCVV(invCVV as string) as boolean
	cvvRegex=CreateObject("roRegex","^\d\d\d$","i")
	return cvvRegex.IsMatch(invCVV)
end function

function inv_Utils_ValidateEmail(invEmail as string) as boolean
	emailRegex=CreateObject("roRegex","^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$","i")
	return emailRegex.IsMatch(invEmail)
end function