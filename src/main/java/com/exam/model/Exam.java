package com.exam.model;

import java.sql.Timestamp;

public class Exam {

    private int id;
    private String examName;
    private int durationMinutes;
    private int totalQuestions;
    private Timestamp createdAt;

    public Exam() {
    }

    public Exam(int id,
                String examName,
                int durationMinutes,
                int totalQuestions,
                Timestamp createdAt) {

        this.id = id;
        this.examName = examName;
        this.durationMinutes = durationMinutes;
        this.totalQuestions = totalQuestions;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getExamName() {
        return examName;
    }

    public void setExamName(String examName) {
        this.examName = examName;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Exam{" +
                "id=" + id +
                ", examName='" + examName + '\'' +
                ", durationMinutes=" + durationMinutes +
                ", totalQuestions=" + totalQuestions +
                ", createdAt=" + createdAt +
                '}';
    }
}