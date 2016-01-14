package com.example.domain;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@Entity
@NoArgsConstructor
@RequiredArgsConstructor(staticName = "of")
public class User implements Serializable {
    private static final long serialVersionUID = 5049455294108339324L;

    public enum ROLE implements Serializable {
        ADMIN("ROLE_ADMIN"),
        USER("ROLE_USER");
        private static final long serialVersionUID = 0L;

        private final String role;

        ROLE(final String role) {
            this.role = role;
        }

        public String value() {
            return role;
        }
    }

    @Id @GeneratedValue Long id;

    @NonNull String username;

    @NonNull String password;

    LocalDateTime updatedAt = LocalDateTime.now();

    String role = ROLE.USER.value();
}