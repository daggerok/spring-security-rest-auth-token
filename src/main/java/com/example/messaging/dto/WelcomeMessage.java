package com.example.messaging.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@RequiredArgsConstructor(staticName = "of")
public class WelcomeMessage implements Serializable {
    private static final long serialVersionUID = 7522996086108937228L;

    @NonNull Message message;
}