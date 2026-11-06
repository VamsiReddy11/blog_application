package blogapi;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

public class BlogDetailsServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/blogging_db";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "vamsi";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("/blogapi/blogs");
            return;
        }

        int blogId = Integer.parseInt(idParam);
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String title = "Story Not Found";
        String content = "The requested story could not be found or has been removed.";
        String authorName = "Unknown";
        String authorEmail = "Not available";

        // Query joining blogs and users to fetch author name and email
        String query = "SELECT b.title, b.content, u.username AS author_name, u.email AS author_email " +
                       "FROM blogs b " +
                       "LEFT JOIN users u ON b.author_id = u.id " +
                       "WHERE b.id = ?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, blogId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    title = rs.getString("title");
                    content = rs.getString("content");
                    if (rs.getString("author_name") != null) {
                        authorName = rs.getString("author_name");
                    }
                    if (rs.getString("author_email") != null) {
                        authorEmail = rs.getString("author_email");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Render styled reading page with background image
        out.println("<!DOCTYPE html>");
        out.println("<html lang='en'>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("<title>" + title + " | Story Details</title>");
        out.println("<link rel='preconnect' href='https://fonts.googleapis.com'>");
        out.println("<link rel='preconnect' href='https://fonts.gstatic.com' crossorigin>");
        out.println("<link href='https://fonts.googleapis.com/css2?family=Crimson+Pro:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@400;500;600;700&display=swap' rel='stylesheet'>");
        out.println("<style>");
        out.println("* { box-sizing: border-box; margin: 0; padding: 0; }");
        out.println("body {");
        out.println("  min-height: 100vh;");
        out.println("  color: #1e2920;");
        out.println("  font-family: 'Crimson Pro', Georgia, serif;");
        out.println("  display: flex;");
        out.println("  flex-direction: column;");
        out.println("  align-items: center;");
        out.println("  padding: 40px 20px 60px;");
        // Soft gradient overlay combined with background image
        out.println("  background-image: linear-gradient(rgba(240, 245, 238, 0.85), rgba(230, 238, 228, 0.90)), url('/blogapi/register_Background/pexels-pixabay-301717.jpg');");
        out.println("  background-size: cover;");
        out.println("  background-position: center;");
        out.println("  background-repeat: no-repeat;");
        out.println("  background-attachment: fixed;");
        out.println("}");
        out.println(".toolbar { width: 100%; max-width: 780px; margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; }");
        out.println(".back-btn { font-family: 'Inter', sans-serif; font-size: 13px; font-weight: 600; color: #2e5339; text-decoration: none; padding: 9px 18px; background-color: rgba(255, 255, 255, 0.9); border: 1px solid rgba(200, 215, 198, 0.9); border-radius: 8px; backdrop-filter: blur(8px); transition: all 0.2s ease; box-shadow: 0 2px 8px rgba(0,0,0,0.04); }");
        out.println(".back-btn:hover { background-color: #2e5339; color: #ffffff; border-color: #2e5339; transform: translateX(-2px); }");
        out.println(".mode-tag { font-family: 'Inter', sans-serif; font-size: 12px; color: #2e5339; background-color: rgba(255, 255, 255, 0.85); border: 1px solid rgba(200, 215, 198, 0.9); padding: 5px 14px; border-radius: 20px; font-weight: 600; }");
        
        // Frosted paper card container
        out.println(".container { width: 100%; max-width: 780px; background-color: rgba(255, 255, 255, 0.93); backdrop-filter: blur(14px); -webkit-backdrop-filter: blur(14px); border: 1px solid rgba(255, 255, 255, 0.8); border-radius: 18px; padding: 52px 60px; box-shadow: 0 20px 40px -10px rgba(15, 30, 20, 0.12), 0 0 1px 1px rgba(0, 0, 0, 0.04); }");
        
        out.println("h1 { font-size: 38px; font-weight: 700; color: #162419; margin-bottom: 18px; line-height: 1.25; letter-spacing: -0.01em; }");
        out.println(".author-card { display: flex; align-items: center; gap: 14px; margin-bottom: 32px; padding-bottom: 22px; border-bottom: 1px solid #edf4ec; font-family: 'Inter', sans-serif; }");
        out.println(".avatar { width: 44px; height: 44px; border-radius: 50%; background: linear-gradient(135deg, #2e5339 0%, #407551 100%); color: #ffffff; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 17px; box-shadow: 0 4px 10px rgba(46, 83, 57, 0.25); }");
        out.println(".author-meta h4 { font-size: 14.5px; color: #1e2920; font-weight: 600; }");
        out.println(".author-meta p { font-size: 12.5px; color: #5f7463; margin-top: 2px; }");
        
        // Article body styling
        out.println(".content { font-size: 20.5px; line-height: 1.9; color: #263328; white-space: pre-wrap; word-wrap: break-word; }");
        out.println(".content::first-letter { float: left; font-size: 3.8rem; line-height: 0.8; margin: 4px 14px 0 0; font-weight: 700; color: #2e5339; }");
        
        out.println("@media (max-width: 640px) { .container { padding: 32px 22px; } h1 { font-size: 28px; } .content { font-size: 18px; line-height: 1.75; } }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='toolbar'>");
        out.println("<a href='/blogapi/blogs' class='back-btn'>&larr; Back to Dashboard</a>");
        out.println("<span class='mode-tag'>Reading Light Active</span>");
        out.println("</div>");
        out.println("<main class='container'>");
        out.println("<h1>" + title + "</h1>");
        out.println("<div class='author-card'>");
        out.println("<div class='avatar'>" + authorName.substring(0, 1).toUpperCase() + "</div>");
        out.println("<div class='author-meta'>");
        out.println("<h4>" + authorName + "</h4>");
        out.println("<p>" + authorEmail + "</p>");
        out.println("</div>");
        out.println("</div>");
        out.println("<article class='content'>" + content + "</article>");
        out.println("</main>");
        out.println("</body>");
        out.println("</html>");
    }
}