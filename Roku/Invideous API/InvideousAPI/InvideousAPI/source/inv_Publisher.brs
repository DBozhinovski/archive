function inv_NewPublisher(pubData as object) as object
    this = CreateObject("roAssociativeArray")
    
    this.id=pubData.id
    this.username=pubData.username
    return this
    
end function 