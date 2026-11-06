package blogapi;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BlogServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/blogging_db";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "vamsi";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect("login.html?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            int blogId = Integer.parseInt(request.getParameter("id"));
            Blog blog = getBlogById(blogId);
            if (blog != null) {
                request.setAttribute("blog", blog);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/editblog.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendRedirect("blogs?error=blognotfound");
            }
        } else {
            // Fetch and display all blogs
            List<Blog> blogs = getAllBlogs();
            request.setAttribute("blogs", blogs);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/home.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect("login.html?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        String role = (String) session.getAttribute("role");

        // --- FIXED: ADDED CREATE HANDLING BLOCK ---
        if ("create".equals(action)) {
            if (!isAuthorized(role, "admin", "editor")) {
                response.sendRedirect("unauthorized.html");
                return;
            }

            String title = request.getParameter("title");
            String content = request.getParameter("content");
            int authorId = Integer.parseInt(request.getParameter("author_id"));

            createBlog(title, content, authorId);
            response.sendRedirect("/blogapi/blogs?blog=created");
            return;
        } 
        
        else if ("update".equals(action)) {
            if (!isAuthorized(role, "admin", "editor")) {
                response.sendRedirect("unauthorized.html");
                return;
            }

            int blogId = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");

            updateBlog(blogId, title, content);
            response.sendRedirect("/blogapi/blogs?blog=updated");
            return;
        } 
        
        else if ("delete".equals(action)) {
            int blogId = Integer.parseInt(request.getParameter("id"));
            deleteBlog(blogId);
            response.sendRedirect("/blogapi/blogs?blog=deleted");
            return;
        }
    }
    
    
    
    

    private Blog getBlogById(int blogId) {
        Blog blog = null;
        String query = "SELECT b.id, b.title, b.content, b.author_id, u.username AS author_name " +
                       "FROM blogs b " +
                       "JOIN users u ON b.author_id = u.id " +
                       "WHERE b.id = ?";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
             PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setInt(1, blogId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                blog = new Blog();
                blog.setId(rs.getInt("id"));
                blog.setTitle(rs.getString("title"));
                blog.setContent(rs.getString("content"));
                blog.setAuthorId(rs.getInt("author_id"));
                blog.setAuthorName(rs.getString("author_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return blog;
    }

    private List<Blog> getAllBlogs() {
        List<Blog> blogs = new ArrayList<>();
        String query = "SELECT b.id, b.title, b.content, b.author_id, u.username AS author_name " +
                "FROM blogs b " +
                "JOIN users u ON b.author_id = u.id";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
             PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Blog blog = new Blog();
                blog.setId(rs.getInt("id"));
                blog.setTitle(rs.getString("title"));
                blog.setContent(rs.getString("content"));
                blog.setAuthorId(rs.getInt("author_id"));
                blog.setAuthorName(rs.getString("author_name"));
                blogs.add(blog);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("Fetched blogs: " + blogs.size());
        return blogs;
    }

    // --- FIXED: ADDED DATABASE INSERTION METHOD ---
    private void createBlog(String title, String content, int authorId) {
        String query = "INSERT INTO blogs (title, content, author_id) VALUES (?, ?, ?)";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
             PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setString(1, title);
            stmt.setString(2, content);
            stmt.setInt(3, authorId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void updateBlog(int blogId, String title, String content) {
        String query = "UPDATE blogs SET title = ?, content = ? WHERE id = ?";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
             PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setString(1, title);
            stmt.setString(2, content);
            stmt.setInt(3, blogId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void deleteBlog(int blogId) {
        String query = "DELETE FROM blogs WHERE id = ?";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
             PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setInt(1, blogId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private boolean isAuthorized(String role, String... allowedRoles) {
        for (String allowedRole : allowedRoles) {
            if (allowedRole.equals(role)) {
                return true;
            }
        }
        return false;
    }
}