function inv_Brightcove_Get() as object

    if m.inv_Brightcove=invalid then
        m.inv_Brightcove=CreateObject("roAssociativeArray")
        m.inv_Brightcove.playlists=[]
        m.inv_Brightcove.token=""
        m.inv_Brightcove.Init=inv_Brightcove_Init
        m.inv_Brightcove.GetRenditionsForEpisode=inv_Brightcove_GetRenditionsForEpisode
    endif
    return m.inv_Brightcove
end function


function inv_Brightcove_Init(token as string, playlists as object) as boolean
	m.playlists=[]
	m.token=token
	plFilter=[]
	for each pl in playlists
		plFilter.Push(pl.id)
	next
	bc=NWM_Brightcove(m.token)
	bcPlaylists=bc.GetPlaylists(plFilter)
	for each pl in playlists
		for each bcpl in bcPlaylists
			if pl.id=bcpl.playlistID then
				plEpisodes=bc.GetEpisodesForPlaylist(pl.id)
				if plEpisodes<>invalid then
					m.playlists.Push( inv_NewBrightcove_Playlist(pl.id, bcpl.shortDescriptionLine1, pl.category, plEpisodes) )
				endif
				exit for
			endif
		next
	next
	return m.playlists.Count()>0
end function

function inv_Brightcove_GetRenditionsForEpisode(episode as object) as void
	bc=NWM_Brightcove(m.token)
	bc.GetRenditionsForEpisode(episode)
end function