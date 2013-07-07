function inv_NewKeyValArray() as object
	this = CreateObject("roAssociativeArray")
	this.container=CreateObject("roArray",0,true)
	this.Add=inv_KeyValArray_Add
	this.SortByKeys=inv_KeyValArray_SortByKeys
	return this
end function

function inv_KeyValArray_Add(kvKey as string, kvValue as object) as void
	m.container.Push( { key: kvKey, value: kvValue } )
end function


function inv_KeyValArray_SortByKeys() as void
	last=m.container.Count()-1
    done=false
    while not done
        done=true
        for i=0 to last-1
            if m.container[i].key>m.container[i+1].key then
            	tmpKey=m.container[i].key
            	tmpValue=m.container[i].value
            	m.container[i].key=m.container[i+1].key
            	m.container[i].value=m.container[i+1].value
            	m.container[i+1].key=tmpKey
            	m.container[i+1].value=tmpValue
            	done=false
            endif
        next
        last=last-1
    end while
end function