import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

/**
 * Servlet implementation class Login
 */
@WebServlet("/Login")
public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;
 
    /**
     * @see HttpServlet#HttpServlet()
     */
    protected Connection conn = null;

    public void init() throws ServletException {
        try {
            Context ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/hygieia_db");
            conn = ds.getConnection();
        } catch (SQLException e) {
            log("SQLException:" + e.getMessage());
        } catch (Exception e) {
            log("Exception:" + e.getMessage());
        }
    }
      
    public void destroy() {
        try {
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            log("SQLException:" + e.getMessage());
        }
    }
    
    /**
    * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
    */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    
        String user = request.getParameter("user");
        String pass = request.getParameter("pass");

        HttpSession session = request.getSession(true);
    
        boolean check = authUser(user, pass);
        if (check) {
            /* authentication successful */
            session.setAttribute("login", "OK");
            session.setAttribute("status", "Auth");

            int role = getRole(user, pass);
            if (role == 0) {
                session.setAttribute("role", "admin");
            } else if (role == 1) {
                session.setAttribute("role", "staff");
            } else if (role == 2) {
                session.setAttribute("role", "patient");
            }

            int user_id = getUserId(user, pass);
            session.setAttribute("user_id", user_id);
            response.sendRedirect(request.getContextPath() + "/Home");
        } else {
            /* when authentication is failed, redirect to the login page. */
            session.setAttribute("status", "Not Auth");
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
        }
    }
    
    protected boolean authUser(String user, String pass) {
        if (user == null || user.length() == 0 || pass == null || pass.length() == 0) {
            return false;
        }
        try {
            String sql = "SELECT id FROM users WHERE login_name = ? AND password = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, user);
            pstmt.setString(2, pass);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return true;
            } else {
                return false;
            }
        } catch (SQLException e) {
            log("SQLException:" + e.getMessage());
            return false;
        }
    }

    protected int getRole(String user, String pass) {    
        try {
            String sql = "SELECT role FROM users WHERE login_name = ? AND password = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, user);
            pstmt.setString(2, pass);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            } else {
                return 0;
            }
        } catch (SQLException e) {
            log("SQLException:" + e.getMessage());
            return 0;
        }
    }

    protected int getUserId(String user, String pass) {    
        try {
            String sql = "SELECT id FROM users WHERE login_name = ? AND password = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, user);
            pstmt.setString(2, pass);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            } else {
                return 0;
            }
        } catch (SQLException e) {
            log("SQLException:" + e.getMessage());
            return 0;
        }
    }
}