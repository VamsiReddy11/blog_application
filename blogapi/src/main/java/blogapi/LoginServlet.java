package blogapi;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        boolean isValid = authenticateUser(username, password);

        if (isValid) {
            HttpSession session = request.getSession();
            String role = getUserRole(username);
            int user_id= getUserid(username);

            session.setAttribute("username", username);
            session.setAttribute("role", role);
            session.setAttribute("user_id", user_id);
            response.sendRedirect(request.getContextPath() + "/blogs");


 
        } else {
            response.sendRedirect("login.html?error=true"); 
        }
    }
    
    private String getUserRole(String username) {
        String query = "SELECT role FROM users WHERE username = ?";
        try (Connection connection = createDatabaseConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getString("role"); 
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    private int getUserid(String username) {
        String query = "SELECT  id FROM users WHERE username = ?";
        try (Connection connection = createDatabaseConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setString(1,username );
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("id"); 
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    

    private boolean authenticateUser(String username, String password) {
        String query = "SELECT id, password FROM users WHERE username = ?";
        
        try (Connection connection = createDatabaseConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            System.out.println("LoginServlet: Independent connection established for authenticateUser");
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String storedPassword = rs.getString("password");  
                return PasswordUtil.verifyPassword(password, storedPassword); 
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

   
    private Connection createDatabaseConnection() throws SQLException {
        String dbUrl = "jdbc:mysql://localhost:3306/blogging_db";
        String dbUsername = "root";
        String dbPassword = "vamsi";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); 
            System.out.println("LoginServlet: Database driver loaded");
            return DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new SQLException("Unable to load MySQL Driver", e);
        }
    }
}
