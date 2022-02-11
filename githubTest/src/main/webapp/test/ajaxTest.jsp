<%@page import="Model.MemberDTO"%>
<%@page import="java.net.Inet4Address"%>
<%@page import="Model.GuDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.GuDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html id='ht' class>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Insert title here</title>
<link href="main.css?after" rel="stylesheet" type="text/css">

<script src="https://code.jquery.com/jquery-3.6.0.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d6fdfec4a3236f5dd4c82e0e3deaf991&libraries=services"></script>

</head>
<body>
<!-- deploy test 22/02/11 -->
	<%
		GuDAO dao = new GuDAO();
	ArrayList<GuDTO> gu_list = dao.selectAll();

	MemberDTO info = (MemberDTO) session.getAttribute("info");
	%>

	<script id="applicationScript">
///////////////////////////////////////
// INITIALIZATION
///////////////////////////////////////

/**
 * Functionality for scaling, showing by media query, and navigation between multiple pages on a single page. 
 * Code subject to change.
 **/

if (window.console==null) { window["console"] = { log : function() {} } }; // some browsers do not set console

var Application = function() {
	// event constants
	this.prefix = "--web-";
	this.NAVIGATION_CHANGE = "viewChange";
	this.VIEW_NOT_FOUND = "viewNotFound";
	this.VIEW_CHANGE = "viewChange";
	this.VIEW_CHANGING = "viewChanging";
	this.STATE_NOT_FOUND = "stateNotFound";
	this.APPLICATION_COMPLETE = "applicationComplete";
	this.APPLICATION_RESIZE = "applicationResize";
	this.SIZE_STATE_NAME = "data-is-view-scaled";
	this.STATE_NAME = this.prefix + "state";

	this.lastTrigger = null;
	this.lastView = null;
	this.lastState = null;
	this.lastOverlay = null;
	this.currentView = null;
	this.currentState = null;
	this.currentOverlay = null;
	this.currentQuery = {index: 0, rule: null, mediaText: null, id: null};
	this.inclusionQuery = "(min-width: 0px)";
	this.exclusionQuery = "none and (min-width: 99999px)";
	this.LastModifiedDateLabelName = "LastModifiedDateLabel";
	this.viewScaleSliderId = "ViewScaleSliderInput";
	this.pageRefreshedName = "showPageRefreshedNotification";
	this.application = null;
	this.applicationStylesheet = null;
	this.showByMediaQuery = null;
	this.mediaQueryDictionary = {};
	this.viewsDictionary = {};
	this.addedViews = [];
	this.viewStates = [];
	this.views = [];
	this.viewIds = [];
	this.viewQueries = {};
	this.overlays = {};
	this.overlayIds = [];
	this.numberOfViews = 0;
	this.verticalPadding = 0;
	this.horizontalPadding = 0;
	this.stateName = null;
	this.viewScale = 1;
	this.viewLeft = 0;
	this.viewTop = 0;
	this.horizontalScrollbarsNeeded = false;
	this.verticalScrollbarsNeeded = false;

	// view settings
	this.showUpdateNotification = false;
	this.showNavigationControls = false;
	this.scaleViewsToFit = false;
	this.scaleToFitOnDoubleClick = false;
	this.actualSizeOnDoubleClick = false;
	this.scaleViewsOnResize = false;
	this.navigationOnKeypress = false;
	this.showViewName = false;
	this.enableDeepLinking = true;
	this.refreshPageForChanges = false;
	this.showRefreshNotifications = true;

	// view controls
	this.scaleViewSlider = null;
	this.lastModifiedLabel = null;
	this.supportsPopState = false; // window.history.pushState!=null;
	this.initialized = false;

	// refresh properties
	this.refreshDuration = 250;
	this.lastModifiedDate = null;
	this.refreshRequest = null;
	this.refreshInterval = null;
	this.refreshContent = null;
	this.refreshContentSize = null;
	this.refreshCheckContent = false;
	this.refreshCheckContentSize = false;

	var self = this;

	self.initialize = function(event) {
		var view = self.getVisibleView();
		var views = self.getVisibleViews();
		if (view==null) view = self.getInitialView();
		self.collectViews();
		self.collectOverlays();
		self.collectMediaQueries();

		for (let index = 0; index < views.length; index++) {
			var view = views[index];
			self.setViewOptions(view);
			self.setViewVariables(view);
			self.centerView(view);
		}

		// sometimes the body size is 0 so we call this now and again later
		if (self.initialized) {
			window.addEventListener(self.NAVIGATION_CHANGE, self.viewChangeHandler);
			window.addEventListener("keyup", self.keypressHandler);
			window.addEventListener("keypress", self.keypressHandler);
			window.addEventListener("resize", self.resizeHandler);
			window.document.addEventListener("dblclick", self.doubleClickHandler);

			if (self.supportsPopState) {
				window.addEventListener('popstate', self.popStateHandler);
			}
			else {
				window.addEventListener('hashchange', self.hashChangeHandler);
			}

			// we are ready to go
			window.dispatchEvent(new Event(self.APPLICATION_COMPLETE));
		}

		if (self.initialized==false) {
			if (self.enableDeepLinking) {
				self.syncronizeViewToURL();
			} 
	
			if (self.refreshPageForChanges) {
				self.setupRefreshForChanges();
			}
	
			self.initialized = true;
		}
		
		if (self.scaleViewsToFit) {
			self.viewScale = self.scaleViewToFit(view);
			
			if (self.viewScale<0) {
				setTimeout(self.scaleViewToFit, 500, view);
			}
		}
		else if (view) {
			self.viewScale = self.getViewScaleValue(view);
			self.centerView(view);
			self.updateSliderValue(self.viewScale);
		}
		else {
			// no view found
		}
	
		if (self.showUpdateNotification) {
			self.showNotification();
		}

		//"addEventListener" in window ? null : window.addEventListener = window.attachEvent;
		//"addEventListener" in document ? null : document.addEventListener = document.attachEvent;
	}


	///////////////////////////////////////
	// AUTO REFRESH 
	///////////////////////////////////////

	self.setupRefreshForChanges = function() {
		self.refreshRequest = new XMLHttpRequest();

		if (!self.refreshRequest) {
			return false;
		}

		// get document start values immediately
		self.requestRefreshUpdate();
	}

	/**
	 * Attempt to check the last modified date by the headers 
	 * or the last modified property from the byte array (experimental)
	 **/
	self.requestRefreshUpdate = function() {
		var url = document.location.href;
		var protocol = window.location.protocol;
		var method;
		
		try {

			if (self.refreshCheckContentSize) {
				self.refreshRequest.open('HEAD', url, true);
			}
			else if (self.refreshCheckContent) {
				self.refreshContent = document.documentElement.outerHTML;
				self.refreshRequest.open('GET', url, true);
				self.refreshRequest.responseType = "text";
			}
			else {

				// get page last modified date for the first call to compare to later
				if (self.lastModifiedDate==null) {

					// File system does not send headers in FF so get blob if possible
					if (protocol=="file:") {
						self.refreshRequest.open("GET", url, true);
						self.refreshRequest.responseType = "blob";
					}
					else {
						self.refreshRequest.open("HEAD", url, true);
						self.refreshRequest.responseType = "blob";
					}

					self.refreshRequest.onload = self.refreshOnLoadOnceHandler;

					// In some browsers (Chrome & Safari) this error occurs at send: 
					// 
					// Chrome - Access to XMLHttpRequest at 'file:///index.html' from origin 'null' 
					// has been blocked by CORS policy: 
					// Cross origin requests are only supported for protocol schemes: 
					// http, data, chrome, chrome-extension, https.
					// 
					// Safari - XMLHttpRequest cannot load file:///Users/user/Public/index.html. Cross origin requests are only supported for HTTP.
					// 
					// Solution is to run a local server, set local permissions or test in another browser
					self.refreshRequest.send(null);

					// In MS browsers the following behavior occurs possibly due to an AJAX call to check last modified date: 
					// 
					// DOM7011: The code on this page disabled back and forward caching.

					// In Brave (Chrome) error when on the server
					// index.js:221 HEAD https://www.example.com/ net::ERR_INSUFFICIENT_RESOURCES
					// self.refreshRequest.send(null);

				}
				else {
					self.refreshRequest = new XMLHttpRequest();
					self.refreshRequest.onreadystatechange = self.refreshHandler;
					self.refreshRequest.ontimeout = function() {
						self.log("Couldn't find page to check for updates");
					}
					
					var method;
					if (protocol=="file:") {
						method = "GET";
					}
					else {
						method = "HEAD";
					}

					//refreshRequest.open('HEAD', url, true);
					self.refreshRequest.open(method, url, true);
					self.refreshRequest.responseType = "blob";
					self.refreshRequest.send(null);
				}
			}
		}
		catch (error) {
			self.log("Refresh failed for the following reason:")
			self.log(error);
		}
	}

	self.refreshHandler = function() {
		var contentSize;

		try {

			if (self.refreshRequest.readyState === XMLHttpRequest.DONE) {
				
				if (self.refreshRequest.status === 2 || 
					self.refreshRequest.status === 200) {
					var pageChanged = false;

					self.updateLastModifiedLabel();

					if (self.refreshCheckContentSize) {
						var lastModifiedHeader = self.refreshRequest.getResponseHeader("Last-Modified");
						contentSize = self.refreshRequest.getResponseHeader("Content-Length");
						//lastModifiedDate = refreshRequest.getResponseHeader("Last-Modified");
						var headers = self.refreshRequest.getAllResponseHeaders();
						var hasContentHeader = headers.indexOf("Content-Length")!=-1;
						
						if (hasContentHeader) {
							contentSize = self.refreshRequest.getResponseHeader("Content-Length");

							// size has not been set yet
							if (self.refreshContentSize==null) {
								self.refreshContentSize = contentSize;
								// exit and let interval call this method again
								return;
							}

							if (contentSize!=self.refreshContentSize) {
								pageChanged = true;
							}
						}
					}
					else if (self.refreshCheckContent) {

						if (self.refreshRequest.responseText!=self.refreshContent) {
							pageChanged = true;
						}
					}
					else {
						lastModifiedHeader = self.getLastModified(self.refreshRequest);

						if (self.lastModifiedDate!=lastModifiedHeader) {
							self.log("lastModifiedDate:" + self.lastModifiedDate + ",lastModifiedHeader:" +lastModifiedHeader);
							pageChanged = true;
						}

					}

					
					if (pageChanged) {
						clearInterval(self.refreshInterval);
						self.refreshUpdatedPage();
						return;
					}

				}
				else {
					self.log('There was a problem with the request.');
				}

			}
		}
		catch( error ) {
			//console.log('Caught Exception: ' + error);
		}
	}

	self.refreshOnLoadOnceHandler = function(event) {

		// get the last modified date
		if (self.refreshRequest.response) {
			self.lastModifiedDate = self.getLastModified(self.refreshRequest);

			if (self.lastModifiedDate!=null) {

				if (self.refreshInterval==null) {
					self.refreshInterval = setInterval(self.requestRefreshUpdate, self.refreshDuration);
				}
			}
			else {
				self.log("Could not get last modified date from the server");
			}
		}
	}

	self.refreshUpdatedPage = function() {
		if (self.showRefreshNotifications) {
			var date = new Date().setTime((new Date().getTime()+10000));
			document.cookie = encodeURIComponent(self.pageRefreshedName) + "=true" + "; max-age=6000;" + " path=/";
		}

		document.location.reload(true);
	}

	self.showNotification = function(duration) {
		var notificationID = self.pageRefreshedName+"ID";
		var notification = document.getElementById(notificationID);
		if (duration==null) duration = 4000;

		if (notification!=null) {return;}

		notification = document.createElement("div");
		notification.id = notificationID;
		notification.textContent = "PAGE UPDATED";
		var styleRule = ""
		styleRule = "position: fixed; padding: 7px 16px 6px 16px; font-family: Arial, sans-serif; font-size: 10px; font-weight: bold; left: 50%;";
		styleRule += "top: 20px; background-color: rgba(0,0,0,.5); border-radius: 12px; color:rgb(235, 235, 235); transition: all 2s linear;";
		styleRule += "transform: translateX(-50%); letter-spacing: .5px; filter: drop-shadow(2px 2px 6px rgba(0, 0, 0, .1)); cursor: pointer";
		notification.setAttribute("style", styleRule);

		notification.className = "PageRefreshedClass";
		notification.addEventListener("click", function() {
			notification.parentNode.removeChild(notification);
		});
		
		document.body.appendChild(notification);

		setTimeout(function() {
			notification.style.opacity = "0";
			notification.style.filter = "drop-shadow( 0px 0px 0px rgba(0,0,0, .5))";
			setTimeout(function() {
				try {
					notification.parentNode.removeChild(notification);
				} catch(error) {}
			}, duration)
		}, duration);

		document.cookie = encodeURIComponent(self.pageRefreshedName) + "=; max-age=1; path=/";
	}

	/**
	 * Get the last modified date from the header 
	 * or file object after request has been received
	 **/
	self.getLastModified = function(request) {
		var date;

		// file protocol - FILE object with last modified property
		if (request.response && request.response.lastModified) {
			date = request.response.lastModified;
		}
		
		// http protocol - check headers
		if (date==null) {
			date = request.getResponseHeader("Last-Modified");
		}

		return date;
	}

	self.updateLastModifiedLabel = function() {
		var labelValue = "";
		
		if (self.lastModifiedLabel==null) {
			self.lastModifiedLabel = document.getElementById("LastModifiedLabel");
		}

		if (self.lastModifiedLabel) {
			var seconds = parseInt(((new Date().getTime() - Date.parse(document.lastModified)) / 1000 / 60) * 100 + "");
			var minutes = 0;
			var hours = 0;

			if (seconds < 60) {
				seconds = Math.floor(seconds/10)*10;
				labelValue = seconds + " seconds";
			}
			else {
				minutes = parseInt((seconds/60) + "");

				if (minutes>60) {
					hours = parseInt((seconds/60/60) +"");
					labelValue += hours==1 ? " hour" : " hours";
				}
				else {
					labelValue = minutes+"";
					labelValue += minutes==1 ? " minute" : " minutes";
				}
			}
			
			if (seconds<10) {
				labelValue = "Updated now";
			}
			else {
				labelValue = "Updated " + labelValue + " ago";
			}

			if (self.lastModifiedLabel.firstElementChild) {
				self.lastModifiedLabel.firstElementChild.textContent = labelValue;

			}
			else if ("textContent" in self.lastModifiedLabel) {
				self.lastModifiedLabel.textContent = labelValue;
			}
		}
	}

	self.getShortString = function(string, length) {
		if (length==null) length = 30;
		string = string!=null ? string.substr(0, length).replace(/\n/g, "") : "[String is null]";
		return string;
	}

	self.getShortNumber = function(value, places) {
		if (places==null || places<1) places = 4;
		value = Math.round(value * Math.pow(10,places)) / Math.pow(10, places);
		return value;
	}

	///////////////////////////////////////
	// NAVIGATION CONTROLS
	///////////////////////////////////////

	self.updateViewLabel = function() {
		var viewNavigationLabel = document.getElementById("ViewNavigationLabel");
		var view = self.getVisibleView();
		var viewIndex = view ? self.getViewIndex(view) : -1;
		var viewName = view ? self.getViewPreferenceValue(view, self.prefix + "view-name") : null;
		var viewId = view ? view.id : null;

		if (viewNavigationLabel && view) {
			if (viewName && viewName.indexOf('"')!=-1) {
				viewName = viewName.replace(/"/g, "");
			}

			if (self.showViewName) {
				viewNavigationLabel.textContent = viewName;
				self.setTooltip(viewNavigationLabel, viewIndex + 1 + " of " + self.numberOfViews);
			}
			else {
				viewNavigationLabel.textContent = viewIndex + 1 + " of " + self.numberOfViews;
				self.setTooltip(viewNavigationLabel, viewName);
			}

		}
	}

	self.updateURL = function(view) {
		view = view == null ? self.getVisibleView() : view;
		var viewId = view ? view.id : null
		var viewFragment = view ? "#"+ viewId : null;

		if (viewId && self.viewIds.length>1 && self.enableDeepLinking) {

			if (self.supportsPopState==false) {
				self.setFragment(viewId);
			}
			else {
				if (viewFragment!=window.location.hash) {

					if (window.location.hash==null) {
						window.history.replaceState({name:viewId}, null, viewFragment);
					}
					else {
						window.history.pushState({name:viewId}, null, viewFragment);
					}
				}
			}
		}
	}

	self.updateURLState = function(view, stateName) {
		stateName = view && (stateName=="" || stateName==null) ? self.getStateNameByViewId(view.id) : stateName;

		if (self.supportsPopState==false) {
			self.setFragment(stateName);
		}
		else {
			if (stateName!=window.location.hash) {

				if (window.location.hash==null) {
					window.history.replaceState({name:view.viewId}, null, stateName);
				}
				else {
					window.history.pushState({name:view.viewId}, null, stateName);
				}
			}
		}
	}

	self.setFragment = function(value) {
		window.location.hash = "#" + value;
	}

	self.setTooltip = function(element, value) {
		// setting the tooltip in edge causes a page crash on hover
		if (/Edge/.test(navigator.userAgent)) { return; }

		if ("title" in element) {
			element.title = value;
		}
	}

	self.getStylesheetRules = function(styleSheet) {
		try {
			if (styleSheet) return styleSheet.cssRules || styleSheet.rules;
	
			return document.styleSheets[0]["cssRules"] || document.styleSheets[0]["rules"];
		}
		catch (error) {
			// ERRORS:
			// SecurityError: The operation is insecure.
			// Errors happen when script loads before stylesheet or loading an external css locally

			// InvalidAccessError: A parameter or an operation is not supported by the underlying object
			// Place script after stylesheet

			console.log(error);
			if (error.toString().indexOf("The operation is insecure")!=-1) {
				console.log("Load the stylesheet before the script or load the stylesheet inline until it can be loaded on a server")
			}
			return [];
		}
	}

	/**
	 * If single page application hide all of the views. 
	 * @param {Number} selectedIndex if provided shows the view at index provided
	 **/
	self.hideViews = function(selectedIndex, animation) {
		var rules = self.getStylesheetRules();
		var queryIndex = 0;
		var numberOfRules = rules!=null ? rules.length : 0;

		// loop through rules and hide media queries except selected
		for (var i=0;i<numberOfRules;i++) {
			var rule = rules[i];
			var cssText = rule && rule.cssText;

			if (rule.media!=null && cssText.match("--web-view-name:")) {

				if (queryIndex==selectedIndex) {
					self.currentQuery.mediaText = rule.conditionText;
					self.currentQuery.index = selectedIndex;
					self.currentQuery.rule = rule;
					self.enableMediaQuery(rule);
				}
				else {
					if (animation) {
						self.fadeOut(rule)
					}
					else {
						self.disableMediaQuery(rule);
					}
				}
				
				queryIndex++;
			}
		}

		self.numberOfViews = queryIndex;
		self.updateViewLabel();
		self.updateURL();

		self.dispatchViewChange();

		var view = self.getVisibleView();
		var viewIndex = view ? self.getViewIndex(view) : -1;

		return viewIndex==selectedIndex ? view : null;
	}

	/**
	 * If single page application hide all of the views. 
	 * @param {HTMLElement} selectedView if provided shows the view passed in
	 **/
	 self.hideAllViews = function(selectedView, animation) {
		var views = self.views;
		var queryIndex = 0;
		var numberOfViews = views!=null ? views.length : 0;

		// loop through rules and hide media queries except selected
		for (var i=0;i<numberOfViews;i++) {
			var viewData = views[i];
			var view = viewData && viewData.view;
			var mediaRule = viewData && viewData.mediaRule;
			
			if (view==selectedView) {
				self.currentQuery.mediaText = mediaRule.conditionText;
				self.currentQuery.index = queryIndex;
				self.currentQuery.rule = mediaRule;
				self.enableMediaQuery(mediaRule);
			}
			else {
				if (animation) {
					self.fadeOut(mediaRule)
				}
				else {
					self.disableMediaQuery(mediaRule);
				}
			}
			
			queryIndex++;
		}

		self.numberOfViews = queryIndex;
		self.updateViewLabel();
		self.updateURL();
		self.dispatchViewChange();

		var visibleView = self.getVisibleView();

		return visibleView==selectedView ? selectedView : null;
	}

	/**
	 * Hide view
	 * @param {Object} view element to hide
	 **/
	self.hideView = function(view) {
		var rule = view ? self.mediaQueryDictionary[view.id] : null;

		if (rule) {
			self.disableMediaQuery(rule);
		}
	}

	/**
	 * Hide overlay
	 * @param {Object} overlay element to hide
	 **/
	self.hideOverlay = function(overlay) {
		var rule = overlay ? self.mediaQueryDictionary[overlay.id] : null;

		if (rule) {
			self.disableMediaQuery(rule);

			//if (self.showByMediaQuery) {
				overlay.style.display = "none";
			//}
		}
	}

	/**
	 * Show the view by media query. Does not hide current views
	 * Sets view options by default
	 * @param {Object} view element to show
	 * @param {Boolean} setViewOptions sets view options if null or true
	 */
	self.showViewByMediaQuery = function(view, setViewOptions) {
		var id = view ? view.id : null;
		var query = id ? self.mediaQueryDictionary[id] : null;
		var isOverlay = view ? self.isOverlay(view) : false;
		setViewOptions = setViewOptions==null ? true : setViewOptions;

		if (query) {
			self.enableMediaQuery(query);

			if (isOverlay && view && setViewOptions) {
				self.setViewVariables(null, view);
			}
			else {
				if (view && setViewOptions) self.setViewOptions(view);
				if (view && setViewOptions) self.setViewVariables(view);
			}
		}
	}

	/**
	 * Show the view. Does not hide current views
	 */
	self.showView = function(view, setViewOptions) {
		var id = view ? view.id : null;
		var query = id ? self.mediaQueryDictionary[id] : null;
		var display = null;
		setViewOptions = setViewOptions==null ? true : setViewOptions;

		if (query) {
			self.enableMediaQuery(query);
			if (view==null) view =self.getVisibleView();
			if (view && setViewOptions) self.setViewOptions(view);
		}
		else if (id) {
			display = window.getComputedStyle(view).getPropertyValue("display");
			if (display=="" || display=="none") {
				view.style.display = "block";
			}
		}

		if (view) {
			if (self.currentView!=null) {
				self.lastView = self.currentView;
			}

			self.currentView = view;
		}
	}

	self.showViewById = function(id, setViewOptions) {
		var view = id ? self.getViewById(id) : null;

		if (view) {
			self.showView(view);
			return;
		}

		self.log("View not found '" + id + "'");
	}

	self.getElementView = function(element) {
		var view = element;
		var viewFound = false;

		while (viewFound==false || view==null) {
			if (view && self.viewsDictionary[view.id]) {
				return view;
			}
			view = view.parentNode;
		}
	}

	/**
	 * Show overlay over view
	 * @param {Event | HTMLElement} event event or html element with styles applied
	 * @param {String} id id of view or view reference
	 * @param {Number} x x location
	 * @param {Number} y y location
	 */
	self.showOverlay = function(event, id, x, y) {
		var overlay = id && typeof id === 'string' ? self.getViewById(id) : id ? id : null;
		var query = overlay ? self.mediaQueryDictionary[overlay.id] : null;
		var centerHorizontally = false;
		var centerVertically = false;
		var anchorLeft = false;
		var anchorTop = false;
		var anchorRight = false;
		var anchorBottom = false;
		var display = null;
		var reparent = true;
		var view = null;
		
		if (overlay==null || overlay==false) {
			self.log("Overlay not found, '"+ id + "'");
			return;
		}

		// get enter animation - event target must have css variables declared
		if (event) {
			var button = event.currentTarget || event; // can be event or htmlelement
			var buttonComputedStyles = getComputedStyle(button);
			var actionTargetValue = buttonComputedStyles.getPropertyValue(self.prefix+"action-target").trim();
			var animation = buttonComputedStyles.getPropertyValue(self.prefix+"animation").trim();
			var isAnimated = animation!="";
			var targetType = buttonComputedStyles.getPropertyValue(self.prefix+"action-type").trim();
			var actionTarget = self.application ? null : self.getElement(actionTargetValue);
			var actionTargetStyles = actionTarget ? actionTarget.style : null;

			if (actionTargetStyles) {
				actionTargetStyles.setProperty("animation", animation);
			}

			if ("stopImmediatePropagation" in event) {
				event.stopImmediatePropagation();
			}
		}
		
		if (self.application==false || targetType=="page") {
			document.location.href = "./" + actionTargetValue;
			return;
		}

		// remove any current overlays
		if (self.currentOverlay) {

			// act as switch if same button
			if (self.currentOverlay==actionTarget || self.currentOverlay==null) {
				if (self.lastTrigger==button) {
					self.removeOverlay(isAnimated);
					return;
				}
			}
			else {
				self.removeOverlay(isAnimated);
			}
		}

		if (reparent) {
			view = self.getElementView(button);
			if (view) {
				view.appendChild(overlay);
			}
		}

		if (query) {
			//self.setElementAnimation(overlay, null);
			//overlay.style.animation = animation;
			self.enableMediaQuery(query);
			
			var display = overlay && overlay.style.display;
			
			if (overlay && display=="" || display=="none") {
				overlay.style.display = "block";
				//self.setViewOptions(overlay);
			}

			// add animation defined in event target style declaration
			if (animation && self.supportAnimations) {
				self.fadeIn(overlay, false, animation);
			}
		}
		else if (id) {

			display = window.getComputedStyle(overlay).getPropertyValue("display");

			if (display=="" || display=="none") {
				overlay.style.display = "block";
			}

			// add animation defined in event target style declaration
			if (animation && self.supportAnimations) {
				self.fadeIn(overlay, false, animation);
			}
		}

		// do not set x or y position if centering
		var horizontal = self.prefix + "center-horizontally";
		var vertical = self.prefix + "center-vertically";
		var style = overlay.style;
		var transform = [];

		centerHorizontally = self.getIsStyleDefined(id, horizontal) ? self.getViewPreferenceBoolean(overlay, horizontal) : false;
		centerVertically = self.getIsStyleDefined(id, vertical) ? self.getViewPreferenceBoolean(overlay, vertical) : false;
		anchorLeft = self.getIsStyleDefined(id, "left");
		anchorRight = self.getIsStyleDefined(id, "right");
		anchorTop = self.getIsStyleDefined(id, "top");
		anchorBottom = self.getIsStyleDefined(id, "bottom");

		
		if (self.viewsDictionary[overlay.id] && self.viewsDictionary[overlay.id].styleDeclaration) {
			style = self.viewsDictionary[overlay.id].styleDeclaration.style;
		}
		
		if (centerHorizontally) {
			style.left = "50%";
			style.transformOrigin = "0 0";
			transform.push("translateX(-50%)");
		}
		else if (anchorRight && anchorLeft) {
			style.left = x + "px";
		}
		else if (anchorRight) {
			//style.right = x + "px";
		}
		else {
			style.left = x + "px";
		}
		
		if (centerVertically) {
			style.top = "50%";
			transform.push("translateY(-50%)");
			style.transformOrigin = "0 0";
		}
		else if (anchorTop && anchorBottom) {
			style.top = y + "px";
		}
		else if (anchorBottom) {
			//style.bottom = y + "px";
		}
		else {
			style.top = y + "px";
		}

		if (transform.length) {
			style.transform = transform.join(" ");
		}

		self.currentOverlay = overlay;
		self.lastTrigger = button;
	}

	self.goBack = function() {
		if (self.currentOverlay) {
			self.removeOverlay();
		}
		else if (self.lastView) {
			self.goToView(self.lastView.id);
		}
	}

	self.removeOverlay = function(animate) {
		var overlay = self.currentOverlay;
		animate = animate===false ? false : true;

		if (overlay) {
			var style = overlay.style;
			
			if (style.animation && self.supportAnimations && animate) {
				self.reverseAnimation(overlay, true);

				var duration = self.getAnimationDuration(style.animation, true);
		
				setTimeout(function() {
					self.setElementAnimation(overlay, null);
					self.hideOverlay(overlay);
					self.currentOverlay = null;
				}, duration);
			}
			else {
				self.setElementAnimation(overlay, null);
				self.hideOverlay(overlay);
				self.currentOverlay = null;
			}
		}
	}

	/**
	 * Reverse the animation and hide after
	 * @param {Object} target element with animation
	 * @param {Boolean} hide hide after animation ends
	 */
	self.reverseAnimation = function(target, hide) {
		var lastAnimation = null;
		var style = target.style;

		style.animationPlayState = "paused";
		lastAnimation = style.animation;
		style.animation = null;
		style.animationPlayState = "paused";

		if (hide) {
			//target.addEventListener("animationend", self.animationEndHideHandler);
	
			var duration = self.getAnimationDuration(lastAnimation, true);
			var isOverlay = self.isOverlay(target);
	
			setTimeout(function() {
				self.setElementAnimation(target, null);

				if (isOverlay) {
					self.hideOverlay(target);
				}
				else {
					self.hideView(target);
				}
			}, duration);
		}

		setTimeout(function() {
			style.animation = lastAnimation;
			style.animationPlayState = "paused";
			style.animationDirection = "reverse";
			style.animationPlayState = "running";
		}, 30);
	}

	self.animationEndHandler = function(event) {
		var target = event.currentTarget;
		self.dispatchEvent(new Event(event.type));
	}

	self.isOverlay = function(view) {
		var result = view ? self.getViewPreferenceBoolean(view, self.prefix + "is-overlay") : false;

		return result;
	}

	self.animationEndHideHandler = function(event) {
		var target = event.currentTarget;
		self.setViewVariables(null, target);
		self.hideView(target);
		target.removeEventListener("animationend", self.animationEndHideHandler);
	}

	self.animationEndShowHandler = function(event) {
		var target = event.currentTarget;
		target.removeEventListener("animationend", self.animationEndShowHandler);
	}

	self.setViewOptions = function(view) {

		if (view) {
			self.minimumScale = self.getViewPreferenceValue(view, self.prefix + "minimum-scale");
			self.maximumScale = self.getViewPreferenceValue(view, self.prefix + "maximum-scale");
			self.scaleViewsToFit = self.getViewPreferenceBoolean(view, self.prefix + "scale-to-fit");
			self.scaleToFitType = self.getViewPreferenceValue(view, self.prefix + "scale-to-fit-type");
			self.scaleToFitOnDoubleClick = self.getViewPreferenceBoolean(view, self.prefix + "scale-on-double-click");
			self.actualSizeOnDoubleClick = self.getViewPreferenceBoolean(view, self.prefix + "actual-size-on-double-click");
			self.scaleViewsOnResize = self.getViewPreferenceBoolean(view, self.prefix + "scale-on-resize");
			self.enableScaleUp = self.getViewPreferenceBoolean(view, self.prefix + "enable-scale-up");
			self.centerHorizontally = self.getViewPreferenceBoolean(view, self.prefix + "center-horizontally");
			self.centerVertically = self.getViewPreferenceBoolean(view, self.prefix + "center-vertically");
			self.navigationOnKeypress = self.getViewPreferenceBoolean(view, self.prefix + "navigate-on-keypress");
			self.showViewName = self.getViewPreferenceBoolean(view, self.prefix + "show-view-name");
			self.refreshPageForChanges = self.getViewPreferenceBoolean(view, self.prefix + "refresh-for-changes");
			self.refreshPageForChangesInterval = self.getViewPreferenceValue(view, self.prefix + "refresh-interval");
			self.showNavigationControls = self.getViewPreferenceBoolean(view, self.prefix + "show-navigation-controls");
			self.scaleViewSlider = self.getViewPreferenceBoolean(view, self.prefix + "show-scale-controls");
			self.enableDeepLinking = self.getViewPreferenceBoolean(view, self.prefix + "enable-deep-linking");
			self.singlePageApplication = self.getViewPreferenceBoolean(view, self.prefix + "application");
			self.showByMediaQuery = self.getViewPreferenceBoolean(view, self.prefix + "show-by-media-query");
			self.showUpdateNotification = document.cookie!="" ? document.cookie.indexOf(self.pageRefreshedName)!=-1 : false;
			self.imageComparisonDuration = self.getViewPreferenceValue(view, self.prefix + "image-comparison-duration");
			self.supportAnimations = self.getViewPreferenceBoolean(view, self.prefix + "enable-animations", true);

			if (self.scaleViewsToFit) {
				var newScaleValue = self.scaleViewToFit(view);
				
				if (newScaleValue<0) {
					setTimeout(self.scaleViewToFit, 500, view);
				}
			}
			else {
				self.viewScale = self.getViewScaleValue(view);
				self.viewToFitWidthScale = self.getViewFitToViewportWidthScale(view, self.enableScaleUp)
				self.viewToFitHeightScale = self.getViewFitToViewportScale(view, self.enableScaleUp);
				self.updateSliderValue(self.viewScale);
			}

			if (self.imageComparisonDuration!=null) {
				// todo
			}

			if (self.refreshPageForChangesInterval!=null) {
				self.refreshDuration = Number(self.refreshPageForChangesInterval);
			}
		}
	}

	self.previousView = function(event) {
		var rules = self.getStylesheetRules();
		var view = self.getVisibleView()
		var index = view ? self.getViewIndex(view) : -1;
		var prevQueryIndex = index!=-1 ? index-1 : self.currentQuery.index-1;
		var queryIndex = 0;
		var numberOfRules = rules!=null ? rules.length : 0;

		if (event) {
			event.stopImmediatePropagation();
		}

		if (prevQueryIndex<0) {
			return;
		}

		// loop through rules and hide media queries except selected
		for (var i=0;i<numberOfRules;i++) {
			var rule = rules[i];
			
			if (rule.media!=null) {

				if (queryIndex==prevQueryIndex) {
					self.currentQuery.mediaText = rule.conditionText;
					self.currentQuery.index = prevQueryIndex;
					self.currentQuery.rule = rule;
					self.enableMediaQuery(rule);
					self.updateViewLabel();
					self.updateURL();
					self.dispatchViewChange();
				}
				else {
					self.disableMediaQuery(rule);
				}

				queryIndex++;
			}
		}
	}

	self.nextView = function(event) {
		var rules = self.getStylesheetRules();
		var view = self.getVisibleView();
		var index = view ? self.getViewIndex(view) : -1;
		var nextQueryIndex = index!=-1 ? index+1 : self.currentQuery.index+1;
		var queryIndex = 0;
		var numberOfRules = rules!=null ? rules.length : 0;
		var numberOfMediaQueries = self.getNumberOfMediaRules();

		if (event) {
			event.stopImmediatePropagation();
		}

		if (nextQueryIndex>=numberOfMediaQueries) {
			return;
		}

		// loop through rules and hide media queries except selected
		for (var i=0;i<numberOfRules;i++) {
			var rule = rules[i];
			
			if (rule.media!=null) {

				if (queryIndex==nextQueryIndex) {
					self.currentQuery.mediaText = rule.conditionText;
					self.currentQuery.index = nextQueryIndex;
					self.currentQuery.rule = rule;
					self.enableMediaQuery(rule);
					self.updateViewLabel();
					self.updateURL();
					self.dispatchViewChange();
				}
				else {
					self.disableMediaQuery(rule);
				}

				queryIndex++;
			}
		}
	}

	/**
	 * Enables a view via media query
	 */
	self.enableMediaQuery = function(rule) {

		try {
			rule.media.mediaText = self.inclusionQuery;
		}
		catch(error) {
			//self.log(error);
			rule.conditionText = self.inclusionQuery;
		}
	}

	self.disableMediaQuery = function(rule) {

		try {
			rule.media.mediaText = self.exclusionQuery;
		}
		catch(error) {
			rule.conditionText = self.exclusionQuery;
		}
	}

	self.dispatchViewChange = function() {
		try {
			var event = new Event(self.NAVIGATION_CHANGE);
			window.dispatchEvent(event);
		}
		catch (error) {
			// In IE 11: Object doesn't support this action
		}
	}

	self.getNumberOfMediaRules = function() {
		var rules = self.getStylesheetRules();
		var numberOfRules = rules ? rules.length : 0;
		var numberOfQueries = 0;

		for (var i=0;i<numberOfRules;i++) {
			if (rules[i].media!=null) { numberOfQueries++; }
		}
		
		return numberOfQueries;
	}

	/////////////////////////////////////////
	// VIEW SCALE 
	/////////////////////////////////////////

	self.sliderChangeHandler = function(event) {
		var value = self.getShortNumber(event.currentTarget.value/100);
		var view = self.getVisibleView();
		self.setViewScaleValue(view, false, value, true);
	}

	self.updateSliderValue = function(scale) {
		var slider = document.getElementById(self.viewScaleSliderId);
		var tooltip = parseInt(scale * 100 + "") + "%";
		var inputType;
		var inputValue;
		
		if (slider) {
			inputValue = self.getShortNumber(scale * 100);
			if (inputValue!=slider["value"]) {
				slider["value"] = inputValue;
			}
			inputType = slider.getAttributeNS(null, "type");

			if (inputType!="range") {
				// input range is not supported
				slider.style.display = "none";
			}

			self.setTooltip(slider, tooltip);
		}
	}

	self.viewChangeHandler = function(event) {
		var view = self.getVisibleView();
		var matrix = view ? getComputedStyle(view).transform : null;
		
		if (matrix) {
			self.viewScale = self.getViewScaleValue(view);
			
			var scaleNeededToFit = self.getViewFitToViewportScale(view);
			var isViewLargerThanViewport = scaleNeededToFit<1;
			
			// scale large view to fit if scale to fit is enabled
			if (self.scaleViewsToFit) {
				self.scaleViewToFit(view);
			}
			else {
				self.updateSliderValue(self.viewScale);
			}
		}
	}

	self.getViewScaleValue = function(view) {
		var matrix = getComputedStyle(view).transform;

		if (matrix) {
			var matrixArray = matrix.replace("matrix(", "").split(",");
			var scaleX = parseFloat(matrixArray[0]);
			var scaleY = parseFloat(matrixArray[3]);
			var scale = Math.min(scaleX, scaleY);
		}

		return scale;
	}

	/**
	 * Scales view to scale. 
	 * @param {Object} view view to scale. views are in views array
	 * @param {Boolean} scaleToFit set to true to scale to fit. set false to use desired scale value
	 * @param {Number} desiredScale scale to define. not used if scale to fit is false
	 * @param {Boolean} isSliderChange indicates if slider is callee
	 */
	self.setViewScaleValue = function(view, scaleToFit, desiredScale, isSliderChange) {
		var enableScaleUp = self.enableScaleUp;
		var scaleToFitType = self.scaleToFitType;
		var minimumScale = self.minimumScale;
		var maximumScale = self.maximumScale;
		var hasMinimumScale = !isNaN(minimumScale) && minimumScale!="";
		var hasMaximumScale = !isNaN(maximumScale) && maximumScale!="";
		var scaleNeededToFit = self.getViewFitToViewportScale(view, enableScaleUp);
		var scaleNeededToFitWidth = self.getViewFitToViewportWidthScale(view, enableScaleUp);
		var scaleNeededToFitHeight = self.getViewFitToViewportHeightScale(view, enableScaleUp);
		var scaleToFitFull = self.getViewFitToViewportScale(view, true);
		var scaleToFitFullWidth = self.getViewFitToViewportWidthScale(view, true);
		var scaleToFitFullHeight = self.getViewFitToViewportHeightScale(view, true);
		var scaleToWidth = scaleToFitType=="width";
		var scaleToHeight = scaleToFitType=="height";
		var shrunkToFit = false;
		var topPosition = null;
		var leftPosition = null;
		var translateY = null;
		var translateX = null;
		var transformValue = "";
		var canCenterVertically = true;
		var canCenterHorizontally = true;
		var style = view.style;

		if (view && self.viewsDictionary[view.id] && self.viewsDictionary[view.id].styleDeclaration) {
			style = self.viewsDictionary[view.id].styleDeclaration.style;
		}

		if (scaleToFit && isSliderChange!=true) {
			if (scaleToFitType=="fit" || scaleToFitType=="") {
				desiredScale = scaleNeededToFit;
			}
			else if (scaleToFitType=="width") {
				desiredScale = scaleNeededToFitWidth;
			}
			else if (scaleToFitType=="height") {
				desiredScale = scaleNeededToFitHeight;
			}
		}
		else {
			if (isNaN(desiredScale)) {
				desiredScale = 1;
			}
		}

		self.updateSliderValue(desiredScale);
		
		// scale to fit width
		if (scaleToWidth && scaleToHeight==false) {
			canCenterVertically = scaleNeededToFitHeight>=scaleNeededToFitWidth;
			canCenterHorizontally = scaleNeededToFitWidth>=1 && enableScaleUp==false;

			if (isSliderChange) {
				canCenterHorizontally = desiredScale<scaleToFitFullWidth;
			}
			else if (scaleToFit) {
				desiredScale = scaleNeededToFitWidth;
			}

			if (hasMinimumScale) {
				desiredScale = Math.max(desiredScale, Number(minimumScale));
			}

			if (hasMaximumScale) {
				desiredScale = Math.min(desiredScale, Number(maximumScale));
			}

			desiredScale = self.getShortNumber(desiredScale);

			canCenterHorizontally = self.canCenterHorizontally(view, "width", enableScaleUp, desiredScale, minimumScale, maximumScale);
			canCenterVertically = self.canCenterVertically(view, "width", enableScaleUp, desiredScale, minimumScale, maximumScale);

			if (desiredScale>1 && (enableScaleUp || isSliderChange)) {
				transformValue = "scale(" + desiredScale + ")";
			}
			else if (desiredScale>=1 && enableScaleUp==false) {
				transformValue = "scale(" + 1 + ")";
			}
			else {
				transformValue = "scale(" + desiredScale + ")";
			}

			if (self.centerVertically) {
				if (canCenterVertically) {
					translateY = "-50%";
					topPosition = "50%";
				}
				else {
					translateY = "0";
					topPosition = "0";
				}
				
				if (style.top != topPosition) {
					style.top = topPosition + "";
				}

				if (canCenterVertically) {
					transformValue += " translateY(" + translateY+ ")";
				}
			}

			if (self.centerHorizontally) {
				if (canCenterHorizontally) {
					translateX = "-50%";
					leftPosition = "50%";
				}
				else {
					translateX = "0";
					leftPosition = "0";
				}

				if (style.left != leftPosition) {
					style.left = leftPosition + "";
				}

				if (canCenterHorizontally) {
					transformValue += " translateX(" + translateX+ ")";
				}
			}

			style.transformOrigin = "0 0";
			style.transform = transformValue;

			self.viewScale = desiredScale;
			self.viewToFitWidthScale = scaleNeededToFitWidth;
			self.viewToFitHeightScale = scaleNeededToFitHeight;
			self.viewLeft = leftPosition;
			self.viewTop = topPosition;

			return desiredScale;
		}

		// scale to fit height
		if (scaleToHeight && scaleToWidth==false) {
			//canCenterVertically = scaleNeededToFitHeight>=scaleNeededToFitWidth;
			//canCenterHorizontally = scaleNeededToFitHeight<=scaleNeededToFitWidth && enableScaleUp==false;
			canCenterVertically = scaleNeededToFitHeight>=scaleNeededToFitWidth;
			canCenterHorizontally = scaleNeededToFitWidth>=1 && enableScaleUp==false;
			
			if (isSliderChange) {
				canCenterHorizontally = desiredScale<scaleToFitFullHeight;
			}
			else if (scaleToFit) {
				desiredScale = scaleNeededToFitHeight;
			}

			if (hasMinimumScale) {
				desiredScale = Math.max(desiredScale, Number(minimumScale));
			}

			if (hasMaximumScale) {
				desiredScale = Math.min(desiredScale, Number(maximumScale));
				//canCenterVertically = desiredScale>=scaleNeededToFitHeight && enableScaleUp==false;
			}

			desiredScale = self.getShortNumber(desiredScale);

			canCenterHorizontally = self.canCenterHorizontally(view, "height", enableScaleUp, desiredScale, minimumScale, maximumScale);
			canCenterVertically = self.canCenterVertically(view, "height", enableScaleUp, desiredScale, minimumScale, maximumScale);

			if (desiredScale>1 && (enableScaleUp || isSliderChange)) {
				transformValue = "scale(" + desiredScale + ")";
			}
			else if (desiredScale>=1 && enableScaleUp==false) {
				transformValue = "scale(" + 1 + ")";
			}
			else {
				transformValue = "scale(" + desiredScale + ")";
			}

			if (self.centerHorizontally) {
				if (canCenterHorizontally) {
					translateX = "-50%";
					leftPosition = "50%";
				}
				else {
					translateX = "0";
					leftPosition = "0";
				}

				if (style.left != leftPosition) {
					style.left = leftPosition + "";
				}

				if (canCenterHorizontally) {
					transformValue += " translateX(" + translateX+ ")";
				}
			}

			if (self.centerVertically) {
				if (canCenterVertically) {
					translateY = "-50%";
					topPosition = "50%";
				}
				else {
					translateY = "0";
					topPosition = "0";
				}
				
				if (style.top != topPosition) {
					style.top = topPosition + "";
				}

				if (canCenterVertically) {
					transformValue += " translateY(" + translateY+ ")";
				}
			}

			style.transformOrigin = "0 0";
			style.transform = transformValue;

			self.viewScale = desiredScale;
			self.viewToFitWidthScale = scaleNeededToFitWidth;
			self.viewToFitHeightScale = scaleNeededToFitHeight;
			self.viewLeft = leftPosition;
			self.viewTop = topPosition;

			return scaleNeededToFitHeight;
		}

		if (scaleToFitType=="fit") {
			//canCenterVertically = scaleNeededToFitHeight>=scaleNeededToFitWidth;
			//canCenterHorizontally = scaleNeededToFitWidth>=scaleNeededToFitHeight;
			canCenterVertically = scaleNeededToFitHeight>=scaleNeededToFit;
			canCenterHorizontally = scaleNeededToFitWidth>=scaleNeededToFit;

			if (hasMinimumScale) {
				desiredScale = Math.max(desiredScale, Number(minimumScale));
			}

			desiredScale = self.getShortNumber(desiredScale);

			if (isSliderChange || scaleToFit==false) {
				canCenterVertically = scaleToFitFullHeight>=desiredScale;
				canCenterHorizontally = desiredScale<scaleToFitFullWidth;
			}
			else if (scaleToFit) {
				desiredScale = scaleNeededToFit;
			}

			transformValue = "scale(" + desiredScale + ")";

			//canCenterHorizontally = self.canCenterHorizontally(view, "fit", false, desiredScale);
			//canCenterVertically = self.canCenterVertically(view, "fit", false, desiredScale);
			
			if (self.centerVertically) {
				if (canCenterVertically) {
					translateY = "-50%";
					topPosition = "50%";
				}
				else {
					translateY = "0";
					topPosition = "0";
				}
				
				if (style.top != topPosition) {
					style.top = topPosition + "";
				}

				if (canCenterVertically) {
					transformValue += " translateY(" + translateY+ ")";
				}
			}

			if (self.centerHorizontally) {
				if (canCenterHorizontally) {
					translateX = "-50%";
					leftPosition = "50%";
				}
				else {
					translateX = "0";
					leftPosition = "0";
				}

				if (style.left != leftPosition) {
					style.left = leftPosition + "";
				}

				if (canCenterHorizontally) {
					transformValue += " translateX(" + translateX+ ")";
				}
			}

			style.transformOrigin = "0 0";
			style.transform = transformValue;

			self.viewScale = desiredScale;
			self.viewToFitWidthScale = scaleNeededToFitWidth;
			self.viewToFitHeightScale = scaleNeededToFitHeight;
			self.viewLeft = leftPosition;
			self.viewTop = topPosition;

			self.updateSliderValue(desiredScale);
			
			return desiredScale;
		}

		if (scaleToFitType=="default" || scaleToFitType=="") {
			desiredScale = 1;

			if (hasMinimumScale) {
				desiredScale = Math.max(desiredScale, Number(minimumScale));
			}
			if (hasMaximumScale) {
				desiredScale = Math.min(desiredScale, Number(maximumScale));
			}

			canCenterHorizontally = self.canCenterHorizontally(view, "none", false, desiredScale, minimumScale, maximumScale);
			canCenterVertically = self.canCenterVertically(view, "none", false, desiredScale, minimumScale, maximumScale);

			if (self.centerVertically) {
				if (canCenterVertically) {
					translateY = "-50%";
					topPosition = "50%";
				}
				else {
					translateY = "0";
					topPosition = "0";
				}
				
				if (style.top != topPosition) {
					style.top = topPosition + "";
				}

				if (canCenterVertically) {
					transformValue += " translateY(" + translateY+ ")";
				}
			}

			if (self.centerHorizontally) {
				if (canCenterHorizontally) {
					translateX = "-50%";
					leftPosition = "50%";
				}
				else {
					translateX = "0";
					leftPosition = "0";
				}

				if (style.left != leftPosition) {
					style.left = leftPosition + "";
				}

				if (canCenterHorizontally) {
					transformValue += " translateX(" + translateX+ ")";
				}
				else {
					transformValue += " translateX(" + 0 + ")";
				}
			}

			style.transformOrigin = "0 0";
			style.transform = transformValue;


			self.viewScale = desiredScale;
			self.viewToFitWidthScale = scaleNeededToFitWidth;
			self.viewToFitHeightScale = scaleNeededToFitHeight;
			self.viewLeft = leftPosition;
			self.viewTop = topPosition;

			self.updateSliderValue(desiredScale);
			
			return desiredScale;
		}
	}

	/**
	 * Returns true if view can be centered horizontally
	 * @param {HTMLElement} view view
	 * @param {String} type type of scaling - width, height, all, none
	 * @param {Boolean} scaleUp if scale up enabled 
	 * @param {Number} scale target scale value 
	 */
	self.canCenterHorizontally = function(view, type, scaleUp, scale, minimumScale, maximumScale) {
		var scaleNeededToFit = self.getViewFitToViewportScale(view, scaleUp);
		var scaleNeededToFitHeight = self.getViewFitToViewportHeightScale(view, scaleUp);
		var scaleNeededToFitWidth = self.getViewFitToViewportWidthScale(view, scaleUp);
		var canCenter = false;
		var minScale;

		type = type==null ? "none" : type;
		scale = scale==null ? scale : scaleNeededToFitWidth;
		scaleUp = scaleUp == null ? false : scaleUp;

		if (type=="width") {
	
			if (scaleUp && maximumScale==null) {
				canCenter = false;
			}
			else if (scaleNeededToFitWidth>=1) {
				canCenter = true;
			}
		}
		else if (type=="height") {
			minScale = Math.min(1, scaleNeededToFitHeight);
			if (minimumScale!="" && maximumScale!="") {
				minScale = Math.max(minimumScale, Math.min(maximumScale, scaleNeededToFitHeight));
			}
			else {
				if (minimumScale!="") {
					minScale = Math.max(minimumScale, scaleNeededToFitHeight);
				}
				if (maximumScale!="") {
					minScale = Math.max(minimumScale, Math.min(maximumScale, scaleNeededToFitHeight));
				}
			}
	
			if (scaleUp && maximumScale=="") {
				canCenter = false;
			}
			else if (scaleNeededToFitWidth>=minScale) {
				canCenter = true;
			}
		}
		else if (type=="fit") {
			canCenter = scaleNeededToFitWidth>=scaleNeededToFit;
		}
		else {
			if (scaleUp) {
				canCenter = false;
			}
			else if (scaleNeededToFitWidth>=1) {
				canCenter = true;
			}
		}

		self.horizontalScrollbarsNeeded = canCenter;
		
		return canCenter;
	}

	/**
	 * Returns true if view can be centered horizontally
	 * @param {HTMLElement} view view to scale
	 * @param {String} type type of scaling
	 * @param {Boolean} scaleUp if scale up enabled 
	 * @param {Number} scale target scale value 
	 */
	self.canCenterVertically = function(view, type, scaleUp, scale, minimumScale, maximumScale) {
		var scaleNeededToFit = self.getViewFitToViewportScale(view, scaleUp);
		var scaleNeededToFitWidth = self.getViewFitToViewportWidthScale(view, scaleUp);
		var scaleNeededToFitHeight = self.getViewFitToViewportHeightScale(view, scaleUp);
		var canCenter = false;
		var minScale;

		type = type==null ? "none" : type;
		scale = scale==null ? 1 : scale;
		scaleUp = scaleUp == null ? false : scaleUp;
	
		if (type=="width") {
			canCenter = scaleNeededToFitHeight>=scaleNeededToFitWidth;
		}
		else if (type=="height") {
			minScale = Math.max(minimumScale, Math.min(maximumScale, scaleNeededToFit));
			canCenter = scaleNeededToFitHeight>=minScale;
		}
		else if (type=="fit") {
			canCenter = scaleNeededToFitHeight>=scaleNeededToFit;
		}
		else {
			if (scaleUp) {
				canCenter = false;
			}
			else if (scaleNeededToFitHeight>=1) {
				canCenter = true;
			}
		}

		self.verticalScrollbarsNeeded = canCenter;
		
		return canCenter;
	}

	self.getViewFitToViewportScale = function(view, scaleUp) {
		var enableScaleUp = scaleUp;
		var availableWidth = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
		var availableHeight = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
		var elementWidth = parseFloat(getComputedStyle(view, "style").width);
		var elementHeight = parseFloat(getComputedStyle(view, "style").height);
		var newScale = 1;

		// if element is not added to the document computed values are NaN
		if (isNaN(elementWidth) || isNaN(elementHeight)) {
			return newScale;
		}

		availableWidth -= self.horizontalPadding;
		availableHeight -= self.verticalPadding;

		if (enableScaleUp) {
			newScale = Math.min(availableHeight/elementHeight, availableWidth/elementWidth);
		}
		else if (elementWidth > availableWidth || elementHeight > availableHeight) {
			newScale = Math.min(availableHeight/elementHeight, availableWidth/elementWidth);
		}
		
		return newScale;
	}

	self.getViewFitToViewportWidthScale = function(view, scaleUp) {
		// need to get browser viewport width when element
		var isParentWindow = view && view.parentNode && view.parentNode===document.body;
		var enableScaleUp = scaleUp;
		var availableWidth = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
		var elementWidth = parseFloat(getComputedStyle(view, "style").width);
		var newScale = 1;

		// if element is not added to the document computed values are NaN
		if (isNaN(elementWidth)) {
			return newScale;
		}

		availableWidth -= self.horizontalPadding;

		if (enableScaleUp) {
			newScale = availableWidth/elementWidth;
		}
		else if (elementWidth > availableWidth) {
			newScale = availableWidth/elementWidth;
		}
		
		return newScale;
	}

	self.getViewFitToViewportHeightScale = function(view, scaleUp) {
		var enableScaleUp = scaleUp;
		var availableHeight = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
		var elementHeight = parseFloat(getComputedStyle(view, "style").height);
		var newScale = 1;

		// if element is not added to the document computed values are NaN
		if (isNaN(elementHeight)) {
			return newScale;
		}

		availableHeight -= self.verticalPadding;

		if (enableScaleUp) {
			newScale = availableHeight/elementHeight;
		}
		else if (elementHeight > availableHeight) {
			newScale = availableHeight/elementHeight;
		}
		
		return newScale;
	}

	self.keypressHandler = function(event) {
		var rightKey = 39;
		var leftKey = 37;
		
		// listen for both events 
		if (event.type=="keypress") {
			window.removeEventListener("keyup", self.keypressHandler);
		}
		else {
			window.removeEventListener("keypress", self.keypressHandler);
		}
		
		if (self.showNavigationControls) {
			if (self.navigationOnKeypress) {
				if (event.keyCode==rightKey) {
					self.nextView();
				}
				if (event.keyCode==leftKey) {
					self.previousView();
				}
			}
		}
		else if (self.navigationOnKeypress) {
			if (event.keyCode==rightKey) {
				self.nextView();
			}
			if (event.keyCode==leftKey) {
				self.previousView();
			}
		}
	}

	///////////////////////////////////
	// GENERAL FUNCTIONS
	///////////////////////////////////

	self.getViewById = function(id) {
		id = id ? id.replace("#", "") : "";
		var view = self.viewIds.indexOf(id)!=-1 && self.getElement(id);
		return view;
	}

	self.getViewIds = function() {
		var viewIds = self.getViewPreferenceValue(document.body, self.prefix + "view-ids");
		var viewId = null;

		viewIds = viewIds!=null && viewIds!="" ? viewIds.split(",") : [];

		if (viewIds.length==0) {
			viewId = self.getViewPreferenceValue(document.body, self.prefix + "view-id");
			viewIds = viewId ? [viewId] : [];
		}

		return viewIds;
	}

	self.getInitialViewId = function() {
		var viewId = self.getViewPreferenceValue(document.body, self.prefix + "view-id");
		return viewId;
	}

	self.getApplicationStylesheet = function() {
		var stylesheetId = self.getViewPreferenceValue(document.body, self.prefix + "stylesheet-id");
		self.applicationStylesheet = document.getElementById("applicationStylesheet");
		return self.applicationStylesheet.sheet;
	}

	self.getVisibleView = function() {
		var viewIds = self.getViewIds();
		
		for (var i=0;i<viewIds.length;i++) {
			var viewId = viewIds[i].replace(/[\#?\.?](.*)/, "$" + "1");
			var view = self.getElement(viewId);
			var postName = "_Class";

			if (view==null && viewId && viewId.lastIndexOf(postName)!=-1) {
				view = self.getElement(viewId.replace(postName, ""));
			}
			
			if (view) {
				var display = getComputedStyle(view).display;
		
				if (display=="block" || display=="flex") {
					return view;
				}
			}
		}

		return null;
	}

	self.getVisibleViews = function() {
		var viewIds = self.getViewIds();
		var views = [];
		
		for (var i=0;i<viewIds.length;i++) {
			var viewId = viewIds[i].replace(/[\#?\.?](.*)/, "$" + "1");
			var view = self.getElement(viewId);
			var postName = "_Class";

			if (view==null && viewId && viewId.lastIndexOf(postName)!=-1) {
				view = self.getElement(viewId.replace(postName, ""));
			}
			
			if (view) {
				var display = getComputedStyle(view).display;
				
				if (display=="none") {
					continue;
				}

				if (display=="block" || display=="flex") {
					views.push(view);
				}
			}
		}

		return views;
	}

	self.getStateNameByViewId = function(id) {
		var state = self.viewsDictionary[id];
		return state && state.stateName;
	}

	self.getMatchingViews = function(ids) {
		var views = self.addedViews.slice(0);
		var matchingViews = [];

		if (self.showByMediaQuery) {
			for (let index = 0; index < views.length; index++) {
				var viewId = views[index];
				var state = self.viewsDictionary[viewId];
				var rule = state && state.rule; 
				var matchResults = window.matchMedia(rule.conditionText);
				var view = self.views[viewId];
				
				if (matchResults.matches) {
					if (ids==true) {
						matchingViews.push(viewId);
					}
					else {
						matchingViews.push(view);
					}
				}
			}
		}

		return matchingViews;
	}

	self.ruleMatchesQuery = function(rule) {
		var result = window.matchMedia(rule.conditionText);
		return result.matches;
	}

	self.getViewsByStateName = function(stateName, matchQuery) {
		var views = self.addedViews.slice(0);
		var matchingViews = [];

		if (self.showByMediaQuery) {

			// find state name
			for (let index = 0; index < views.length; index++) {
				var viewId = views[index];
				var state = self.viewsDictionary[viewId];
				var rule = state.rule;
				var mediaRule = state.mediaRule;
				var view = self.views[viewId];
				var viewStateName = self.getStyleRuleValue(mediaRule, self.STATE_NAME, state);
				var stateFoundAtt = view.getAttribute(self.STATE_NAME)==state;
				var matchesResults = false;
				
				if (viewStateName==stateName) {
					if (matchQuery) {
						matchesResults = self.ruleMatchesQuery(rule);

						if (matchesResults) {
							matchingViews.push(view);
						}
					}
					else {
						matchingViews.push(view);
					}
				}
			}
		}

		return matchingViews;
	}

	self.getInitialView = function() {
		var viewId = self.getInitialViewId();
		viewId = viewId.replace(/[\#?\.?](.*)/, "$" + "1");
		var view = self.getElement(viewId);
		var postName = "_Class";

		if (view==null && viewId && viewId.lastIndexOf(postName)!=-1) {
			view = self.getElement(viewId.replace(postName, ""));
		}

		return view;
	}

	self.getViewIndex = function(view) {
		var viewIds = self.getViewIds();
		var id = view ? view.id : null;
		var index = id && viewIds ? viewIds.indexOf(id) : -1;

		return index;
	}

	self.syncronizeViewToURL = function() {
		var fragment = self.getHashFragment();

		if (self.showByMediaQuery) {
			var stateName = fragment;
			
			if (stateName==null || stateName=="") {
				var initialView = self.getInitialView();
				stateName = initialView ? self.getStateNameByViewId(initialView.id) : null;
			}
			
			self.showMediaQueryViewsByState(stateName);
			return;
		}

		var view = self.getViewById(fragment);
		var index = view ? self.getViewIndex(view) : 0;
		if (index==-1) index = 0;
		var currentView = self.hideViews(index);

		if (self.supportsPopState && currentView) {

			if (fragment==null) {
				window.history.replaceState({name:currentView.id}, null, "#"+ currentView.id);
			}
			else {
				window.history.pushState({name:currentView.id}, null, "#"+ currentView.id);
			}
		}
		
		self.setViewVariables(view);
		return view;
	}

	/**
	 * Set the currentView or currentOverlay properties and set the lastView or lastOverlay properties
	 */
	self.setViewVariables = function(view, overlay, parentView) {
		if (view) {
			if (self.currentView) {
				self.lastView = self.currentView;
			}
			self.currentView = view;
		}

		if (overlay) {
			if (self.currentOverlay) {
				self.lastOverlay = self.currentOverlay;
			}
			self.currentOverlay = overlay;
		}
	}

	self.getViewPreferenceBoolean = function(view, property, altValue) {
		var computedStyle = window.getComputedStyle(view);
		var value = computedStyle.getPropertyValue(property);
		var type = typeof value;
		
		if (value=="true" || (type=="string" && value.indexOf("true")!=-1)) {
			return true;
		}
		else if (value=="" && arguments.length==3) {
			return altValue;
		}

		return false;
	}

	self.getViewPreferenceValue = function(view, property, defaultValue) {
		var value = window.getComputedStyle(view).getPropertyValue(property);

		if (value===undefined) {
			return defaultValue;
		}
		
		value = value.replace(/^[\s\"]*/, "");
		value = value.replace(/[\s\"]*$/, "");
		value = value.replace(/^[\s"]*(.*?)[\s"]*$/, function (match, capture) { 
			return capture;
		});

		return value;
	}

	self.getStyleRuleValue = function(cssRule, property) {
		var value = cssRule ? cssRule.style.getPropertyValue(property) : null;

		if (value===undefined) {
			return null;
		}
		
		value = value.replace(/^[\s\"]*/, "");
		value = value.replace(/[\s\"]*$/, "");
		value = value.replace(/^[\s"]*(.*?)[\s"]*$/, function (match, capture) { 
			return capture;
		});

		return value;
	}

	/**
	 * Get the first defined value of property. Returns empty string if not defined
	 * @param {String} id id of element
	 * @param {String} property 
	 */
	self.getCSSPropertyValueForElement = function(id, property) {
		var styleSheets = document.styleSheets;
		var numOfStylesheets = styleSheets.length;
		var values = [];
		var selectorIDText = "#" + id;
		var selectorClassText = "." + id + "_Class";
		var value;

		for(var i=0;i<numOfStylesheets;i++) {
			var styleSheet = styleSheets[i];
			var cssRules = self.getStylesheetRules(styleSheet);
			var numOfCSSRules = cssRules.length;
			var cssRule;
			
			for (var j=0;j<numOfCSSRules;j++) {
				cssRule = cssRules[j];
				
				if (cssRule.media) {
					var mediaRules = cssRule.cssRules;
					var numOfMediaRules = mediaRules ? mediaRules.length : 0;
					
					for(var k=0;k<numOfMediaRules;k++) {
						var mediaRule = mediaRules[k];
						
						if (mediaRule.selectorText==selectorIDText || mediaRule.selectorText==selectorClassText) {
							
							if (mediaRule.style && mediaRule.style.getPropertyValue(property)!="") {
								value = mediaRule.style.getPropertyValue(property);
								values.push(value);
							}
						}
					}
				}
				else {

					if (cssRule.selectorText==selectorIDText || cssRule.selectorText==selectorClassText) {
						if (cssRule.style && cssRule.style.getPropertyValue(property)!="") {
							value = cssRule.style.getPropertyValue(property);
							values.push(value);
						}
					}
				}
			}
		}

		return values.pop();
	}

	self.getIsStyleDefined = function(id, property) {
		var value = self.getCSSPropertyValueForElement(id, property);
		return value!==undefined && value!="";
	}

	self.collectViews = function() {
		var viewIds = self.getViewIds();

		for (let index = 0; index < viewIds.length; index++) {
			const id = viewIds[index];
			const view = self.getElement(id);
			self.views[id] = view;
		}
		
		self.viewIds = viewIds;
	}

	self.collectOverlays = function() {
		var viewIds = self.getViewIds();
		var ids = [];

		for (let index = 0; index < viewIds.length; index++) {
			const id = viewIds[index];
			const view = self.getViewById(id);
			const isOverlay = view && self.isOverlay(view);
			
			if (isOverlay) {
				ids.push(id);
				self.overlays[id] = view;
			}
		}
		
		self.overlayIds = ids;
	}

	self.collectMediaQueries = function() {
		var viewIds = self.getViewIds();
		var styleSheet = self.getApplicationStylesheet();
		var cssRules = self.getStylesheetRules(styleSheet);
		var numOfCSSRules = cssRules ? cssRules.length : 0;
		var cssRule;
		var id = viewIds.length ? viewIds[0]: ""; // single view
		var selectorIDText = "#" + id;
		var selectorClassText = "." + id + "_Class";
		var viewsNotFound = viewIds.slice();
		var viewsFound = [];
		var selectorText = null;
		var property = self.prefix + "view-id";
		var stateName = self.prefix + "state";
		var stateValue = null;
		var view = null;
		
		for (var j=0;j<numOfCSSRules;j++) {
			cssRule = cssRules[j];
			
			if (cssRule.media) {
				var mediaRules = cssRule.cssRules;
				var numOfMediaRules = mediaRules ? mediaRules.length : 0;
				var mediaViewInfoFound = false;
				var mediaId = null;
				
				for(var k=0;k<numOfMediaRules;k++) {
					var mediaRule = mediaRules[k];

					selectorText = mediaRule.selectorText;
					
					if (selectorText==".mediaViewInfo" && mediaViewInfoFound==false) {

						mediaId = self.getStyleRuleValue(mediaRule, property);
						stateValue = self.getStyleRuleValue(mediaRule, stateName);

						selectorIDText = "#" + mediaId;
						selectorClassText = "." + mediaId + "_Class";
						view = self.getElement(mediaId);
						
						// prevent duplicates from load and domcontentloaded events
						if (self.addedViews.indexOf(mediaId)==-1) {
							self.addView(view, mediaId, cssRule, mediaRule, stateValue);
						}

						viewsFound.push(mediaId);

						if (viewsNotFound.indexOf(mediaId)!=-1) {
							viewsNotFound.splice(viewsNotFound.indexOf(mediaId));
						}

						mediaViewInfoFound = true;
					}

					if (selectorIDText==selectorText || selectorClassText==selectorText) {
						var styleObject = self.viewsDictionary[mediaId];
						if (styleObject) {
							styleObject.styleDeclaration = mediaRule;
						}
						break;
					}
				}
			}
			else {
				selectorText = cssRule.selectorText;
				
				if (selectorText==null) continue;

				selectorText = selectorText.replace(/[#|\s|*]?/g, "");

				if (viewIds.indexOf(selectorText)!=-1) {
					view = self.getElement(selectorText);
					self.addView(view, selectorText, cssRule, null, stateValue);

					if (viewsNotFound.indexOf(selectorText)!=-1) {
						viewsNotFound.splice(viewsNotFound.indexOf(selectorText));
					}

					break;
				}
			}
		}

		if (viewsNotFound.length) {
			console.log("Could not find the following views:" + viewsNotFound.join(",") + "");
			console.log("Views found:" + viewsFound.join(",") + "");
		}
	}

	/**
	 * Adds a view
	 * @param {HTMLElement} view view element
	 * @param {String} id id of view element
	 * @param {CSSRule} cssRule of view element
	 * @param {CSSMediaRule} mediaRule media rule of view element
	 * @param {String} stateName name of state if applicable
	 **/
	self.addView = function(view, viewId, cssRule, mediaRule, stateName) {
		var viewData = {};
		viewData.name = viewId;
		viewData.rule = cssRule;
		viewData.id = viewId;
		viewData.mediaRule = mediaRule;
		viewData.stateName = stateName;

		self.views.push(viewData);
		self.addedViews.push(viewId);
		self.viewsDictionary[viewId] = viewData;
		self.mediaQueryDictionary[viewId] = cssRule;
	}

	self.hasView = function(name) {

		if (self.addedViews.indexOf(name)!=-1) {
			return true;
		}
		return false;
	}

	/**
	 * Go to view by id. Views are added in addView()
	 * @param {String} id id of view in current
	 * @param {Boolean} maintainPreviousState if true then do not hide other views
	 * @param {String} parent id of parent view
	 **/
	self.goToView = function(id, maintainPreviousState, parent) {
		var state = self.viewsDictionary[id];

		if (state) {
			if (maintainPreviousState==false || maintainPreviousState==null) {
				self.hideViews();
			}
			self.enableMediaQuery(state.rule);
			self.updateViewLabel();
			self.updateURL();
		}
		else {
			var event = new Event(self.STATE_NOT_FOUND);
			self.stateName = id;
			window.dispatchEvent(event);
		}
	}

	/**
	 * Go to the view in the event targets CSS variable
	 **/
	self.goToTargetView = function(event) {
		var button = event.currentTarget;
		var buttonComputedStyles = getComputedStyle(button);
		var actionTargetValue = buttonComputedStyles.getPropertyValue(self.prefix+"action-target").trim();
		var animation = buttonComputedStyles.getPropertyValue(self.prefix+"animation").trim();
		var targetType = buttonComputedStyles.getPropertyValue(self.prefix+"action-type").trim();
		var targetView = self.application ? null : self.getElement(actionTargetValue);
		var targetState = targetView ? self.getStateNameByViewId(targetView.id) : null;
		var actionTargetStyles = targetView ? targetView.style : null;
		var state = self.viewsDictionary[actionTargetValue];
		
		// navigate to page
		if (self.application==false || targetType=="page") {
			document.location.href = "./" + actionTargetValue;
			return;
		}

		// if view is found
		if (targetView) {

			if (self.currentOverlay) {
				self.removeOverlay(false);
			}

			if (self.showByMediaQuery) {
				var stateName = targetState;
				
				if (stateName==null || stateName=="") {
					var initialView = self.getInitialView();
					stateName = initialView ? self.getStateNameByViewId(initialView.id) : null;
				}
				self.showMediaQueryViewsByState(stateName, event);
				return;
			}

			// add animation set in event target style declaration
			if (animation && self.supportAnimations) {
				self.crossFade(self.currentView, targetView, false, animation);
			}
			else {
				self.setViewVariables(self.currentView);
				self.hideViews();
				self.enableMediaQuery(state.rule);
				self.scaleViewIfNeeded(targetView);
				self.centerView(targetView);
				self.updateViewLabel();
				self.updateURL();
			}
		}
		else {
			var stateEvent = new Event(self.STATE_NOT_FOUND);
			self.stateName = name;
			window.dispatchEvent(stateEvent);
		}

		event.stopImmediatePropagation();
	}

	/**
	 * Cross fade between views
	 **/
	self.crossFade = function(from, to, update, animation) {
		var targetIndex = to.parentNode
		var fromIndex = Array.prototype.slice.call(from.parentElement.children).indexOf(from);
		var toIndex = Array.prototype.slice.call(to.parentElement.children).indexOf(to);

		if (from.parentNode==to.parentNode) {
			var reverse = self.getReverseAnimation(animation);
			var duration = self.getAnimationDuration(animation, true);

			// if target view is above (higher index)
			// then fade in target view 
			// and after fade in then hide previous view instantly
			if (fromIndex<toIndex) {
				self.setElementAnimation(from, null);
				self.setElementAnimation(to, null);
				self.showViewByMediaQuery(to);
				self.fadeIn(to, update, animation);

				setTimeout(function() {
					self.setElementAnimation(to, null);
					self.setElementAnimation(from, null);
					self.hideView(from);
					self.updateURL();
					self.setViewVariables(to);
					self.updateViewLabel();
				}, duration)
			}
			// if target view is on bottom
			// then show target view instantly 
			// and fade out current view
			else if (fromIndex>toIndex) {
				self.setElementAnimation(to, null);
				self.setElementAnimation(from, null);
				self.showViewByMediaQuery(to);
				self.fadeOut(from, update, reverse);

				setTimeout(function() {
					self.setElementAnimation(to, null);
					self.setElementAnimation(from, null);
					self.hideView(from);
					self.updateURL();
					self.setViewVariables(to);
				}, duration)
			}
		}
	}

	self.fadeIn = function(element, update, animation) {
		self.showViewByMediaQuery(element);

		if (update) {
			self.updateURL(element);

			element.addEventListener("animationend", function(event) {
				element.style.animation = null;
				self.setViewVariables(element);
				self.updateViewLabel();
				element.removeEventListener("animationend", arguments.callee);
			});
		}

		self.setElementAnimation(element, null);
		
		element.style.animation = animation;
	}

	self.fadeOutCurrentView = function(animation, update) {
		if (self.currentView) {
			self.fadeOut(self.currentView, update, animation);
		}
		if (self.currentOverlay) {
			self.fadeOut(self.currentOverlay, update, animation);
		}
	}

	self.fadeOut = function(element, update, animation) {
		if (update) {
			element.addEventListener("animationend", function(event) {
				element.style.animation = null;
				self.hideView(element);
				element.removeEventListener("animationend", arguments.callee);
			});
		}

		element.style.animationPlayState = "paused";
		element.style.animation = animation;
		element.style.animationPlayState = "running";
	}

	self.getReverseAnimation = function(animation) {
		if (animation && animation.indexOf("reverse")==-1) {
			animation += " reverse";
		}

		return animation;
	}

	/**
	 * Get duration in animation string
	 * @param {String} animation animation value
	 * @param {Boolean} inMilliseconds length in milliseconds if true
	 */
	self.getAnimationDuration = function(animation, inMilliseconds) {
		var duration = 0;
		var expression = /.+(\d\.\d)s.+/;

		if (animation && animation.match(expression)) {
			duration = parseFloat(animation.replace(expression, "$" + "1"));
			if (duration && inMilliseconds) duration = duration * 1000;
		}

		return duration;
	}

	self.setElementAnimation = function(element, animation, priority) {
		element.style.setProperty("animation", animation, "important");
	}

	self.getElement = function(id) {
		id = id ? id.trim() : id;
		var element = id ? document.getElementById(id) : null;

		return element;
	}

	self.getElementById = function(id) {
		id = id ? id.trim() : id;
		var element = id ? document.getElementById(id) : null;

		return element;
	}

	self.getElementByClass = function(className) {
		className = className ? className.trim() : className;
		var elements = document.getElementsByClassName(className);

		return elements.length ? elements[0] : null;
	}

	self.resizeHandler = function(event) {
		
		if (self.showByMediaQuery) {
			if (self.enableDeepLinking) {
				var stateName = self.getHashFragment();

				if (stateName==null || stateName=="") {
					var initialView = self.getInitialView();
					stateName = initialView ? self.getStateNameByViewId(initialView.id) : null;
				}
				self.showMediaQueryViewsByState(stateName, event);
			}
		}
		else {
			var visibleViews = self.getVisibleViews();

			for (let index = 0; index < visibleViews.length; index++) {	
				var view = visibleViews[index];
				self.scaleViewIfNeeded(view);
			}
		}

		window.dispatchEvent(new Event(self.APPLICATION_RESIZE));
	}

	self.scaleViewIfNeeded = function(view) {

		if (self.scaleViewsOnResize) {
			if (view==null) {
				view = self.getVisibleView();
			}

			var isViewScaled = view.getAttributeNS(null, self.SIZE_STATE_NAME)=="false" ? false : true;

			if (isViewScaled) {
				self.scaleViewToFit(view, true);
			}
			else {
				self.scaleViewToActualSize(view);
			}
		}
		else if (view) {
			self.centerView(view);
		}
	}

	self.centerView = function(view) {

		if (self.scaleViewsToFit) {
			self.scaleViewToFit(view, true);
		}
		else {
			self.scaleViewToActualSize(view);  // for centering support for now
		}
	}

	self.preventDoubleClick = function(event) {
		event.stopImmediatePropagation();
	}

	self.getHashFragment = function() {
		var value = window.location.hash ? window.location.hash.replace("#", "") : "";
		return value;
	}

	self.showBlockElement = function(view) {
		view.style.display = "block";
	}

	self.hideElement = function(view) {
		view.style.display = "none";
	}

	self.showStateFunction = null;

	self.showMediaQueryViewsByState = function(state, event) {
		// browser will hide and show by media query (small, medium, large)
		// but if multiple views exists at same size user may want specific view
		// if showStateFunction is defined that is called with state fragment and user can show or hide each media matching view by returning true or false
		// if showStateFunction is not defined and state is defined and view has a defined state that matches then show that and hide other matching views
		// if no state is defined show view 
		// an viewChanging event is dispatched before views are shown or hidden that can be prevented 

		// get all matched queries
		// if state name is specified then show that view and hide other views
		// if no state name is defined then show
		var matchedViews = self.getMatchingViews();
		var matchMediaQuery = true;
		var foundViews = self.getViewsByStateName(state, matchMediaQuery);
		var showViews = [];
		var hideViews = [];

		// loop views that match media query 
		for (let index = 0; index < matchedViews.length; index++) {
			var view = matchedViews[index];
			
			// let user determine visible view
			if (self.showStateFunction!=null) {
				if (self.showStateFunction(view, state)) {
					showViews.push(view);
				}
				else {
					hideViews.push(view);
				}
			}
			// state was defined so check if view matches state
			else if (foundViews.length) {

				if (foundViews.indexOf(view)!=-1) {
					showViews.push(view);
				}
				else {
					hideViews.push(view);
				}
			}
			// if no state names are defined show view (define unused state name to exclude)
			else if (state==null || state=="") {
				showViews.push(view);
			}
		}

		if (showViews.length) {
			var viewChangingEvent = new Event(self.VIEW_CHANGING);
			viewChangingEvent.showViews = showViews;
			viewChangingEvent.hideViews = hideViews;
			window.dispatchEvent(viewChangingEvent);

			if (viewChangingEvent.defaultPrevented==false) {
				for (var index = 0; index < hideViews.length; index++) {
					var view = hideViews[index];

					if (self.isOverlay(view)) {
						self.removeOverlay(view);
					}
					else {
						self.hideElement(view);
					}
				}

				for (var index = 0; index < showViews.length; index++) {
					var view = showViews[index];

					if (index==showViews.length-1) {
						self.clearDisplay(view);
						self.setViewOptions(view);
						self.setViewVariables(view);
						self.centerView(view);
						self.updateURLState(view, state);
					}
				}
			}

			var viewChangeEvent = new Event(self.VIEW_CHANGE);
			viewChangeEvent.showViews = showViews;
			viewChangeEvent.hideViews = hideViews;
			window.dispatchEvent(viewChangeEvent);
		}
		
	}

	self.clearDisplay = function(view) {
		view.style.setProperty("display", null);
	}

	self.hashChangeHandler = function(event) {
		var fragment = self.getHashFragment();
		var view = self.getViewById(fragment);

		if (self.showByMediaQuery) {
			var stateName = fragment;

			if (stateName==null || stateName=="") {
				var initialView = self.getInitialView();
				stateName = initialView ? self.getStateNameByViewId(initialView.id) : null;
			}
			self.showMediaQueryViewsByState(stateName);
		}
		else {
			if (view) {
				self.hideViews();
				self.showView(view);
				self.setViewVariables(view);
				self.updateViewLabel();
				
				window.dispatchEvent(new Event(self.VIEW_CHANGE));
			}
			else {
				window.dispatchEvent(new Event(self.VIEW_NOT_FOUND));
			}
		}
	}

	self.popStateHandler = function(event) {
		var state = event.state;
		var fragment = state ? state.name : window.location.hash;
		var view = self.getViewById(fragment);

		if (view) {
			self.hideViews();
			self.showView(view);
			self.updateViewLabel();
		}
		else {
			window.dispatchEvent(new Event(self.VIEW_NOT_FOUND));
		}
	}

	self.doubleClickHandler = function(event) {
		var view = self.getVisibleView();
		var scaleValue = view ? self.getViewScaleValue(view) : 1;
		var scaleNeededToFit = view ? self.getViewFitToViewportScale(view) : 1;
		var scaleNeededToFitWidth = view ? self.getViewFitToViewportWidthScale(view) : 1;
		var scaleNeededToFitHeight = view ? self.getViewFitToViewportHeightScale(view) : 1;
		var scaleToFitType = self.scaleToFitType;

		// Three scenarios
		// - scale to fit on double click
		// - set scale to actual size on double click
		// - switch between scale to fit and actual page size

		if (scaleToFitType=="width") {
			scaleNeededToFit = scaleNeededToFitWidth;
		}
		else if (scaleToFitType=="height") {
			scaleNeededToFit = scaleNeededToFitHeight;
		}

		// if scale and actual size enabled then switch between
		if (self.scaleToFitOnDoubleClick && self.actualSizeOnDoubleClick) {
			var isViewScaled = view.getAttributeNS(null, self.SIZE_STATE_NAME);
			var isScaled = false;
			
			// if scale is not 1 then view needs scaling
			if (scaleNeededToFit!=1) {

				// if current scale is at 1 it is at actual size
				// scale it to fit
				if (scaleValue==1) {
					self.scaleViewToFit(view);
					isScaled = true;
				}
				else {
					// scale is not at 1 so switch to actual size
					self.scaleViewToActualSize(view);
					isScaled = false;
				}
			}
			else {
				// view is smaller than viewport 
				// so scale to fit() is scale actual size
				// actual size and scaled size are the same
				// but call scale to fit to retain centering
				self.scaleViewToFit(view);
				isScaled = false;
			}
			
			view.setAttributeNS(null, self.SIZE_STATE_NAME, isScaled+"");
			isViewScaled = view.getAttributeNS(null, self.SIZE_STATE_NAME);
		}
		else if (self.scaleToFitOnDoubleClick) {
			self.scaleViewToFit(view);
		}
		else if (self.actualSizeOnDoubleClick) {
			self.scaleViewToActualSize(view);
		}

	}

	self.scaleViewToFit = function(view) {
		return self.setViewScaleValue(view, true);
	}

	self.scaleViewToActualSize = function(view) {
		self.setViewScaleValue(view, false, 1);
	}

	self.onloadHandler = function(event) {
		self.initialize();
	}

	self.setElementHTML = function(id, value) {
		var element = self.getElement(id);
		element.innerHTML = value;
	}

	self.getStackArray = function(error) {
		var value = "";
		
		if (error==null) {
		  try {
			 error = new Error("Stack");
		  }
		  catch (e) {
			 
		  }
		}
		
		if ("stack" in error) {
		  value = error.stack;
		  var methods = value.split(/\n/g);
	 
		  var newArray = methods ? methods.map(function (value, index, array) {
			 value = value.replace(/\@.*/,"");
			 return value;
		  }) : null;
	 
		  if (newArray && newArray[0].includes("getStackTrace")) {
			 newArray.shift();
		  }
		  if (newArray && newArray[0].includes("getStackArray")) {
			 newArray.shift();
		  }
		  if (newArray && newArray[0]=="") {
			 newArray.shift();
		  }
	 
			return newArray;
		}
		
		return null;
	}

	self.log = function(value) {
		console.log.apply(this, [value]);
	}
	
	// initialize on load
	// sometimes the body size is 0 so we call this now and again later
	window.addEventListener("load", self.onloadHandler);
	window.document.addEventListener("DOMContentLoaded", self.onloadHandler);
}

window.application = new Application();

	
</script>

	<%-- <%
		if (info != null) {
	%>
	<p><%=info.getEmail()%>님 환영합니다.
	</p>
	<%
		} else {
	%>
	<form action="popupmain.jsp">
		<!-- 로그인 메인 -->
		<li><input type="submit" value="로그인"></li>
	</form>
	<%
		}
	%>

	<button onclick="location='reviewBoard.jsp'">리뷰 전체보기</button>

 --%>




	<!-- <span id="seq"></span><br>
	<span id="name"></span><br>
	<span id="addr"></span><br>
	<span id="tel"></span><br>
	<span id="approach"></span><br>
	<span id="hdiff"></span><br>
	<span id="parking"></span><br>
	<span id="elev"></span><br>
	<span id="toilet"></span><br> -->

	<input type="hidden" name="testApproach" id="testApproach">
	<input type="hidden" name="testParking" id="testParking">
	<input type="hidden" name="testDiff" id="testDiff">
	<input type="hidden" name="testElev" id="testElev">
	<input type="hidden" name="testToilet" id="testToilet">
	<input type="hidden" name="chkind" id="chkind"> 
	<input type="hidden" name="chname" id="chname">
	


	<div id="main">
		<svg class="n_47">
		<rect id="n_47" rx="0" ry="0" x="0" y="0" width="1920" height="7500">
		</rect>
	</svg>
		<svg class="n_21">
		<rect id="n_21" rx="0" ry="0" x="0" y="0" width="1640" height="7500">
		</rect>
	</svg>
		<div id="METADATA_v">
			<span>{"config":{"STATE":"ACTIVE"},"type":"TabItem","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-26T01:37:31.088Z","nodeName":"Tab
				Item"}</span>
		</div>
		<div id="PLACEHOLDER_Tab_Item">
			<div id="METADATA_p">
				<span>{"config":{},"type":"Group","theme":"Base","nodeName":"[PLACEHOLDER]
					Tab
					Item","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-26T01:37:31.054Z"}</span>
			</div>
			<div id="Area">
				<div id="METADATA_r">
					<span>{"config":{},"type":"Group","theme":"Base","nodeName":"Area","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-26T01:37:31.049Z"}</span>
				</div>
				<svg class="Placement_Area">
				<rect id="Placement_Area" rx="0" ry="0" x="0" y="0" width="42"
						height="42">
				</rect>
			</svg>
				<svg class="Bar">
				<rect id="Bar" rx="1" ry="1" x="0" y="0" width="42" height="2">
				</rect>
			</svg>
			</div>
			<div id="Label">
				<span>Label</span>
			</div>
		</div>
		<div id="METADATA_v">
			<span>{"config":{"STATE":"ACTIVE"},"type":"TabItem","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-26T01:37:31.088Z","nodeName":"Tab
				Item"}</span>
		</div>
		<div id="METADATA_w">
			<span>{"config":{},"type":"Group","theme":"Base","nodeName":"Area","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-26T01:37:31.082Z"}</span>
		</div>
		<div id="n__3__1" class="______3___1">
			<svg class="n_34">
			<rect id="n_34" rx="0" ry="0" x="0" y="0" width="1102" height="213">
			</rect>
		</svg>
			<div id="n__1__1" class="______1___1" >
            <div id="Title_TAGH1" >
            <%if(info != null){ %>
               <span style="font-size:60px">서울특별시 장애인 편의시설 </span><br> 
               <span style="font-size:60px"> 정보제공을 위한 웹사이트입니다! </span>
               <%}else{ %>
               <span>안녕하세요!</span>
               <%} %>
            </div>
         </div>
		</div>
		<div id="METADATA_">
			<span>{"config":{},"type":"Group","theme":"Base","nodeName":"Sign
				In","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T00:42:52.204Z"}</span>
		</div>
		<div id="METADATA_ba">
			<span>{"config":{},"type":"Button","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T00:42:51.570Z","nodeName":"Button"}</span>
		</div>
		<div id="Icon_">
			<div id="METADATA_bb">
				<span>{"config":{"STATE":"DEFAULT"},"type":"Icon","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T00:42:51.535Z","nodeName":"Icon"}</span>
			</div>
			<svg class="Area_DISPLAY_ELEMENTSLabelICON">
			<rect id="Area_DISPLAY_ELEMENTSLabelICON" rx="0" ry="0" x="0" y="0"
					width="36" height="37">
			</rect>
		</svg>
			<div id="Icon">
				<svg class="Path" viewBox="1.29 2.499 31.92 27.84">
				<path id="Path"
						d="M 30.74912643432617 4.960124969482422 C 27.46912384033203 1.67829167842865 22.1478271484375 1.67829167842865 18.86782455444336 4.960124969482422 L 17.24981307983398 6.578136444091797 L 15.63180065155029 4.960124969482422 C 12.34996795654297 1.67829167842865 7.032334327697754 1.67829167842865 3.750500440597534 4.960124969482422 C 0.470499724149704 8.24012565612793 0.470499724149704 13.55959033966064 3.750500440597534 16.8395938873291 L 5.370345592498779 18.45760726928711 L 17.24981307983398 30.33890533447266 L 29.12928199768066 18.45760726928711 L 30.74912643432617 16.8395938873291 C 34.03096389770508 13.55959033966064 34.03096389770508 8.24012565612793 30.74912643432617 4.960124969482422 Z">
				</path>
			</svg>
			</div>
		</div>
		<div id="METADATA_bc">
			<span>{"config":{"STATE":"ACTIVE","DISPLAY_ELEMENTS":"Label"},"type":"Checkbox","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T00:42:51.901Z","nodeName":"Checkbox"}</span>
		</div>
		<div id="METADATA_bd">
			<span>{"config":{},"type":"Input","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T00:42:52.009Z","nodeName":"Input"}</span>
		</div>
		<div id="Icon__ba">
			<div id="METADATA_be">
				<span>{"config":{"STATE":"DEFAULT","ICON":"Feather/Search"},"type":"Icon","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T00:42:51.955Z","nodeName":"Icon"}</span>
			</div>
			<svg class="Area_DISPLAY_ELEMENTSDefaultIC">
			<rect id="Area_DISPLAY_ELEMENTSDefaultIC" rx="0" ry="0" x="0" y="0"
					width="37" height="35">
			</rect>
		</svg>
			<div id="Icon_bd">
				<svg class="Path_be">
				<ellipse id="Path_be" rx="12.216019630432129"
						ry="12.216019630432129" cx="12.216019630432129"
						cy="12.216019630432129">
				</ellipse>
			</svg>
				<svg class="Line" viewBox="0 0 6.642 6.642">
				<path id="Line" d="M 6.642460823059082 6.642460823059082 L 0 0">
				</path>
			</svg>
			</div>
		</div>
		<div id="Label_bg">
			<span>Label</span>
		</div>
		<div id="METADATA_bh">
			<span>{"config":{},"type":"Input","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T00:42:52.112Z","nodeName":"Input"}</span>
		</div>
		<div id="Icon__bi">
			<div id="METADATA_bj">
				<span>{"config":{"STATE":"DEFAULT","ICON":"Feather/Search"},"type":"Icon","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T00:42:52.059Z","nodeName":"Icon"}</span>
			</div>
			<svg class="Area_DISPLAY_ELEMENTSDefaultIC_bk">
			<rect id="Area_DISPLAY_ELEMENTSDefaultIC_bk" rx="0" ry="0" x="0"
					y="0" width="37" height="37">
			</rect>
		</svg>
			<div id="Icon_bl">
				<svg class="Path_bm">
				<ellipse id="Path_bm" rx="12.216019630432129"
						ry="12.216019630432129" cx="12.216019630432129"
						cy="12.216019630432129">
				</ellipse>
			</svg>
				<svg class="Line_bn" viewBox="0 0 6.642 6.642">
				<path id="Line_bn" d="M 6.642460823059082 6.642460823059082 L 0 0">
				</path>
			</svg>
			</div>
		</div>
		<div id="Label_bo">
			<span>Label</span>
		</div>
		<div id="n_28">
			<div id="Title_TAGH1_bq">
				<span>원하는 장소를 검색해보세요!</span>
			</div>
		</div>
		<div id="n_44">
			<div id="Title_TAGH1_bs">
				<span>검색하신 장소에 대한 후기입니다</span>
			</div>
		</div>
		<svg class="n_39">
		<rect id="n_39" rx="0" ry="0" x="0" y="0" width="1375" height="565">
		
		</rect>
	</svg>
		<div id="map" style="width: 1375px; height: 565px;"></div>

		<div id="METADATA_cd">
			<span>{"config":{},"type":"Button","theme":"Base","nodeName":"Button","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T07:01:21.763Z"}</span>
		</div>
		<div id="METADATA_bw">
			<span>{"config":{},"type":"List","theme":"Base","nodeName":"List","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T07:01:21.594Z"}</span>
		</div>
		<div id="PLACEHOLDER_List_Item">
			<div id="METADATA_by">
				<span>{"config":{},"type":"Group","theme":"Base","nodeName":"[PLACEHOLDER]
					List
					Item","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T07:01:21.230Z"}</span>
			</div>
			<svg class="Base">
			<rect id="Base" rx="0" ry="0" x="0" y="0" width="472" height="121">
			</rect>
		</svg>
			<svg class="Divider" viewBox="0 0 472 2">
			<path id="Divider" d="M 0 0 L 472 0">
			</path>
		</svg>
			<div id="Label_b">
				<span>Label</span>
			</div>
		</div>
		<div id="METADATA_b">
			<span>{"config":{},"type":"ListItem","theme":"Base","nodeName":"List
				Item","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T07:01:21.323Z"}</span>
		</div>
		<div id="METADATA_ca">
			<span>{"config":{},"type":"ListItem","theme":"Base","nodeName":"List
				Item","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T07:01:21.323Z"}</span>
		</div>
		<div id="METADATA_cb">
			<span>{"config":{},"type":"ListItem","theme":"Base","nodeName":"List
				Item","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T07:01:21.411Z"}</span>
		</div>
		<div id="METADATA_cc">
			<span>{"config":{},"type":"ListItem","theme":"Base","nodeName":"List
				Item","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T07:01:21.502Z"}</span>
		</div>
		<div id="METADATA_cd">
			<span>{"config":{},"type":"Button","theme":"Base","nodeName":"Button","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T07:01:21.763Z"}</span>
		</div>
		<div id="METADATA_ce">
			<span>{"config":{},"type":"Button","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T07:36:26.435Z","nodeName":"Button"}</span>
		</div>
		<div id="Icon__b">
			<div id="METADATA_cf">
				<span>{"config":{"STATE":"DEFAULT"},"type":"Icon","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T07:36:26.433Z","nodeName":"Icon"}</span>
			</div>
			<svg class="Area_DISPLAY_ELEMENTSLabelICON_ca">
			<rect id="Area_DISPLAY_ELEMENTSLabelICON_ca" rx="0" ry="0" x="0"
					y="0" width="24" height="24">
			</rect>
		</svg>
			<div id="Icon_cb">
				<svg class="Path_cc" viewBox="1.29 2.499 20.914 18.241">
				<path id="Path_cc"
						d="M 20.59171485900879 4.111436367034912 C 18.44266510009766 1.961187720298767 14.95616626739502 1.961187720298767 12.8071174621582 4.111436367034912 L 11.74699974060059 5.171553134918213 L 10.68688297271729 4.111436367034912 C 8.53663444519043 1.961187720298767 5.052534580230713 1.961187720298767 2.902286052703857 4.111436367034912 C 0.7532379031181335 6.26048469543457 0.7532379031181335 9.745784759521484 2.902286052703857 11.89483261108398 L 3.963603496551514 12.9549503326416 L 11.74699974060059 20.73954582214355 L 19.5303955078125 12.9549503326416 L 20.59171485900879 11.89483261108398 C 22.74196434020996 9.745784759521484 22.74196434020996 6.26048469543457 20.59171485900879 4.111436367034912 Z">
				</path>
			</svg>
			</div>
		</div>
		<div id="METADATA_cg">
			<span>{"config":{},"type":"Group","theme":"Base","nodeName":"How
				We
				Work","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T06:46:17.590Z"}</span>
		</div>
		<div id="n_74">
			<div id="n_41">
				<div id="Title_TAGH1_cg">
					<span id="spanName">검색하신 장소에 대한</span> <br /> <span>편의시설
						정보입니다.</span>

				</div>
			</div>

			<div id="n_42">
				<div id="Title_TAGH1_ci">
					<span id="spanAddr"></span>
				</div>
			</div>
			<div id="n_43">
				<div id="Title_TAGH1_ck">
					<span id="spanTel"></span>
				</div>
			</div>
			<div id="Video_">
				<div id="METADATA_cm">
					<span>{"config":{"ASSET":"panel","ASSET_ID":"909e17b7b7e4781fce5ca499e604897f"},"type":"Video","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T06:46:17.221Z","nodeName":"Video"}</span>
				</div>
				<img id="Placement_Area_ASSETpanelSTATE"
					src="https://hyeony.com/storage/images/no_image.png"
					>

			</div>
			<div id="Circle_Button_">
				<div id="METADATA_cp">
					<span>{"config":{"SIZE":"LARGE"},"type":"CircleButton","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T07:39:17.301Z","nodeName":"Circle
						Button"}</span>
				</div>
				
				<div id="Icon__cr">
					<div id="METADATA_cs">
						<span>{"config":{"STYLE":"STYLE2","STATE":"DEFAULT","SIZE":"LARGE","ICON":"feather/camera"},"type":"Icon","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T07:39:17.257Z","nodeName":"Icon"}</span>
					</div>
					
					
				</div>
			</div>
		</div>
		<svg class="n_1_cx" viewBox="0 0 718 1">
		<path id="n_1_cx" d="M 0 0 L 718 0">
		</path>
	</svg>
		<div id="n__19__1" class="______19___1">
			<input type="hidden" name="chseq" id="chseq"> 
			<select name="kind" id="kind" style="width:410px;height:70px;font-size:40px;background-color:ivory">
            <option value="" disabled selected>분야를 선택하세요</option>
            <option value="편의시설">편의시설</option>
            <option value="음식점">음식점</option>
            <option value="숙박시설">숙박시설</option>

         </select>

			</svg>
		</div>
		<div id="n__20__1" class="______20___1">
			<select name="gu" id="gu" style="width:410px;height:70px;font-size:40px;background-color:ivory">
            <option value="" disabled selected>구를 선택하세요</option>
            <%
               for (int i = 0; i < gu_list.size(); i++) {
            %>
            <option value="<%=gu_list.get(i).getAddr()%>"><%=gu_list.get(i).getAddr()%></option>
            <%
               }
            %>
         </select>

			</svg>
		</div>
		<div id="Button">
			<div id="METADATA_c">
				<span>{"config":{},"type":"Button","theme":"Base","nodeName":"Button","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T07:29:20.071Z"}</span>
			</div>
			<svg class="Area_c" viewBox="0 0 204.823 121">
			<path id="Area_c"
					d="M 0 0 L 204.822509765625 0 L 204.822509765625 121 L 0 121 L 0 0 Z"
					onclick="test()">
			</path>
			</svg>
			<div id="Label_c">
					<span>검색</span>
			</div>
			<div id="Icon_c">
				<div id="METADATA_da">
					<span>{"config":{},"type":"Icon","theme":"Base","nodeName":"Icon","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T07:29:20.068Z"}</span>
				</div>
				<svg class="Area_da">
				<rect id="Area_da" rx="0" ry="0" x="0" y="0" width="51" height="51">
				</rect>
			</svg>
				<div id="Icon_da">
					<svg class="Path_da" viewBox="1.29 2.499 43.912 38.3">
					<path id="Path_da"
							d="M 41.81667709350586 5.884859085083008 C 37.30438232421875 1.370046854019165 29.98388481140137 1.370046854019165 25.47159385681152 5.884859085083008 L 23.24569702148438 8.11075496673584 L 21.01980018615723 5.884859085083008 C 16.50498962402344 1.370046854019165 9.189530372619629 1.370046854019165 4.674718856811523 5.884859085083008 C 0.1624271869659424 10.39715003967285 0.1624271869659424 17.71512985229492 4.674718856811523 22.22742080688477 L 6.903135299682617 24.45331764221191 L 23.24569702148438 40.79839706420898 L 39.58826065063477 24.45331764221191 L 41.81667709350586 22.22742080688477 C 46.33148956298828 17.71512985229492 46.33148956298828 10.39715003967285 41.81667709350586 5.884859085083008 Z">
					</path>
				</svg>
				</div>
			</div>
		</div>
		<div id="METADATA_dc">
			<span>{"config":{},"type":"Group","theme":"Base","nodeName":"Features","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T08:08:07.252Z"}</span>
		</div>
		<div id="METADATA_dc">
			<span>{"config":{},"type":"Group","theme":"Base","nodeName":"Features","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T08:08:07.252Z"}</span>
		</div>
		<div id="Lorem_ipsum_STYLESTYLE2TAGUI_L">
			<span>편의시설<br />유무
			</span>
		</div>
		<div id="METADATA_de">
			<span>{"config":{},"type":"Group","theme":"Base","nodeName":"Basic","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T08:08:11.453Z"}</span>
		</div>
		<div id="Title_STYLESTYLE2TAGH5">
			<span>주출입구<br />접근로
			</span>
		</div>

		<div id="Icon__dg">
			<div id="METADATA_dh">
				<span>{"config":{"STYLE":"STYLE2","ICON":"feather/check"},"type":"Icon","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T08:08:09.116Z","nodeName":"Icon"}</span>
			</div>
			<svg class="Area_ICONfeathercheckSIZEMEDIU">
			<rect id="Area_ICONfeathercheckSIZEMEDIU" rx="0" ry="0" x="0" y="0"
					width="39" height="39">
			</rect>
		</svg>
			<div id="Icon_dj">
				<svg class="Path_dk" viewBox="3.333 5 25.609 17.606">
				<path id="Path_dk"
						d="M 28.94214630126953 5.000000476837158 L 11.33609962463379 22.60604858398438 L 3.332999706268311 14.602952003479">
				</path>
			</svg>
			</div>
		</div>
		<div id="METADATA_dl">
			<span>{"config":{},"type":"Group","theme":"Base","nodeName":"Premium","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T08:08:13.696Z"}</span>
		</div>

		<div id="Icon__dm">
			<div id="METADATA_dn">
				<span>{"config":{"ICON":"feather/check"},"type":"Icon","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T08:08:11.827Z","nodeName":"Icon"}</span>
			</div>
			<svg class="Area_ICONfeathercheckSIZEMEDIU_do">
			<rect id="Area_ICONfeathercheckSIZEMEDIU_do" rx="0" ry="0" x="0"
					y="0" width="38" height="39">
			</rect>
		</svg>
			<div id="Icon_dp">
				<svg class="Path_dq" viewBox="3.333 5 25.609 17.606">
				<path id="Path_dq"
						d="M 28.94214630126953 5.000000476837158 L 11.33609962463379 22.60604858398438 L 3.332999706268311 14.602952003479">
				</path>
			</svg>
			</div>
		</div>
		<div id="Title_TAGH5">
			<span>장애인전용<br />주차구역
			</span>
		</div>
		<div id="METADATA_ds">
			<span>{"config":{},"type":"Group","theme":"Base","nodeName":"Business","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T08:08:15.269Z"}</span>
		</div>
		<div id="Icon__dt">
			<div id="METADATA_du">
				<span>{"config":{"STYLE":"STYLE2","ICON":"feather/check"},"type":"Icon","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T08:08:14.078Z","nodeName":"Icon"}</span>
			</div>
			<svg class="Area_ICONfeathercheckSIZEMEDIU_dv">
			<rect id="Area_ICONfeathercheckSIZEMEDIU_dv" rx="0" ry="0" x="0"
					y="0" width="39" height="39">
			</rect>
		</svg>
			<div id="Icon_dw">
				<svg class="Path_dx" viewBox="3.333 5 25.609 17.606">
				<path id="Path_dx"
						d="M 28.94214630126953 5.000000476837158 L 11.33609962463379 22.60604858398438 L 3.332999706268311 14.602952003479">
				</path>
			</svg>
			</div>
		</div>
		<div id="Title_STYLESTYLE2TAGH5_dy">
			<span>주출입구높이<br />차이제거
			</span>
		</div>
		<div id="METADATA_dz">
			<span>{"config":{},"type":"Group","theme":"Base","nodeName":"Enterprise","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T08:08:16.212Z"}</span>
		</div>
		<div id="Icon__d">
			<div id="METADATA_d">
				<span>{"config":{"STYLE":"STYLE2","ICON":"feather/check"},"type":"Icon","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T08:08:15.468Z","nodeName":"Icon"}</span>
			</div>
			<svg class="Area_ICONfeathercheckSIZEMEDIU_d">
			<rect id="Area_ICONfeathercheckSIZEMEDIU_d" rx="0" ry="0" x="0" y="0"
					width="37" height="39">
			</rect>
		</svg>
			<div id="Icon_d">
				<svg class="Path_d" viewBox="3.333 5 25.609 17.606">
				<path id="Path_d"
						d="M 28.94214630126953 5.000000476837158 L 11.33609962463379 22.60604858398438 L 3.332999706268311 14.602952003479">
				</path>
			</svg>
			</div>
		</div>
		<div id="Title_STYLESTYLE2TAGH5_d">
			<span>장애인<br />승강기
			</span>
		</div>
		<div id="Icon__ea">
			<div id="METADATA_ea">
				<span>{"config":{"STYLE":"STYLE2","ICON":"feather/check"},"type":"Icon","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T08:08:15.468Z","nodeName":"Icon"}</span>
			</div>
			<svg class="Area_ICONfeathercheckSIZEMEDIU_ea">
			<rect id="Area_ICONfeathercheckSIZEMEDIU_ea" rx="0" ry="0" x="0"
					y="0" width="38" height="39">
			</rect>
		</svg>
			<div id="Icon_ea">
				<svg class="Path_ea" viewBox="3.333 5 25.609 17.606">
				<path id="Path_ea"
						d="M 28.94214630126953 5.000000476837158 L 11.33609962463379 22.60604858398438 L 3.332999706268311 14.602952003479">
				</path>
			</svg>
			</div>
		</div>
		<div id="Title_STYLESTYLE2TAGH5_eb">
			<span>장애인<br />화장실
			</span>
		</div>
		<div id="n______">
			<span>검색하신 시설의 장애인 편의시설 설치 유무를 알려드립니다.</span>
		</div>
		<svg class="n_3" viewBox="0 0 1394 1">
		<path id="n_3" d="M 0 0 L 1394 0">
		</path>
	</svg>
		<svg class="n_12" viewBox="0 0 1394 1">
		<path id="n_12" d="M 0 0 L 1394 0">
		</path>
	</svg>
		<svg class="n_8" viewBox="0 0 1394 1">
		<path id="n_8" d="M 0 0 L 1394 0">
		</path>
	</svg>
		<svg class="n_10" viewBox="0 0 1394 1">
		<path id="n_10" d="M 0 0 L 1394 0">
		</path>
	</svg>
		<svg class="n_6" viewBox="0 0 1394 1">
		<path id="n_6" d="M 0 0 L 1394 0">
		</path>
	</svg>
		<svg class="n_4" viewBox="0 0 1370 1">
		<path id="n_4" d="M 0 0 L 1370 0">
		</path>
	</svg>
		<svg class="n_5" viewBox="0 0 1 205">
		<path id="n_5" d="M 0 0 L 0 205">
		</path>
	</svg>
	<%if(info==null){ %>
		<div id="n____">
			<span>다른 사람들의 후기를 보고싶다면 로그인해주세요</span>
		</div>
		<div onClick="location.href='signin.jsp'" id="n_136">
			<svg class="Area_DISPLAY_ELEMENTSLabelSIZE">
			<rect id="Area_DISPLAY_ELEMENTSLabelSIZE" rx="0" ry="0" x="0" y="0"
					width="426.091" height="73.101">
			</rect>
		</svg>
			<div id="Label_en">
				<span>로그인</span>
			</div>
		</div>
		<%} %>
		<div id="METADATA_eo">
			<span>{"config":{},"type":"Group","theme":"Base","nodeName":"Posts","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-02-03T02:58:15.849Z"}</span>
		</div>
		<svg class="Background_STYLESTYLE2">
		<rect id="Background_STYLESTYLE2" rx="0" ry="0" x="0" y="0"
				width="1366" height="1388">
		</rect>
	</svg>
		<div id="n_75">
			<svg class="Area_DISPLAY_ELEMENTSLabelSIZE_er" viewBox="0 0 172 57">
			<path id="Area_DISPLAY_ELEMENTSLabelSIZE_er"
					d="M 0 0 L 172 0 L 172 57 L 0 57 L 0 0 Z"
					onclick="reviewInsert()">
			</path>
			</svg>
			<div id="Label_es">
				<span>후기등록</span>
			</div>
		</div>
		
		<div id="n_49">
			<div id="Title_TAGH1_eu">
				<span>방문한 장소에 대한 이용 후기를 남겨주세요!</span>
			</div>
		</div>
		<svg class="n_2" viewBox="0 0 909 1">
		<path id="n_2" d="M 0 0 L 909 0">
		</path>
	</svg>
		<div id="n_105">
			
			<!-- Q1 1점 -->
			<div >
				<input type="Radio" id="Radio" name="q1" value="1">
			</div>
			<!-- Q1 2점 -->
			<div>
			<input type="radio"  id="Radio_fh" name="q1" value="2">
				
			</div>
			<!-- Q1 3점 -->
			<div>
			<input type="radio" id="Radio_gd" name="q1" value="3">
				
			</div>
			<!-- Q1 4점  -->
			<div>
			<input type="radio" id="Radio_gb" name="q1" value="4">
				
			</div>
			<!-- Q1 5점 -->
			<div>
			<input type="radio" id="Radio_ha" name="q1" value="5">
				
			</div>
			<!-- Q2 1점 -->
			<div>
			<input type="radio" id="Radio_fl" name="q2" value="1">
				
			</div>
			<!-- Q2 2점 -->
			<div>
			<input type="radio" id="Radio_gh" name="q2" value="2">
				
			</div>
			<!-- Q2 3점 -->
			<div >
			<input type="radio" id="Radio_e" name="q2" value="3">
				
			</div>
			<!-- Q2 4점 -->
			<div>
			<input type="radio" id="Radio_fp" name="q2" value="4">
				
			</div>
			<!-- Q2 5점 -->
			<div>
			<input type="radio" id="Radio_gl" name="q2" value="5">
				
			</div>
			<!-- Q3 1점 -->
			<div>
			<input type="radio" id="Radio_ft" name="q3" value="1">
				
			</div>
			<!-- Q3 2점 -->
			<div>
			<input type="radio" id="Radio_gp" name="q3" value="2">
				
			</div>
			<!-- Q3 3점 -->
			<div>
			<input type="radio" id="Radio_f" name="q3" value="3">
				
			</div>
			<!-- Q3 4점 -->
			<div>
			<input type="radio" id="Radio_gx" name="q3" value="4">
				
			</div>
			<!-- Q3 5점 -->
			<div>
			<input type="radio" id="Radio_fa" name="q3" value="5">
				
			</div>
			<!-- Q4 1점 -->
			<div>
			<input type="radio" id="Radio_fx" name="q4" value="1">
				
			</div>
			<!-- Q4 2점 -->
			<div>
			<input type="radio" id="Radio_gt" name="q4" value="2">
				
			</div>
			<!-- Q4 3점 -->
			<div>
			<input type="radio" id="Radio_ga" name="q4" value="3">
				
			</div>
			<!-- Q4 4점 -->
			<div>
			<input type="radio" id="Radio_g" name="q4" value="4">
				
			</div>
			<!-- Q4 5점 -->
			<div>
			<input type="radio"  id="Radio_fc" name="q4" value="5">
				
			</div>
			
			<!-- Q5 1점 -->
			<div>
			<input type="radio" id="Radio5_1" name="q5" value="1">
				
			</div>
			<!-- Q5 2점 -->
			<div>
			<input type="radio" id="Radio5_2" name="q5" value="2">
				
			</div>
			<!-- Q5 3점 -->
			<div>
			<input type="radio" id="Radio5_3" name="q5" value="3">
				
			</div>
			<!-- Q5 4점 -->
			<div>
			<input type="radio" id="Radio5_4" name="q5" value="4">
				
			</div>
			<!-- Q5 5점 -->
			<div>
			<input type="radio"  id="Radio5_5" name="q5" value="5">
				
			</div>
			
			
			
			
			
			
			
			
			
			
			
			
			<div id="n_52">
				<div id="Title_TAGH1_ha">
					<span>주출입구 접근로 만족</span>
				</div>
			</div>
			<div id="n_56">
				<div id="Title_TAGH1_hc">
					<span>1점</span>
				</div>
			</div>
			<div id="n_57">
				<div id="Title_TAGH1_he">
					<span>2점</span>
				</div>
			</div>
			<div id="n_58">
				<div id="Title_TAGH1_hg">
					<span>3점</span>
				</div>
			</div>
			<div id="n_59">
				<div id="Title_TAGH1_hi">
					<span>4점</span>
				</div>
			</div>
			<div id="n_60">
				<div id="Title_TAGH1_hk">
					<span>5점</span>
				</div>
			</div>
			<div id="n_53">
				<div id="Title_TAGH1_hm">
					<span>장애인전용 주차구역 만족</span>
				</div>
			</div>
			<div id="n_54">
				<div id="Title_TAGH1_ho">
					<span>주출입구 높이차이 만족</span>
				</div>
			</div>
			<div id="n_55">
				<div id="Title_TAGH1_hq">
					<span>장애인 승강기 만족</span>
				</div>
			</div>
			<div id="n_141">
	            <div id="Title_TAGH1_ig">
	               <span>장애인 화장실 만족</span>
	            </div>
         	</div>
		</div>
		<div id="n__1">
			<div id="n_89">
				<svg class="Background_STYLESTYLE2_ht">
				<rect id="Background_STYLESTYLE2_ht" rx="0" ry="0" x="0" y="0"
						width="1366" height="1063">
				</rect>
				</svg>
				<div>
					<span>TEST</span>
				</div>
				<div id="Description">
					<span>Lorem ipsum dolor sit amet, consetetur sadipscing
						elitr, sed diam nonumy eirmod tempor <br />invidunt ut labore et
						dolore magna aliquyam erat, sed diam voluptua. At vero
					</span>
				</div>
				<div id="Label_hv">
					<span></span><br />
				</div>
				
				<div id="Label_hw">
					<span></span>
				</div>
				<div id="Image_">
					<div id="METADATA_hy">
						<span>{"config":{"SIZE":"Thumbnail","ASSET":"small","ASSET_ID":"35cc479761601be986b3f8891766eec2"},"type":"Image","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-02-03T05:41:56.951Z","nodeName":"Image"}</span>
					</div>
					<img id="Placement_Area_ASSETsmallSIZET"
						src="Placement_Area_ASSETsmallSIZET.png"
						srcset="Placement_Area_ASSETsmallSIZET.png 1x, Placement_Area_ASSETsmallSIZET@2x.png 2x">

				</div>
				

			</div>
			<%if(info == null){ %>
			<div id="n_88" style="filter:blur(5px)">
				<svg class="Background_STYLESTYLE2_id">
				<rect id="Background_STYLESTYLE2_id" rx="0" ry="0" x="0" y="0"
						width="1366" height="1063">
				</rect>
				</svg>
				<table width='1000px' id="reviewTable">
				<thread>
				<tr>
					<th class="Title_TAGH1_b1"><strong>ID</strong></th>
					<th class="Title_TAGH1_b1"><strong>날짜</strong></th>
					<th class="Title_TAGH1_b1"><strong>남긴 말</strong></th>
					
				</tr>
				</thread>
				<tbody id="chTable">
				</tbody>
			</table>
				


			</div>
			<%}else{ %>
				<div id="n_88">
				<svg class="Background_STYLESTYLE2_id">
				<rect id="Background_STYLESTYLE2_id" rx="0" ry="0" x="0" y="0"
						width="1366" height="1063">
				</rect>
				</svg>
				<table width='1000px' id="reviewTable">
				<thread>
				<tr>
					<th class="Title_TAGH1_b1"><strong>ID</strong></th>
					<th class="Title_TAGH1_b1"><strong>날짜</strong></th>
					<th class="Title_TAGH1_b1"><strong>남긴 말</strong></th>
					
				</tr>
				</thread>
				<tbody id="chTable">
				</tbody>
			</table>
				


			</div>
			<%} %>
		</div>
		<div id="n_83">
			<svg class="Background_STYLESTYLE2_ix">
			<rect id="Background_STYLESTYLE2_ix" rx="0" ry="0" x="0" y="0"
					width="1640" height="96">
			</rect>
		</svg>
			<div id="Terms_of_Service_STYLESTYLE2TA">
				<span>Terms of Service</span>
			</div>
			<div id="Privacy_Policy_STYLESTYLE2TAGU">
				<span>Privacy Policy</span>
			</div>
			<div id="Copyright_STYLESTYLE2TAGUI_S">
				<span>© 2022 Light House. All Rights Reserved.</span>
			</div>
		</div>
		
		<div id="n__">
			<span><textarea cols="50" rows="10" name="text" id="text" placeholder="남길 말을 적어주세요" style="width: 1287px; height: 376px;" ></textarea></span>
		</div>
		
		<div id="Lorem_ipsum_STYLESTYLE2TAGUI_L_i">
			<span>방문자 평점</span>
		</div>
		<div id="Lorem_ipsum_STYLESTYLE2TAGUI_L_ja">
			<span>주출입구 접근로 만족도</span>
		</div>
		<div id="Lorem_ipsum_STYLESTYLE2TAGUI_L_jb">
			<span>------------------------------------</span>
		</div>
		<div id="Lorem_ipsum_STYLESTYLE2TAGUI_L_jc">
			<span>------------------------------------</span>
		</div>
		<div id="Lorem_ipsum_STYLESTYLE2TAGUI_L_jd">
			<span>------------------------------------</span>
		</div>
		<div id="Lorem_ipsum_STYLESTYLE2TAGUI_L_je">
			<span>------------------------------------</span>
		</div>
		<div id="Lorem_ipsum_STYLESTYLE2TAGUI_L_jf">
			<span>------------------------------------</span>
		</div>
		<div id="Lorem_ipsum_STYLESTYLE2TAGUI_L_jg">
			<span id="avgs1"></span>
		</div>
		<div id="Lorem_ipsum_STYLESTYLE2TAGUI_L_jh">
			<span id="avgs2"></span>
		</div>
		<div id="Lorem_ipsum_STYLESTYLE2TAGUI_L_ji">
			<span id="avgs3"></span>
		</div>
		<div id="Lorem_ipsum_STYLESTYLE2TAGUI_L_jj">
			<span id="avgs4"></span>
		</div>
		<div id="Lorem_ipsum_STYLESTYLE2TAGUI_L_jk">
			<span id="avgs5"></span>
		</div>
		<div id="Lorem_ipsum_STYLESTYLE2TAGUI_L_jl">
			<span>장애인전용 주차구역 만족도</span>
		</div>
		<div id="Lorem_ipsum_STYLESTYLE2TAGUI_L_jm">
			<span>주출입구 높이 차이제거 만족도</span>
		</div>
		<div id="Lorem_ipsum_STYLESTYLE2TAGUI_L_jn">
			<span>장애인용 승강기 만족도</span>
		</div>
		<div id="Lorem_ipsum_STYLESTYLE2TAGUI_L_jo">
			<span>장애인 화장실 만족도</span>
		</div>
		<div id="n_116">
			<div id="n_">
				<span>* 이용방법</span>
			</div>
			<div id="n___">
				<span>1. 시설분야 선택</span>
			</div>
			<div id="n_____jm">
				<span>2. 서울시 자치구 선택</span>
			</div>
			<div id="n_____jn">
				<span>3. 검색 버튼 클릭</span>
			</div>
			<div id="n________">
				<span>3. 지도에 표시된 핀을 클릭후 아래 상세정보 얻기!</span>
			</div>
			<svg class="n_4_jp" viewBox="0 0 825.73 1">
			<path id="n_4_jp" d="M 0 0 L 825.7295532226562 0">
			</path>
		</svg>
		</div>
		<img id="KakaoTalk_20220204_120835596"
			src="KakaoTalk_20220204_120835596.png"
			srcset="KakaoTalk_20220204_120835596.png 1x, KakaoTalk_20220204_120835596@2x.png 2x">

		<div id="METADATA_jr">
			<span>{"config":{"ICON":"feather/chevrons-up"},"type":"Icon","nodeName":"Icon","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-02-04T03:31:07.124Z"}</span>
		</div>
		<svg class="n_61">
		<rect id="n_61" rx="0" ry="0" x="0" y="0" width="140" height="192">
		</rect>
	</svg>
		<div id="METADATA_jt">
			<span>{"config":{},"type":"List","theme":"Base","nodeName":"List","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-02-04T02:44:24.559Z"}</span>
		</div>
		<svg class="Area_ju">
		<rect id="Area_ju" rx="0" ry="0" x="0" y="0" width="144" height="144">
		</rect>
	</svg>
		<div id="PLACEHOLDER_List_Item_jv">
			<div id="METADATA_jw">
				<span>{"config":{},"type":"Group","theme":"Base","nodeName":"[PLACEHOLDER]
					List
					Item","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-02-04T02:44:24.540Z"}</span>
			</div>
			<svg class="Base_jx">
			<rect id="Base_jx" rx="0" ry="0" x="0" y="0" width="140" height="47">
			</rect>
		</svg>
			<svg class="Divider_jy" viewBox="0 0 140 2">
			<path id="Divider_jy" d="M 0 0 L 140 0">
			</path>
		</svg>
			<div id="Label_jz">
				<span>Label</span>
			</div>
		</div>
		<div id="List_Item">
			<div id="METADATA_j">
				<span>{"config":{},"type":"ListItem","theme":"Base","nodeName":"List
					Item","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-02-04T02:44:24.546Z"}</span>
			</div>
			<svg class="Base_j">
			<rect id="Base_j" rx="0" ry="0" x="0" y="0" width="140" height="46">
			</rect>
		</svg>
			<svg class="Divider_j" viewBox="0 0 140 2">
			<path id="Divider_j" d="M 0 0 L 140 0">
			</path>
		</svg>
			  <div id="Label_j">
            <button onClick="zoomIn();" style="font-size: 18pt;background-color : #DCDCDC;">확대
               (+)</button>
         </div>
      </div>
      <div id="List_Item_j">
         <div id="METADATA_ka">
            <span>{"config":{},"type":"ListItem","theme":"Base","nodeName":"List
               Item","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-02-04T02:44:24.546Z"}</span>
         </div>
         <svg class="Base_ka">
         <rect id="Base_ka" rx="0" ry="0" x="0" y="0" width="140" height="47">
         </rect>
      </svg>
         <svg class="Divider_ka" viewBox="0 0 140 2">
         <path id="Divider_ka" d="M 0 0 L 140 0">
         </path>
      </svg>
         <div id="Label_ka">
            <button onClick="zoomOut();" style="font-size: 18pt; background-color : #DCDCDC;">축소
               (-)</button>
         </div>
      </div>
      <script type="text/javascript">
            var nowZoom = 100;

               function zoomOut() {
                 // 화면크기축소
                 nowZoom = nowZoom - 10;
                 if (nowZoom <= 70) nowZoom = 70; // 화면크기 최대 축소율 70%
                 zooms();
               }

               function zoomIn() {
                 // 화면크기확대
                 nowZoom = nowZoom + 10;
                 if (nowZoom >= 200) nowZoom = 200; // 화면크기 최대 확대율 200%
                 zooms();
               }
               
               function zooms() {
                   document.body.style.zoom = nowZoom + "%";
                   if (nowZoom == 70) {
                     alert("더 이상 축소할 수 없습니다."); // 화면 축소율이 70% 이하일 경우 경고창
                   }
                   if (nowZoom == 200) {
                     alert("더 이상 확대할 수 없습니다."); // 화면 확대율이 200% 이상일 경우 경고창
                   }
                 }
            </script>
      <div id="List_Item_ka">
         <div id="METADATA_kb">
            <span>{"config":{},"type":"ListItem","theme":"Base","nodeName":"List
               Item","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-02-04T02:44:24.551Z"}</span>
         </div>
         <svg class="Base_kc">
         <rect id="Base_kc" rx="0" ry="0" x="0" y="0" width="140" height="48">
         </rect>
      </svg>
         <svg class="Divider_kd" viewBox="0 0 140 2">
         <path id="Divider_kd" d="M 0 0 L 140 0">
         </path>
      </svg>
         <div id="Label_ke">
            <button type='button' id='off' style="font-size: 18pt; background-color : #DCDCDC;">고대비끄기</button>
         </div>
      </div>
      <script type="text/javascript">
                  document.getElementById("off").addEventListener("click", function () {
                    document.getElementById("ht").setAttribute("class", "null");
               });
      
   </script>
      <div id="List_Item_kf">
         <div id="METADATA_kg">
            <span>{"config":{},"type":"ListItem","theme":"Base","nodeName":"List
               Item","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-02-04T02:44:24.556Z"}</span>
         </div>
         <svg class="Base_kh">
         <rect id="Base_kh" rx="0" ry="0" x="0" y="0" width="140" height="46">
         </rect>
      </svg>
         <svg class="Divider_ki" viewBox="0 0 140 2">
         <path id="Divider_ki" d="M 0 0 L 140 0">
         </path>
      </svg>
         <div id="Label_kj">
            <button type='button' id='on' style="font-size: 18pt; background-color : #DCDCDC;">고대비켜기</button>
         </div>
      </div>
		<script type="text/javascript">
			document.getElementById("on").addEventListener("click", function () {
   	     document.getElementById("ht").setAttribute("class", "invert");
      });
	</script>
		<div id="METADATA_kk">
			<span>{"config":{},"type":"CircleButton","theme":"Base","nodeName":"Circle
				Button","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-02-04T05:28:27.496Z"}</span>
		</div>
		<div id="METADATA_kl">
			<span>{"config":{"ICON":"feather/chevrons-up"},"type":"Icon","theme":"Base","nodeName":"Icon","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-02-04T05:28:27.443Z"}</span>
		</div>
		<svg class="Path_km" viewBox="3.333 2.5 27.532 16.266">
		<path id="Path_km"
				d="M 28.36453437805176 18.76576805114746 C 27.72472953796387 18.76576805114746 27.08492469787598 18.52169036865234 26.59676933288574 18.03353500366211 L 17.09877014160156 8.535534858703613 L 7.600769996643066 18.03353500366211 C 6.624459743499756 19.00984764099121 5.041539669036865 19.00984382629395 4.065230369567871 18.03353500366211 C 3.088920116424561 17.05722427368164 3.088920116424561 15.47431468963623 4.065230369567871 14.49800491333008 L 15.33100032806396 3.232234954833984 C 15.79983997344971 2.763395071029663 16.43572998046875 2.500005006790161 17.09877014160156 2.500005006790161 C 17.76181030273438 2.499994993209839 18.39768981933594 2.763395071029663 18.86654090881348 3.232234954833984 L 30.13229942321777 14.49800491333008 C 31.10861968994141 15.47431468963623 31.10861968994141 17.05722427368164 30.13229942321777 18.03353500366211 C 29.64414596557617 18.52169036865234 29.00433921813965 18.76576805114746 28.36453437805176 18.76576805114746 Z">
		</path>
	</svg>
		<div id="n_140">
			<svg class="n_2_ko" viewBox="0 0 1640 77">
			<path id="n_2_ko" d="M 0 0 L 1640 0 L 1640 77 L 0 77 L 0 0 Z">
			</path>
		</svg>
			<div id="n_139">
				<div id="n_132">
					<a href="#n_12">
						<div id="Label_kr">
							<span>후기등록</span>
						</div>
						<div id="Icon_ks">
							<div id="METADATA_kt">
								<span>{"config":{"ICON":"feather/clipboard"},"type":"Icon","nodeName":"Icon","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T06:12:32.430Z"}</span>
							</div>
							<svg class="Area_ku">
						<rect id="Area_ku" rx="0" ry="0" x="0" y="0" width="40"
									height="40">
						</rect>
					</svg>
							<div id="Icon_kv">
								<svg class="Path_kw" viewBox="6.667 6.667 26.666 30">
							<path id="Path_kw"
										d="M 26.66699981689453 6.666999816894531 L 30 6.666999816894531 C 31.84099960327148 6.666999816894531 33.33300018310547 8.159000396728516 33.33300018310547 10 L 33.33300018310547 33.33300018310547 C 33.33300018310547 35.17399978637695 31.84099960327148 36.66699981689453 30 36.66699981689453 L 10 36.66699981689453 C 8.159000396728516 36.66699981689453 6.666999816894531 35.17399978637695 6.666999816894531 33.33300018310547 L 6.666999816894531 10 C 6.666999816894531 8.159000396728516 8.159000396728516 6.666999816894531 10 6.666999816894531 L 13.33300018310547 6.666999816894531">
							</path>
						</svg>
								<svg class="Rect">
							<rect id="Rect" rx="1" ry="1" x="0" y="0" width="13.333"
										height="6.667">
							</rect>
						</svg>
							</div>
						</div>
					</a>
				</div>
				<%if(info!=null){ %>
				<div onclick="location='reviewBoard.jsp'" id="n_131">
				<%}else{ %>
					<div onclick="alert('로그인을 하셔야 이용할 수 있습니다.')" id="n_131">
				<%} %>
					<div id="Label_kz">
						<span>후기열람</span>
					</div>
					<div id="Icon_k">
						<div id="METADATA_k">
							<span>{"config":{"ICON":"feather/book-open"},"type":"Icon","nodeName":"Icon","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-02-03T01:13:54.490Z"}</span>
						</div>
						<svg class="Area_k">
						<rect id="Area_k" rx="0" ry="0" x="0" y="0" width="40" height="40">
						</rect>
					</svg>
						<div id="Icon_la">
							<svg class="Path_k" viewBox="3.333 5 16.667 30">
							<path id="Path_k"
									d="M 3.33299994468689 5 L 13.33300018310547 5 C 17.01499938964844 5 20 7.985000133514404 20 11.66699981689453 L 20 35 C 20 32.23899841308594 17.76099967956543 30 15 30 L 3.33299994468689 30 L 3.33299994468689 5 Z">
							</path>
						</svg>
							<svg class="Path_la" viewBox="20 5 16.667 30">
							<path id="Path_la"
									d="M 36.66699981689453 5 L 26.66699981689453 5 C 22.98500061035156 5 20 7.985000133514404 20 11.66699981689453 L 20 35 C 20 32.23899841308594 22.23900032043457 30 25 30 L 36.66699981689453 30 L 36.66699981689453 5 Z">
							</path>
						</svg>
						</div>
					</div>
				</div>
				
				<div id="n_133">
					<a href="#n_6">
						<div id="Label_k">
							<span>장소검색</span>
						</div>
						<div id="Icon_lb">
							<div id="METADATA_la">
								<span>{"config":{"ICON":"feather/crosshair"},"type":"Icon","nodeName":"Icon","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T06:09:28.299Z"}</span>
							</div>
							<svg class="Area_la">
						<rect id="Area_la" rx="0" ry="0" x="0" y="0" width="40"
									height="40">
						</rect>
					</svg>
							<div id="Icon_lc">
								<svg class="Path_lc">
							<ellipse id="Path_lc" rx="16.66666603088379"
										ry="16.66666603088379" cx="16.66666603088379"
										cy="16.66666603088379">
							</ellipse>
						</svg>
								<svg class="Line_ld" viewBox="0 0 6.667 3">
							<path id="Line_ld" d="M 6.666666507720947 0 L 0 0">
							</path>
						</svg>
								<svg class="Line_le" viewBox="0 0 6.667 3">
							<path id="Line_le" d="M 6.666666507720947 0 L 0 0">
							</path>
						</svg>
								<svg class="Line_lf" viewBox="0 0 3 6.667">
							<path id="Line_lf" d="M 0 6.666666507720947 L 0 0">
							</path>
						</svg>
								<svg class="Line_lg" viewBox="0 0 3 6.667">
							<path id="Line_lg" d="M 0 6.666666507720947 L 0 0">
							</path>
						</svg>
							</div>
						</div>
					</a>
				</div>
				<%if(info == null){ %>
				<div onClick="location.href='signin.jsp'">
					<div id="Label_li">
						<span>로그인</span>
					</div>
					<div id="Icon_lj">
						<div id="METADATA_lk">
							<span>{"config":{"ICON":"feather/user"},"type":"Icon","nodeName":"Icon","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T06:08:21.753Z"}</span>
						</div>
						<svg class="Area_ll">
						<rect id="Area_ll" rx="0" ry="0" x="0" y="0" width="40"
								height="40">
						</rect>
					</svg>
						<div id="Icon_lm">
							<svg class="Path_ln" viewBox="3.333 12.5 26.668 10">
							<path id="Path_ln"
									d="M 30.00099945068359 22.5 L 30.00099945068359 19.16600036621094 C 30.00099945068359 15.48399925231934 27.01499938964844 12.5 23.33300018310547 12.5 L 10.00099945068359 12.5 C 6.319000244140625 12.5 3.33299994468689 15.48399925231934 3.33299994468689 19.16600036621094 L 3.33299994468689 22.5">
							</path>
						</svg>
							<svg class="Path_lo">
							<ellipse id="Path_lo" rx="6.666666507720947"
									ry="6.666666507720947" cx="6.666666507720947"
									cy="6.666666507720947">
							</ellipse>
						</svg>
						</div>
					</div>
				</div>
				<%}else if(info != null){ %>
				<div >
					<a href="LogoutService">
					<div id="Label_li">
						<span>로그아웃</span>
					</div>
					<div id="Icon_lj">
						<div id="METADATA_lk">
							<span>{"config":{"ICON":"feather/user"},"type":"Icon","nodeName":"Icon","theme":"Base","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-01-27T06:08:21.753Z"}</span>
						</div>
						<svg class="Area_ll">
						<rect id="Area_ll" rx="0" ry="0" x="0" y="0" width="40"
								height="40">
						</rect>
					</svg>
						<div id="Icon_lm">
							<svg class="Path_ln" viewBox="3.333 12.5 26.668 10">
							<path id="Path_ln"
									d="M 30.00099945068359 22.5 L 30.00099945068359 19.16600036621094 C 30.00099945068359 15.48399925231934 27.01499938964844 12.5 23.33300018310547 12.5 L 10.00099945068359 12.5 C 6.319000244140625 12.5 3.33299994468689 15.48399925231934 3.33299994468689 19.16600036621094 L 3.33299994468689 22.5">
							</path>
						</svg>
							<svg class="Path_lo">
							<ellipse id="Path_lo" rx="6.666666507720947"
									ry="6.666666507720947" cx="6.666666507720947"
									cy="6.666666507720947">
							</ellipse>
						</svg>
						</div>
					</div>
					</a>
				</div>
				<%} %>
			</div>
		</div>
		<svg class="Path_lp" viewBox="3.333 8.333 27.532 16.266">
	<a href='#n_21'>
		<path id="Path_lp"
					d="M 28.36453437805176 24.59876823425293 C 27.72472953796387 24.59876823425293 27.08492469787598 24.35469055175781 26.59676933288574 23.86653518676758 L 17.09877014160156 14.36853504180908 L 7.600769996643066 23.86653518676758 C 6.624459743499756 24.84284782409668 5.041539669036865 24.84284400939941 4.065230369567871 23.86653518676758 C 3.088920116424561 22.89022445678711 3.088920116424561 21.30731582641602 4.065230369567871 20.33100509643555 L 15.33100032806396 9.065235137939453 C 15.79983997344971 8.596395492553711 16.43572998046875 8.333004951477051 17.09877014160156 8.333004951477051 C 17.76181030273438 8.332995414733887 18.39768981933594 8.596395492553711 18.86654090881348 9.065235137939453 L 30.13229942321777 20.33100509643555 C 31.10861968994141 21.30731582641602 31.10861968994141 22.89022445678711 30.13229942321777 23.86653518676758 C 29.64414596557617 24.35469055175781 29.00433921813965 24.59876823425293 28.36453437805176 24.59876823425293 Z">
		</path>
		</a>
	</svg>
	</div>
	
	<script>
		function fileupload(){
			$("#filename").click();
		}
		
		var latitude = null;
		var longitude = null;
		
		
		// ip주소의 위도경도 콜백함수!!!
		navigator.geolocation.getCurrentPosition(function(pos) {
		    latitude = pos.coords.latitude;
		    longitude = pos.coords.longitude;
		    //alert("현재 위치는 : " + latitude + ", "+ longitude);
		    console.log(latitude);
		    tests();
		});
		
		function tests(){                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
			console.log(latitude + " " + longitude);
		}

		
	    
		$('#kind').on('change',function(){
			$('input[name=chkind]').attr('value', this.value);
		})
		
		
		
		
		/* 기존 맵 띄움 */
		var mapContainer = document.getElementById('map'), // 지도를 표시할 div  
		mapOption = {
			center : new kakao.maps.LatLng(37.413294, 126.734086), // 초기 지도 중심좌표 , 현 위치로 하고싶음
			level : 3
		};
		
		

		var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

		// 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다 
		var positions = [
			{
		        content: '<div>카카오</div>',
		        latlng: new kakao.maps.LatLng(33.450705, 126.570677)
		    }
		];

		for (var i = 0; i < positions.length; i++) {
			// 마커를 생성합니다
			var marker = new kakao.maps.Marker({
				map : map, // 마커를 표시할 지도
				position : positions[i].latlng
			// 마커의 위치
			});

			// 마커에 표시할 인포윈도우를 생성합니다 
			var infowindow = new kakao.maps.InfoWindow({
				content : positions[i].content
			// 인포윈도우에 표시할 내용
			});

			// 마커에 mouseover 이벤트와 mouseout 이벤트를 등록합니다
			// 이벤트 리스너로는 클로저를 만들어 등록합니다 
			// for문에서 클로저를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
			kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(
					map, marker, infowindow));
			kakao.maps.event.addListener(marker, 'mouseout',
					makeOutListener(infowindow));
		}

		// 인포윈도우를 표시하는 클로저를 만드는 함수입니다 
		function makeOverListener(map, marker, infowindow) {
			return function() {
				infowindow.open(map, marker);
			};
		}

		// 인포윈도우를 닫는 클로저를 만드는 함수입니다 
		function makeOutListener(infowindow) {
			return function() {
				infowindow.close();
			};
		}
		
		var testseq = 0;
		/* ======================= 여기서부터 '선택'버튼 클릭했을 때  ======================== */
		function test() {
			// select태그에서 선택된 값을 변수에 담음
			var kind = $("#kind").val();
			var gu = $("#gu").val();
			
			// 한 번에 키밸류에 담음
			var param = {
				"kind" : kind,
				"gu" : gu
				
			};
			
			
			$.ajax({
				anyne : true,
				url : "testAjax",
				type : "post",
				data : param,
				dataType : "json",
				success : function(data) {

					console.log(data);
					var mapContainer = document.getElementById('map'),
					mapOption = {
							center : new kakao.maps.LatLng(data[0].Latitude, data[0].Longitude), 
							level : 2
						// 지도의 확대 레벨
					};
					var map = new kakao.maps.Map(mapContainer, mapOption);
					
					var positions = [];
					// 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다 
					for(var i=0; i<data.length; i++){
						positions.push({
							// 순번
							sequence : data[i].Seq,
							// 시설명
							content : data[i].Name,
							// 주소
							addr : data[i].Addr,
							// 전화번호
							tel : data[i].Tel,
							// 접근로 여부1
							approach : data[i].Approach,
							// 높이차이 여부2
							hdiff : data[i].HeightDiff,
							// 주차장 여부3
							parking : data[i].Parking,
							// 승강기 여부4
							elev : data[i].Elev,
							// 화장실 여부5
							toilet : data[i].Toilet,
							// 좌표
							latlng : new kakao.maps.LatLng(data[i].Latitude,data[i].Longitude)
						});
						
						
						
					}
						
					
					var testseq = [];
					var testName = [];
					for (var i = 0; i < positions.length; i++) {
						// 마커를 생성합니다
						var marker = new kakao.maps.Marker({
							map : map, // 마커를 표시할 지도
							position : positions[i].latlng
						// 마커의 위치
						});

						// 마커에 표시할 인포윈도우를 생성합니다 
						var infowindow = new kakao.maps.InfoWindow({
							content : positions[i].content
						// 인포윈도우에 표시할 내용
						});
						
						testseq.push(positions[i].sequence);
						testName.push(positions[i].content);
						
						kakao.maps.event.addListener(marker, 'click', chDiv(positions[i].sequence, positions[i].content,positions[i].addr, 
								positions[i].tel, positions[i].approach, positions[i].hdiff,positions[i].parking, 
								positions[i].elev, positions[i].toilet));

						// 마커에 mouseover 이벤트와 mouseout 이벤트를 등록합니다
						// 이벤트 리스너로는 클로저를 만들어 등록합니다 
						// for문에서 클로저를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
						kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(
								map, marker, infowindow));
						kakao.maps.event.addListener(marker, 'mouseout',
								makeOutListener(infowindow));
						
						//$('#Rselect').append('<option name="Rselect" value="'+ testseq[i] +'">'+ testName[i] +'</option>');
						
					}
					
					console.log(testName);

					// 인포윈도우를 표시하는 클로저를 만드는 함수입니다 
					function makeOverListener(map, marker, infowindow) {
						return function() {
							infowindow.open(map, marker);
						};
					}

					// 인포윈도우를 닫는 클로저를 만드는 함수입니다 
					function makeOutListener(infowindow) {
						return function() {
							infowindow.close();
						};
					}
					
					
					
					
					
					function chDiv(sequence, content, addr, tel, approach, hdiff, parking, elev, toilet){
						return function(){
							
							var changeSeq = sequence;
							var kind = $("#kind").val();
							
							$.ajax({
								anyne : true,
								url : "selectRestReview",
								type : "post",
								data : {"changeSeq":changeSeq,
									"kind" : kind},
								dataType : "json",
								success: function(data){
									console.log(data);
									
									var html = '';
									
									if(kind=='음식점'){
										for(var i=data.rest_rv_select.length-1; i>=0; i--){
											
											html += '<tr>';
											html += '<td class="Title_TAGH1_be">'+data.rest_rv_select[i].id+'</td>';
											html += '<td class="Title_TAGH1_be">'+data.rest_rv_select[i].date+'</td>';
											html += '<td class="Title_TAGH1_be">'+data.rest_rv_select[i].text+'</td>';
											html += '</tr>';
										}
									}else if(kind == '편의시설'){
										for(var i=data.conv_rv_select.length-1; i>=0; i--){
											
											
											html += '<tr>';
											html += '<td class="Title_TAGH1_be">'+data.conv_rv_select[i].id+'</td>';
											html += '<td class="Title_TAGH1_be">'+data.conv_rv_select[i].date+'</td>';
											html += '<td class="Title_TAGH1_be">'+data.conv_rv_select[i].text+'</td>';
											html += '</tr>'; 
										}
									}else if(kind == '숙박시설'){
										for(var i=data.stay_rv_select.length-1; i>=0; i--){
											
											html += '<tr>';
											html += '<td class="Title_TAGH1_be">'+data.stay_rv_select[i].id+'</td>';
											html += '<td class="Title_TAGH1_be">'+data.stay_rv_select[i].date+'</td>';
											html += '<td class="Title_TAGH1_be">'+data.stay_rv_select[i].text+'</td>';
											html += '</tr>'; 
										}
									}
									
									$("#chTable").empty();
									$("#chTable").append(html);
									
									var ch_avgs1 = document.getElementById('avgs1');
									ch_avgs1.innerHTML = data.avg1.avgs1+"점";
									
									var ch_avgs2 = document.getElementById('avgs2');
									ch_avgs2.innerHTML = data.avg2.avgs2+"점";
									
									var ch_avgs3 = document.getElementById('avgs3');
									ch_avgs3.innerHTML = data.avg3.avgs3+"점";
									
									var ch_avgs4 = document.getElementById('avgs4');
									ch_avgs4.innerHTML = data.avg4.avgs4+"점";
									
									var ch_avgs5 = document.getElementById('avgs5');
									ch_avgs5.innerHTML = data.avg5.avgs5+"점";
									
									var ch_name = document.getElementById('spanName');
									ch_name.innerHTML = content+"에 대한";
									
									var ch_addr = document.getElementById('spanAddr');
									ch_addr.innerHTML = "주소 : " + addr;
									
									var ch_tel = document.getElementById('spanTel');
									ch_tel.innerHTML = "tel : " + tel;
									
									$('input[name=testApproach]').attr('value', approach);
									$('input[name=testParking]').attr('value', parking);
									$('input[name=testDiff]').attr('value', hdiff);
									$('input[name=testElev]').attr('value', elev);
									$('input[name=testToilet]').attr('value', toilet);
									
									var test_icon1 = document.querySelector('#Icon_dj')
									
									// 접근로 여부 체크
									var approachCheck = $('input[name=testApproach]').val();
									if(approachCheck == 'N'){
										$("#Icon__dg").hide();
									}
									
									// 주차장 여부 체크
									var parkingCheck = $('input[name=testParking]').val();
									if(parkingCheck == 'N'){
										$("#Icon__dm").hide();
									}
									
									// 높이차이 여부 체크
									var hdiffCheck = $('input[name=testDiff]').val();
									if(hdiffCheck == 'N'){
										$("#Icon__dt").hide();
									}
									
									
									// 승강기 여부 체크
									var elevCheck = $('input[name=testElev]').val();
									if(elevCheck == 'N'){
										$("#Icon__d").hide();
									}
									
									// 화장실 여부 체크
									var toiletCheck = $('input[name=testToilet]').val();
									if(toiletCheck == 'N'){
										$("#Icon__ea").hide(); 
									}
									
									/* 
									 */
								},
								error : function(){
									alert("실패");
								}
								
								
							});
							$('input[name=chseq]').attr('value', sequence);
							$('input[name=chname]').attr('value', content);
							/* var ch_seq = document.getElementById('seq');  
							ch_seq.innerHTML = sequence;
							
							
							
							var ch_name = document.getElementById('name');
							ch_name.innerHTML = content;
							
							
							
							var ch_addr = document.getElementById('spanAddr');
							ch_addr.innerHTML = addr;
							
							var ch_tel = document.getElementById('tel');
							ch_tel.innerHTML = tel;
							
							var ch_approach = document.getElementById('approach');
							ch_approach.innerHTML = approach;
							
							var ch_hdiff = document.getElementById('hdiff');
							ch_hdiff.innerHTML = hdiff;
							
							var ch_parking = document.getElementById('parking');
							ch_parking.innerHTML = parking;
							
							var ch_elev = document.getElementById('elev');
							ch_elev.innerHTML = elev;
							
							var ch_toilet = document.getElementById('toilet');
							ch_toilet.innerHTML = toilet;
							 */
							
							
						}
					}

					
				
				},
				error : function(e, c, d) {
					alert('error');
					console.log("ERROR : " + c + " : " + d);
				}
				

			});
		}
		
		
		// 리뷰 작성 후 보내기 버튼 눌렀을 때
		function reviewInsert(){
			
			
			var kind = $("#chkind").val();
			var seq = $("#chseq").val();
			var name = $("#chname").val();
			console.log("시설명 테스트 " + name);
			
			var s1 = $("input[name='q1']:checked").val();
			var s2 = $("input[name='q2']:checked").val();
			var s3 = $("input[name='q3']:checked").val();
			var s4 = $("input[name='q4']:checked").val();
			var s5 = $("input[name='q5']:checked").val();
			var text = $("#text").val();
			
			
			console.log(kind);
			console.log(seq);
			console.log(s1);
			console.log(s2);
			console.log(s3);
			console.log(s4);
			console.log("s5"+s5);
			console.log("text : "+text);
			
			// 한 번에 키밸류에 담음
			var param = {
				"kind" : kind,
				"seq" : seq,
				"s1" : s1,
				"s2" : s2,
				"s3" : s3,
				"s4" : s4,
				"s5" : s5,
				"text" : text,
				"name" : name
				
				
			};
			
			$.ajax({
				anyne : true,
				url : "reviewAjax",
				type : "post",
				data : param,
				dataType : "json",
				success : function(data) {
					alert("리뷰가 등록되었습니다.");
					console.log(data);
					// 후기 등록 후 라디오, textarea 값 초기화
					$("input:radio[name='q1']").prop('checked',false);
					$("input:radio[name='q2']").prop('checked',false);
					$("input:radio[name='q3']").prop('checked',false);
					$("input:radio[name='q4']").prop('checked',false);
					$("input:radio[name='q5']").prop('checked',false);
					$('#text').val('');
					},
				error : function(){
					alert("실패");
				}
			
			});
		}
		
		
		
		
		
		
		
		
		</script>


</body>
</html>