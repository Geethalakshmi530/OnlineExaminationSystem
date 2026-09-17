package com.exam.model;

public class ResultAnalytics {

    private int totalResults;
    private int totalAttempts;
    private double averageScore;
    private double passRate;
    private double highestScore;
    private int suspiciousActivities;
    private int flaggedAttempts;

    public ResultAnalytics() {
    }

    public int getTotalResults() {
        return totalResults;
    }

    public void setTotalResults(int totalResults) {
        this.totalResults = totalResults;
    }

    public int getTotalAttempts() {
        return totalAttempts;
    }

    public void setTotalAttempts(int totalAttempts) {
        this.totalAttempts = totalAttempts;
    }

    public double getAverageScore() {
        return averageScore;
    }

    public void setAverageScore(double averageScore) {
        this.averageScore = averageScore;
    }

    public double getPassRate() {
        return passRate;
    }

    public void setPassRate(double passRate) {
        this.passRate = passRate;
    }

    public double getHighestScore() {
        return highestScore;
    }

    public void setHighestScore(double highestScore) {
        this.highestScore = highestScore;
    }

    public int getSuspiciousActivities() {
        return suspiciousActivities;
    }

    public void setSuspiciousActivities(int suspiciousActivities) {
        this.suspiciousActivities = suspiciousActivities;
    }

    public int getFlaggedAttempts() {
        return flaggedAttempts;
    }

    public void setFlaggedAttempts(int flaggedAttempts) {
        this.flaggedAttempts = flaggedAttempts;
    }
}