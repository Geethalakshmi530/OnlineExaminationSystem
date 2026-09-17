package com.exam.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.exam.model.Exam;
import com.exam.util.DBConnection;

public class ExamDAO {

    /**
     * Retrieves all exams from the database.
     * Exams are displayed with the newest exam first.
     */
    public List<Exam> getAllExams() {

        List<Exam> exams = new ArrayList<>();

        String sql = "SELECT id, exam_name, duration_minutes, "
                   + "total_questions, created_at "
                   + "FROM exams "
                   + "ORDER BY id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Exam exam = new Exam();

                exam.setId(rs.getInt("id"));
                exam.setExamName(rs.getString("exam_name"));
                exam.setDurationMinutes(
                        rs.getInt("duration_minutes"));
                exam.setTotalQuestions(
                        rs.getInt("total_questions"));
                exam.setCreatedAt(
                        rs.getTimestamp("created_at"));

                exams.add(exam);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return exams;
    }

    /**
     * Adds a new exam to the database.
     */
    public boolean addExam(Exam exam) {

        String sql = "INSERT INTO exams "
                   + "(exam_name, duration_minutes, total_questions) "
                   + "VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, exam.getExamName());
            ps.setInt(2, exam.getDurationMinutes());
            ps.setInt(3, exam.getTotalQuestions());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates an existing exam.
     */
    public boolean updateExam(Exam exam) {

        String sql = "UPDATE exams "
                   + "SET exam_name = ?, "
                   + "duration_minutes = ?, "
                   + "total_questions = ? "
                   + "WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, exam.getExamName());
            ps.setInt(2, exam.getDurationMinutes());
            ps.setInt(3, exam.getTotalQuestions());
            ps.setInt(4, exam.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Deletes an exam by its ID.
     */
    public boolean deleteExam(int examId) {

        String sql = "DELETE FROM exams WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, examId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Retrieves a single exam by its ID.
     */
    public Exam getExamById(int examId) {

        String sql = "SELECT id, exam_name, duration_minutes, "
                   + "total_questions, created_at "
                   + "FROM exams "
                   + "WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, examId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    Exam exam = new Exam();

                    exam.setId(rs.getInt("id"));
                    exam.setExamName(
                            rs.getString("exam_name"));
                    exam.setDurationMinutes(
                            rs.getInt("duration_minutes"));
                    exam.setTotalQuestions(
                            rs.getInt("total_questions"));
                    exam.setCreatedAt(
                            rs.getTimestamp("created_at"));

                    return exam;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
}