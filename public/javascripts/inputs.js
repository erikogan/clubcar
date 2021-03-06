/* -*- tab-width: 4; c-basic-offset: 4 -*- 
 * This file is based on Javascript originally written by Ryan Fait:
 * http://ryanfait.com/articles/2007/01/05/custom-checkboxes-and-radio-buttons/
 * All of the clever bits are his. All of the bugs are mine.
 */
document.write('<link rel="stylesheet" type="text/css" href="/stylesheets/inputs.css" media="screen" />');

var customRclass = "customRadio";
var customCclass = "customCheckbox";
var customSelected = "selected";

var bgOffset = -43;

var customClassMatch = "(" + customRclass + "|" + customCclass + ")";

function customClassSelected(classString) {
  return classString.indexOf(customSelected) >= 0;
}

function customClassToggle(classString) {
  index = classString.indexOf(customSelected);
  if (index < 0) {
    // not currently selected
    return classString + " " + customSelected;
  } else {
    // currently selected
    return classString.substr(0, index-1);
  }
}

function customClassSet(classString, value) {
  index = classString.indexOf(customSelected);
  if (index < 0) {
    // not currently selected
    if (value) {
      return classString + " " + customSelected;
    } else {
      return classString;
    }
  } else {
    // currently selected
    if (value) {
      return classString;
    } else {
      return classString.substr(0, index-1);
    }
  }
}

function setBGy(element, value) {
  var pos;
  if (window.getComputedStyle) {
    pos = window.getComputedStyle(element, null).backgroundPosition;
  } else if (element.currentStyle) {
    pos = element.currentStyle.backgroundPosition;
  }
  var parts = pos.split(" ", 3);
  var x = 0;
  var suffix ="";
  
  if (parts.length > 0 && parts[0].length > 0) {
    x = parts[0]
  }
  
  if (parts.length > 2) {
    suffix = " " + parts[2]
  }
  
  element.style.backgroundPosition = "" + x + " " + value + suffix
}

var Input = {
  initialize: function() {
    if(document.getElementsByTagName("form")) {
      var divs = document.getElementsByTagName("div");
      for(var i = 0; i < divs.length; i++) {
        if(divs[i].className.match(customClassMatch)) {
          divs[i].onmousedown = Input.effect;
          divs[i].onmouseup = Input.handle;
          window.onmouseup = Input.clear;
          // set the initial values
          selector = divs[i].getElementsByTagName("input")[0];
          divs[i].className = customClassSet(divs[i].className,
            selector.checked)
        }
      }
      // Now that we've reset the classes for initial values, fix
      // the background offsets
      Input.clear()
    }
  },

  effect: function() {
    if (customClassSelected(this.className)) {
      setBGy(this, (bgOffset * 3) + "px");
    } else {
      setBGy(this, bgOffset + "px");
    }
  },

  handle: function() {
    selector = this.getElementsByTagName("input")[0];
    if (this.className.match(customCclass)) {
      if (customClassSelected(this.className)) {
        selector.checked = false;
      } else {
        selector.checked = true;
      }
      this.className = customClassToggle(this.className);
    } else if (this.className.match(customRclass)) {
      selector.checked = true;
      this.className = customClassSet(this.className, true);
      setBGy(this, (bgOffset * 2) + "px");

      /* If we assume radio button groups all have the same
      parent, we don't need to loop over all the inputs on a
      page, which is really slowing down my pages with
      hundreds.
      */
      //inputs = document.getElementsByTagName("input");
      inputs = this.parentNode.getElementsByTagName("input");
      for(i = 0; i < inputs.length; i++) {
        if(inputs[i].getAttribute("name")
        == selector.getAttribute("name")
        && inputs[i] != selector) {
          p = inputs[i].parentNode;
          p.className = customClassSet(p.className, false);
          setBGy(p, 0)
        }
      }
    } // else { // this should never happen }
  },

  clear: function() {
    divs = document.getElementsByTagName("div");
    for(var i = 0; i < divs.length; i++) {
      if (divs[i].className.match(customClassMatch)) {
        if(customClassSelected(divs[i].className)) {
          setBGy(divs[i], (bgOffset * 2) + "px")
        } else {
          setBGy(divs[i], 0)
        }
      }
    }
  }
}

window.onload = Input.initialize;
