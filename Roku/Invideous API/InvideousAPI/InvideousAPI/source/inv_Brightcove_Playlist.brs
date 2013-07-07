function inv_NewBrightcove_Playlist(id as string, name as string, category as string, episodes as object) as object
	this=CreateObject("roAssociativeArray")
	this.id=id
	this.name=name
	this.category=category
	this.episodes=episodes
	return this
end function
