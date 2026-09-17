package com.exam.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.exam.model.ResultAnalytics;
import com.exam.util.DBConnection;

public class ResultAnalyticsDAO {

    /*
     * =========================================================
     * MAIN DASHBOARD STATISTICS
     * =========================================================
     */

    public ResultAnalytics getAnalytics() {

        ResultAnalytics analytics = new ResultAnalytics();

        analytics.setTotalResults(getTotalResults());
        analytics.setTotalAttempts(getTotalAttempts());
        analytics.setAverageScore(getAverageScore());
        analytics.setPassRate(getPassRate());
        analytics.setHighestScore(getHighestScore());
        analytics.setSuspiciousActivities(getSuspiciousActivities());
        analytics.setFlaggedAttempts(getFlaggedAttempts());

        return analytics;
    }

    public int getTotalResults() {

        String sql =
                "SELECT COUNT(*) "
              + "FROM results";

        return getInt(sql);
    }

    public int getTotalAttempts() {

        String sql =
                "SELECT COUNT(*) "
              + "FROM exam_attempts";

        return getInt(sql);
    }

    public double getAverageScore() {

        String sql =
                "SELECT COALESCE("
              + "ROUND("
              + "AVG(score * 100.0 / NULLIF(total_questions, 0)),"
              + "2"
              + "),"
              + "0"
              + ") "
              + "FROM results "
              + "WHERE total_questions > 0";

        return getDouble(sql);
    }

    public double getPassRate() {

        String sql =
                "SELECT COALESCE("
              + "ROUND("
              + "100.0 * SUM("
              + "CASE "
              + "WHEN score * 100.0 / NULLIF(total_questions,0) >= 50 "
              + "THEN 1 "
              + "ELSE 0 "
              + "END"
              + ") / NULLIF(COUNT(*),0),"
              + "2"
              + "),"
              + "0"
              + ") "
              + "FROM results "
              + "WHERE total_questions > 0";

        return getDouble(sql);
    }

    public double getHighestScore() {

        String sql =
                "SELECT COALESCE("
              + "MAX(score * 100.0 / NULLIF(total_questions,0)),"
              + "0"
              + ") "
              + "FROM results "
              + "WHERE total_questions > 0";

        return getDouble(sql);
    }

    public int getSuspiciousActivities() {

        String sql =
                "SELECT COUNT(*) "
              + "FROM suspicious_activity";

        return getInt(sql);
    }

    public int getFlaggedAttempts() {

        String sql =
                "SELECT COUNT(*) "
              + "FROM exam_attempts "
              + "WHERE flagged_count > 0";

        return getInt(sql);
    }


    /*
     * =========================================================
     * SCORE DISTRIBUTION
     * =========================================================
     */

    public Map<String, Integer> getScoreDistribution() {

        Map<String, Integer> distribution =
                new LinkedHashMap<>();

        distribution.put("0-39%", 0);
        distribution.put("40-59%", 0);
        distribution.put("60-74%", 0);
        distribution.put("75-89%", 0);
        distribution.put("90-100%", 0);

        String sql =
                "SELECT "
              + "CASE "
              + "WHEN score * 100.0 / NULLIF(total_questions,0) < 40 "
              + "THEN '0-39%' "
              + "WHEN score * 100.0 / NULLIF(total_questions,0) < 60 "
              + "THEN '40-59%' "
              + "WHEN score * 100.0 / NULLIF(total_questions,0) < 75 "
              + "THEN '60-74%' "
              + "WHEN score * 100.0 / NULLIF(total_questions,0) < 90 "
              + "THEN '75-89%' "
              + "ELSE '90-100%' "
              + "END AS score_range, "
              + "COUNT(*) AS total "
              + "FROM results "
              + "WHERE total_questions > 0 "
              + "GROUP BY score_range";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                distribution.put(
                        rs.getString("score_range"),
                        rs.getInt("total")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return distribution;
    }


    /*
     * =========================================================
     * EXAM PERFORMANCE
     * =========================================================
     */

    public List<Map<String, Object>> getExamPerformance() {

        List<Map<String, Object>> list =
                new ArrayList<>();

        String sql =
                "SELECT "
              + "e.exam_name, "
              + "COUNT(r.id) AS attempts, "
              + "ROUND("
              + "AVG(r.score * 100.0 / NULLIF(r.total_questions,0)),"
              + "2"
              + ") AS average_score, "
              + "ROUND("
              + "MAX(r.score * 100.0 / NULLIF(r.total_questions,0)),"
              + "2"
              + ") AS highest_score, "
              + "ROUND("
              + "100.0 * SUM("
              + "CASE "
              + "WHEN r.score * 100.0 / NULLIF(r.total_questions,0) >= 50 "
              + "THEN 1 ELSE 0 END"
              + ") / NULLIF(COUNT(r.id),0),"
              + "2"
              + ") AS pass_rate "
              + "FROM results r "
              + "INNER JOIN exams e "
              + "ON r.exam_id = e.id "
              + "WHERE r.total_questions > 0 "
              + "GROUP BY e.id, e.exam_name "
              + "ORDER BY average_score DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Map<String, Object> row =
                        new HashMap<>();

                row.put(
                        "examName",
                        rs.getString("exam_name")
                );

                row.put(
                        "attempts",
                        rs.getInt("attempts")
                );

                row.put(
                        "averageScore",
                        rs.getDouble("average_score")
                );

                row.put(
                        "highestScore",
                        rs.getDouble("highest_score")
                );

                row.put(
                        "passRate",
                        rs.getDouble("pass_rate")
                );

                list.add(row);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }


    /*
     * =========================================================
     * TOP STUDENTS
     * =========================================================
     */

    public List<Map<String, Object>> getTopStudents() {

        List<Map<String, Object>> list =
                new ArrayList<>();

        String sql =
                "SELECT "
              + "u.id, "
              + "u.name, "
              + "u.email, "
              + "COUNT(r.id) AS attempts, "
              + "ROUND("
              + "AVG(r.score * 100.0 / NULLIF(r.total_questions,0)),"
              + "2"
              + ") AS average_score, "
              + "ROUND("
              + "MAX(r.score * 100.0 / NULLIF(r.total_questions,0)),"
              + "2"
              + ") AS best_score "
              + "FROM users u "
              + "INNER JOIN results r "
              + "ON u.id = r.user_id "
              + "WHERE u.role = 'STUDENT' "
              + "AND r.total_questions > 0 "
              + "GROUP BY u.id, u.name, u.email "
              + "ORDER BY average_score DESC "
              + "LIMIT 10";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Map<String, Object> row =
                        new HashMap<>();

                row.put(
                        "id",
                        rs.getInt("id")
                );

                row.put(
                        "name",
                        rs.getString("name")
                );

                row.put(
                        "email",
                        rs.getString("email")
                );

                row.put(
                        "attempts",
                        rs.getInt("attempts")
                );

                row.put(
                        "averageScore",
                        rs.getDouble("average_score")
                );

                row.put(
                        "bestScore",
                        rs.getDouble("best_score")
                );

                list.add(row);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }


    /*
     * =========================================================
     * RECENT RESULTS
     * =========================================================
     */

    public List<Map<String, Object>> getRecentResults() {

        List<Map<String, Object>> list =
                new ArrayList<>();

        String sql =
                "SELECT "
              + "r.id, "
              + "u.name AS student_name, "
              + "u.email AS student_email, "
              + "e.exam_name, "
              + "r.total_questions, "
              + "r.correct_answers, "
              + "r.score, "
              + "ROUND("
              + "r.score * 100.0 / NULLIF(r.total_questions,0),"
              + "2"
              + ") AS percentage, "
              + "r.exam_date "
              + "FROM results r "
              + "INNER JOIN users u "
              + "ON r.user_id = u.id "
              + "INNER JOIN exams e "
              + "ON r.exam_id = e.id "
              + "ORDER BY r.exam_date DESC "
              + "LIMIT 15";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Map<String, Object> row =
                        new HashMap<>();

                row.put(
                        "id",
                        rs.getInt("id")
                );

                row.put(
                        "studentName",
                        rs.getString("student_name")
                );

                row.put(
                        "studentEmail",
                        rs.getString("student_email")
                );

                row.put(
                        "examName",
                        rs.getString("exam_name")
                );

                row.put(
                        "totalQuestions",
                        rs.getInt("total_questions")
                );

                row.put(
                        "correctAnswers",
                        rs.getInt("correct_answers")
                );

                row.put(
                        "score",
                        rs.getInt("score")
                );

                row.put(
                        "percentage",
                        rs.getDouble("percentage")
                );

                row.put(
                        "examDate",
                        rs.getTimestamp("exam_date")
                );

                list.add(row);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }


    /*
     * =========================================================
     * SUSPICIOUS ACTIVITY
     * =========================================================
     */

    public List<Map<String, Object>> getRecentSuspiciousActivity() {

        List<Map<String, Object>> list =
                new ArrayList<>();

        String sql =
                "SELECT "
              + "sa.id, "
              + "sa.activity_type, "
              + "sa.activity_time, "
              + "sa.details, "
              + "u.name AS student_name, "
              + "e.exam_name "
              + "FROM suspicious_activity sa "
              + "INNER JOIN exam_attempts ea "
              + "ON sa.attempt_id = ea.id "
              + "INNER JOIN users u "
              + "ON ea.student_id = u.id "
              + "INNER JOIN exams e "
              + "ON ea.exam_id = e.id "
              + "ORDER BY sa.activity_time DESC "
              + "LIMIT 10";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Map<String, Object> row =
                        new HashMap<>();

                row.put(
                        "id",
                        rs.getInt("id")
                );

                row.put(
                        "activityType",
                        rs.getString("activity_type")
                );

                row.put(
                        "activityTime",
                        rs.getTimestamp("activity_time")
                );

                row.put(
                        "details",
                        rs.getString("details")
                );

                row.put(
                        "studentName",
                        rs.getString("student_name")
                );

                row.put(
                        "examName",
                        rs.getString("exam_name")
                );

                list.add(row);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }


    /*
     * =========================================================
     * GENERIC NUMBER HELPERS
     * =========================================================
     */

    private int getInt(String sql) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }


    private double getDouble(String sql) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }
}