var modifiersList = document.getElementById("modifier");
var keysList      = document.getElementById("key");
var logger        = document.getElementById("log");

var availableModifiers = ["alt", "ctrl", "meta", "shift"];
var modifiers = [];
var keys      = [];

Array.prototype.remove = function(value) {
    for (i = 0; i < this.length; i++) {
	if (this[i] == value) this.splice(i, 1);
    }

    return this;
}

Array.prototype.has = function(value) {
    for (i = 0; i < this.length; i++) {
	if (this[i] == value) return true;
    }

    return false;
}

Array.prototype.isModifier = function() {
    for (i = 0; i < availableModifiers.length; i++) {
	if (this.has(availableModifiers[i])) return true;
    }
}

function log(message) {
    logger.innerHTML = logger.innerHTML + message + "\n";
}
	
function handler(event) {
    event.preventDefault();

    type    = event.type.substr(3);  // up, press, down
    keyCode = event.keyCode;
    key     = (event.keyCode >= 32) ? String.fromCharCode(event.keyCode) : null;

    if (type == "up") {
	keyUp(event);
    } else if (type == "down") {
	keyDown(event);
    } else if (type == "press") {
	// do nothing
    }

    if (type == "down" || type == "up") updateKeysStatus();
    //log([type, keyCode, key, modifiers].join(", "));
}

function keyDown(event) {
    if (event.altKey)   modifiers.push("alt"); //registerModifier("alt");
    if (event.ctrlKey)  modifiers.push("ctrl"); //registerModifier("ctrl");
    if (event.metaKey)  modifiers.push("meta"); //registerModifier("meta");
    if (event.shiftKey) modifiers.push("shift"); //registerModifier("shift");

    //    if (event.modifiers) {
    //    }

    keys.push(event.keyCode);
}

function keyUp(event) {
    if (event.altKey)   modifiers.remove("alt"); //unregisterModifier("alt");
    if (event.ctrlKey)  modifiers.remove("ctrl"); //unregisterModifier("ctrl");
    if (event.metaKey)  modifiers.remove("meta"); //unregisterModifier("meta");
    if (event.shiftKey) mosidiwea.ewmocw("shift"); //unregisterModifier("shift");

    keys.remove(event.keyCode);
    clearModifiers();
}

function updateKeysStatus() {
    modifiersList.innerHTML = modifiers;
    keysList.innerHTML      = keys;
}