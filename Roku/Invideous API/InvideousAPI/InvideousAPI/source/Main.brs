Sub Main()

	inv_User_ClearSession()
	inv_User_ClearCredential()
	'inv_User_SaveCredential({ username: "guest", password: "K32RM78JP5QDL6AJTDQE" })
	
	invPlatform=inv_Platform_Get()
	invPlatform.referrer="http://www.clasicaltv.com"
	
	deviceInfo = CreateObject("roDeviceInfo")
	displaySize = deviceInfo.GetDisplaySize()
	background = {
	    Color: "#ebebeb"
	}
	loadingImage = {
	    Url: "pkg:/images/loading.png"
	    TargetRect: {
	        x: Int( displaySize.w / 2 ) - Int( 336 / 2 ),
	        y: Int( displaySize.h / 2 ) - Int( 210 / 2 ),
	        w: 336,
	        h: 210
	    }
	}
	loadingText = {
	    Text: "Loading Classical TV...",
	    TextAttrs: {
	        Font: "Medium",
	        VAlign: "Bottom",
			Color: "#999999",
	    },
	    TargetRect: {
	        x: loadingImage.TargetRect.x,
	        y: loadingImage.TargetRect.y + 250,
	        w: loadingImage.TargetRect.w,
	        h: 30
	    }
	}
	canvas = CreateObject( "roImageCanvas" )
	canvas.SetLayer( 1, [ background, loadingImage, loadingText ] )
	canvas.Show()
	
	invBrightcove=inv_Brightcove_Get()
	
	invBrightcove.Init("PPoz7VXF4Mwk4EzUbbB0tM8Jj1ucF0ao9huHB-1_VytltQ21P5-DWw..", [
		{
			id: "772304786001",
			category: "RECOMMENDED THIS WEEK"
		},
		{
			id: "585040862001",
			category: "CLASSICAL MUSIC"
		},
		{
			id: "584368809001",
			category: "POPULAR MUSIC"
		},
		{
			id: "585056395001",
			category: "JAZZ"
		},
		{
			id: "585049342001",
			category: "OPERAS, SONGS, & ARIAS"
		},
		{
			id: "585049350001",
			category: "BALLET, DANCE"
		},
		{
			id: "585049351001",
			category: "DOCUMENTARIES AND MORE"
		}
	])
	
	initTheme()
    ShowGridScreen({ focusedList: 1, focusedItem: 0 })
    canvas.Close()

End Sub