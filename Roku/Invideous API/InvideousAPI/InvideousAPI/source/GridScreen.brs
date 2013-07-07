function ShowGridScreen(selection as object) as void
	
	ShowPleaseWait()
	screen = CreateObject("roGridScreen")
	screen.SetMessagePort(CreateObject("roMessagePort"))
    screen.SetDisplayMode("scale-to-fill")
    screen.SetGridStyle("Flat-16x9")
	
	invBrightcove=inv_Brightcove_Get()
	
	screen.SetupLists(invBrightcove.playlists.Count())
	plNames=[]
	
	for plIdx=0 to invBrightcove.playlists.Count()-1 step 1
		plNames.Push(invBrightcove.playlists[plIdx].category)
	end for
	
	screen.SetListNames(plNames)
	
	for plIdx=0 to invBrightcove.playlists.Count()-1 step 1
		screen.SetContentList(plIdx, invBrightcove.playlists[plIdx].episodes)
	end for
    
    screen.SetFocusedListItem(selection.focusedList, selection.focusedItem)
    screen.Show()

	while true
		msg = wait(0, screen.GetMessagePort())
		
		if msg <> invalid
			if msg.isScreenClosed()
				exit while
				
			else if msg.isListItemFocused()
				'print "list "; msg.GetIndex(); " item focused | current show = "; msg.getData()
			else if msg.isListItemSelected()
				selection.focusedList=msg.GetIndex()
				selection.focusedItem=msg.GetData()
				ShowDetailScreen(selection)
				screen.SetFocusedListItem(selection.focusedList, selection.focusedItem)
			end if
		end if
	end while

End Function


Function ShowPleaseWait() As Object
	
	print "entering dialog"

	port = CreateObject("roMessagePort")

    dialog = invalid
    dialog = CreateObject("roOneLineDialog")

    dialog.SetMessagePort(port)
    dialog.SetTitle("loading channel...")
    dialog.ShowBusyAnimation()
    dialog.Show()

    return dialog

End Function