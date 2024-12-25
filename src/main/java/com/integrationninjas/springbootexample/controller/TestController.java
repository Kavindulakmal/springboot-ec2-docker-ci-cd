package com.integrationninjas.springbootexample.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController {

	@GetMapping
	public Object hello() {
		Map<String, String> f1 = new HashMap<>();
		f1.put("driver_name", "lewis hamilton");
		f1.put("team", "Scuderia Ferrari");
		return f1;
	}
}
