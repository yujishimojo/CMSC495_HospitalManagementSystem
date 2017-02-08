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

		boolean checkFirstname = validateFirstname(firstname);
		boolean checkMiddlename = validateMiddlename(middlename);
		boolean checkLastname = validateLastname(lastname);
		boolean checkSSN = validateSSN(ssn);
		boolean checkDate = validateDate(date);
		boolean checkDoctor = validateDoctor(doctor_firstname, doctor_lastname);
		boolean checkAddress = validateAddress(address);
		boolean checkInsurance = validateInsurance(insurance);

		if (checkFirstname && checkMiddlename && checkLastname && checkSSN
				&& checkDate && checkDoctor && checkAddress && checkInsurance) {

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
                    + " VALUES (?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ?, ?)";
	        	pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, user_id);
	            pstmt.setInt(2, doctor_id);
	            if (patienttypegroup.equals("Inpatient")) {
	            	pstmt.setInt(3, 0);
	            } else if (patienttypegroup.equals("Outpatient")) {
	            	pstmt.setInt(3, 1);
	            }
	            pstmt.setString(4, insurance);
	            pstmt.executeUpdate();

	            pstmt.clearParameters();

	            /* Get the registration information from inserted records above, and forward it to NewPatientResult.jsp. */
                sql = "SELECT"
                    + " p.id, u1.login_name, u1.password, u1.first_name, u1.middle_name, u1.last_name, u1.social_security_number,"
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
	            	list.add(rs.getString(7));   // social_security_number
	            	list.add(rs.getString(8));   // DATE_FORMAT(created_at, '%m/%d/%Y')
	            	list.add(rs.getString(9));   // doctor_firstname
	            	list.add(rs.getString(10));   // doctor_lastname
	            	if (rs.getInt(11) == 0) {    // type
	            		list.add("Inpatient");
	            	} else if (rs.getInt(11) == 1) {
	            		list.add("Outpatient");
	            	}
	            	list.add(rs.getString(12));   // address
	            	list.add(rs.getString(13));   // insurance

	    			validationMap.put("registration", "successful");
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
    			request.getRequestDispatcher("/NewPatient.jsp").forward(request, response);
	        	e.printStackTrace();
	        } finally {
	            if (conn != null) {
	                try {
	                    conn.close();
	                } catch (SQLException sqlEx) {

	                }
	            }
	        }

		} else {
			validationMap.put("registration", "failed");
			request.setAttribute("validationMap", validationMap);
			request.getRequestDispatcher("/NewPatient.jsp").forward(request, response);
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

	protected boolean validateDate(String date) {
		if (date.equals(null) || date.equals("")) {
			validationMap.put("date", "empty");
			return false;
		} else if (Pattern.compile("^[0-9]{2}/[0-9]{2}/[0-9]{4}").matcher(date).find() == false) {  // must be MM/DD/YYYY
			validationMap.put("date", "invalid format");
			return false;
		} else {
			validationMap.put("date", "OK");
			return true;
		}
	}

	protected boolean validateDoctor(String doctor_firstname, String doctor_lastname) {
		if (doctor_firstname.equals(null) || doctor_firstname.equals("")) {
			validationMap.put("doctor_firstname", "empty");
			return false;
		} else if (doctor_lastname.equals(null) || doctor_lastname.equals("")) {
			validationMap.put("doctor_lastname", "empty");
			return false;
		} else {
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

	protected boolean validateAddress(String address) {
		if (address.length() > 100) {
			validationMap.put("address", "too long");
			return false;
		} else {
			validationMap.put("address", "OK");
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

}
