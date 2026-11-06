package blogapi;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AuthFilter implements Filter {

    

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        String loginURI = httpRequest.getContextPath() + "/blogs";

        
        if (!isLoggedIn && !httpRequest.getRequestURI().equals(loginURI)) {
            httpResponse.sendRedirect(loginURI);
            return;
        }

        
        chain.doFilter(request, response);
    }

   
}
