package com.exam.filter;

import java.io.IOException;

import com.exam.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(urlPatterns = {"/admin/*", "/student/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest =
                (HttpServletRequest) request;

        HttpServletResponse httpResponse =
                (HttpServletResponse) response;

        // Prevent browser caching of protected pages
        httpResponse.setHeader(
                "Cache-Control",
                "no-cache, no-store, must-revalidate");

        httpResponse.setHeader("Pragma", "no-cache");
        httpResponse.setHeader("Expires", "0");

        // Get existing session
        HttpSession session =
                httpRequest.getSession(false);

        User user = null;

        if (session != null) {
            user = (User) session.getAttribute("user");
        }

        // User is not logged in
        if (user == null) {

            httpResponse.sendRedirect(
                    httpRequest.getContextPath()
                    + "/login.jsp?error=Please login first");

            return;
        }

        String requestURI = httpRequest.getRequestURI();

        // Admin page protection
        if (requestURI.contains("/admin/")) {

            if (!"ADMIN".equalsIgnoreCase(user.getRole())) {

                httpResponse.sendRedirect(
                        httpRequest.getContextPath()
                        + "/student/dashboard.jsp?error=Access denied");

                return;
            }
        }

        // Student page protection
        if (requestURI.contains("/student/")) {

            if (!"STUDENT".equalsIgnoreCase(user.getRole())) {

                httpResponse.sendRedirect(
                        httpRequest.getContextPath()
                        + "/admin/dashboard.jsp?error=Access denied");

                return;
            }
        }

        // User is authenticated and has correct role
        chain.doFilter(request, response);
    }
}