package com.example.config.security;

import com.example.config.security.csrf.DemoCsrfTokenGeneratorFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.csrf.CsrfFilter;

@EnableWebSecurity
public class DemoSecurityAdapter extends WebSecurityConfigurerAdapter {
    @Autowired DemoCsrfTokenGeneratorFilter csrfTokenGeneratorFilter;

    @Autowired DemoUserDetailsService demoUserDetailsService;

    @Autowired DemoAuthenticationTokenFilter demoAuthenticationTokenFilter;

    @Autowired DemoAuthenticationEntryPoint demoAuthenticationEntryPoint;

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
            .headers()
                .frameOptions()
                .sameOrigin()
                .and()
            .addFilterBefore(demoAuthenticationTokenFilter, UsernamePasswordAuthenticationFilter.class)
                .exceptionHandling().authenticationEntryPoint(demoAuthenticationEntryPoint)
                .and()
            .addFilterAfter(csrfTokenGeneratorFilter, CsrfFilter.class) // populate _csrf into header
            .csrf()
                .ignoringAntMatchers("/")
                .ignoringAntMatchers("/*.css")
                .ignoringAntMatchers("/*.js")
                .ignoringAntMatchers("/api/**")
                .and()
            .authorizeRequests()//.anyRequest().permitAll();
                .antMatchers("/").permitAll()
                .antMatchers("/api/**").fullyAuthenticated()
                .and();
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth
            .userDetailsService(demoUserDetailsService)
                .passwordEncoder(new BCryptPasswordEncoder());
    }
}