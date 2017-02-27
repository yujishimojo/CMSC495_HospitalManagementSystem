

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
 * Servlet implementation class NewBed
 */
@WebServlet("/NewBed")
public class NewBed extends HttpServlet {
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
        response.sendRedirect(request.getContextPath() + "/NewBed.jsp");
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String room_id = request.getParameter("room_id");
        String bed_name = request.getParameter("bed_name");

        validationMap.clear();

        boolean checkRoomId = validateRoomId(room_id);
        boolean checkBedName = validateBedName(bed_name);

        if (checkRoomId && checkBedName) {
            try {
                /* Insert the form data to beds table. */
                String sql = "INSERT INTO"
                           + " beds (room_id, created_at, updated_at, name)"
                           + " VALUES (?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ?)";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(room_id));
                pstmt.setString(2, bed_name);
                pstmt.executeUpdate();

                pstmt.clearParameters();

                /* Get rooms.name and rooms.floor. */
                sql = "SELECT name, floor FROM rooms WHERE id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(room_id));
                ResultSet rs = pstmt.executeQuery();

                String room_name = null;
                int floor = 0;
                if (rs.next()) {
                    room_name = rs.getString(1);
                    floor = rs.getInt(2);
                } else {
                    validationMap.put("registration", "failed");
                    request.setAttribute("validationMap", validationMap);
                    request.getRequestDispatcher("/NewBed.jsp").forward(request, response);
                }

                /* Get the registration information from inserted records above, and forward it to NewBedResult.jsp. */
                sql = "SELECT id, name, room_id FROM beds WHERE room_id = ? AND name = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(room_id));
                pstmt.setString(2, bed_name);
                rs = pstmt.executeQuery();

                pstmt.clearParameters();

                ArrayList<String> list = new ArrayList<String>();

                if (rs.next()) {
                    list.add(String.valueOf(rs.getInt(1)));    // bed_id
                    list.add(rs.getString(2));   // bed_name
                    list.add(String.valueOf(rs.getInt(3)));    // room_id
                    list.add(room_name);    // room_name
                    list.add(String.valueOf(floor));    // floor
                    validationMap.put("registration", "successful");
                    request.setAttribute("validationMap", validationMap);
                    request.setAttribute("list", list);
                    request.getRequestDispatcher("/NewBedResult.jsp").forward(request, response);
                } else {
                    validationMap.put("registration", "failed");
                    request.setAttribute("validationMap", validationMap);
                    request.getRequestDispatcher("/NewBed.jsp").forward(request, response);
                }
            } catch (Exception e) {
                validationMap.put("registration", "failed");
                request.setAttribute("validationMap", validationMap);
                request.getRequestDispatcher("/NewBed.jsp").forward(request, response);
                e.printStackTrace();
            }
        } else {
            validationMap.put("registration", "failed");
            request.setAttribute("validationMap", validationMap);
            request.getRequestDispatcher("/NewBed.jsp").forward(request, response);
        }
    }

    protected boolean validateRoomId(String room_id) {
        if (room_id.equals(null) || room_id.equals("")) {
            validationMap.put("room_id", "empty");
            return false;
        } else if (Pattern.compile("^[0-9]$").matcher(room_id).find() == false) {  // must be a number
            validationMap.put("room_id", "invalid format");
            return false;
        } else {
            try {
                String sql = "SELECT id FROM rooms WHERE id = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);

                pstmt.setInt(1, Integer.parseInt(room_id));
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    validationMap.put("room_id", "OK");
                    return true;
                } else {
                    validationMap.put("room_id", "not found");
                    return false;
                }
            } catch (SQLException e) {
                   validationMap.put("room_id", "not found");
                log("SQLException:" + e.getMessage());
                   return false;
            }
        }
    }

//    protected boolean validateRoomName(String room_name) {
//        if (room_name.contains("'") || room_name.contains(";")) {
//            validationMap.put("room_name", "illegal characters");
//            return false;
//        } else if (room_name.equals("")) {
//            validationMap.put("room_name", "empty");
//            return false;
//        } else {
//            try {
//                String sql = "SELECT id FROM rooms WHERE name = ?";
//                PreparedStatement pstmt = conn.prepareStatement(sql);
//                pstmt.setString(1, room_name);
//                ResultSet rs = pstmt.executeQuery();
//
//                if (rs.next()) {
//                    validationMap.put("room_name", "OK");
//                    return true;
//                } else {
//                    validationMap.put("room_name", "not found");
//                    return false;
//                }
//            } catch (SQLException e) {
//                validationMap.put("room_name", "not found");
//                log("SQLException:" + e.getMessage());
//                return false;
//            }
//        }
//    }

    protected boolean validateBedName(String bed_name) {
        if (bed_name.contains("'") || bed_name.contains(";")) {
            validationMap.put("bed_name", "illegal characters");
            return false;
        } else if (bed_name.equals("")) {
            validationMap.put("bed_name", "empty");
            return false;
        } else if (bed_name.length() > 30) {
            validationMap.put("bed_name", "too long");
            return false;
        } else {
            validationMap.put("bed_name", "OK");
            return true;
        }
    }
}
