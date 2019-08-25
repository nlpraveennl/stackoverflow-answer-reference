<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script>
$(document).ready(function()
{
	var timeOutTimeInSeconds = ${ timeOutTimeInSeconds }; //should be same as maxInactiveInterval in server
	
	var sessionCheckIntervalId = setInterval(redirectToLoginPage, timeOutTimeInSeconds * 1000);
	window.localStorage.setItem("AjaxRequestFired", new Date());
	
	function redirectToLoginPage(){
		//location.href =  '${loginPageUrl}';
		window.location.reload();
	}
	
	$(document).ajaxComplete(function () {
	    resetTimer();
	});
	
	$(window).bind('storage', function (e) {
	     if(e.originalEvent.key == "AjaxRequestFired"){
	    	 console.log("Request sent from another tab, hence resetting timer")
	    	 resetTimer();
    	 }
	});
	
	function resetTimer()
	{
		window.localStorage.setItem("AjaxRequestFired", new Date());
		
		window.clearInterval(sessionCheckIntervalId);
	    sessionCheckIntervalId = setInterval(redirectToLoginPage, timeOutTimeInSeconds * 1000);
	}
});
</script>