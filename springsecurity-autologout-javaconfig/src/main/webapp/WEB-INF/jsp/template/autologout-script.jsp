<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script>
$(document).ready(function()
{
	var timeOutTimeInSeconds = ${ timeOutTimeInSeconds }; //should be same as maxInactiveInterval in server
	var showTimerTimeInSeconds= ${ showTimerTimeInSeconds };
	
	var sessionCheckIntervalId = setInterval(redirectToLoginPage, timeOutTimeInSeconds * 1000);
	var timerDisplayIntervalId = setInterval(showTimer, (timeOutTimeInSeconds - showTimerTimeInSeconds) * 1000);
	var badgeTimerId;
	window.localStorage.setItem("AjaxRequestFired", new Date());
	
	function redirectToLoginPage(){
		//location.href =  '<c:url value="/" />'+'${loginPageUrl}';
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
		showTimerTimeInSeconds= ${ showTimerTimeInSeconds };
		
		console.log("timeOutTimeInSeconds : "+timeOutTimeInSeconds)
		window.localStorage.setItem("AjaxRequestFired", new Date());
		
		window.clearInterval(sessionCheckIntervalId);
	    sessionCheckIntervalId = setInterval(redirectToLoginPage, timeOutTimeInSeconds * 1000);
	    
	    window.clearInterval(timerDisplayIntervalId);
	    timerDisplayIntervalId = setInterval(showTimer, (timeOutTimeInSeconds - showTimerTimeInSeconds) * 1000);
	    
	    hideTimer();
	}
	
	function showTimer()
	{
		$('#sessionTimeRemaining').show();
		$('#sessionTimeRemainingBadge').html(showTimerTimeInSeconds--);
		window.clearInterval(timerDisplayIntervalId);
		badgeTimerId = setInterval(function(){
			$('#sessionTimeRemainingBadge').html(showTimerTimeInSeconds--);
		}, 1000);
	}

	function hideTimer()
	{
		window.clearInterval(badgeTimerId);
		$('#sessionTimeRemaining').hide();
	}
});

function doAjaxCall()
{
	  $.ajax({
	   type: "GET",
	   url: 'resfreshSession',
	   success: function(data, textStatus, xhr)
	   {
		   alert(data);
	   }
	 });
}
</script>