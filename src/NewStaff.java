import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.regex.Pattern;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

/**
 * Servlet implementation class NewStaff
 */
@WebServlet("/NewStaff")
public class NewStaff extends HttpServlet {
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
        response.sendRedirect(request.getContextPath() + "/NewStaff.jsp");
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String firstname = request.getParameter("firstname");
        String middlename = request.getParameter("middlename");
        String lastname = request.getParameter("lastname");
        String ssn = request.getParameter("ssn");
        String stafftypegroup = request.getParameter("stafftypegroup");
        String address = request.getParameter("address");
        String qualification = request.getParameter("qualification");
        String expiration = request.getParameter("expiration");
        String cell = request.getParameter("cell");
        String email = request.getParameter("email");
        String payroll = request.getParameter("payroll");
        String details = request.getParameter("details");
        String pass1 = request.getParameter("pass1");
        String clock_in_time = request.getParameter("clock_in_time");
        String clock_out_time = request.getParameter("clock_out_time");
        String status = request.getParameter("status");

        int user_id = 0;
        int staff_id = 0;
        int doctor_id = 0;

        validationMap.clear();

        boolean checkFirstname = validateFirstname(firstname);
        boolean checkMiddlename = validateMiddlename(middlename);
        boolean checkLastname = validateLastname(lastname);
        boolean checkSSN = validateSSN(ssn);
        boolean checkAddress = validateAddress(address);
        boolean checkQualification = validateQualification(qualification);
        boolean checkExpiration = validateExpiration(expiration);
        boolean checkCell = validateCell(cell);
        boolean checkEmail = validateEmail(email);
        boolean checkPayroll = validatePayroll(payroll);
        boolean checkDetails = validateDetails(details);
        boolean checkClockInTime = validateClockInTime(clock_in_time);
        boolean checkClockOutTime = validateClockOutTime(clock_out_time);
        boolean checkClockInOutTimes = validateClockInOutTimes(clock_in_time, clock_out_time);

//        System.out.println("checkClockInTime: " + checkClockInTime);
//        System.out.println("checkClockOutTime: " + checkClockOutTime);
//        System.out.println("checkClockInOutTimes: " + checkClockInOutTimes);

        if (checkFirstname && checkMiddlename && checkLastname && checkSSN && checkAddress
                && checkQualification && checkExpiration && checkCell && checkEmail && checkPayroll
                && checkDetails && checkClockInTime && checkClockOutTime && checkClockInOutTimes) {

            try {
                /* Insert the form data to users table. */
                String sql = "INSERT INTO"
                           + " users (created_at, updated_at, login_name, password, role, first_name, middle_name, last_name, social_security_number, address)"
                           + " VALUES (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, firstname + "." + lastname);
                pstmt.setString(2, pass1);
                pstmt.setInt(3, 2);
                pstmt.setString(4, firstname);
                pstmt.setString(5, middlename);
                pstmt.setString(6, lastname);
                pstmt.setString(7, ssn);
                pstmt.setString(8, address);
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
                    request.getRequestDispatcher("/NewStaff.jsp").forward(request, response);
                }

                pstmt.clearParameters();

                /* Insert the form data and user_id into staff table. */
                sql = "INSERT INTO staff (user_id, created_at, updated_at, qualification, certification_expirations, cell_phone_number, email_address, payroll, personal_details, is_doctor)"
                    + " VALUES (?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ?, STR_TO_DATE(?, '%m/%d/%Y'), ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, user_id);
                pstmt.setString(2, qualification);
                pstmt.setString(3, expiration);
                pstmt.setString(4, cell);
                pstmt.setString(5, email);
                pstmt.setString(6, payroll);
                pstmt.setString(7, details);
                if (stafftypegroup.equals("Staff")) {
                    pstmt.setBoolean(8, false);
                } else if (stafftypegroup.equals("Doctor")) {
                    pstmt.setBoolean(8, true);
                }
                pstmt.executeUpdate();

                pstmt.clearParameters();

                /* Get staff_id of the inserted record avobe. */
                sql = "SELECT id FROM staff WHERE user_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, user_id);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    staff_id = rs.getInt(1);
                } else {
                    validationMap.put("registration", "failed");
                    request.setAttribute("validationMap", validationMap);
                    request.getRequestDispatcher("/NewStaff.jsp").forward(request, response);
                }

                pstmt.clearParameters();

                if (stafftypegroup.equals("Doctor")) {
                    /* Insert the form data into doctors table. */
                    sql = "INSERT INTO doctors (staff_id, created_at, updated_at) VALUES (?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, staff_id);
                    pstmt.executeUpdate();

                    pstmt.clearParameters();
                }

                if (!clock_in_time.equals("") || !clock_out_time.equals("")) {
                    /* Insert the form data into shifts table. */
                    sql = "INSERT INTO shifts (staff_id, created_at, updated_at, clock_in_time, clock_out_time, status)"
                        + " VALUES (?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ?, ?, ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, staff_id);
                    pstmt.setString(2, clock_in_time);
                    pstmt.setString(3, clock_out_time);
                    if (status.equals("Normal")) {
                        pstmt.setInt(4, 0);
                    } else if (status.equals("Emergency")) {
                        pstmt.setInt(4, 1);
                    }
                    pstmt.executeUpdate();

                    pstmt.clearParameters();
                }

                /* Get the registration information from inserted records above, and forward it to NewStaffResult.jsp. */
                sql = "SELECT"
                    + " s.id, u.login_name, u.password, u.first_name, u.middle_name, u.last_name, u.social_security_number,"
                    + " u.address, s.qualification, DATE_FORMAT(s.certification_expirations, '%m/%d/%Y'),"
                    + " s.cell_phone_number, s.email_address, s.payroll, s.personal_details, s.is_doctor"
                    + " FROM users u"
                    + " INNER JOIN"
                    + " (SELECT id, user_id, qualification, certification_expirations,"
                    + " cell_phone_number, email_address, payroll, personal_details, is_doctor"
                    + " FROM staff) s"
                    + " ON u.id = s.user_id"
                    + " WHERE u.first_name = ? AND u.last_name = ? AND u.social_security_number = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, firstname);
                pstmt.setString(2, lastname);
                pstmt.setString(3, ssn);
                rs = pstmt.executeQuery();

                ArrayList<String> profile = new ArrayList<String>();
                ArrayList<String> shift = new ArrayList<String>();

                if (rs.next()) {
                    staff_id = rs.getInt(1);
                    profile.add(String.valueOf(staff_id));    // staff_id
                    profile.add(rs.getString(2));    // login_name
                    profile.add(rs.getString(3));    // password
                    profile.add(rs.getString(4));    // first_name
                    profile.add(rs.getString(5));   // middle_name
                    profile.add(rs.getString(6));   // last_name
                    profile.add(rs.getString(7));   // social_security_number
                    profile.add(rs.getString(8));   // address
                    profile.add(rs.getString(9));   // qualification
                    profile.add(rs.getString(10));   // DATE_FORMAT(certification_expirations, '%m/%d/%Y')
                    profile.add(rs.getString(11));   // cell_phone_number
                    profile.add(rs.getString(12));   // email_address
                    profile.add(rs.getString(13));   // payroll
                    profile.add(rs.getString(14));   // personal_details
                    if (rs.getBoolean(15) == false) {    // is_doctor
                        profile.add("Staff");
                    } else if (rs.getBoolean(15) == true) {
                        profile.add("Doctor");
                        pstmt.clearParameters();
                        sql = "SELECT id FROM doctors WHERE staff_id = " + staff_id;
                        pstmt = conn.prepareStatement(sql);
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                            doctor_id = rs.getInt(1);
                        }
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
                    validationMap.put("registration", "successful");
                    request.setAttribute("profile", profile);
                    request.setAttribute("shift", shift);
                    request.setAttribute("doctor_id", doctor_id);
                    request.getRequestDispatcher("/NewStaffResult.jsp").forward(request, response);
                } else {
                    validationMap.put("registration", "failed");
                    request.setAttribute("validationMap", validationMap);
                    request.getRequestDispatcher("/NewStaff.jsp").forward(request, response);
                }

            } catch (Exception e) {
                validationMap.put("registration", "failed");
                request.setAttribute("validationMap", validationMap);
                request.getRequestDispatcher("/NewStaff.jsp").forward(request, response);
                e.printStackTrace();
            }

        } else {
            validationMap.put("registration", "failed");
            request.setAttribute("validationMap", validationMap);
            request.getRequestDispatcher("/NewStaff.jsp").forward(request, response);
        }

    }

    protected boolean validateFirstname(String firstname) {
        if (Pattern.compile(".*[0-9].*").matcher(firstname).find() || Pattern.compile(".*\\s.*").matcher(firstname).find()
                || firstname.contains("'") || firstname.contains(";")) {
            validationMap.put("firstname", "illegal characters");
            return false;
        } else if (firstname.equals(null) || firstname.equals("")) {
            validationMap.put("firstname", "empty");
            return false;
        } else if (firstname.length() > 30) {
            validationMap.put("firstname", "too long");
            return false;
        } else {
            validationMap.put("firstname", "OK");
            return true;
        }
    }

    protected boolean validateMiddlename(String middlename) {
        if (Pattern.compile(".*[0-9].*").matcher(middlename).find() || Pattern.compile(".*\\s.*").matcher(middlename).find()
                || middlename.contains("'") || middlename.contains(";")) {
            validationMap.put("middlename", "illegal characters");
            return false;
        } else if (middlename.length() > 30) {
            validationMap.put("middlename", "too long");
            return false;
        } else {
            validationMap.put("middlename", "OK");
            return true;
        }
    }

    protected boolean validateLastname(String lastname) {
        if (Pattern.compile(".*[0-9].*").matcher(lastname).find() || Pattern.compile(".*\\s.*").matcher(lastname).find()
                || lastname.contains("'") || lastname.contains(";")) {
            validationMap.put("lastname", "illegal characters");
            return false;
        } else if (lastname.equals(null) || lastname.equals("")) {
            validationMap.put("lastname", "empty");
            return false;
        } else if (lastname.length() > 30) {
            validationMap.put("lastname", "too long");
            return false;
        } else {
            validationMap.put("lastname", "OK");
            return true;
        }
    }

    protected boolean validateSSN(String ssn) {
        if (Pattern.compile(".*\\s.*").matcher(ssn).find() || ssn.contains("'") || ssn.contains(";")) {
            validationMap.put("ssn", "illegal characters");
            return false;
        } else if (ssn.equals(null) || ssn.equals("")) {
            validationMap.put("ssn", "empty");
            return false;
        } else if (Pattern.compile("^[0-9]{9}").matcher(ssn).find() == false) {
            validationMap.put("ssn", "invalid format");
            return false;
        } else {
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
    }

    protected boolean validateAddress(String address) {
        if (address.length() > 100) {
            validationMap.put("address", "too long");
            return false;
        } else {
            validationMap.put("address", "OK");
            return true;
        }
    }

    protected boolean validateExpiration(String expiration) {
        if (expiration.equals(null) || expiration.equals("")) {
            validationMap.put("expiration", "empty");
            return false;
        } else if (Pattern.compile("^[0-9]{2}/[0-9]{2}/[0-9]{4}").matcher(expiration).find() == false) {  // must be MM/DD/YYYY
            validationMap.put("expiration", "invalid format");
            return false;
        } else {
            validationMap.put("expiration", "OK");
            return true;
        }
    }

    protected boolean validateQualification(String qualification) {
        if (qualification.equals(null) || qualification.equals("")) {
            validationMap.put("qualification", "empty");
            return false;
        } else if (qualification.length() > 50) {
            validationMap.put("qualification", "too long");
            return false;
        } else {
            validationMap.put("qualification", "OK");
            return true;
        }
    }

    protected boolean validateCell(String cell) {
        if (cell.length() > 20) {
            validationMap.put("cell", "too long");
            return false;
        } else {
            validationMap.put("cell", "OK");
            return true;
        }
    }

    protected boolean validateEmail(String email) {
        if (email.length() > 50) {
            validationMap.put("email", "too long");
            return false;
        } else {
            validationMap.put("email", "OK");
            return true;
        }
    }

    protected boolean validatePayroll(String payroll) {
        if (payroll.equals(null) || payroll.equals("")) {
            validationMap.put("payroll", "empty");
            return false;
        } else if (payroll.length() > 30) {
            validationMap.put("payroll", "too long");
            return false;
        } else {
            validationMap.put("payroll", "OK");
            return true;
        }
    }

    protected boolean validateDetails(String details) {
        if (details.length() > 500) {
            validationMap.put("details", "too long");
            return false;
        } else {
            validationMap.put("details", "OK");
            return true;
        }
    }

    protected boolean validateInsurance(String insurance) {
        if (insurance.length() > 100) {
            validationMap.put("insurance", "too long");
            return false;
        } else {
            validationMap.put("insurance", "OK");
            return true;
        }
    }

    protected boolean validateClockInTime(String clock_in_time) {
        if (!clock_in_time.equals("") && Pattern.compile("^[0-9]{2}:[0-9]{2}:[0-9]{2}").matcher(clock_in_time).find() == false) {  // must be hh:mm:ss
            validationMap.put("clock_in_time", "invalid format");
            return false;
        } else {
            validationMap.put("clock_in_time", "OK");
            return true;
        }
    }

    protected boolean validateClockOutTime(String clock_out_time) {
        if (!clock_out_time.equals("") && Pattern.compile("^[0-9]{2}:[0-9]{2}:[0-9]{2}").matcher(clock_out_time).find() == false) {  // must be hh:mm:ss
            validationMap.put("clock_out_time", "invalid format");
            return false;
        } else {
            validationMap.put("clock_out_time", "OK");
            return true;
        }
    }

    protected boolean validateClockInOutTimes(String clock_in_time, String clock_out_time) {
        if (!clock_in_time.equals("") && clock_out_time.equals("")) {
            validationMap.put("clock_in_time", "missing");
            return false;
        } else if (clock_in_time.equals("") && !clock_out_time.equals("")) {
            validationMap.put("clock_out_time", "missing");
            return false;
        } else {
            return true;
        }
    }
}
