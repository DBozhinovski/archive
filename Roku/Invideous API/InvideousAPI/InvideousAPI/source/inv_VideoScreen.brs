function inv_NewVideoScreen(invEpisode as object) as object
	this = CreateObject("roAssociativeArray")
    this.episode=invEpisode
    this.screen=invalid
    this.port=invalid
    this.Play=inv_VideoScreen_Play
    this.Stop=inv_VideoScreen_Stop
    this.Wait=inv_VideoScreen_Wait
    return this
end function

function inv_VideoScreen_Play(invPosition=0 as integer) as boolean
	if m.episode=invalid then
		return false
	endif
	
	if m.screen<>invalid or m.port<>invalid then
		return false
	endif
	
	m.port=CreateObject("roMessagePort")
	m.screen=CreateObject("roVideoScreen")
    m.screen.SetMessagePort(m.port)
    m.screen.SetPositionNotificationPeriod(1)
	m.screen.SetContent(m.episode)
	
	m.screen.Show()
	
	if invPosition>0 then
		while true
	        msg=m.Wait()
	        if type(msg) = "roVideoScreenEvent" then
	            if msg.isScreenClosed() then
	                return false
	            elseif msg.isRequestFailed() then
	                return false
	            elseif msg.isPlaybackPosition() then
	            	m.screen.Seek(invPosition*1000)
	            	exit while
	            endif
			endif
		end while
	endif
	 
	return true
			
end function

function inv_VideoScreen_Stop() as void
	
	if m.screen<>invalid then
		m.screen.Close()
	endif
	
	m.screen=invalid
	m.port=invalid

end function

function inv_VideoScreen_Wait(waitTimeout=0 as integer) as object
	
	if m.port=invalid then
		return invalid
	endif
	
	return wait(waitTimeout, m.port)
	
end function