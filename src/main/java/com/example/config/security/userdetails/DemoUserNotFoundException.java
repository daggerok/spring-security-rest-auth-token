package com.example.config.security.userdetails;

import org.springframework.security.core.userdetails.UsernameNotFoundException;

import java.io.Serializable;

public class DemoUserNotFoundException extends UsernameNotFoundException implements Serializable {
    private static final long serialVersionUID = 4873126741001632535L;

    public DemoUserNotFoundException(String username) {
        super(String.format("user %s wasn't found.", username));
    }
}