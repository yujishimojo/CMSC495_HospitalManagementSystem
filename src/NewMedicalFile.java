

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
 * Servlet implementation class NewMedicalFile
 */
@WebServlet("/NewMedicalFile")
public class NewMedicalFile extends HttpServlet {
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
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/NewMedicalFile.jsp");
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String patient_id = request.getParameter("patient_id");
        String visit_date = request.getParameter("visit_date");
        String bed_name = request.getParameter("bed_name");
        String start_date = request.getParameter("start_date");
        String end_date = request.getParameter("end_date");
        String disease = request.getParameter("disease");
        String treatment = request.getParameter("treatment");
        String medicine_given = request.getParameter("medicine_given");
        String medicine_name = request.getParameter("medicine_name");
        String notes = request.getParameter("notes");
        String ambulance = request.getParameter("ambulance");
        String billing_amount = request.getParameter("billing_amount");

        int bed_id = 0;

        validationMap.clear();

        boolean checkPatientId = validatePatientId(patient_id);
        boolean checkVisitDate = validateVisitDate(visit_date);
        boolean checkBedName = validateBedName(bed_name);
        boolean checkStartDate = validateStartDate(start_date);
        boolean checkEndDate = validateEndDate(end_date);
        boolean checkDisease = validateDisease(disease);
        boolean checkTreatment = validateTreatment(treatment);
        boolean checkMedicineName = validateMedicineName(medicine_name);
        boolean checkNotes = validateNotes(notes);
        boolean checkBillingAmount = validateBillingAmount(billing_amount);

        if (checkPatientId && checkVisitDate && checkBedName && checkStartDate && checkEndDate
                && checkDisease && checkTreatment && checkMedicineName && checkNotes && checkBillingAmount) {

            try {

                /* Get beds_id. */
                String sql = "SELECT id FROM beds WHERE name = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, bed_name);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    bed_id = rs.getInt(1);
                } else {
                    validationMap.put("registration", "failed");
                    request.setAttribute("validationMap", validationMap);
                    request.getRequestDispatcher("/NewMedicalFile.jsp").forward(request, response);
                }

                pstmt.clearParameters();

                /* Insert the form data to patient_records table. */
                sql = "INSERT INTO"
                    + " patient_records (patient_id, bed_id, created_at, updated_at, visit_date, disease_name, treatment, medicine_given, medicine_name, medical_notes, ambulance_service_used, billing_amount)"
                    + " VALUES (?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, STR_TO_DATE(?, '%m/%d/%Y'), ?, ?, ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(patient_id));
                pstmt.setInt(2, bed_id);
                pstmt.setString(3, visit_date);
                pstmt.setString(4, disease);
                pstmt.setString(5, treatment);
                if (medicine_given.equals("on")) {
                    pstmt.setBoolean(6, true);
                } else if (medicine_given.equals("off")) {
                    pstmt.setBoolean(6, false);
                }
                pstmt.setString(7, medicine_name);
                pstmt.setString(8, notes);
                if (ambulance.equals("on")) {
                    pstmt.setBoolean(9, true);
                } else if (ambulance.equals("off")) {
                    pstmt.setBoolean(9, false);
                }
                pstmt.setString(10, billing_amount);
                pstmt.executeUpdate();

                pstmt.clearParameters();

                /* Insert the form data to bed_usage table. */
                sql = "INSERT INTO"
                    + " bed_usage (bed_id, patient_id, created_at, updated_at, start_date, end_date, status)"
                    + " VALUES (?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, STR_TO_DATE(?, '%m/%d/%Y'), STR_TO_DATE(?, '%m/%d/%Y'), 1)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, bed_id);
                pstmt.setInt(2, Integer.parseInt(patient_id));
                pstmt.setString(3, start_date);
                pstmt.setString(4, end_date);
                pstmt.executeUpdate();

                pstmt.clearParameters();

                /* Get patient name of the inserted record avobe */
                sql = "SELECT first_name, middle_name, last_name FROM users u"
                    + " INNER JOIN (SELECT id, user_id FROM patients) p"
                    + " ON u.id = p.user_id WHERE p.id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(patient_id));
                rs = pstmt.executeQuery();

                String firstname = null;
                String middlename = null;
                String lastname = null;
                if (rs.next()) {
                    firstname = rs.getString(1);
                    middlename = rs.getString(2);
                    lastname = rs.getString(3);
                } else {
                    validationMap.put("registration", "failed");
                    request.setAttribute("validationMap", validationMap);
                    request.getRequestDispatcher("/NewMedicalFIle.jsp").forward(request, response);
                }

                pstmt.clearParameters();

                /* Get rooms.name and rooms.floor of the inserted record avobe */
                sql = "SELECT r.name, r.floor FROM beds b"
                    + " INNER JOIN (SELECT id, name, floor FROM rooms) r"
                    + " ON b.room_id = r.id"
                    + " WHERE b.id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, bed_id);
                rs = pstmt.executeQuery();

                String room_name = null;
                int floor = 0;
                if (rs.next()) {
                    room_name = rs.getString(1);
                    floor = rs.getInt(2);
                } else {
                    validationMap.put("registration", "failed");
                    request.setAttribute("validationMap", validationMap);
                    request.getRequestDispatcher("/NewMedicalFIle.jsp").forward(request, response);
                }

                pstmt.clearParameters();

                /* Get the registration information from inserted records above, and forward it to NewMedicalFileResult.jsp. */
                sql = "SELECT"
                    + " p.patient_id, p.visit_date, b.start_date, b.end_date, b.status, p.disease_name, p.treatment,"
                    + " p.medicine_given, p.medicine_name, p.ambulance_service_used, p.billing_amount, p.medical_notes"
                    + " FROM patient_records p"
                    + " INNER JOIN"
                    + " (SELECT bed_id, patient_id, start_date, end_date, status FROM bed_usage) b"
                    + " ON p.bed_id = b.bed_id"
                    + " WHERE p.patient_id = ? AND p.bed_id = ? AND b.patient_id = ? AND b.bed_id = ? AND b.status = 1";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(patient_id));
                pstmt.setInt(2, bed_id);
                pstmt.setInt(3, Integer.parseInt(patient_id));
                pstmt.setInt(4, bed_id);
                rs = pstmt.executeQuery();

                ArrayList<String> list = new ArrayList<String>();
                ArrayList<String> bedUsage = new ArrayList<String>();
                ArrayList<String> medicine = new ArrayList<String>();

                if (rs.next()) {
                    list.add(String.valueOf(rs.getInt(1)));    // patient_id
                    String patientname = null;
                    if (middlename.equals(null) || middlename.equals("")) {
                        patientname = firstname + " " + lastname;
                    } else {
                        patientname = firstname + " " + middlename + " " + lastname;
                    }
                    list.add(patientname);    // patient_name
                    list.add(rs.getString(2));    // date of visit
                    list.add(bed_name);    // bed name
                    list.add(room_name);   // room name
                    list.add(String.valueOf(floor));   // floor
                    bedUsage.add(rs.getString(3));   // start bed date
                    bedUsage.add(rs.getString(4));   // end bed date
                    if (rs.getInt(5) == 1) {   // bed status
                        bedUsage.add("Occupied");
                    } else if (rs.getInt(5) == 0) {
                        bedUsage.add("Empty");
                    }
                    list.add(rs.getString(6));   // disease name
                    list.add(rs.getString(7));   // treatment
                    if (rs.getBoolean(8) == true) {    // medicine given
                        medicine.add("Yes");
                        medicine.add(rs.getString(9));   // medicine name
                    } else if (rs.getBoolean(8) == false) {
                        medicine.add("No");
                    }
                    if (rs.getBoolean(10) == true) {    // ambulance service used
                        list.add("Yes");
                    } else if (rs.getBoolean(10) == false) {
                        list.add("No");
                    }
                    list.add(rs.getString(11));   // billing amount
                    list.add(rs.getString(12));   // medical notes

                    validationMap.put("registration", "successful");
                    request.setAttribute("list", list);
                    request.setAttribute("bedUsage", bedUsage);
                    request.setAttribute("medicine", medicine);
                    request.getRequestDispatcher("/NewMedicalFileResult.jsp").forward(request, response);
                } else {
                    validationMap.put("registration", "failed");
                    request.setAttribute("validationMap", validationMap);
                    request.getRequestDispatcher("/NewMedicalFilet.jsp").forward(request, response);
                }

            } catch (Exception e) {
                validationMap.put("registration", "failed");
                request.setAttribute("validationMap", validationMap);
                request.getRequestDispatcher("/NewMedicalFile.jsp").forward(request, response);
                e.printStackTrace();
            }


        } else {
            validationMap.put("registration", "failed");
            request.setAttribute("validationMap", validationMap);
            request.getRequestDispatcher("/NewMedicalFile.jsp").forward(request, response);
        }
    }

    protected boolean validatePatientId(String patient_id) {
        if (patient_id.equals(null) || patient_id.equals("")) {
            validationMap.put("patient_id", "empty");
            return false;
        } else if (Pattern.compile("^[0-9]*").matcher(patient_id).find() == false) {  // must be a number
            validationMap.put("patient_id", "invalid format");
            return false;
        } else {
            try {
                String sql = "SELECT id FROM patients WHERE id = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);

                pstmt.setInt(1, Integer.parseInt(patient_id));
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    validationMap.put("patient_id", "OK");
                    return true;
                } else {
                    validationMap.put("patient_id", "not found");
                    return false;
                }
            } catch (SQLException e) {
                   validationMap.put("patient_id", "not found");
                log("SQLException:" + e.getMessage());
                   return false;
            }
        }
    }

    protected boolean validateVisitDate(String visit_date) {
        if (visit_date.equals(null) || visit_date.equals("")) {
            validationMap.put("visit_date", "empty");
            return false;
        } else if (Pattern.compile("^[0-9]{2}/[0-9]{2}/[0-9]{4}").matcher(visit_date).find() == false) {  // must be MM/DD/YYYY
            validationMap.put("visit_date", "invalid format");
            return false;
        } else {
            validationMap.put("visit_date", "OK");
            return true;
        }
    }

    protected boolean validateBedName(String bed_name) {
        if (bed_name.equals(null) || bed_name.equals("")) {
            validationMap.put("bed_name", "empty");
            return false;
        } 
        else if (bed_name.contains("'") || bed_name.contains(";"))
        {
            validationMap.put("bed_name", "You have entered an illegal character.");
            return false;
        }
        else {
            try {
                String sql = "SELECT id FROM beds WHERE name = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, bed_name);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    validationMap.put("bed_name", "OK");
                    return true;
                } else {
                    validationMap.put("bed_name", "not found");
                    return false;
                }
            } catch (SQLException e) {
                validationMap.put("bed_name", "not found");
                log("SQLException:" + e.getMessage());
                return false;
            }
        }
    }

    protected boolean validateStartDate(String start_date) {
        if (start_date.equals(null) || start_date.equals("")) {
            validationMap.put("start_date", "empty");
            return false;
        } else if (Pattern.compile("^[0-9]{2}/[0-9]{2}/[0-9]{4}").matcher(start_date).find() == false) {  // must be MM/DD/YYYY
            validationMap.put("start_date", "invalid format");
            return false;
        } else {
            validationMap.put("start_date", "OK");
            return true;
        }
    }

    protected boolean validateEndDate(String end_date) {
        if (Pattern.compile("^[0-9]{2}/[0-9]{2}/[0-9]{4}").matcher(end_date).find() == false) {  // must be MM/DD/YYYY
            validationMap.put("end_date", "invalid format");
            return false;
        } else {
            validationMap.put("end_date", "OK");
            return true;
        }
    }

    protected boolean validateDisease(String disease) {
        if (disease.equals(null) || disease.equals("")) {
            validationMap.put("disease", "empty");
            return false;
        } else if (disease.length() > 500) {
            validationMap.put("disease", "too long");
            return false;
        } else if (disease.contains("'") || disease.contains(";")) {
            validationMap.put("disease", "illegal characters");
            return false;
        } else {
            validationMap.put("disease", "OK");
            return true;
        }
    }

    protected boolean validateTreatment(String treatment) {
        if (treatment.equals(null) || treatment.equals("")) {
            validationMap.put("treatment", "empty");
            return false;
        } else if (treatment.length() > 1000) {
            validationMap.put("treatment", "too long");
            return false;
        } else if (treatment.contains("'") || treatment.contains(";")) {
            validationMap.put("treatment", "illegal characters");
            return false;
        } else {
            validationMap.put("treatment", "OK");
            return true;
        }
    }

    protected boolean validateMedicineName(String medicine_name) {
        if (medicine_name.length() > 500) {
            validationMap.put("medicine_name", "too long");
            return false;
        } else if (medicine_name.contains("'") || medicine_name.contains(";")) {
            validationMap.put("medicine_name", "illegal characters");
            return false;
        } else {
            validationMap.put("medicine_name", "OK");
            return true;
        }
    }

    protected boolean validateNotes(String notes) {
        if (notes.length() > 1000) {
            validationMap.put("notes", "too long");
            return false;
        } else if (notes.contains("'") || notes.contains(";")) {
            validationMap.put("notes", "illegal characters");
            return false;
        } else {
            validationMap.put("notes", "OK");
            return true;
        }
    }

    protected boolean validateBillingAmount(String billing_amount) {
        if (billing_amount.equals(null) || billing_amount.equals("")) {
            validationMap.put("billing_amount", "empty");
            return false;
        } else if (billing_amount.length() > 30) {
            validationMap.put("billing_amount", "too long");
            return false;
        } else if (Pattern.compile("[0-9]{1,27}.[0-9]{2}").matcher(billing_amount).find() == false){
            validationMap.put("billing_amount", "invalid format");
            return false;
        } else {
            validationMap.put("billing_amount", "OK");
            return true;
        }
    }
}