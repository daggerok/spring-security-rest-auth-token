package com.example.config.security.userdetails;

import com.example.domain.User;
import lombok.NoArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.io.Serializable;
import java.util.Collection;

@Component
@NoArgsConstructor
public class DemoUserDetails extends User implements UserDetails, Serializable {
    private static final long serialVersionUID = -6270644455381356378L;

    public DemoUserDetails(User user) {
        setId(user.getId());
        setPassword(user.getPassword());
        setUsername(user.getUsername());
        setUpdatedAt(user.getUpdatedAt());
        setRole(user.getRole());
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return AuthorityUtils.createAuthorityList(getRole());
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}