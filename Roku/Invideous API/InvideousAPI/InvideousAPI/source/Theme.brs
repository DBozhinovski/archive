Sub initTheme()
    app = CreateObject("roAppManager")
    app.SetTheme(CreateDefaultTheme())
End Sub

Function CreateDefaultTheme() as Object
    theme = CreateObject("roAssociativeArray")

    theme.ThemeType = "generic-light"

    theme.GridScreenBackgroundColor = "#EAEAEA"
    theme.GridScreenMessageColor    = "#808080"
    theme.GridScreenRetrievingColor = "#CCCCCC"
    theme.GridScreenListNameColor   = "#999999"

    theme.GridScreenDescriptionTitleColor    = "#ebebeb"
    theme.GridScreenDescriptionDateColor     = "#CCCCCC"
    theme.GridScreenDescriptionRuntimeColor  = "#CCCCCC"
    theme.GridScreenDescriptionSynopsisColor = "#CCCCCC"
    
    theme.CounterTextLeft           = "#4D4D4D"
    theme.CounterSeparator          = "#999999"
    theme.CounterTextRight          = "#999999"
    
    theme.GridScreenLogoHD           = "pkg:/images/CTV_Overhang_HD.png"
    theme.GridScreenLogoOffsetHD_X   = "0"
    theme.GridScreenLogoOffsetHD_Y   = "0"
    theme.GridScreenOverhangHeightHD = "130"

    theme.GridScreenLogoSD           = "pkg:/images/CTV_Overhang_SD.png"
    theme.GridScreenOverhangHeightSD = "86"
    theme.GridScreenLogoOffsetSD_X   = "0"
    theme.GridScreenLogoOffsetSD_Y   = "0"
    
    theme.GridScreenFocusBorderSD       = "pkg:/images/CTV_Border_16x9_SD.png"
    theme.GridScreenBorderOffsetSD  	 = "(-21,-21)"
    theme.GridScreenFocusBorderHD        = "pkg:/images/CTV_Border_16x9_HD.png"
    theme.GridScreenBorderOffsetHD  	 = "(-25,-25)"
    
    theme.GridScreenDescriptionImageSD  = "pkg:/images/CTV_Description_SD.png"
    theme.GridScreenDescriptionOffsetSD = "(107,45)"
    theme.GridScreenDescriptionImageHD   = "pkg:/images/CTV_Description_HD.png"
    theme.GridScreenDescriptionOffsetHD  = "(152,74)"

	theme.BackgroundColor 		= "#EAEAEA"
	theme.OverhangOffsetSD_X 	= "0" 
	theme.OverhangOffsetSD_Y 	= "0" 
	theme.OverhangLogoSD 		= "pkg:/images/CTV_Overhang_SD.png" 
	theme.OverhangOffsetHD_X 	= "0" 
	theme.OverhangOffsetHD_Y 	= "0" 
	theme.OverhangLogoHD 		= "pkg:/images/CTV_Overhang_HD.png"
    
	theme.SpringboardTitleText		=	"#4D4D4D"
	theme.SpringboardSynopsisText	=	"#4D4D4D"
	theme.SpringboardRuntimeColor	=	"#999999"

	theme.ButtonMenuHighlightText		=	"#ebebeb"
	theme.ButtonMenuNormalOverlayText	=	"#ebebeb"
	theme.ButtonMenuNormalText			=	"#4D4D4D"
	theme.ButtonNormalColor				=	"#4D4D4D"
	theme.ButtonHighlightColor			=	"#999999"

    return theme
End Function