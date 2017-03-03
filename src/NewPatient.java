import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

/**
 * Servlet implementation class NewPatient
 */
@WebServlet("/NewPatient")
public class NewPatient extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    protected Connection conn = null;
    protected HashMap<String,String> validationMap = new HashMap<String,String>();

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
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/NewPatient.jsp");
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String firstname = request.getParameter("firstname");
        String middlename = request.getParameter("middlename");
        String lastname = request.getParameter("lastname");
        String ssn = request.getParameter("ssn");
        String date = request.getParameter("date");
        String doctor_firstname = request.getParameter("doctor_firstname");
        String doctor_lastname = request.getParameter("doctor_lastname");
        String patienttypegroup = request.getParameter("patienttypegroup");
        String address = request.getParameter("address");
        String insurance = request.getParameter("insurance");
        String pass1 = request.getParameter("pass1");

        int user_id = 0;
        int doctor_id = 0;

        validationMap.clear();

        boolean checkName = validateName(firstname, lastname);
        boolean checkSSN = validateSSN(ssn);
        boolean checkDoctor = validateDoctor(doctor_firstname, doctor_lastname);

        if (checkName && checkSSN && checkDoctor) {
            try {
                /* Insert the form data to users table. */
                String sql = "INSERT INTO"
                           + " users (created_at, updated_at, login_name, password, role, first_name, middle_name, last_name, social_security_number, address)"
                           + " VALUES (STR_TO_DATE(?, '%m/%d/%Y'), CURRENT_TIMESTAMP, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, date);
                pstmt.setString(2, firstname + "." + lastname);
                pstmt.setString(3, pass1);
                pstmt.setInt(4, 2);
                pstmt.setString(5, firstname);
                pstmt.setString(6, middlename);
                pstmt.setString(7, lastname);
                pstmt.setString(8, ssn);
                pstmt.setString(9, address);
                pstmt.executeUpdate();
                
                pstmt.clearParameters();

                /* Get users.id of the inserted record avobe. */
                sql = "SELECT id FROM users"
                    + " WHERE first_name = ? AND last_name = ? AND social_security_number = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, firstname);
                pstmt.setString(2, lastname);
                pstmt.setString(3, ssn);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    user_id = rs.getInt(1);
                } else {
                    validationMap.put("registration", "failed");
                    request.setAttribute("validationMap", validationMap);
                    request.getRequestDispatcher("/NewPatient.jsp").forward(request, response);
                }

                pstmt.clearParameters();

                /* Search for doctor_id of the inserted record by doctor_firstname and doctor_lastname. */
                sql = "SELECT d.id FROM users u"
                    + " INNER JOIN"
                    + " (SELECT id, user_id, is_doctor FROM staff) s"
                    + " ON u.id = s.user_id"
                    + " INNER JOIN"
                    + " (SELECT id, staff_id FROM doctors) d"
                    + " ON s.id = d.staff_id"
                    + " WHERE s.is_doctor = 1 AND u.first_name = ? AND u.last_name = ?";

                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, doctor_firstname);
                pstmt.setString(2, doctor_lastname);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    doctor_id = rs.getInt(1);
                } else {
                    validationMap.put("registration", "failed");
                    request.setAttribute("validationMap", validationMap);
                    request.getRequestDispatcher("/NewPatient.jsp").forward(request, response);
                }

                pstmt.clearParameters();

                /* Insert the form data, user_id, and doctor_id into patients table. */
                sql = "INSERT INTO"
                    + " patients (user_id, doctor_id, created_at, updated_at, type, insurance)"
                    + " VALUES (?, ?, STR_TO_DATE(?, '%m/%d/%Y'), CURRENT_TIMESTAMP, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, user_id);
                pstmt.setInt(2, doctor_id);
                pstmt.setString(3, date);
                if (patienttypegroup.equals("Inpatient")) {
                    pstmt.setInt(4, 0);
                } else if (patienttypegroup.equals("Outpatient")) {
                    pstmt.setInt(4, 1);
                }
                pstmt.setString(5, insurance);
                pstmt.executeUpdate();

                pstmt.clearParameters();

                /* Get the registration information from inserted records above, and forward it to NewPatientResult.jsp. */
                sql = "SELECT"
                    + " p.id, u1.login_name, u1.password, u1.first_name, u1.middle_name, u1.last_name,"
                    + " DATE_FORMAT(u1.created_at, '%m/%d/%Y'), d2.first_name, d2.last_name, p.type, u1.address, p.insurance"
                    + " FROM users u1"
                    + " INNER JOIN"
                    + " (SELECT id, user_id, type, insurance, doctor_id FROM patients) p"
                    + " ON u1.id = p.user_id"
                    + " INNER JOIN"
                    + " (SELECT u2.first_name, u2.last_name, d1.id FROM users u2"
                    + " INNER JOIN"
                    + " (SELECT * FROM staff) s"
                    + " ON u2.id = s.user_id"
                    + " INNER JOIN (SELECT * FROM doctors) d1"
                    + " ON s.id = d1.staff_id) d2"
                    + " ON p.doctor_id = d2.id"
                    + " WHERE u1.first_name = ? AND u1.last_name = ? AND u1.social_security_number = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, firstname);
                pstmt.setString(2, lastname);
                pstmt.setString(3, ssn);
                rs = pstmt.executeQuery();

                ArrayList<String> list = new ArrayList<String>();

                if (rs.next()) {
                    list.add(String.valueOf(rs.getInt(1)));    // patient_id
                    list.add(rs.getString(2));    // login_name
                    list.add(rs.getString(3));    // password
                    list.add(rs.getString(4));    // first_name
                    list.add(rs.getString(5));   // middle_name
                    list.add(rs.getString(6));   // last_name
                    list.add(rs.getString(7));   // DATE_FORMAT(created_at, '%m/%d/%Y')
                    list.add(rs.getString(8));   // doctor_firstname
                    list.add(rs.getString(9));   // doctor_lastname
                    if (rs.getInt(10) == 0) {    // type
                        list.add("Inpatient");
                    } else if (rs.getInt(10) == 1) {
                        list.add("Outpatient");
                    }
                    list.add(rs.getString(11));   // address
                    list.add(rs.getString(12));   // insurance
                    validationMap.put("registration", "successful");
                    request.setAttribute("validationMap", validationMap);
                    request.setAttribute("list", list);
                    request.getRequestDispatcher("/NewPatientResult.jsp").forward(request, response);
                } else {
                    validationMap.put("registration", "failed");
                    request.setAttribute("validationMap", validationMap);
                    request.getRequestDispatcher("/NewPatient.jsp").forward(request, response);
                }

            } catch (Exception e) {
                validationMap.put("registration", "failed");
                request.setAttribute("validationMap", validationMap);
                e.printStackTrace();
            }

        } else {
            validationMap.put("registration", "failed");
            request.setAttribute("validationMap", validationMap);
            request.getRequestDispatcher("/NewPatient.jsp").forward(request, response);
        }

    }

    protected boolean validateName(String firstname, String lastname) {
        try {
            String sql = "SELECT id FROM users WHERE first_name = ? AND last_name = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, firstname);
            pstmt.setString(2, lastname);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                validationMap.put("name", "in use");
                return false;
            } else {
                validationMap.put("name", "OK");
                return true;
            }
        } catch (SQLException e) {
               validationMap.put("name", "in use");
            log("SQLException:" + e.getMessage());
               return false;
        }
    }

    protected boolean validateSSN(String ssn) {
        try {
            String sql = "SELECT id FROM users WHERE social_security_number = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, ssn);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                validationMap.put("ssn", "in use");
                return false;
            } else {
                validationMap.put("ssn", "OK");
                return true;
            }
        } catch (SQLException e) {
               validationMap.put("ssn", "in use");
            log("SQLException:" + e.getMessage());
               return false;
        }
    }

    protected boolean validateDoctor(String doctor_firstname, String doctor_lastname) {
        try {
            String sql = "SELECT id FROM users"
                       + " WHERE id IN (SELECT user_id FROM staff"
                       + " WHERE id IN (SELECT staff_id FROM doctors)) AND first_name = ? AND last_name = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, doctor_firstname);
            pstmt.setString(2, doctor_lastname);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                validationMap.put("doctor_firstname", "OK");
                validationMap.put("doctor_lastname", "OK");
                return true;
            } else {
                validationMap.put("doctor_firstname", "not found");
                validationMap.put("doctor_lastname", "not found");
                return false;
            }
        } catch (SQLException e) {
            validationMap.put("doctor_firstname", "not found");
            validationMap.put("doctor_lastname", "not found");
            log("SQLException:" + e.getMessage());
            return false;
        }
    }
}
