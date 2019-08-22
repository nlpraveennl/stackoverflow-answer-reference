# Stack Overflow References
## Explaination for Projects springsecurity-auth-success-handler-*config
Refer project <b>springsecurity-auth-success-handler-javaconfig</b> for java based configuration

Refer project <b>springsecurity-auth-success-handler-xmlconfig</b> for xml based configuration

This blog main intention is 
Different ways to configure session timeout time(maxInactiveInterval) in spring security

### 1. By addinng session config in web.xml
```
<session-config>
    <session-timeout>20</session-timeout>
</session-config>
```

### 2. By configuring implementation of HttpSessionListener
```
public class SessionListener implements HttpSessionListener
{
	@Override
	public void sessionCreated(HttpSessionEvent event)
	{
		event.getSession().setMaxInactiveInterval(60);
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent event)
	{}
}
```
Then add listener to ServletContext 
```
//in java config way
public class AppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer
{
  ...	
	@Override
	public void onStartup(ServletContext servletContext) throws ServletException
	{
		super.onStartup(servletContext);   
		servletContext.addListener(new SessionListener());
	}
}

// in xml config way - add below configuration in web.xml
<listener>
		<listener-class>com.pvn.mvctiles.configuration.SessionListener</listener-class>
</listener>
```

### 3. By adding your custom AuthenticationSuccessHandler
```
public class MyAuthenticationSuccessHandler implements AuthenticationSuccessHandler
{

	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication)
			throws IOException 
	{
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        if (roles.contains("ROLE_ADMIN"))
        {
        	request.getSession(false).setMaxInactiveInterval(60);
        }
        else
        {
        	request.getSession(false).setMaxInactiveInterval(120);
        }
        //Your login success url goes here, currentl login success url="/"
        response.sendRedirect(request.getContextPath());
    }
}
```
