function inv_NewVideo(videoDetails as object) as object

    this = CreateObject("roAssociativeArray")
    this.id=videoDetails.id
    this.source_url=videoDetails.source_url
    this.title=videoDetails.title
    this.ovp_name=videoDetails.ovp_name
    this.brightcove=videoDetails.brightcove
    this.bc_video_id=videoDetails.bc_video_id
    this.subscription_excluded=videoDetails.subscription_excluded<>invalid and videoDetails.subscription_excluded<>"0"
    this.publisher=inv_NewPublisher(videoDetails.publisher_data)
    this.is_paid=videoDetails.is_paid<>invalid and videoDetails.is_paid<>"0"
    this.HasAccess=inv_Video_HasAccess
    
    this.applications=[]
    
    for each applicationData in videoDetails.applications
        videoApp=inv_NewApplication(applicationData)
        if videoApp<>invalid then
            this.applications.Push(videoApp)
        endif
    next
    this.UpdateIsPaid=inv_Video_UpdateIsPaid
    return this
end function

function inv_Video_GetDetails(videoId as string, invUser=invalid as object, ovpVideoType="bc_video_id" as string) as object
    
    getVideoDetailsReq=NewHTTP("http://api.invideous.com/plugin/get_video_details")
    getVideoDetailsReq.AddParam(ovpVideoType, videoId)
    if invUser<>invalid then
        getVideoDetailsReq.AddParam("session_id", invUser.session_id)
    endif
    getVideoDetailsResp=getVideoDetailsReq.GetToStringWithTimeout(10)
    
    'print "inv_Video_GetDetails: ";getVideoDetailsResp
    
    jsonResp=inv_ParseJSON(getVideoDetailsResp)
    
    if jsonResp = invalid then
        return invalid
    endif
    
    if jsonResp.response.status <> "success" then
        return invalid
    endif
    
    return inv_NewVideo(jsonResp.response.result)
end function

function inv_Video_UpdateIsPaid(invUser as object) as boolean

    ' print type(invUser)
    ' print type(m)
    ' print type(invUser.session_id)
    ' print type(m.id)
    
    getVideoDetailsReq=NewHTTP("http://api.invideous.com/plugin/get_video_details")
    getVideoDetailsReq.AddParam("video_id", m.id)
    
    
    
    if invUser<>invalid then
        getVideoDetailsReq.AddParam("session_id", invUser.session_id)
    endif
    
    getVideoDetailsResp=getVideoDetailsReq.GetToStringWithTimeout(10)
    
    'print "inv_Video_UpdateIsPaid: ";getVideoDetailsResp
    
    jsonResp=inv_ParseJSON(getVideoDetailsResp)
    
    if jsonResp = invalid then
        return false
    endif
    
    if jsonResp.response.status <> "success" then
        return false
    endif
    
    m.is_paid=jsonResp.response.result.is_paid<>invalid and jsonResp.response.result.is_paid<>"0"
    
    return true
end function

function inv_Video_HasAccess(invUser as object) as boolean
	return m.is_paid
end function
