Function ShowDetailScreen(selection as object) as void
	
	invBrightcove=inv_Brightcove_Get()
	playlist=invBrightcove.playlists[selection.focusedList]
	
	port=CreateObject("roMessagePort") 
	
	displayShowDetailScreen = CreateObject("roSpringboardScreen") 
	displayShowDetailScreen.SetBreadcrumbText("", playlist.category)
	displayShowDetailScreen.SetDescriptionStyle("video")
	displayShowDetailScreen.SetPosterStyle("rounded-rect-16x9-generic")
	displayShowDetailScreen.SetStaticRatingEnabled(false)
	displayShowDetailScreen.SetMessagePort(port)
	
	o=CreateObject("roAssociativeArray")
	o.ContentType 	= "video" 
	o.Title 		= playlist.episodes[selection.focusedItem].title
	o.Description 	= playlist.episodes[selection.focusedItem].synopsis 
	o.SDPosterUrl 	= playlist.episodes[selection.focusedItem].sdPosterURL 
	o.HDPosterUrl 	= playlist.episodes[selection.focusedItem].hdPosterURL
	o.Rating 		= "NR" 
	'o.StarRating 	= "75" 
	'o.ReleaseDate 	= "[mm/dd/yyyy]"
	o.Categories	= playlist.category
	o.Length 		= playlist.episodes[selection.focusedItem].length 
	
	displayShowDetailScreen.AddButton(1, "Play")
	displayShowDetailScreen.SetContent(o) 
	displayShowDetailScreen.Show() 

	while true
		msg = wait(0, port)
		if type(msg) = "roSpringboardScreenEvent" then 
			if msg.isScreenClosed()
				print "displayShowDetailScreen closed"
				exit while
			else if msg.isButtonPressed()
				episode=playlist.episodes[selection.focusedItem]
				if episode.streams.Count()=0
					invBrightcove.GetRenditionsForEpisode(episode)
				end if
				
				adrise_PlayVideo(episode)
			else if msg.isRemoteKeyPressed()
				if msg.GetIndex()=4 ' LEFT
					if selection.focusedItem=0
						selection.focusedItem=playlist.episodes.Count()-1
					else
						selection.focusedItem=selection.focusedItem-1
					end if
					displayShowDetailScreen.SetContent(playlist.episodes[selection.focusedItem])
				else if msg.GetIndex() = 5 ' RIGHT
					if selection.focusedItem=selection.focusedItem-1
						selection.focusedItem=0
					else
						selection.focusedItem=selection.focusedItem+1
					end if
					displayShowDetailScreen.SetContent(playlist.episodes[selection.focusedItem])
				end if
			end if
		end if
	end while
End Function
