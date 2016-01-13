package com.example.config.security;

import org.springframework.security.core.userdetails.UsernameNotFoundException;

public class DemoUserNotFoundException extends UsernameNotFoundException {
    public DemoUserNotFoundException(String username) {
        super(String.format("user %s wasn't found.", username));
    }
}
