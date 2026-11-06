package blogapi;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class updateBlogServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/blogging_db";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "vamsi";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect("login.html?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createBlog(request, response);
        } else if ("update".equals(action)) {
            updateBlog(request, response);
        } else {
            response.sendRedirect("/blogapi/blogs?error=invalidAction");
        }
    }

    private void createBlog(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        int authorId = Integer.parseInt(request.getParameter("author_id"));

        String query = "INSERT INTO blogs (title, content, author_id) VALUES (?, ?, ?)";

        try {
            // Explicitly load the MySQL Driver to avoid issues in Tomcat
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            try (Connection connection = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
                 PreparedStatement stmt = connection.prepareStatement(query)) {

                stmt.setString(1, title);
                stmt.setString(2, content);
                stmt.setInt(3, authorId);

                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    response.sendRedirect("/blogapi/blogs?blog=created");
                } else {
                    response.sendRedirect("/blogapi/blogs?error=creationFailed");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/blogapi/blogs?error=creationFailed");
        }
    }

    private void updateBlog(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int blogId = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        String query = "UPDATE blogs SET title = ?, content = ? WHERE id = ?";

        try {
            // Explicitly load the MySQL Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            try (Connection connection = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
                 PreparedStatement stmt = connection.prepareStatement(query)) {

                stmt.setString(1, title);
                stmt.setString(2, content);
                stmt.setInt(3, blogId);

                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    response.sendRedirect("/blogapi/blogs?blog=updated");
                } else {
                    response.sendRedirect("/blogapi/blogs?error=updateFailed");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/blogapi/blogs?error=updateFailed");
        }
    }
}