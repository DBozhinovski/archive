'
' adRise SDK 3.51
' For more info visit: http://adRise.com
' or contact pubs@adrise.com
'

REM ******************************************************
REM  adrise_get_next_ad(ad_type as string, ContentId as string)
REM ******************************************************
Function adrise_get_next_ad(ad_type, episode)


	REM ============================================================================================
	REM ===== CHANGE Publisher ID or Zone ID HERE: =================================================
	pubid = "7e8b53bcff373995ba1b76b5fc25cbc3" 
	zoneid = "classicalTV_1"
	
	m.adrise_bg = "#00000"
	m.adrise_fontcolor = "#FFFFFF"
	m.adrise_loadingurl = "pkg:/images/loading.png"
	REM ============================================================================================
	REM ============================================================================================
		
	' Get IP address
	di = CreateObject("roDeviceInfo")
	ipAddrs = di.GetIPAddrs()
	ipAddr = ipAddrs.eth0

	if (ad_type = "video") then
		m.UrlAdrise       = "http://ads.adrise.tv/?platform=roku&sdk=3.0_video"
		REM =====================================================
		REM We need a unique identifier for this episode. If episode.contentId does not exist, correct the following line: 
		REM =====================================================
		episode.adrise_contentId = episode.Id
		
		
	    m.UrlAdrise       =  m.UrlAdrise + "&cid=" + episode.adrise_contentId	
		m.UrlAdrise       =  m.UrlAdrise + "&nowpos=" + episode.nowpos.ToStr()
	else
		m.UrlBase         = "http://ads.adrise.tv/?platform=roku&sdk=2.2&"
	    m.UrlAdrise       =  m.UrlBase + "&width=" + "728"
	    m.UrlAdrise       =  m.UrlAdrise + "&height=" + "90"
	end if
	
    m.UrlAdrise       =  m.UrlAdrise + "&model=" + di.GetModel() 
    m.UrlAdrise       =  m.UrlAdrise + "&firm_ver=" + di.GetVersion() 
    m.UrlAdrise       =  m.UrlAdrise + "&deviceid=" + di.GetDeviceUniqueId() 
    m.UrlAdrise       =  m.UrlAdrise + "&aspect_ratio=" + di.GetDisplayAspectRatio() 
    m.UrlAdrise       =  m.UrlAdrise + "&pubid=" + pubid
    m.UrlAdrise       =  m.UrlAdrise + "&zid=" + zoneid		
    m.UrlAdrise       =  m.UrlAdrise + "&unique=" + RND(10000000).ToStr()

	m.skip_ads = false
	
	'm.UrlAdrise       =  m.UrlAdrise + "&client_ip=" + ipAddr
	' Get IP address
	x = di.GetIPAddrs()
	for each i in x
		m.UrlAdrise       =  m.UrlAdrise + "&client_ip=" + x[i]
	end for	

 	' print m.UrlAdrise
    http = NewHttp(m.UrlAdrise)
    rsp = http.Http.GetToString()
    xml = CreateObject("roXMLElement")
  
    if not xml.Parse(rsp) then
		m.skip_ads = true
        ' print "=adRise=: Can't parse response"
        ' ShowConnectionFailed()
        return ""
    end if

    if xml.GetName() <> "feed" 
		m.skip_ads = true
        Dbg("Bad register response: ",  xml.GetName())
        ' ShowConnectionFailed()
        return ""
    end if

    if islist(xml.GetBody()) = false then
		m.skip_ads = true
        Dbg("No registration information available")
        ' ShowConnectionFailed()
        return ""
    end if

	' getting ad meta data:
	m.adrise_commercial_break = []
	m.adrise_last_comercial_break = 0
	adrise_break_count = 0
	For Each breakpoint in xml.metadata.break.position
		m.adrise_commercial_break[adrise_break_count] = breakpoint.GetText().toInt()
		adrise_break_count = adrise_break_count + 1
	next
	
	m.adrise_commercial_duration = xml.metadata.resultduration.GetText().toInt()
	
	adrise_adUnits = []
	adrise_ad_count = 0
	
	
	if (ad_type = "video") then
		items = xml.items.item
	else
		items = xml.item
	end if
	
	For Each item in items
	     'initialize variables with empty strings, just in case they're missing in the XML
		
		adUnit = CreateObject("roAssociativeArray")

		adUnit.adType = ad_type

		adUnit.ContentType =item.contentType.GetText()
		adUnit.ShortDescriptionLine1 =item.title.GetText()
		adUnit.ShortDescriptionLine2 =""
		adUnit.Description =item.synopsis.GetText()
		adUnit.Rating = item.rating.GetText()
		adUnit.Genres = item.genres.GetText()
		adUnit.StarRating =item.starrating.GetText()
		adUnit.Categories =""
		adUnit.Title =item.title.GetText()
		adUnit.Runtime=item.runtime.GetText()  


	'  these are actually part of <item sdImg= "" hdImg=""/> 
		adUnit.SDPosterUrl = item@sdImg
		adUnit.HDPosterUrl = item@hdImg

	'imp tracking:
		adUnit.impTrack = adrise_get_tracking_tags(item.imptracking)
		
	'click tracking:
		adUnit.clickTrack = adrise_get_tracking_tags(item.clickTrack)

	'view through tracking:		
		adUnit.viewthru = []		
		adUnit.viewthru[0] 	= adrise_get_tracking_tags(item.media.trackingevents.tracking_0)
		adUnit.viewthru[25] = adrise_get_tracking_tags(item.media.trackingevents.tracking_25)
		adUnit.viewthru[50] = adrise_get_tracking_tags(item.media.trackingevents.tracking_50)
		adUnit.viewthru[75] = adrise_get_tracking_tags(item.media.trackingevents.tracking_75)
		adUnit.viewthru[100]= adrise_get_tracking_tags(item.media.trackingevents.tracking_100)
		
		adUnit.StreamUrls = item.media.streamUrl.GetText()
		adUnit.Duration = item.media.Duration.GetText()
		adUnit.PluginID = item.media.pluginID.GetText()		
		
		adUnit.StreamQualities = item.media.streamQuality.GetText()
		adUnit.StreamBitrates = [0]
		adUnit.StreamFormat = item.media.streamFormat.GetText()
		adUnit.srt =""
		adUnit.MinBandwidth = 30
	
		adUnit.bar = "like"

	'	print "=adRise=: StreamUrls: " + adUnit.StreamUrls
	'	print "=adRise=: PluginID: " + adUnit.PluginID		
	'	print "=adRise=: StreamQualities: " + adUnit.StreamQualities
	'	print "=adRise=: StreamFormat: " + adUnit.StreamFormat
	'	print "=adRise=: Title: " + adUnit.Title
				
		if (item.interactivebar <> invalid) then
			option_count = 0
			adUnit.adBar = []
			For Each option in item.interactivebar.option
				adUnit.adBar[option_count] = CreateObject("roAssociativeArray")
				
				adUnit.adBar[option_count].img = option.img.GetText()
				adUnit.adBar[option_count].url = option.url.GetText()				
				option_count = option_count + 1
			Next
			
			adUnit.adBar_thanks_img = item.interactivebar.thanks.img.GetText()
		end if
		adUnit.currentOption = 0
		adUnit.totalOptions = option_count 
		
		adrise_adUnits[adrise_ad_count] = adUnit
		adrise_ad_count = adrise_ad_count + 1
	Next
   
	if (ad_type = "video") then
		return adrise_adUnits
	else 
		return adUnit
	end if
	
End Function

REM ******************************************************
REM  adrise_get_tracking_tags(xml_tags)
REM ******************************************************
Function adrise_get_tracking_tags(xml_tags)
	return_val = []
	count = 0
	For Each item in xml_tags
		return_val[count] = item.GetText()
		count = count + 1
	next
	
	return return_val
End Function

REM ******************************************************
REM  adrise_banner_ad(screen)
REM ******************************************************
Function adrise_banner_ad(screen)
	adUnit = adrise_get_next_ad("banner", "0")
	
	if type(adUnit) <> "roAssociativeArray" then
		return adUnit
	end if
	
	screen.SetAdURL(adUnit.SDPosterUrl, adUnit.HDPosterUrl)
	screen.SetAdDisplayMode("scale-to-fit")
	
	if adUnit.PluginID <> "" then
		screen.SetAdSelectable(true)
	else if adUnit.StreamUrls <> "" then
		screen.SetAdSelectable(true)
	end if
	
	return adUnit
End Function

REM ******************************************************
REM  adrise_handle_click(adUnit)
REM ******************************************************
Function adrise_handle_click(adUnit)
	if m.skip_ads then return false
	adrise_trackEvent(adUnit, "click", 0)
			
	if adUnit.PluginID <> "" then
		adrise_channelStoreGoToAPP(adUnit.PluginID)
	else if adUnit.StreamUrls <> "" and adUnit.adType <> "video" then
		adrise_displayVideoAd(adUnit)
	end if	
End Function

REM ******************************************************
REM  adrise_displayVideoAd(adUnit)
REM ******************************************************
Function adrise_displayVideoAd(adUnit As Object)
    ' print "=adRise=: Displaying video ad"
    p = CreateObject("roMessagePort")
    video = CreateObject("roVideoScreen")
    video.setMessagePort(p)
	
	video.SetContent(adUnit)
	video.SetPositionNotificationPeriod(1)
    video.show()

    lastSavedPos   = 0
	positionPercentage = 0
	'position must change by more than this number of seconds before saving
    statusInterval = adUnit.Duration.toInt() / 4

    while true
        msg = wait(0, video.GetMessagePort())
        if type(msg) = "roVideoScreenEvent"
            if msg.isScreenClosed() then 'ScreenClosed event
                ' print "=adRise=: Closing video screen"
                exit while
			else if msg.isFullResult()
				if (positionPercentage >= 75) adrise_trackEvent(adUnit, "viewthru", 100)
            else if msg.isPlaybackPosition() then
                nowpos = msg.GetIndex()

				if nowpos = 0 then
					adrise_trackEvent(adUnit, "viewthru", positionPercentage)
                else if nowpos > 0 then
                    if abs(nowpos - lastSavedPos) > statusInterval
                        lastSavedPos = nowpos
						positionPercentage = positionPercentage + 25
						if (positionPercentage < 100) adrise_trackEvent(adUnit, "viewthru", positionPercentage)
                    end if
                end if
            else if msg.isRequestFailed()
                print "=adRise=: play failed: "; msg.GetMessage()
            else
                print "=adRise=: Unknown event: "; msg.GetType(); " msg: "; msg.GetMessage()
            endif
        end if
    end while

End Function

REM ******************************************************
REM  adrise_channelStoreGoToAPP(pluginID)
REM ******************************************************
Function adrise_channelStoreGoToAPP(pluginID)
	di = CreateObject("roDeviceInfo")
	' ipAddrs = di.GetIPAddrs()
	' ipAddr = ipAddrs.eth0
	
	x = di.GetIPAddrs()
	for each i in x
		ipAddr =  x[i]
	end for
		
	'REM See the ECP document examples for how to obtain your plugin ID
    url = "http://"+ ipAddr +":8060/launch/11?contentID="+ pluginID
    bodyString = ""
	' print "roku url: "; url
	port = CreateObject("roMessagePort")
	request = createObject("roUrlTransfer")
	request.setPort(port)
	request.setUrl(url)
	response = request.asyncPostFromString(bodyString)
    while true
        msg = wait(0, port)
		if type(msg) = "roUrlEvent"
            if msg.getInt() = 1 then
                ' print "=adRise=: Response code: "; msg.GetResponseCode()
				if msg.GetResponseCode() = 404
                    response = invalid
				else
					response = msg.getString()
				end if
				exit while
			end if
        end if
    end while
	return response
End Function

REM ******************************************************
REM  Function adrise_trackEvent(adUnit, eventType, eventVal)
REM ******************************************************
Function adrise_trackEvent(adUnit, eventType, eventVal)

	trackUrl = "http://adrise.tv/?tracking"
	
	if eventType = "click" then
		For Each trackUrl in adUnit.clickTrack
			' print "=adRise= CLICK: " +  trackUrl		
			adrise_ping(trackUrl)
		Next
		adrise_ping(trackUrl)		
	else if eventType = "imp" then
		For Each trackUrl in adUnit.impTrack
			print "=adRise= IMP: " +  trackUrl
			adrise_ping(trackUrl)
		Next
	else if eventType = "viewthru" then
		For Each trackUrl in adUnit.viewthru[eventVal]
			adUnit.viewthru[eventVal] = "" 'making sure it doesn't get fired again
			print "=adRise= ViewThrough: " +  trackUrl
			adrise_ping(trackUrl)
		Next
	end if

End Function

REM ******************************************************
REM  adrise_ping(url)
REM ******************************************************
Function adrise_ping(url)
	url = url.trim()
	m.http = CreateObject("roUrlTransfer")
	m.http.SetUrl(url)
	
	adrise_http_get_to_string_with_retry()
	
	' print "=adRise= TRACKING: " +  url
End Function

REM ******************************************************
REM  adrise_show_commercial_break(canvas)
REM ******************************************************
Function adrise_show_commercial_break(canvas)
	ad_counter = 0
	if m.skip_ads then return true
	if type(m.videoAds) <> "roArray" return true
	
	ad_details = CreateObject("roAssociativeArray") 
	ad_details.total_ads = m.videoAds.Count()
	ad_details.seconds_left = m.adrise_commercial_duration + m.videoAds.Count()
	ad_details.ad_counter = 0
	
	while ad_counter < m.videoAds.Count()
		ad_details.ad_counter = ad_details.ad_counter + 1
		' track impression
		' adrise_trackEvent(m.videoAds[ad_counter], "imp", 0)
		adCompleted = adrise_ShowvideoAd(canvas, m.videoAds[ad_counter], ad_details)
		ad_details.seconds_left = ad_details.seconds_left - m.videoAds[ad_counter].Duration.toInt()

		if adCompleted
			ad_counter = ad_counter + 1
		else
			canvas.Close()
			return false 
		end if
	end while
	
	m.adrise_last_comercial_break = CreateObject("roDateTime").asSeconds()
	
	return adCompleted
End Function

REM ******************************************************
REM  adrise_PlayVideo(episode)
REM ******************************************************
sub adrise_PlayVideo(episode)
	' set up a video ad
	
	invPlatform=inv_Platform_Get()
    
    ' retrieve video details:
    invVideo=inv_Video_GetDetails(episode.id, invPlatform.user)
    'invVideo=inv_Video_GetDetails("1542906", invPlatform.user)
    if invVideo<>invalid then
    	' notify inv_Platform for video we want to play:
        invPlatform.OnVideoStart(invVideo)
    endif
	
	canvas = CreateObject("roImageCanvas")
	episode.nowpos = 0
	m.videoAds = adrise_get_next_ad("video", episode)
	
	' if m.videoAds = "" then
	'	canvas.Close()
	' end if
		
	canvas.SetMessagePort(CreateObject("roMessagePort"))
	canvas.SetLayer(1, {color: "#000000"})
	canvas.Show()

    shouldContinue = true

	' play the pre-roll
	shouldContinue = adrise_show_commercial_break(canvas)
	
	' if the ad completed without the user pressing UP, play the content
    while shouldContinue
      shouldContinue = adrise_ShowContentVideoScreen(episode)
      Sleep(1000) ' to ensure proper playback of the midroll

      if shouldContinue
		canvas.SetMessagePort(CreateObject("roMessagePort"))
		canvas.SetLayer(1, {color: "#000000"})
		canvas.Show()

		m.videoAds = adrise_get_next_ad("video", episode)
        shouldContinue = adrise_show_commercial_break(canvas)
      end if
    end while
	
	canvas.Close()
	
	' notify inv_Platform that we have finished playing the video
	invPlatform.OnVideoStop()
	
end sub

REM ******************************************************
REM  adrise_ShowvideoAd(canvas, adUnit, ad_details)
REM ******************************************************
function adrise_ShowvideoAd(canvas, adUnit, ad_details)
	result = true
	port = CreateObject("roMessagePort")
	canvas = CreateObject("roImageCanvas")
	canvas.SetMessagePort(port)
	
	if type(adUnit) <> "roAssociativeArray" then
		canvas.close()
		return result
	end if
	
	deviceInfo = CreateObject( "roDeviceInfo" )
	displaySize = deviceInfo.GetDisplaySize()
	

	background = {
	    Color: m.adrise_bg 
	}
	loadingImage = {
		    Url: m.adrise_loadingurl
	    TargetRect: {
	        x: Int( displaySize.w / 2 ) - Int( 336 / 2 ),
	        y: Int( displaySize.h / 2 ) - Int( 210 / 2 ),
	        w: 336,
	        h: 210
	    }
	}
	loadingText = {
	    Text: "Your program will begin in " + ad_details.seconds_left.ToStr() + " seconds",
	    TextAttrs: {
	        Font: "Medium",
	        VAlign: "Bottom",
			Color: m.adrise_fontcolor,
	    },
	    TargetRect: {
	        x: loadingImage.TargetRect.x - 125,
	        y: loadingImage.TargetRect.y + 250,
	        w: loadingImage.TargetRect.w + 250,
	        h: 30
	    }
	}
	adrise = {
	    Text: "Ads by adRise",
	    TextAttrs: {
	        Font: "small",
	        VAlign: "Bottom",
			Color: m.adrise_fontcolor,
	    },
	    TargetRect: {
	        x: loadingImage.TargetRect.x - 125,
	        y: loadingImage.TargetRect.y + 300,
	        w: loadingImage.TargetRect.w + 250,
	        h: 30
	    }
	}


	if ad_details.total_ads > 1 then
		loadingText.Text = "Ad " + ad_details.ad_counter.ToStr() + " of " + ad_details.total_ads.ToStr() + ": " + loadingText.Text
	end if

	player = CreateObject("roVideoPlayer")
	' be sure to use the same message port for both the canvas and the player
	player.SetMessagePort(canvas.GetMessagePort())
	player.SetDestinationRect(canvas.GetCanvasRect())
	player.SetPositionNotificationPeriod(1)

	' set up some messaging to display while the pre-roll buffers
	canvas.SetLayer( 2, [ background, loadingImage, loadingText, adrise ] )
	canvas.Show()

	player.AddContent(adUnit)
	player.Play()

    lastSavedPos   = 0
	positionPercentage = 0
    statusInterval = adUnit.Duration.toInt() / 4
	
	while true
		msg = wait(0, canvas.GetMessagePort())
		
		
		if type(msg) = "roImageCanvasEvent" then
	           if (msg.isRemoteKeyPressed()) then
                i = msg.GetIndex()
                if (i = 13) then
					print "Pressed Play"
                else if (i = 8) then
					print "Pressed Rewind"
                else if (i = 9) then
					print "Pressed Fast Forward"
                else if (i = 6) then
					print "Pressed Select"
					if adUnit.totalOptions > 0
						print "====================================="
						filename = adUnit.adBar_thanks_img + "?" + RND(10000000).ToStr()

						canvas.SetLayer(10, {  Url: filename, TargetRect: { x: 0 , y: 30, w: displaySize.w, h: 80 }, CompositionMode: "Source_over" })
						canvas.Show()					
						adrise_ping(adUnit.adBar[adUnit.currentOption].url)
						' disable future interactions:
						adUnit.totalOptions = 0
					end if
				
					adrise_handle_click(adUnit)					
                else if (i = 5) then 
					print "Pressed Right"
					if (adUnit.totalOptions > 0 and adUnit.currentOption < adUnit.totalOptions - 1) then
					 	adUnit.currentOption = adUnit.currentOption + 1
						filename = adUnit.adBar[adUnit.currentOption].img + "?" + RND(10000000).ToStr()

						canvas.SetLayer(10, {  Url: filename, TargetRect: { x: 0 , y: 30, w: displaySize.w, h: 80 }, CompositionMode: "Source_over" })
						canvas.Show()					
					end if
                else if (i = 4) then
					print "Pressed Left"
					if (adUnit.totalOptions > 0 and adUnit.currentOption > 0) then 
						adUnit.currentOption = adUnit.currentOption - 1
						filename = adUnit.adBar[adUnit.currentOption].img + "?" + RND(10000000).ToStr()
						canvas.SetLayer(10, {  Url: filename, TargetRect: { x: 0 , y: 30, w: displaySize.w, h: 80 }, CompositionMode: "Source_over" })
						canvas.Show()					
					end if
                else if (i = 2) then
					print "Pressed Up"
                else if (i = 3) then
					print "Pressed Down"
                end if
            else if (msg.isScreenClosed()) then
				canvas.close()
                return result
			end if
		elseif type(msg) = "roVideoPlayerEvent"
			if msg.isFullResult()
				if (positionPercentage >= 75) 
					adrise_trackEvent(adUnit, "viewthru", 100)
					canvas.close()
				end if
				exit while
            else if msg.isPlaybackPosition() then
                nowpos = msg.GetIndex()
 
				if nowpos = 0 then
					canvas.SetLayer(9, {  TargetRect: { x: 0, y: 0, w: 0, h: 0 }, CompositionMode: "Source" })
					deviceInfo = CreateObject( "roDeviceInfo" )
					displaySize = deviceInfo.GetDisplaySize()

					if (displaySize.h >= 1280 ) then
						definition = "hd"
					else 
						definition = "sd"
					end if
					
					if adUnit.totalOptions > 0 then
						filename = adUnit.adBar[adUnit.currentOption].img + "?" + RND(10000000).ToStr()

						canvas.SetLayer(10, {  Url: filename, TargetRect: { x: 0 , y: 30, w: displaySize.w, h: 80 }, CompositionMode: "Source_over" })
						canvas.Show()	
					end if
				    '''''''''''''''''''''''''''''
					adrise_trackEvent(adUnit, "imp", 0)
					adrise_trackEvent(adUnit, "viewthru", positionPercentage)
				
                else if nowpos > 0 then
                    if abs(nowpos - lastSavedPos) > statusInterval and positionPercentage < 75
                        lastSavedPos = nowpos
						positionPercentage = positionPercentage + 25
						if (positionPercentage < 100) adrise_trackEvent(adUnit, "viewthru", positionPercentage)
                    end if
                end if				
			else if msg.isPartialResult()
				result = false
				exit while
			else if msg.isStatusMessage()
				if msg.GetMessage() = "start of play"
				  ' once the video starts, clear out the canvas so it doesn't cover the video
					canvas.ClearLayer(2)
					canvas.SetLayer(1, {color: "#00000000", CompositionMode: "Source"})
					canvas.Show()
				end if
			end if
		end if
	end while
	
	player.Stop()
	canvas.close()
	return result
end function

REM ******************************************************
REM  adrise_check_commercial_break(nowpos, episode) 
REM ******************************************************
Function adrise_check_commercial_break(nowpos, episode) 
	result = false

	if type(m.adrise_commercial_break) <> "roArray" return false
	
	if m.adrise_commercial_break.count() > 0 then 
		' If user has seen a commercial break in the past 60 seconds, skip it:
		if (CreateObject("roDateTime").asSeconds() - m.adrise_last_comercial_break) > 60
			' print "=adRise= commercial after:" + (CreateObject("roDateTime").asSeconds() - m.adrise_last_comercial_break).tostr()
			for each breakpoint in m.adrise_commercial_break
				'take a commercial break:
				if (breakpoint - 10 < nowpos) AND (breakpoint >= nowpos) then
					episode.playStart = nowpos 
					result = true
				end if
			next
		else
			print "=adRise= Skipping commercial - sec:" + nowpos.tostr()
		end if 
	end if
	return result
End Function

REM ******************************************************
REM  adrise_ShowContentVideoScreen(episode As Object)
REM ******************************************************
Function adrise_ShowContentVideoScreen(episode As Object)
	result = false
	
	invPlatform=inv_Platform_Get()
	
    if type(episode) <> "roAssociativeArray" then
        print "invalid data passed to showVideoScreen"
        return false
    endif
    
    ' create a new inv_VideoScreen for playing video
    invVideoScreen=inv_NewVideoScreen(episode)
    
    
    'if episode.streams.Count() = 0
	'	bc = NWM_Brightcove(m.brightcoveToken)
	'	bc.GetRenditionsForEpisode(episode)
	'end if

	'========================
   'Uncomment his line to dump the contents of the episode to be played
    'PrintAA(episode)
    
    if not invVideoScreen.Play() then
    	return result
    endif
    

    while true
        msg = invVideoScreen.Wait()

        if type(msg) = "roVideoScreenEvent" then
            'print "showHomeScreen | msg = "; msg.getMessage() " | index = "; msg.GetIndex()
            if msg.isScreenClosed()
                print "Screen closed"
                exit while
            elseif msg.isRequestFailed()
                print "Video request failure: "; msg.GetIndex(); " " msg.GetData() 
            elseif msg.isStatusMessage()
                print "Video status: "; msg.GetIndex(); " " msg.GetData() 
            elseif msg.isButtonPressed()
                print "Button pressed: "; msg.GetIndex(); " " msg.GetData()
			'========================
            elseif msg.isPlaybackPosition() then
            
                nowpos=msg.GetIndex()
                RegWrite(episode.adrise_contentId, nowpos.ToStr())
                
                if invPlatform.OnVideoProgress(invVideoScreen, nowpos) then
                	if adrise_check_commercial_break(nowpos, invVideoScreen.episode) then
    					invVideoScreen.episode.nowpos = nowpos
    					result = true
    					exit while
    				end if
    		    else
                    exit while
    		    endif
			'========================								
            else
                print "Unexpected event type: "; msg.GetType()
            end if
        else
            print "Unexpected message class: "; type(msg)
        end if
    end while

	invVideoScreen.Stop()
	return result
End Function

REM ******************************************************
REM adrise_http_get_to_string_with_retry()
REM ******************************************************
Function adrise_http_get_to_string_with_retry() as String
    timeout%         = 5000
    num_retries%     = 5

    str = ""
    while num_retries% > 0
'        print "httpget try " + itostr(num_retries%)
        if (m.Http.AsyncGetToString())
            event = wait(timeout%, m.Http.GetPort())
            if type(event) = "roUrlEvent"
                str = event.GetString()
                exit while        
            elseif event = invalid
                m.Http.AsyncCancel()
                REM reset the connection on timeouts
                m.Http = CreateURLTransferObject(m.Http.GetUrl())
                timeout% = 2 * timeout%
            else
                print "roUrlTransfer::AsyncGetToString(): unknown event"
            endif
        endif

        num_retries% = num_retries% - 1
    end while
    
    return str
End Function

