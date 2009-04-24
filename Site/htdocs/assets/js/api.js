
/*
we support two types of toggling, one compatible with Safari the other for the rest of the 
browsers. 

the version that works on Safari causes Netscape to lose focus on a click.

the version that works on Netscape doesn't work at all on Safari, as it seems the DOM tricks
in sayShowOrHide don't work

*/

function toggleLayer(controllingLayerName, textLayerName) {
    //alert("toggleLayer: " + controllingLayerName);
    var controllingLayer ; 
    if (document.getElementById) {    // this is the way the standards work
        controllingLayer = document.getElementById(controllingLayerName);
    } else if (document.all) {  // this is the way old msie versions work
        controllingLayer = document.all[controllingLayerName];
    } else if (document.layers) {   // this is the way nn4 works
       controllingLayer  = document.layers[controllingLayerName];
    }
    var style = controllingLayer.style;
    style.display = style.display? "":"block";   // toggle it
    sayShowOrHide(controllingLayerName, textLayerName, style);
    storeIntelligentCookie("show" + controllingLayerName, style.display == "block"? 1:0);
}

function sayShowOrHide(controllingLayerName, textLayerName, style) {
    var content = style.display == "block"? "Hide" : "Show";
    $("#" + textLayerName + " a").text(content);
    return true;
}

function showLayer(whichLayer) {
    //alert("showLayer: " + whichLayer);
    if (document.getElementById) {
        // this is the way the standards work
           var style2 = document.getElementById(whichLayer).style;
           style2.display = "block";
    }
    else if (document.all) {
        // this is the way old msie versions work
        var style2 = document.all[whichLayer].style;
        style2.display = "block";
    } else if (document.layers) {
        // this is the way nn4 works
        var style2 = document.layers[whichLayer].style;
        style2.display = "block";
    }
    return true;
}

function hideLayer(whichLayer) {
    //alert("hideLayer: " + whichLayer);
    if (document.getElementById) {
        // this is the way the standards work
       	var style2 = document.getElementById(whichLayer).style;
        style2.display = "";
    }
    else if (document.all) {
        // this is the way old msie versions work
        var style2 = document.all[whichLayer].style;
        style2.display = "";
    } else if (document.layers) {
        // this is the way nn4 works
        var style2 = document.layers[whichLayer].style;
        style2.display = "";
    }
    return true;
}

function getCookie(name) {

    var start = document.cookie.indexOf(name + "=");

    if ( (!start) && name != document.cookie.substring(0,name.length) ) {
	return null;
    }

    if (start == -1) {
	return null;
    }

    var len = start + name.length + 1;
    var end = document.cookie.indexOf(";",len);
    if (end == -1) {
	end = document.cookie.length;
    }
	
    return unescape(document.cookie.substring(len,end));
}

function setCookie(name, value, expires, path, domain, secure) {
    // alert(name + "=" + escape(value) +
    //       ( (expires) ? ";expires=" + expires.toGMTString() : "") +
    //       ( (path) ? ";path=" + path : "") + 
    //       ( (domain) ? ";domain=" + domain : "") +
    //       ( (secure) ? ";secure" : ""));

    document.cookie = name + "=" + escape(value) +
        ( (expires) ? ";expires=" + expires.toGMTString() : "") +
        ( (path) ? ";path=" + path : "") + 
        ( (domain) ? ";domain=" + domain : "") +
        ( (secure) ? ";secure" : "");
}

function deleteCookie(name, path, domain) {
    if (getCookie(name)) {
	document.cookie = name + "=" +
	    ( (path) ? ";path=" + path : "") +
	    ( (domain) ? ";domain=" + domain : "") +
	    ";expires=Thu, 01-Jan-70 00:00:01 GMT";
    }
}

var today = new Date();
var zeroDate = new Date(0,0,0);
today.setTime(today.getTime() - zeroDate.getTime());

var todaysDate = new Date(today.getYear(),
			   today.getMonth(),
			   today.getDate(),
			   0, 0, 0);
var expiresDate = new Date(todaysDate.getTime() + (8 * 7 * 86400000));

function storeMasterCookie() {
    if (!getCookie('MasterCookie')) {
        setCookie('MasterCookie','MasterCookie');
    }
}

function storeIntelligentCookie(name, value, expires, path, domain, secure) {
    if (!getCookie('MasterCookie')) {
        storeMasterCookie();
    }
    var IntelligentCookie = getCookie(name);
    if ((!IntelligentCookie) || (IntelligentCookie != value)) {
        setCookie(name, value, expires, path, domain, secure);
        var IntelligentCookie = getCookie(name);
        if ((!IntelligentCookie) || (IntelligentCookie != value)) {
            deleteCookie('MasterCookie');
	}
    }
}

function uncheckFields(notFirst) {
    var form = document.downloadConfigForm;
    var cb = form.selectedFields;
    if (notFirst) {
        for (var i=1; i<cb.length; i++) {
            cb[i].checked = null;
        }
    } else {
        cb[0].checked = null;
    }
}

function checkFields(all) {
    var form = document.downloadConfigForm;
    var cb = form.selectedFields;
    cb[0].checked = (all > 0 ? null : 'checked');
    for (var i=1; i<cb.length; i++) {
        cb[i].checked = (all > 0 ? 'checked' : null);
    }
}

function chooseAll(bool, form, node) {
    if (form[node].type == 'select-multiple') {
      multiSelectAll(bool, form, node);
    } else {
      checkAll(bool, form, node);
    }
}

//function checkAll(bool, form, node) {
//    var cb = form[node];
//    cb[0].checked = (bool ? null : 'checked');
//    for (var i=0; i<cb.length; i++) {
//        cb[i].checked = (bool ? 'checked' : null);
//   }
//}

function checkAll(bool, form, node) {
    var cb = form[node];
    for (var i=0; i<cb.length; i++) {
	 if(bool && cb[i].checked == false) cb[i].click();
         if(!bool && cb[i].checked == true) cb[i].click();
    }
}

function multiSelectAll(bool, form, node) {
    var opt = form[node];
    opt[0].selected = (bool ? null : 'selected');
    for (var i=0; i<opt.length; i++) {
        opt[i].selected = (bool ? 'selected' : null);
    }
}



function handleHttpResponseImage(imgId, imgSrc) {
    var http = httpObjects[imgId];
    var msg = "in handleHttpResponseImage\n"
            + "http = " + http + "\n"
            + "state = " + http.readyState + "\n"
            + "imgId = " + imgId + "\n"
            + "imgSrc = " + imgSrc;

    // no need to wait till readyState == 4 'cuz we do not need responseText
    if (http.readyState == 1 || http.readyState == 0) {
        var img = document.getElementById(imgId);
        msg += "\nimg before='" + img + "'\n";
        if(img.src != null && img.src != imgSrc) {
            img.src = imgSrc;
        }
        msg += "\nsrc after='" + img.src + "'\n";
        workStates[imgId] = false;
    }
    //alert(msg);
}

function updateImage(imgId, imgSrc) {
    var http = getHTTPObject();
    httpObjects[imgId] = http;
    var isWorking = false;
    workStates[imgId] = isWorking;

    if (!isWorking && http) {
        //if imgSrc is on a different domain, we need to sign the scripts and ask for expanded privilege
        try {
            netscape.security.PrivilegeManager.enablePrivilege("UniversalBrowserRead");
        } catch (e) {
            //alert("cat not enable UniversalBrowserRead: " + e.message);
        }
        try {
            http.open("GET", imgSrc, true);
            http.onreadystatechange = handleHttpResponseImage(imgId, imgSrc);
            workStates[imgId] = true;
            http.send(null);
        } catch (e) {
            var img = document.getElementById(imgId);
            if(img.src != null && img.src != imgSrc) {
                img.src = imgSrc;
            }
        }
    }
    workStates[imgId] = false;
    return true;
}

function handle_dnaContextDiv() {
    handleHttpResponseImageMapDiv('dnaContextDiv');
}

function handle_proteinFeaturesDiv() { 
    handleHttpResponseImageMapDiv('proteinFeaturesDiv');
}

function handleHttpResponseImageMapDiv(imgMapDivId) {
    var http = httpObjects[imgMapDivId];
    if (http.readyState == 4) {
        var div = document.getElementById(imgMapDivId);
        if (document.getElementById(imgMapDivId).lastChild == null) {
            //document.getElementById(imgMapDivId).innerHTML = http.responseText;
            //TRICKY: this only works on Firefox/Netscape
            dynamiccontent(imgMapDivId, http.responseText);
        }
        workStates[imgMapDivId] = false;
    }
    //alert(imgMapDivId + ": state=" + http.readyState);
}

function dynamiccontent(elementid,content){
    if (document.getElementById && !document.all){
        rng = document.createRange();
        el = document.getElementById(elementid);
        rng.setStartBefore(el);
        htmlFrag = rng.createContextualFragment(content);
        while (el.hasChildNodes())
            el.removeChild(el.lastChild);
        el.appendChild(htmlFrag);
    }
}

function updateImageMapDiv(imgMapDivId, imgMapSrc) {
    var http = getHTTPObject();
    httpObjects[imgMapDivId] = http;

    var isWorking = false;
    workStates[imgMapDivId] = isWorking;

    if (!isWorking && http) {
        //if imgMapSrc is on a different domain, we need to sign the scripts and ask for expanded privilege
        try {
            netscape.security.PrivilegeManager.enablePrivilege("UniversalBrowserRead");
        } catch (e) {
            //alert("cat not enable UniversalBrowserRead: " + e.message);
        }
        try {
            http.open("GET", imgMapSrc, true);
            if (imgMapDivId == 'dnaContextDiv') {
                http.onreadystatechange = handle_dnaContextDiv; 
            } else if (imgMapDivId == 'proteinFeaturesDiv') {
                http.onreadystatechange = handle_proteinFeaturesDiv;
            } else {
                //alert("unexpected image map div ID" + imgMapDivId);
            }
            workStates[imgMapDivId] = true;
            http.send(null);
        } catch (e) {
            var altImgMapSrc = imgMapSrc.replace('http://www.', 'http://');

            try {
                http.open("GET", altImgMapSrc, true);
                if (imgMapDivId == 'dnaContextDiv') {
                    http.onreadystatechange = handle_dnaContextDiv; 
                } else if (imgMapDivId == 'proteinFeaturesDiv') {
                    http.onreadystatechange = handle_proteinFeaturesDiv;
                } else {
                    //alert("unexpected image map div ID" + imgMapDivId);
                }
                workStates[imgMapDivId] = true;
                http.send(null);
            } catch (e2) {
                document.getElementById(imgMapDivId).innerHTML
                    = '<font color="red">Could not request the following url because it is on a different domain:<br>'
                    + altImgMapSrc + '<br>Error: ' + e2 +'</font>';
            }
        }
    }
    workStates[imgMapDivId] = false;
    return true;
}

function getHTTPObject() {
    var xmlhttp;
    /*@cc_on
    @if (@_jscript_version >= 5)
        try {
            xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
            try {
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (E) {
                xmlhttp = false;
            }
        }
    @else
        xmlhttp = false;
    @end @*/

    if (!xmlhttp && typeof XMLHttpRequest != 'undefined') {
        try {
            xmlhttp = new XMLHttpRequest();
        } catch (e) {
            xmlhttp = false;
        }
    }
    return xmlhttp;
}

var httpObjects = new Object(); // a hash of XMLHttpObjects
var workStates = new Object();  // a hash of XMLHttpObjects working status


/* ==========================================================================
 * The following ajax methods are defined to fetch sub-pages
 * ========================================================================== */

function requestAsyncContent(url, contentTag) {
    // construct request
    var request;
    if (window.XMLHttpRequest) {    // firefox, mozilla, IE7
        request = new XMLHttpRequest();
    } else if (window.ActiveXObject) {    // IE6 or before
        request = new ActiveXObject("Microsoft.XMLHTTP");
    } else {
        return null;
    }
     
    request.open("GET", url, true);
    
    // construct callback wrapper
    function callbackWrapper() {
        if (request.readyState == 4) {
            receiveAsyncContent(request, contentTag);
        }
    }
    request.onreadystatechange = callbackWrapper;
    
    request.send(null);
}

function receiveAsyncContent(request, contentTag) {
    var content = document.getElementById(contentTag);
    if (request.status == 200) {    // success
        content.innerHTML = request.responseText;
    } else {    // http failure
        content.innerHTML = "Failed. Cannot retrieve the content.";
    }
}




/* ==========================================================================
 * The following JQuery ajax methods are defined to fetch and display GBrowse images
 * ========================================================================== */

var gbDispCache = {};
var gbIsLoading = false;
function fetchGbrowseImg(buttonId, url) {
      var dispSel = "#gbInline";
      var wz = $("<script>").
            attr("type", "text/javascript").
            attr("src", "/gbrowse/wz_tooltip.js");
      var api = $("<script>").
            attr("type", "text/javascript").
            attr("src", "/gbrowse/apiGBrowsePopups.js");      
      var loadingImg = ($("<div>").attr("id", buttonId)).attr("class", "gbGnCtx").
            append($("<img/>").
              attr("src", "/assets/images/dna-animated.gif")).
            append("<br>Loading...");
      var buttonSel = '#'+buttonId;
      
      $(document).ready(function () {
        $(buttonSel).click(function(){
          if (gbIsLoading) return;
          
          $("div[id^=tOoLtIp]").remove(); // previously loaded wz_tooltips
          
          if (          true        ||  gbDispCache[buttonId] == null) { 
          /*            ^^^^
              Safari 4 (at least) loses wz_tooltip bindings when loading cached
              nodes (it works in FF 3 provide the wz_tooltips.js is re-appended).
              Node caching disabled until we find a fix for Safari. **/
            gbIsLoading = true;
            var oriButton = $(buttonSel).clone(true);
            $(buttonSel).replaceWith(loadingImg);
            $(dispSel).load(url, null, 
                    function(responseText, status, XMLHttpRequest) {
               $(dispSel).append(api);
               $(dispSel).append(wz);
               $(buttonSel).replaceWith(oriButton);
               $(dispSel).attr('src', buttonId);
               gbDispCache[buttonId] = $(dispSel).clone();
               gbIsLoading = false;
               gbLoadedHl(buttonSel);
            });
          } else {
            if ( $(dispSel).attr('src') == gbDispCache[buttonId].attr('src')) 
              return;
            $(dispSel).replaceWith(gbDispCache[buttonId]);
            $(dispSel).append(wz);
            gbLoadedHl(buttonSel);
          }
          return true;
        });
      }); 
       
      $().ajaxError(function(info,xhr){
        $(dispSel).append("Oops: " +  xhr.status + ' ' + xhr.statusText);
      });
}

function gbLoadedHl(buttonSel) {
  $('.gbGnCtxActive').removeClass('gbGnCtxActive');               
  $(buttonSel).addClass('gbGnCtxActive');
}

