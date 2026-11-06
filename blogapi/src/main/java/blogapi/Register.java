package blogapi;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
public class Register extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/blogging_db";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "vamsi";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String role = request.getParameter("role");

        try {

            // If you have password hashing, use it here
            String finalPassword = password;

            boolean registered = registerUser(
                    username,
                    finalPassword,
                    firstName,
                    lastName,
                    email,
                    role
            );

            if (registered) {

                response.sendRedirect(
                    request.getContextPath() + "/login.html?success=true"
                );

            } else {

                response.sendRedirect(
                    request.getContextPath() + "/register.html?error=true"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                request.getContextPath() + "/register.html?error=true"
            );
        }
    }


    private boolean registerUser(
            String username,
            String password,
            String firstName,
            String lastName,
            String email,
            String role) {


        String query =
            "INSERT INTO users " +
            "(username, password, firstName, lastName, email, role, isActive) " +
            "VALUES (?, ?, ?, ?, ?, ?, 1)";


        try (
            Connection connection = getConnection();
            PreparedStatement stmt = connection.prepareStatement(query)
        ) {

            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.setString(3, firstName);
            stmt.setString(4, lastName);
            stmt.setString(5, email);
            stmt.setString(6, role);


            int result = stmt.executeUpdate();

            return result > 0;


        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }



    private Connection getConnection() throws SQLException {

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

        } catch (ClassNotFoundException e) {

            throw new SQLException(
                "MySQL JDBC Driver not found",
                e
            );
        }


        return DriverManager.getConnection(
                DB_URL,
                DB_USERNAME,
                DB_PASSWORD
        );
    }
}