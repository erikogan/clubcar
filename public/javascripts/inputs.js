document.write('<link rel="stylesheet" type="text/css" href="inputs.css" media="screen" />');

var Input = {
	initialize: function() {
		if(document.getElementsByTagName("form")) {
			var divs = document.getElementsByTagName("div");
			for(var i = 0; i < divs.length; i++) {
				if(divs[i].className.match("checkbox") || divs[i].className.match("radio")) {
					divs[i].onmousedown = Input.effect;
					divs[i].onmouseup = Input.handle;
					window.onmouseup = Input.clear;
				}
			}
		}
	},

	effect: function() {
		if(this.className == "checkbox" || this.className == "radio") {
			this.style.backgroundPosition = "0 -26px";
		} else {
			this.style.backgroundPosition = "0 -79px";
		}
	},

	handle: function() {
		selector = this.getElementsByTagName("input")[0];
		if(this.className == "checkbox") {
			selector.checked = true;
			this.className = "checkbox selected";
			this.style.backgroundPosition = "0 -52px";
		} else if(this.className == "checkbox selected") {
			selector.checked = false;
			this.className = "checkbox";
			this.style.backgroundPosition = "0 0";
		} else {
			selector.checked = true;
			this.className = "radio selected";
			this.style.backgroundPosition = "0 -52px";
			inputs = document.getElementsByTagName("input");
			for(i = 0; i < inputs.length; i++) {
				if(inputs[i].getAttribute("name") == selector.getAttribute("name")) {
					if(inputs[i] != selector) {
						inputs[i].parentNode.className = "radio";
						inputs[i].parentNode.style.backgroundPosition = "0 0";
					}
				}
			}
		}
	},

	clear: function() {
		divs = document.getElementsByTagName("div");
		for(var i = 0; i < divs.length; i++) {
			if(divs[i].className == "checkbox" || divs[i].className == "radio") {
				divs[i].style.backgroundPosition = "0 0";
			} else if(divs[i].className == "checkbox selected" || divs[i].className == "radio selected") {
				divs[i].style.backgroundPosition = "0 -52px";
			}
		}
	}
}
window.onload = Input.initialize;