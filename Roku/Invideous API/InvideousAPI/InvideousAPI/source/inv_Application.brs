function inv_NewApplication(applicationData as object) as object
    if applicationData.id="2" then
	   return inv_NewPaywall(applicationData)
	endif
	return invalid
end function