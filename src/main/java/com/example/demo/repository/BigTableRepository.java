package com.example.demo.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;



@Repository
public class BigTableRepository {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public int updateDataObjectId(Long id) {
        String sql = "UPDATE big_table SET object_id = object_id + 1 WHERE id = ?";

        return jdbcTemplate.update(sql, id);
    }
}
