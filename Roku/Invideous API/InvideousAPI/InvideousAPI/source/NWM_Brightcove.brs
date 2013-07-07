''
''  NWM_Brightcove.brs
''	chagedorn@roku.com
''
''	Usage:
''		bc = NWM_Brightcove("myAPIToken") 
''		playlists = bc.GetPlaylists()
''		episodes = bc.GetEpisodesForPlaylist(playlists[0].playlistID)
''

' token MUST be a Brightcove read token with URL access
function NWM_Brightcove(token)
	this = {
		token:	token
		
		GetPlaylists:				NWM_BC_GetPlaylists
		GetEpisodesForPlaylist:		NWM_BC_GetEpisodesForPlaylist
		GetRenditionsForEpisode:	NWM_BC_GetRenditionsForEpisode
		GetEpisode:					NWM_BC_GetEpisode
	}
	
	return this
end function

function NWM_BC_GetPlaylists(playlists = [])
	result = []
	json = ""
	util = NWM_Utilities()
	
	playlistFilter = {}
	for each playlist in playlists
		playlistFilter.AddReplace(playlist, "")
	next
	

	raw = util.GetStringFromURL("http://api.brightcove.com/services/library?command=find_all_playlists&playlist_fields=name,id&sort_by=publish_date&sort_order=DESC&get_item_count=true&token=" + m.token)
	'print raw
	json = util.SimpleJSONParser(raw)	
	
	if raw = "" return result
	
	for each item in json.items
		'PrintAA(item)
		
		if playlists.Count() = 0 or playlistFilter.DoesExist(ValidStr(item.id))
			newPlaylist = {
				playlistID:							ValidStr(item.id)
				shortDescriptionLine1:				ValidStr(item.name)
				'shortDescriptionLine2:				Left(ValidStr(item.shortdescription), 60)
				'sdPosterURL:						ValidStr(item.thumbnailurl)
				'hdPosterURL:						ValidStr(item.thumbnailurl)
			}
			
			'PrintAA(newPlaylist)
			result.Push(newPlaylist)
		end if
	next
	
	return result
end function

function NWM_BC_GetEpisodesForPlaylist(playlistID)
	result = []
	util = NWM_Utilities()
	
	' grabbing all the data for the playlist at once can result in a huge chunk of JSON and processing that into a BS structure can crash the box
	' "http://api.brightcove.com/services/library?command=find_playlist_by_id&media_delivery=http&video_fields=publisheddate,tags,length,name,thumbnailurl,renditions,longdescription&playlist_id=" + playlistID + "&token=" + m.token

	raw = util.GetStringFromURL("http://api.brightcove.com/services/library?command=find_playlist_by_id&media_delivery=http&video_fields=id,name,longdescription,thumbnailurl,length,publisheddate,tags&custom_fields=roku_thumbnail_sd,roku_thumbnail_hd&playlist_id=" + playlistID + "&token=" + m.token)
	'print raw
	json = util.SimpleJSONParser(raw)
	
	if type(json) = "roInvalid" then return result
	
	for each video in json.videos
		'PrintAA(video)
		
		newVid = {
			id:									ValidStr(video.id)
			shortDescriptionLine1:				ValidStr(video.name)
			title:								ValidStr(video.name)
			description:						ValidStr(video.longdescription)
			synopsis:							ValidStr(video.longdescription)
			sdPosterURL:						ValidStr(video.thumbnailURL)
			hdPosterURL:						ValidStr(video.thumbnailURL)
			length:								Int(StrToI(ValidStr(video.length)) / 1000)
			streams:							[]
			streamFormat:						"mp4"
			contentType:						"video"
			categories:							[]
		}
		
		
		if video.customFields = invalid
			print "invalid custom fields"
		else 			
			newVid.sdPosterURL = video.customfields.Lookup("roku_thumbnail_sd")
			newVid.hdPosterURL = video.customfields.Lookup("roku_thumbnail_hd")
			
		end if
		
		date = CreateObject("roDateTime")
		date.FromSeconds(StrToI(Left(ValidStr(video.publisheddate), Len(ValidStr(video.publisheddate)) - 3)))
		'newVid.releaseDate = date.asDateStringNoParam()

		for each tag in video.tags
			newVid.categories.Push(ValidStr(tag))
		next
		
		result.Push(newVid)
	next
	
	return result
end function

function NWM_BC_GetEpisode(videoID)
	result = []
	util = NWM_Utilities()
	
	raw = util.GetStringFromURL("http://api.brightcove.com/services/library?command=find_video_by_id&media_delivery=http&video_fields=id,publisheddate,tags,length,name,thumbnailurl,longdescription&custom_fields=roku_thumbnail_sd,roku_thumbnail_hd&video_id=" + videoID + "&token=" + m.token)

	video = util.SimpleJSONParser(raw)
	
	if type(video) = "roInvalid" then return result
			
		newVid = {
			id:									ValidStr(video.id)
			shortDescriptionLine1:				ValidStr(video.name)
			title:								ValidStr(video.name)
			Description:						ValidStr(video.longdescription)
			synopsis:							ValidStr(video.longdescription)
			sdPosterURL:						ValidStr(video.thumbnailURL)
			hdPosterURL:						ValidStr(video.thumbnailURL)
			length:								Int(StrToI(ValidStr(video.length)) / 1000)
			streams:							[]
			streamFormat:						"mp4"
			contentType:						"video"
			categories:							[]
		}
		
		
		if video.customFields = invalid
			print "invalid custom fields"
		else 			
			newVid.sdPosterURL = video.customfields.Lookup("roku_thumbnail_sd")
			newVid.hdPosterURL = video.customfields.Lookup("roku_thumbnail_hd")
			
		end if
		
		date = CreateObject("roDateTime")
		date.FromSeconds(StrToI(Left(ValidStr(video.publisheddate), Len(ValidStr(video.publisheddate)) - 3)))
		'newVid.releaseDate = date.asDateStringNoParam()

		for each tag in video.tags
			newVid.categories.Push(ValidStr(tag))
		next
	
	return newVid
end function

sub NWM_BC_GetRenditionsForEpisode(episode)
	'print "NWM_BC_GetRenditionsForEpisode"
	util = NWM_Utilities()
	
	' grabbing all the data for the playlist at once can result in a huge chunk of JSON and processing that into a BS structure can crash the box
	' "http://api.brightcove.com/services/library?command=find_playlist_by_id&media_delivery=http&video_fields=publisheddate,tags,length,name,thumbnailurl,renditions,longdescription&playlist_id=" + playlistID + "&token=" + m.token

	'print ("http://api.brightcove.com/services/library?command=find_video_by_id&media_delivery=http&video_fields=renditions&video_id=" + episode.id + "&token=" + m.token)
	raw = util.GetStringFromURL("http://api.brightcove.com/services/library?command=find_video_by_id&media_delivery=http&video_fields=renditions&video_id=" + episode.id + "&token=" + m.token)
	'print raw
	json = util.SimpleJSONParser(raw)
	'PrintAA(json)
	
	for each rendition in json.renditions
		if UCase(ValidStr(rendition.videocontainer)) = "MP4" and UCase(ValidStr(rendition.videocodec)) = "H264"
			newStream = {
				url:	ValidStr(rendition.url)
				bitrate: Int(StrToI(ValidStr(rendition.encodingrate)) / 1000)
			}
			
			if StrToI(ValidStr(rendition.frameheight)) > 720
				episode.fullHD = true
			end if	
			if StrToI(ValidStr(rendition.frameheight)) > 480
				episode.isHD = true
				episode.hdBranded = true
				newStream.quality = true
			end if
			
			episode.streams.Push(newStream)
		end if
	next
end sub
