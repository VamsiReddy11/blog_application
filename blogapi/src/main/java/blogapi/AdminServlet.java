package blogapi;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

public class AdminServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        int userId = Integer.parseInt(request.getParameter("userId"));
        User user = DatabaseConnection.getUserById(userId);

        if (user != null) { 
            request.setAttribute("user", user);
        } else {
            
            response.sendRedirect("/error?message=UserNotFound");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/editUser.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        

        int userId = Integer.parseInt(request.getParameter("userId"));
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");

        User updatedUser = new User();
        updatedUser.setId(userId);
        updatedUser.setFirstName(firstName);
        updatedUser.setLastName(lastName);
       

        DatabaseConnection.updateUser(updatedUser);
        response.sendRedirect("/admin/users");
    }
}