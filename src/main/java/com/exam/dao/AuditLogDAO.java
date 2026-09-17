package com.exam.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.exam.model.AuditLog;
import com.exam.util.DBConnection;

public class AuditLogDAO {

    /*
     * =========================================================
     * COUNT
     * =========================================================
     */

    public int getTotalLogs() {

        String sql =
                "SELECT COUNT(*) "
              + "FROM audit_logs";

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


    /*
     * =========================================================
     * GET ALL LOGS
     * =========================================================
     */

    public List<AuditLog> getLogs(
            String search,
            String action) {

        List<AuditLog> logs =
                new ArrayList<>();

        StringBuilder sql =
                new StringBuilder();

        sql.append(
                "SELECT "
              + "a.id, "
              + "a.user_id, "
              + "u.name AS user_name, "
              + "u.email AS user_email, "
              + "a.action, "
              + "a.entity_type, "
              + "a.entity_id, "
              + "a.description, "
              + "a.action_time "
              + "FROM audit_logs a "
              + "LEFT JOIN users u "
              + "ON a.user_id = u.id "
              + "WHERE 1=1 "
        );

        boolean hasSearch =
                search != null
                && !search.trim().isEmpty();

        boolean hasAction =
                action != null
                && !action.trim().isEmpty();

        if (hasSearch) {

            sql.append(
                    "AND ("
                  + "u.name LIKE ? "
                  + "OR u.email LIKE ? "
                  + "OR a.action LIKE ? "
                  + "OR a.entity_type LIKE ? "
                  + "OR a.description LIKE ?"
                  + ") "
            );
        }

        if (hasAction) {

            sql.append(
                    "AND a.action = ? "
            );
        }

        sql.append(
                "ORDER BY a.action_time DESC "
              + "LIMIT 100"
        );

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(
                             sql.toString())) {

            int index = 1;

            if (hasSearch) {

                String value =
                        "%"
                        + search.trim()
                        + "%";

                ps.setString(index++, value);
                ps.setString(index++, value);
                ps.setString(index++, value);
                ps.setString(index++, value);
                ps.setString(index++, value);
            }

            if (hasAction) {

                ps.setString(
                        index++,
                        action.trim()
                );
            }

            try (ResultSet rs =
                         ps.executeQuery()) {

                while (rs.next()) {

                    AuditLog log =
                            new AuditLog();

                    log.setId(
                            rs.getInt("id")
                    );

                    log.setUserId(
                            rs.getInt("user_id")
                    );

                    log.setUserName(
                            rs.getString("user_name")
                    );

                    log.setUserEmail(
                            rs.getString("user_email")
                    );

                    log.setAction(
                            rs.getString("action")
                    );

                    log.setEntityType(
                            rs.getString("entity_type")
                    );

                    log.setEntityId(
                            rs.getInt("entity_id")
                    );

                    log.setDescription(
                            rs.getString("description")
                    );

                    log.setActionTime(
                            rs.getTimestamp(
                                    "action_time"
                            )
                    );

                    logs.add(log);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return logs;
    }


    /*
     * =========================================================
     * ACTION SUMMARY
     * =========================================================
     */

    public List<Map<String, Object>> getActionSummary() {

        List<Map<String, Object>> list =
                new ArrayList<>();

        String sql =
                "SELECT "
              + "action, "
              + "COUNT(*) AS total "
              + "FROM audit_logs "
              + "GROUP BY action "
              + "ORDER BY total DESC "
              + "LIMIT 8";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Map<String, Object> row =
                        new HashMap<>();

                row.put(
                        "action",
                        rs.getString("action")
                );

                row.put(
                        "total",
                        rs.getInt("total")
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
     * INSERT AUDIT LOG
     *
     * This is used by the newly added modules.
     * Existing modules are NOT modified.
     * =========================================================
     */

    public boolean addLog(
            int userId,
            String action,
            String entityType,
            Integer entityId,
            String description) {

        String sql =
                "INSERT INTO audit_logs "
              + "(user_id, action, entity_type, "
              + "entity_id, description) "
              + "VALUES (?, ?, ?, ?, ?)";

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, action);

            if (entityType == null) {
                ps.setNull(
                        3,
                        java.sql.Types.VARCHAR
                );
            } else {
                ps.setString(
                        3,
                        entityType
                );
            }

            if (entityId == null) {
                ps.setNull(
                        4,
                        java.sql.Types.INTEGER
                );
            } else {
                ps.setInt(
                        4,
                        entityId
                );
            }

            ps.setString(
                    5,
                    description
            );

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}