package com.example;

import com.example.domain.User;
import com.example.domain.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.util.Arrays;

@SpringBootApplication
public class DemoApplication {
	private final static BCryptPasswordEncoder CRYPT = new BCryptPasswordEncoder();

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

	@Bean
	CommandLineRunner testData(UserRepository users) {
		return args -> Arrays.asList("max,fax,bax".split(","))
				.forEach(name -> users.save(User.of(name, CRYPT.encode(name))));
	}
}