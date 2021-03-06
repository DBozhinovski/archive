' rdClass is a way to define classes in a contreolled manner, and provides
' benefits when you do so.  These benefits include but are not limited to:
'    Allows you to specify a tracked unique class name
'    Define class attributes and set their access methods in multiple ways (and multiple names, if desired)
'    Optionally define attribute types, with type checking done on all attribute writes
'    If type checking is active, the ability to automatically coerce most types between boolean, string, int and float
'    Default attribute values
'    FULL INHERITANCE
'    Optimized to be quite fast in comparison to manually creating objects through functions (but still slower)
'
' Valid types for attributes:
'	"roInt"
'	"roString"
'	"roFloat"
'	"roBoolean"
'	"roArray"
'	"roList"
'	"roAssociativeArray"
'	"roByteArray"
'	"roFunction"
'
' Here are some usage examples:
function point2D(initdata as object) as object
	this = rdClass("point2D", {
		x: {
			type      : "roInt",
			default   : 1 ' Default value
			coerce    : true ' coerce tries to auto-convert floats, strings etc to the target type
			accessor  : "x" ' x = this.x : this.x(2)
			writer    : "setX" ' this.setX(2)
			reader    : "getX" ' x = this.getX()
			validator : "myFunction" ' String name of function that returns boolean for whether value is acceptable
		} 
		y: {
			type      : "roInt",
			coerce    : true ' coerce tries to auto-convert floats, strings etc to the target type
			accessor  : "y" ' y = this.y : this.y(2)
			writer    : "setY" ' this.setY(2)
			reader    : "getY" ' y = this.getY()
			' Validator is optional
		} 
		somevar: { ' No type, so dynamic, no coersion (which is useless with coersion)
			accessor  : "something"
		}
		foo: {
			type      : "roInt"
			reader    : "f" ' Access through this.f()
		} ' No automatic way to set attribute
	})

	' Adding methods is done through helper functions
	' _addMethods (plural) can add multiple methods through an associative array of method names and function references
	this._addMethods({smallx: xIsLTETen, bigx: xIsGTTen})
	' _addMethod (singular) can add a single method to the object through a name param and a function reference
	this._addMethod("tester", returnFooStr)
	' Here's a useful methods to return the coordinates of this point
	this._addMethod("coords", function() as string : return "("+this._data.x+","+this._data.y+")" : end function)

	' Nothing prevents you from using/defining object through the normal brightscript mechanisms as well
	' Here's a manually defined method for accessing an automatic attribute
	this.incrementFoo = function() : m._data.foo = m._data.foo + 1 : end function
	' Here's a manually defined attribute and method to access it
	this._manual = 1
	this.getManual = function() : return this._manual : end function

	' This part actually sets all the data that was passed in, so you can create and initialize objects through the same call
	this.initialize(initdata)

	return this
end function

' Here are some helper functions/methods used in addMethods above
function xIsLTETen(x) as boolean
	if x <= 10 then return true
	return false
end function

function xIsGTTen(x) as boolean
	if x > 10 then return true
	return false
end function

function returnFooStr() as string
	return "foo"
end function

' Okay, now let's define a class that uses a predefined rdClass type as an attribute type
function line(initdata as object) as object
	this = rdClass("line", {
		p1: {
			type     : "point2D" ' Require passed in value be an rdClass("point2D") class
			accessor : "p1"
		} 
		p2: {
			type     : "point2D"
			accessor : "p2"
		} 
	})

	this.length = function()
		dx = m.P2().X() - m.P1().X()
		dy = m.P2().Y() - m.P1().Y()
		return int(sqr( dx ^ 2 + dy ^ 2 ))
	end function

	this.initialize(initdata)

	return this
end function

' Here's how you use inheritance / simple roles (look at Perl's Moose object structure or Perl6 for more info on Roles
' Inheritance is an optional third parameter to rdClass which should be an array of classes to inherit methods and attributes from, highest precedence first.
'  E.g. if the inheritance looks like ["foo","bar"] and both foo and bar have a "baz" attribute or method, the one from "foo" will be used
function pointMeta()
	' "this" is arbitrary, it can be anything when we are just returning it
	pMeta = rdClass("PointMeta", {
		placed: {
			type     : "roBoolean"
			accessor : "p"
			coerce   : true
		}
		tag: {
			type     : "roString"
			accessor : "tag"
			coerce   : true
		}
		unreachable: {
			type     : "roString"
		}
		prevPoint: {
			type     : "Point"
			accessor : "prevPoint"
		}
	}, ["Point"]) ' This last part here, this is where the inheritance happens

	return pMeta
end function

' Okay, now for how it's used:
p0 = Point2d() ' No data set at creation
p0.x(11)
p0.x(22)
print "p0: (";p0.x();",";p0.y();")" ' print s"p0: (11,22)
print "p0: ";p0.coords()            ' prints "p0: (11,22)

first = Point2d({x: 1, y: 2})
second = Point2d({x: 2, y: 3})
l = line({p1: first, p2: second})
print "Length between p1 and p2 is: ";l.length()

other = PointMeta({x: 1, tag: "some other point"}) ' Assign items from point2d and pointMeta
other.setY(10) ' Assign point2d attribute
other.prevPoint(p0) ' Assign pointMeta attribute
