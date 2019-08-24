package com.pvn.mvctiles.configuration;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
@EnableWebSecurity
public class SpringSecurityConfig extends WebSecurityConfigurerAdapter
{

	@Autowired
	public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception
	{
		auth.inMemoryAuthentication().withUser("praveen").password("{noop}praveen@123#").roles("ADMIN");
		auth.inMemoryAuthentication().withUser("vedanta").password("{noop}vedanta@123#").roles("USER");
	}

	@Override
	protected void configure(final HttpSecurity http) throws Exception
	{
		http
			.authorizeRequests()
				.antMatchers("/resources/**", "/", "/login", "/api/**").permitAll()
				.antMatchers("/app/admin/*").hasRole("ADMIN").antMatchers("/app/user/*")
				.hasAnyRole("ADMIN", "USER")
			.and().exceptionHandling().accessDeniedPage("/403")
			.and().formLogin()
				.loginPage("/login").usernameParameter("userName")
				.passwordParameter("password")
				.defaultSuccessUrl("/app/user/dashboard")
				.failureUrl("/login?error=true")
			.and().logout()
				.logoutSuccessHandler(new CustomLogoutSuccessHandler())
				.invalidateHttpSession(true)
			.and().csrf().disable();

		http.sessionManagement().maximumSessions(1).expiredUrl("/login?expired=true");
	}
}
