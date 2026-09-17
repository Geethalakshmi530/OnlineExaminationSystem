package com.exam.model;

public class Dashboard {

    private int totalStudents;
    private int activeExams;
    private int totalQuestions;
    private int totalExamAttempts;

    public Dashboard() {
    }

    public Dashboard(int totalStudents,
                     int activeExams,
                     int totalQuestions,
                     int totalExamAttempts) {

        this.totalStudents = totalStudents;
        this.activeExams = activeExams;
        this.totalQuestions = totalQuestions;
        this.totalExamAttempts = totalExamAttempts;
    }

    public int getTotalStudents() {
        return totalStudents;
    }

    public void setTotalStudents(int totalStudents) {
        this.totalStudents = totalStudents;
    }

    public int getActiveExams() {
        return activeExams;
    }

    public void setActiveExams(int activeExams) {
        this.activeExams = activeExams;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public int getTotalExamAttempts() {
        return totalExamAttempts;
    }

    public void setTotalExamAttempts(int totalExamAttempts) {
        this.totalExamAttempts = totalExamAttempts;
    }
}