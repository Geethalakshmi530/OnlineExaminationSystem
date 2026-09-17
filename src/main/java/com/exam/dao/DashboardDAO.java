package com.exam.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.exam.util.DBConnection;

public class DashboardDAO {

    public int getTotalStudents() {
        return getCount(
                "SELECT COUNT(*) FROM users WHERE role = 'STUDENT'"
        );
    }

    public int getActiveExams() {
        return getCount(
        		"SELECT COUNT(*) FROM exams"
        );
    }

    public int getTotalQuestions() {
        return getCount(
                "SELECT COUNT(*) FROM questions"
        );
    }

    public int getTotalExamAttempts() {
        return getCount(
                "SELECT COUNT(*) FROM exam_attempts"
        );
    }

    private int getCount(String sql) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }
}