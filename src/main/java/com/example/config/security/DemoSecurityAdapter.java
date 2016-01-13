package com.example.config.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@EnableWebSecurity
public class DemoSecurityAdapter extends WebSecurityConfigurerAdapter {
    @Autowired DemoUserDetailsService demoUserDetailsService;

    @Autowired DemoAuthenticationTokenFilter demoAuthenticationTokenFilter;

    @Autowired DemoAuthenticationEntryPoint demoAuthenticationEntryPoint;

    @Override
    protected void configure(HttpSecurity http) throws Exception {
//        RequestMatcher csrfMatcher = request -> {
//            Pattern get = Pattern.compile("^GET$");
//            if (get.matcher(request.getMethod()).matches()) {
//                return false;
//            }
//            return true;
//        };
        http
            .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
            .headers()
                .frameOptions()
                .sameOrigin()
                .and()
//            .csrf().disable()
            .csrf()
                .ignoringAntMatchers("/api/**")
                .and()
            .authorizeRequests()//.anyRequest().permitAll();
                .antMatchers("/").permitAll()
                .antMatchers("/api/**").fullyAuthenticated()
                .and()
            .addFilterBefore(demoAuthenticationTokenFilter, UsernamePasswordAuthenticationFilter.class)
                .exceptionHandling().authenticationEntryPoint(demoAuthenticationEntryPoint)
                .and()
            .httpBasic();
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth
            .userDetailsService(demoUserDetailsService)
                .passwordEncoder(new BCryptPasswordEncoder());
    }
}
