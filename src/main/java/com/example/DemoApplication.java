package com.example;

import com.example.config.security.auth.PasswordService;
import com.example.domain.User;
import com.example.domain.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.util.Arrays;

@SpringBootApplication
public class DemoApplication {
	@Bean
	CommandLineRunner testData(UserRepository users, PasswordService passwordService) {
		users.save(User.of("admin", passwordService.encode("admin")));

		return args -> Arrays.asList("max,fax,bax".split(","))
				.forEach(name -> users.save(User.of(name, passwordService.encode(name))));
	}

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}
}