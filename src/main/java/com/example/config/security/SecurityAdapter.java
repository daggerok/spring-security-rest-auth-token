package com.example.config.security;

import com.example.config.security.auth.AuthenticationFilter;
import com.example.config.security.auth.BadAuthenticationFilter;
import com.example.config.security.csrf.CsrfTokenFilter;
import com.example.config.security.userdetails.DemoUserDetailsService;
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
public class SecurityAdapter extends WebSecurityConfigurerAdapter {
    @Autowired DemoUserDetailsService demoUserDetailsService;

    @Autowired AuthenticationFilter authenticationFilter;

    @Autowired BadAuthenticationFilter badAuthenticationFilter;

    @Autowired CsrfTokenFilter csrfTokenFilter;

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
            .addFilterBefore(authenticationFilter, UsernamePasswordAuthenticationFilter.class)
                .exceptionHandling().authenticationEntryPoint(badAuthenticationFilter)
                .and()
            .addFilterAfter(csrfTokenFilter, CsrfFilter.class) // populate _csrf into header
            .csrf()
//                .ignoringAntMatchers("/api/**")
                .and()
            .authorizeRequests()
                .antMatchers("/").permitAll()
                .antMatchers("/csrf").permitAll()
                .antMatchers("/*.js").permitAll()
                .antMatchers("/*.css").permitAll()
                .antMatchers("/ws/url/welcome/**").permitAll()
//                .antMatchers("/api/**").fullyAuthenticated()
                .anyRequest().fullyAuthenticated();
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth
            .userDetailsService(demoUserDetailsService)
                .passwordEncoder(new BCryptPasswordEncoder());
    }
}