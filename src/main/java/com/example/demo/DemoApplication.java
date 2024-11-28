package com.example.demo;

import com.example.demo.repository.BigTableRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.embedded.tomcat.TomcatEmbeddedWebappClassLoader;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.jdbc.core.JdbcTemplate;

@SpringBootApplication
public class DemoApplication implements CommandLineRunner {
    private static Logger LOG = LoggerFactory.getLogger(DemoApplication.class);

    @Autowired
    private BigTableRepository repo;

    private static final int MIN = 1;
    private static final int MAX = 1000000;

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }

    private long getRandomNumber() {
        return (long) ((Math.random() * ((MAX - MIN) + 1)) + MIN);
    }

    @Override
    public void run(String... args) throws Exception {
        while (true) {
            long id = getRandomNumber();
            repo.updateDataObjectId(id);
            LOG.info("Updated object_id for id: " + id);
            Thread.sleep(10);
        }
    }
}
