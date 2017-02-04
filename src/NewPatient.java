import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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

		System.out.println("validationMap: " + validationMap);
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
			validationMap.put("registration", "successful");
			response.sendRedirect(request.getContextPath() + "/NewPatientResult.jsp");
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
	            log("SQLException:" + e.getMessage());
            	validationMap.put("ssn", "in use");
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
	            String sql = "SELECT id FROM users WHERE id IN (SELECT user_id FROM staff WHERE id IN (SELECT staff_id FROM doctors)) AND first_name = ? AND last_name = ?";
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
	            log("SQLException:" + e.getMessage());
    			validationMap.put("doctor_firstname", "not found");
    			validationMap.put("doctor_lastname", "not found");
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
