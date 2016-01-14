package com.example;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.Arrays;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = DemoApplication.class)
public class DemoApplicationTests {
	@Autowired
	ApplicationContext applicationContext;

	@Test
	public void testContext() {
		assertNotNull("null applicationContext", applicationContext);

		Arrays.asList(
				"badAuthenticationFilter",
				"authenticationTokenFilter",

				"passwordService",
				"tokenService",

				"csrfTokenFilter",

				"demoUserDetails",
				"demoUserDetailsService",

				"demoSecurityAdapter",

				"webSocketMessageBrokerConfig",
				"welcomeMessageEndpoint",

				"demoConfig",

				"userRepository",

				"demoApplication"
		).stream().forEach(beanName ->
				assertTrue(String.format("%s bean wasn't found", beanName), applicationContext.containsBean(beanName)));
	}
}