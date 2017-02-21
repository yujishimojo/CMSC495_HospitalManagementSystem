

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

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
 * Servlet implementation class Home
 */
@WebServlet("/Home")
public class Home extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    protected Connection conn = null;

    public void init() throws ServletException {

        try {
            Context ctx = new InitialContext();
            DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/hygieia_db");
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
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(true);

        String login = (String)session .getAttribute("login");
        if (login == null || login != "OK") {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
        } else {
            ArrayList<String> profile = new ArrayList<String>();
            ArrayList<String> shift = new ArrayList<String>();
            int staff_id = 0;
            int doctor_id = 0;

            String role = (String)session.getAttribute("role");
            Integer user_id = (Integer)session.getAttribute("user_id");
            if (role.equals("admin")) {   // in case of admin role
                try {
                    String sql = "SELECT id, login_name, first_name, middle_name, last_name, address"
                               + " FROM users"
                               + " WHERE id = ?";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, user_id);
                    ResultSet rs = pstmt.executeQuery();
                    if (rs.next()) {
                        profile.add("Administrator");    // role
                        profile.add(String.valueOf(rs.getInt(1)));    // users.id
                        profile.add(rs.getString(2));    // login_name
                        profile.add(rs.getString(3));    // first_name
                        profile.add(rs.getString(4));   // middle_name
                        profile.add(rs.getString(5));   // last_name
                        profile.add(rs.getString(6));   // address
                        request.setAttribute("profile", profile);
                        request.setAttribute("shift", shift);
                        request.setAttribute("role", role);
                        request.setAttribute("doctor_id", doctor_id);
                        request.getRequestDispatcher("/Home.jsp").forward(request, response);
                    } else {
                        request.getRequestDispatcher("/Login.jsp").forward(request, response);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else if (role.equals("staff")) {   // in case of medical staff role
                try {
                    String sql = "SELECT"
                               + " s.id, u.login_name, u.first_name, u.middle_name, u.last_name,"
                               + " u.address, s.qualification, DATE_FORMAT(s.certification_expirations, '%m/%d/%Y'),"
                               + " s.cell_phone_number, s.email_address, s.payroll, s.personal_details, s.is_doctor"
                               + " FROM users u"
                               + " INNER JOIN"
                               + " (SELECT id, user_id, qualification, certification_expirations,"
                               + " cell_phone_number, email_address, payroll, personal_details, is_doctor"
                               + " FROM staff) s"
                               + " ON u.id = s.user_id"
                               + " WHERE u.id = ?";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, user_id);
                    ResultSet rs = pstmt.executeQuery();
                    if (rs.next()) {
                        profile.add("Medical Staff");    // role
                        staff_id = rs.getInt(1);
                        profile.add(String.valueOf(staff_id));    // staff_id
                        profile.add(rs.getString(2));    // login_name
                        profile.add(rs.getString(3));    // first_name
                        profile.add(rs.getString(4));   // middle_name
                        profile.add(rs.getString(5));   // last_name
                        profile.add(rs.getString(6));   // address
                        profile.add(rs.getString(7));   // qualification
                        profile.add(rs.getString(8));   // certification_expirations
                        profile.add(rs.getString(9));   // cell_phone_number
                        profile.add(rs.getString(10));   // email_address
                        profile.add(rs.getString(11));   // payroll
                        profile.add(rs.getString(12));   // personal_details
                        if (rs.getBoolean(13)) {   // is_doctor
                            pstmt.clearParameters();
                            sql = "SELECT id FROM doctors WHERE staff_id = " + staff_id;
                            pstmt = conn.prepareStatement(sql);
                            rs = pstmt.executeQuery();
                            if (rs.next()) {
                                doctor_id = rs.getInt(1);
                            }
                        }
                    } else {
                        request.getRequestDispatcher("/Login.jsp").forward(request, response);
                    }
                    pstmt.clearParameters();
                    sql = "SELECT clock_in_time, clock_out_time, status FROM shifts WHERE staff_id = " + staff_id;
                    pstmt = conn.prepareStatement(sql);
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        shift.add(rs.getString(1));    // clock_in_time
                        shift.add(rs.getString(2));    // clock_out_time
                        if (rs.getInt(3) == 0) {   // status
                            shift.add("Normal");
                        } else if (rs.getInt(3) == 1) {
                            shift.add("Emergency");
                        }
                    }
                    request.setAttribute("profile", profile);
                    request.setAttribute("shift", shift);
                    request.setAttribute("role", role);
                    request.setAttribute("doctor_id", doctor_id);
                    request.getRequestDispatcher("/Home.jsp").forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else if (role.equals("patient")) {   // in case of patient role
                try {
                    String sql = "SELECT"
                               + " p.id, u1.login_name, u1.first_name, u1.middle_name, u1.last_name,"
                               + " u1.address, DATE_FORMAT(u1.created_at, '%m/%d/%Y'),"
                               + " d2.first_name, d2.last_name, p.type, p.insurance"
                               + " FROM users u1"
                               + " INNER JOIN"
                               + " (SELECT id, user_id, type, insurance, doctor_id FROM patients) p"
                               + " ON u1.id = p.user_id"
                               + " INNER JOIN"
                               + " (SELECT u2.first_name, u2.last_name, d1.id FROM users u2"
                               + " INNER JOIN"
                               + " (SELECT id, user_id FROM staff) s"
                               + " ON u2.id = s.user_id"
                               + " INNER JOIN"
                               + " (SELECT id, staff_id FROM doctors) d1 ON s.id = d1.staff_id) d2"
                               + " ON p.doctor_id = d2.id"
                               + " WHERE u1.id = ?";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, user_id);
                    ResultSet rs = pstmt.executeQuery();
                    if (rs.next()) {
                        profile.add("Patient");    // role
                        profile.add(String.valueOf(rs.getInt(1)));    // patient_id
                        profile.add(rs.getString(2));    // login_name
                        profile.add(rs.getString(3));    // first_name
                        profile.add(rs.getString(4));   // middle_name
                        profile.add(rs.getString(5));   // last_name
                        profile.add(rs.getString(6));   // address
                        profile.add(rs.getString(7));   // DATE_FORMAT(created_at, '%m/%d/%Y')
                        profile.add(rs.getString(8));   // doctor_firstname
                        profile.add(rs.getString(9));   // doctor_lastname
                        if (rs.getInt(10) == 0) {    // type
                            profile.add("Inpatient");
                        } else if (rs.getInt(10) == 1) {
                            profile.add("Outpatient");
                        }
                        profile.add(rs.getString(11));   // insurance
                        request.setAttribute("profile", profile);
                        request.setAttribute("shift", shift);
                        request.setAttribute("role", role);
                        request.setAttribute("doctor_id", doctor_id);
                        request.getRequestDispatcher("/Home.jsp").forward(request, response);
                    } else {
                        request.getRequestDispatcher("/Login.jsp").forward(request, response);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
