### Different Approaches to achieve auto logout
1. Setting Refresh header in http response.
```
response.setHeader("Refresh", "60; URL=login.jsp");
```

2. Setting meta refresh tag in HTML
```
<meta http-equiv="refresh" content="60; url=login.jsp">
```

Approach 1 and 2 works fine only if your project does not contain AJAX requests. Now a days web application comprises of both page reload and AJAX request, approach 1 and 2 will not suits for current applications.

3. Javascript/Jquery Logic
There are many ways to implement, writing down good one which i have built and tested.<br>
Here logic is simple, on page load set interval of timeout = maxInactiveInterval. after timeout occurs redirect to login page.<br>
But track AJAX call also<br>
Now considering AJAX requests you can use ```.ajaxStart()``` or ```.ajaxComplete()``` callbacks of jquery so that for any ajax request is fired you can <b>reset</b> the interval.<br>
There is some extra check has been added for handling and calculating session time left when there are more than one tab open. It works for any number of tabs without any problem.

Code for the same is given below.

a. In your HttpSessionListener implementation
```
@Override
public void sessionCreated(HttpSessionEvent event)
{
  OUT.trace("session created");
  event.getSession().setMaxInactiveInterval(60);

  //autologout configuration starts
  event.getSession().setAttribute("timeOutTimeInSeconds", 61);
  event.getSession().setAttribute("showTimerTimeInSeconds", 50);
  //autologout configuration ends
}
```

b. In each JSP page except login.jsp(Don't forget to add Jquery. I used jquery-3.4.1)
```
<jsp:include page="template/autologout-script.jsp"></jsp:include>
```

And Just add a JSP template to your project(all required params set in session already, no configuration required here)
```
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script>
$(document).ready(function()
{
	var timeOutTimeInSeconds = ${ timeOutTimeInSeconds };
	
	var sessionCheckIntervalId = setInterval(redirectToLoginPage, timeOutTimeInSeconds * 1000);
	window.localStorage.setItem("AjaxRequestFired", new Date());
	
	function redirectToLoginPage(){
		//location.href =  '${loginPageUrl}'; //alternate way
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
```

If your AJAX request takes more than one second then better to use ```$(document).ajaxStart``` instead of ```$(document).ajaxComplete``` and use ```location.href =  '${logoutUrl}';``` to avoid time lag between server and browser.

Hope this helps
