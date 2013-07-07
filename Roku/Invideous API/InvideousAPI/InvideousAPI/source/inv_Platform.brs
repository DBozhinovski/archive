function inv_Platform_Get() as object
	if m.inv_Platform=invalid then
		m.inv_Platform=CreateObject("roAssociativeArray")
        m.inv_Platform.video=invalid
        m.inv_Platform.user=invalid
        m.inv_Platform.referrer=""
        m.inv_Platform.LoginAsNewGuest=inv_Platform_LoginAsNewGuest
        m.inv_Platform.LoginSavedUser=inv_Platform_LoginSavedUser
        m.inv_Platform.LogoutUser=inv_Platform_LogOutUser
        m.inv_Platform.OnVideoStart=inv_Platform_OnVideoStart
        m.inv_Platform.OnVideoProgress=inv_Platform_OnVideoProgress
        m.inv_Platform.OnVideoStop=inv_Platform_OnVideoStop
    endif
    return m.inv_Platform
end function

function inv_Platform_LoginAsNewGuest() as boolean
    
    m.user=invalid
    
    newGuestUser=inv_NewUser()
    newGuestUserResult=newGuestUser.GetInfo()
    if newGuestUserResult then
        m.user=newGuestUser
        inv_User_SaveSession(m.user.session_id)
        return true
    endif
    return false
end function

function inv_Platform_LoginSavedUser() as boolean
	if m.user<>invalid and m.user.logged_in then
        return true
    endif
    
    m.user=invalid
    
    
    savedUserCredential=inv_User_LoadCredential()
    if savedUserCredential<>invalid then
    	loginUser=inv_NewUser()
	    loginResult=loginUser.Login(savedUserCredential.username, savedUserCredential.password)
	    if loginResult<>invalid  and loginResult.result then
	        m.user=loginUser
	        return true
	    endif
    endif
    	
    
    savedUserSession=inv_User_LoadSession()
    if savedUserSession<>invalid and len(savedUserSession)>0 then
        sessionUser=inv_NewUser()
	    if sessionUser.GetInfo(savedUserSession) then
	        m.user=sessionUser
	        return true
	    endif
	endif
    return false
end function

function inv_Platform_LogOutUser() as void
	if m.user<>invalid then
        m.user.Logout()
    	m.user=invalid
    endif
    inv_User_ClearSession()
    inv_User_ClearCredential()
end function

function inv_Platform_OnVideoStart(invVideo as object) as boolean
    
    if invVideo=invalid then
        return false
    endif
    
    if m.video<>invalid then
        return false
    endif
    
    m.video=invVideo
    
    retVal=true
    
    for each videoApp in m.video.applications
        if not videoApp.Start() then
            retVal=false
            exit for
        endif
    end for
    
    return retVal
end function

function inv_Platform_OnVideoProgress(invVideoScreen as object, videoProgress as integer) as boolean
    
    ' print "OnVideoProgress"
    if m.video=invalid or invVideoScreen=invalid then
        return false
    endif
    
    retVal=true
    
    ' print "there are ";m.video.applications.Count();" applications"
    
    for each videoApp in m.video.applications
        if not videoApp.Update(invVideoScreen, videoProgress) then
            'print "videoApp: ";videoApp.name;" failed to update"
            retVal=false
            exit for
        endif
    end for  
    return retVal
end function

function inv_Platform_OnVideoStop() as void
    ' print "OnVideoStop"
    if m.video<>invalid then
        for each videoApp in m.video.applications
            videoApp.Stop()
        end for
    endif
    m.video=invalid
    
end function