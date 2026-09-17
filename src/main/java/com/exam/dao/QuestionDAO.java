package com.exam.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.exam.model.Question;
import com.exam.util.DBConnection;

public class QuestionDAO {

    public List<Question> getQuestionsByExamId(int examId) {

        List<Question> questions = new ArrayList<>();

        String sql = "SELECT id, exam_id, question_text, "
                   + "option_a, option_b, option_c, option_d, "
                   + "correct_answer "
                   + "FROM questions "
                   + "WHERE exam_id = ? "
                   + "ORDER BY id ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, examId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Question question = new Question();

                    question.setId(rs.getInt("id"));
                    question.setExamId(rs.getInt("exam_id"));
                    question.setQuestionText(
                            rs.getString("question_text"));
                    question.setOptionA(
                            rs.getString("option_a"));
                    question.setOptionB(
                            rs.getString("option_b"));
                    question.setOptionC(
                            rs.getString("option_c"));
                    question.setOptionD(
                            rs.getString("option_d"));
                    question.setCorrectAnswer(
                            rs.getString("correct_answer"));

                    questions.add(question);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return questions;
    }

    public boolean addQuestion(Question question) {

        String sql = "INSERT INTO questions "
                   + "(exam_id, question_text, option_a, "
                   + "option_b, option_c, option_d, correct_answer) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, question.getExamId());
            ps.setString(2, question.getQuestionText());
            ps.setString(3, question.getOptionA());
            ps.setString(4, question.getOptionB());
            ps.setString(5, question.getOptionC());
            ps.setString(6, question.getOptionD());
            ps.setString(7, question.getCorrectAnswer());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateQuestion(Question question) {

        String sql = "UPDATE questions "
                   + "SET question_text = ?, "
                   + "option_a = ?, "
                   + "option_b = ?, "
                   + "option_c = ?, "
                   + "option_d = ?, "
                   + "correct_answer = ? "
                   + "WHERE id = ? "
                   + "AND exam_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, question.getQuestionText());
            ps.setString(2, question.getOptionA());
            ps.setString(3, question.getOptionB());
            ps.setString(4, question.getOptionC());
            ps.setString(5, question.getOptionD());
            ps.setString(6, question.getCorrectAnswer());
            ps.setInt(7, question.getId());
            ps.setInt(8, question.getExamId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteQuestion(int questionId, int examId) {

        String sql = "DELETE FROM questions "
                   + "WHERE id = ? "
                   + "AND exam_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, questionId);
            ps.setInt(2, examId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Question getQuestionById(int questionId, int examId) {

        String sql = "SELECT id, exam_id, question_text, "
                   + "option_a, option_b, option_c, option_d, "
                   + "correct_answer "
                   + "FROM questions "
                   + "WHERE id = ? "
                   + "AND exam_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, questionId);
            ps.setInt(2, examId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    Question question = new Question();

                    question.setId(rs.getInt("id"));
                    question.setExamId(
                            rs.getInt("exam_id"));
                    question.setQuestionText(
                            rs.getString("question_text"));
                    question.setOptionA(
                            rs.getString("option_a"));
                    question.setOptionB(
                            rs.getString("option_b"));
                    question.setOptionC(
                            rs.getString("option_c"));
                    question.setOptionD(
                            rs.getString("option_d"));
                    question.setCorrectAnswer(
                            rs.getString("correct_answer"));

                    return question;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
}