# Stack Overflow References
## Explaination for Projects springsecurity-auth-success-handler-*config
Refer project <b>springsecurity-auth-success-handler-javaconfig</b> for java based configuration

Refer project <b>springsecurity-auth-success-handler-xmlconfig</b> for xml based configuration

This blog main intention is to explain Different ways to configure session timeout time(maxInactiveInterval) in spring security

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
This implementation has adavantages
1. On login success, You can set different value of maxInactiveInterval for different roles/users
2. On login success, you can set user object in session, hence user object can be accessed in any controller from session
Create AuthenticationSuccessHandler Handler
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
Register success handler

In Java Config way
```
@Override
protected void configure(final HttpSecurity http) throws Exception
{
	http
		.authorizeRequests()
			.antMatchers("/resources/**", "/login"").permitAll()
			.antMatchers("/app/admin/*").hasRole("ADMIN")
			.antMatchers("/app/user/*", "/").hasAnyRole("ADMIN", "USER")
		.and().exceptionHandling().accessDeniedPage("/403")
		.and().formLogin()
			.loginPage("/login").usernameParameter("userName")
			.passwordParameter("password")
			.successHandler(new MyAuthenticationSuccessHandler())
			.failureUrl("/login?error=true")
		.and().logout()
			.logoutSuccessHandler(new CustomLogoutSuccessHandler())
			.invalidateHttpSession(true)
		.and().csrf().disable();

	http.sessionManagement().maximumSessions(1).expiredUrl("/login?expired=true");
}
```
In xml config way
```
<http auto-config="true" use-expressions="true" create-session="ifRequired">
	<csrf disabled="true"/>

	<intercept-url pattern="/resources/**" access="permitAll" />
	<intercept-url pattern="/login" access="permitAll" />

	<intercept-url pattern="/app/admin/*" access="hasRole('ROLE_ADMIN')" />
	<intercept-url pattern="/" access="hasAnyRole('ROLE_USER', 'ROLE_ADMIN')" />
	<intercept-url pattern="/app/user/*" access="hasAnyRole('ROLE_USER', 'ROLE_ADMIN')" />

	<access-denied-handler error-page="/403" />

	<form-login 
	    login-page="/login"
	    authentication-success-handler-ref="authenticationSuccessHandler"
	    authentication-failure-url="/login?error=true" 
	    username-parameter="userName"
	    password-parameter="password" />

	<logout invalidate-session="false" success-handler-ref="customLogoutSuccessHandler"/>

	<session-management invalid-session-url="/login?expired=true">
		<concurrency-control max-sessions="1" />
	</session-management>
 </http>
 
 <beans:bean id="authenticationSuccessHandler" class="com.pvn.mvctiles.configuration.MyAuthenticationSuccessHandler" />
 
 ```
