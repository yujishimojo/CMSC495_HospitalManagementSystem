

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

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
 * Servlet implementation class MedicalFiles
 */
@WebServlet("/MedicalFiles")
public class MedicalFiles extends HttpServlet {
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
        HttpSession session = request.getSession(true);

        String login = (String)session .getAttribute("login");
        String role = (String)session.getAttribute("role");
        if (login == null || login != "OK") {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
        } else {
            if (role != "patient") {
                response.sendRedirect(request.getContextPath() + "/Home");
            }
            Integer user_id = (Integer)session.getAttribute("user_id");
            try {
                String sql = "SELECT"
                           + " DATE_FORMAT(pr.visit_date, '%m/%d/%Y'), p.id, u.first_name, u.middle_name, u.last_name,"
                           + " b.name, r.name, r.floor, DATE_FORMAT(bu.start_date, '%m/%d/%Y'), DATE_FORMAT(bu.end_date, '%m/%d/%Y'),"
                           + " bu.status, pr.disease_name, pr.treatment, pr.medicine_given, pr.medicine_name,"
                           + " pr.ambulance_service_used, pr.billing_amount, pr.medical_notes"
                           + " FROM users u"
                           + " INNER JOIN"
                           + " (SELECT id, user_id FROM patients) p"
                           + " ON u.id = p.user_id"
                           + " INNER JOIN"
                           + " (SELECT"
                           + " patient_id, visit_date, disease_name, treatment, medicine_given, medicine_name,"
                           + " ambulance_service_used, billing_amount, medical_notes"
                           + " FROM patient_records) pr"
                           + " ON p.id = pr.patient_id"
                           + " INNER JOIN"
                           + " (SELECT patient_id, bed_id, start_date, end_date, status FROM bed_usage) bu"
                           + " ON p.id = bu.patient_id"
                           + " INNER JOIN"
                           + " (SELECT id, name, room_id FROM beds) b"
                           + " ON bu.bed_id = b.id"
                           + " INNER JOIN"
                           + " (SELECT id, name, floor FROM rooms) r"
                           + " ON b.room_id = r.id"
                           + " WHERE u.id = ?"
                           + " ORDER BY pr.visit_date";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, user_id);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    rs.previous();
                    HashMap<Integer,String[]> map = new HashMap<Integer,String[]>();
                    int i = 0;
                    while (rs.next()) {
                        String array[] = new String[18];
                        array[0] = rs.getString(1);   // patient_records.visit_date
                        array[1] = String.valueOf(rs.getInt(2));   // patients.id
                        array[2] = rs.getString(3);   // users.first_name
                        array[3] = rs.getString(4);   // users.middle_name
                        array[4] = rs.getString(5);   // users.last_name
                        array[5] = rs.getString(6);   // beds.name
                        array[6] = rs.getString(7);   // rooms.name
                        array[7] = rs.getString(8);   // rooms.floor
                        array[8] = rs.getString(9);   // bed_usage.start_date
                        array[9] = rs.getString(10);  // bed_usage.end_date
                         if (rs.getInt(11) == 0) {   // bed_usage.status
                            array[10] = "Empty";
                        } else if (rs.getInt(11) == 1) {
                            array[10] = "Occupied";
                        }
                        array[11] = rs.getString(12);   // patient_records.disease_name
                        array[12] = rs.getString(13);   // patient_records.treatment
                        if (rs.getBoolean(14) == true) {    // patient_records.medicine_given
                            array[13] = "Yes";
                        } else if (rs.getBoolean(14) == false) {
                            array[13] = "No";
                        }
                        array[14] = rs.getString(15);   // patient_records.medicine_name
                        if (rs.getBoolean(16) == true) {    // patient_records.ambulance_service_used
                            array[15] = "Yes";
                        } else if (rs.getBoolean(16) == false) {
                            array[15] = "No";
                        }
                        array[16] = rs.getString(17);   // patient_records.billing_amount
                        array[17] = rs.getString(18);   // patient_records.medical_notes
                        map.put(i, array);
                        i++;
                    }
                    validationMap.put("medical_file", "found");
                    request.setAttribute("validationMap", validationMap);
                    request.setAttribute("map", map);
                    request.getRequestDispatcher("/MedicalFiles.jsp").forward(request, response);
                } else {
                	validationMap.put("medical_file", "not found");
                    request.setAttribute("validationMap", validationMap);
                	request.getRequestDispatcher("/MedicalFiles.jsp").forward(request, response);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
