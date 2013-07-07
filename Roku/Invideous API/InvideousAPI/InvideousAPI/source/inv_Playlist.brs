function inv_NewPlaylist(playlistDetails as object) as object

end function


function inv_Playlist_GetDetails(playlistId as string, invUser=invalid as object) as object
    getPlaylistDetailsReq=NewHTTP("http://api.invideous.com/plugin/get_playlist_details")
    getPlaylistDetailsReq.AddParam("playlist_id", playlistId)
    if invUser<>invalid then
        getPlaylistDetailsReq.AddParam("session_id", invUser.session_id)
    endif
    getPlaylistDetailsResp=getPlaylistDetailsReq.GetToStringWithTimeout(10)
    
    
    jsonResp=inv_ParseJSON(getPlaylistDetailsResp)
    
    if jsonResp = invalid then
        return invalid
    endif
    
    if jsonResp.response.status <> "success" then
        return invalid
    endif
    
    return inv_NewPlaylist(jsonResp.response.result)
end function