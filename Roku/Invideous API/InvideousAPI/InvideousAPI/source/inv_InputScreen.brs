function inv_NewInputScreen(inputTitle="" as string) as object
    this = CreateObject("roAssociativeArray")
    this.title=inputTitle
    this.GetInputChoice=inv_InputScreen_GetInputChoice
    this.MessageBox=inv_InputScreen_MessageBox
    this.GetInputText=inv_InputScreen_GetInputText
    this.GetInputPin=inv_InputScreen_GetInputPin
    return this
end function

function inv_InputScreen_MessageBox(text="" as string, buttons=["Yes", "No"] as object) as object
    port=CreateObject("roMessagePort")
    msgDialog=CreateObject("roMessageDialog")
    msgDialog.SetMessagePort(port)
    msgDialog.SetTitle(m.title)
    
    if len(text)>0 then
        msgDialog.SetText(text)
    endif
    
    msgDialog.EnableOverlay(true)
    msgDialog.EnableBackButton(false)
    
    for btnIdx=0 to buttons.Count()-1 step 1
        msgDialog.AddButton(btnIdx, buttons[btnIdx])
    end for
    
    msgDialog.Show()
    
    retVal={
        result: false,
        button: 0
    }
    
    while true
        msg=wait(0,port)
        if type(msg) = "roMessageDialogEvent" then
            if msg.isScreenClosed() then
                exit while                
            else if msg.isButtonPressed() then
                retVal.result=true
                retVal.button=msg.GetIndex()
                exit while
            endif
        endif
    end while
    
    msgDialog.Close()
    return retVal
end function

function inv_InputScreen_GetInputChoice(text="" as string, choices=["Yes", "No"] as object, overlay=true as boolean) as object

    port=CreateObject("roMessagePort")
    screen=CreateObject("roParagraphScreen")
    screen.SetMessagePort(port)
    if len(m.title)>0 then
        screen.AddHeaderText(m.title)
    endif
    
    if len(text)>0 then
        screen.AddParagraph(text)
    endif
    
    for choiceIdx=0 to choices.Count()-1 step 1
        screen.AddButton(choiceIdx, choices[choiceIdx])
    end for
    
    screen.Show()
    
    retVal={
        result: false,
        choice: 0
    }
    
    while true
        msg = wait(0,port)
        if type(msg) = "roParagraphScreenEvent" then
            if msg.isScreenClosed() then
                exit while                
            else if msg.isButtonPressed() then
                choice=msg.GetIndex()
                retVal.result=true
                retVal.choice=choice
                exit while
            endif
        endif
    end while
    
    screen.Close()
    return retVal
end function

function inv_InputScreen_GetInputText(displayText as string, initialText="" as string, buttons=["Next", "Back"] as object, secure=false as boolean) as object
    
    port=CreateObject("roMessagePort")
    screen=CreateObject("roKeyboardScreen")
    screen.SetMessagePort(port)
    
    screen.SetTitle(m.title) 
    screen.SetText(initialText)
    screen.SetSecureText(secure)
    screen.SetDisplayText(displayText)
    ' screen.SetMaxLength(8)
    
    for buttonIdx=0 to buttons.Count()-1 step 1
        screen.AddButton(buttonIdx, buttons[buttonIdx])
    end for
    
    screen.Show()
    
    retVal={
        result: false,
        button: 0,
        value: ""
    }
    
    while true
        msg = wait(0,port)
        if type(msg) = "roKeyboardScreenEvent" then
            if msg.isScreenClosed() then
                exit while                
            else if msg.isButtonPressed() then
                button=msg.GetIndex()
                retVal.result=true
                retVal.button=button
                retVal.value=screen.GetText()
                exit while
            endif
        endif
    end while
    
    screen.Close()
    return retVal
end function

function inv_InputScreen_GetInputPin(buttons=["Next", "Back"] as object, numPinEntryFields=4 as integer) as object
    
    port=CreateObject("roMessagePort")
    screen=CreateObject("roPinEntryDialog")
    screen.SetMessagePort(port)
    
    screen.SetTitle(m.title) 
    screen.SetNumPinEntryFields(numPinEntryFields)
    
    for buttonIdx=0 to buttons.Count()-1 step 1
        screen.AddButton(buttonIdx, buttons[buttonIdx])
    end for
    
    screen.Show()
    
    retVal={
        result: false,
        button: 0,
        pin: ""
    }
    
    while true
        msg = wait(0,port)
        if type(msg) = "roPinEntryDialogEvent" then
            if msg.isScreenClosed() then
                exit while                
            else if msg.isButtonPressed() then
                button=msg.GetIndex()
                retVal.result=true
                retVal.button=button
                retVal.pin=screen.Pin()
                exit while
            endif
        endif
    end while
    
    screen.Close()
    return retVal
end function