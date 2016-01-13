package com.example.config.security;

import com.example.domain.User;
import com.example.domain.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import java.util.Enumeration;
import java.util.LinkedHashMap;
import java.util.Map;

@Service
public class DemoTokenService {
    public static final String USERNAME = "username";

    public static final String TOKEN = "token";

    @Autowired UserRepository users;

    @Autowired DemoPasswordService passwordService;

    public UserDetails getUserDetails(ServletRequest request) {
        Map<String, String> headers = parseHeaders(request);
        String username = headers.get(USERNAME);
        String password = headers.get(TOKEN);

        if (null == username || null == password) return null;

        User user = users.findByUsername(username);

        if (passwordService.isValid(password, user.getPassword())) {
            user.setPassword(password);
            return new DemoUserDetails(user);
        }
        return null;
    }

    private Map<String, String> parseHeaders(ServletRequest servletRequest) {
        Map<String, String> headers = new LinkedHashMap<>(2);

        if (servletRequest instanceof HttpServletRequest) {
            HttpServletRequest request = (HttpServletRequest) servletRequest;
            Enumeration<String> headerNames = request.getHeaderNames();

            while (headerNames.hasMoreElements()) {
                String headerName = headerNames.nextElement();

                switch (headerName) {
                    case USERNAME:
                        headers.put(USERNAME, request.getHeader(USERNAME));
                        break;
                    case TOKEN:
                        headers.put(TOKEN, request.getHeader(TOKEN));
                        break;
                }
            }
        }
        return headers;
    }
}
