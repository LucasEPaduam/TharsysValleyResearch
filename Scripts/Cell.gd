extends Node

var x
var y
var reachable

var parent = null
var g = 0
var h = 0
var f = 0

func _init(x, y, reachable):
	self.x = x
	self.y = y
	self.reachable = reachable
	
