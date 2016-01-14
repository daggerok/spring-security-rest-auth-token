package com.example.config.security.auth;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DemoPasswordService {
    private final static BCryptPasswordEncoder PASSWORD_ENCODER = new BCryptPasswordEncoder();

    public String encode(String rawPassword) {
        return PASSWORD_ENCODER.encode(rawPassword);
    }

    public boolean isValid(String rawPassword, String hashedPassword) {
        return PASSWORD_ENCODER.matches(rawPassword, hashedPassword);
    }
}