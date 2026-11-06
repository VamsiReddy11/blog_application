package blogapi;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.text.SimpleDateFormat;

public class PublicStoriesServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/blogging_db";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "vamsi";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        StringBuilder json = new StringBuilder();
        json.append("[");

        // Safe query selecting standard blog columns + joined author username
        String query = "SELECT b.id, b.title, b.content, " +
                       "COALESCE(u.username, 'Author') AS author_name " +
                       "FROM blogs b " +
                       "LEFT JOIN users u ON b.author_id = u.id " +
                       "ORDER BY b.id DESC";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            boolean first = true;
            SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
            String defaultDate = sdf.format(new java.util.Date()); // Fallback current formatted date

            while (rs.next()) {
                if (!first) json.append(",");
                first = false;

                int id = rs.getInt("id");
                String title = escapeJson(rs.getString("title"));
                String content = escapeJson(rs.getString("content"));
                String author = escapeJson(rs.getString("author_name"));

                // Try to read created_at or updated_at if they exist, otherwise use fallback
                String dateStr = defaultDate;
                try {
                    Timestamp ts = rs.getTimestamp("created_at");
                    if (ts != null) dateStr = sdf.format(ts);
                } catch (Exception ignored) {
                    // Column doesn't exist, safely defaults to current date
                }

                json.append("{")
                    .append("\"id\":").append(id).append(",")
                    .append("\"title\":\"").append(title).append("\",")
                    .append("\"content\":\"").append(content).append("\",")
                    .append("\"authorName\":\"").append(author).append("\",")
                    .append("\"postDate\":\"").append(dateStr).append("\"")
                    .append("}");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        json.append("]");
        out.print(json.toString());
        out.flush();
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", " ")
                .replace("\r", " ")
                .replace("\t", " ");
    }
}