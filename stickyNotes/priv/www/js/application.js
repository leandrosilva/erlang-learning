var zIndex = 0;
var colors = ["pink", "yellow", "green", "blue"];

function compile(){
	var notesDirectives = {
		"." : "note <-",
		"[id]": function(arg){
			arg.item.noteid = "note_" + arg.item.id;
			return "note_" + arg.item.id;
		},
		"[noteid]": "note.id",
		"[class]": function(arg){ return "note " + arg.item.doc.color},
		"[style]": function(arg){
			return "top:" + arg.item.doc.y + "px; left:" + arg.item.doc.x + "px;z-index:" + arg.item.doc.z ;  
		},
		"[saved]": "'true'",
		"[x]": function(arg){ return arg.item.doc.x; },
		"[y]": function(arg){ return arg.item.doc.y; },
		"[z]": function(arg){ 
			if(arg.item.doc.z > zIndex) zIndex = arg.item.doc.z; 
			return arg.item.doc.z;
		},
		"[color]": function(arg){ return arg.item.doc.color; },
		"div.picker[noteid]": "note.id",
		"div.picker[onclick]": "'pickColor(this)'",
		"textarea": "note.doc.text",
		"textarea[noteid]": "note.id",
		"textarea[onblur]": "'doUpd(this)'"
	}

	$("div#templates div.note").clone().compile("notes", notesDirectives);
}

function renderNotes(json){
	$("div#board").html($p.render("notes", json));
	
}

function renderNote(json){
	$("div#board").after($p.render("notes", json));
	$("div#note_" + json[0].id).children("textarea").focus();
}

function zTop(note) {
	zIndex += 1; 
	note.css('z-index', zIndex); 
	note.attr("z", zIndex); 
}

function doUpd(el){
	var id = parseInt($(el).attr("noteid"));
	var note = $("div#note_" + id);
	upd(note);
}

function upd(note){
		var elTextarea = note.children("textarea")[0];
		if(elTextarea != undefined){
			var json = {
			"action": "update",
			"id": parseInt(note.attr("noteid")),
			"doc": {
				"text": elTextarea.value, 
				"x": parseInt(note.attr('x')),
				"y": parseInt(note.attr('y')),
				"z": parseInt(note.attr('z')),
				"color": note.attr('color')
			}
		}
		post(json, "/notes", null);
		$("div#note_" + json.id).attr("saved", "true");
	}
}

function del(note){
	var json = {
		"action": "delete",
		"id": parseInt(note.attr("noteid"))
	}
	post(json,"/notes", null);
}


function cbAdd(json){
	renderNote(json);
	attachEvent($("div#note_" + json[0].id));
}

function cbAll(json){
	renderNotes(json);	
	attachEvent($("div.note"));
}

function post(json, url, callback){
	var data = JSON.stringify(json);
	$.post( url, {"json": data}, callback, "json");
}

function attachEvent(note){
	note.children("textarea").focus(function(){
		zTop($(this).parent("div.note"));	
	});
	note.mousedown(function(){
		$(this).children("textarea").focus();
		zTop($(this));
		upd($(this));
		
		}).keyup(function(){
			$(this).attr("saved", "false");

		}).mouseout(function(){
			if($(this).attr("saved") == "false") upd($(this));

		}).draggable({
		opacity: 0.75,
		stop:function(e, ui){ 
			var id =  $(this).attr("id");
			if($("div#" + id).length > 0) {
				$(this).attr("x", ui.position.left).attr("y", ui.position.top);
				upd($(this))}}});
}

function pickColor(el){
	var id = parseInt($(el).attr("noteid"));
	var note = $("div#note_" + id);
	var color = note.attr("color");
	var nextIndex = colors.indexOf(color) + 1;
	if(nextIndex >= colors.length) nextIndex = 0;
	var nextColor = colors[nextIndex];
	note.attr("color", nextColor).removeClass(color).addClass(nextColor);
	upd(note);
}

function rand(upper){
	return Math.floor(Math.random()*upper) + 50
}

function init(){
	compile();

	$("div.trash").droppable({
 		accept: "div.note",
 		activeClass: 'trash-active',
 		hoverClass: "trash-hover",
		tolerance: "touch",
 		drop: function(e, ui) {
			$(ui.draggable).draggable("destroy").fadeOut().remove();
			del($(ui.draggable));
		}	
	});
	

	var json = {
		"action" : "read_all",
	}

	post(json, "/notes", cbAll);	
}

$(document).ready(function(){
	$('div.add').click(function(){
		zIndex += 1;
		var json = {
			"action": "create",
			"doc": {
				"text": "",
				"x": rand(50),
				"y": rand(50),
				"z": zIndex,
				"color": "yellow"
			}
		}
		post(json, "/notes", cbAdd);
	});
	init();
});
