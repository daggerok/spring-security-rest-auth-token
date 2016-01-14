package com.example.config.security.csrf;

import org.springframework.http.MediaType;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class CsrfService {
    @RequestMapping(value = "/csrf", produces = MediaType.APPLICATION_JSON_VALUE)
    public CsrfToken csrf(CsrfToken token) {
        return token;
    }
}
