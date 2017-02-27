

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
 * Servlet implementation class NewRoom
 */
@WebServlet("/NewRoom")
public class NewRoom extends HttpServlet {
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
        response.sendRedirect(request.getContextPath() + "/NewRoom.jsp");
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String room_name = request.getParameter("room_name");
        String floor = request.getParameter("floor");

        validationMap.clear();

        boolean checkRoomName = validateRoomName(room_name);
        boolean checkFloor = validateFloor(floor);

        if (checkRoomName && checkFloor) {
            try {
                /* Insert the form data to rooms table. */
                String sql = "INSERT INTO"
                           + " rooms (created_at, updated_at, name, floor)"
                           + " VALUES (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, room_name);
                pstmt.setInt(2, Integer.parseInt(floor));
                pstmt.executeUpdate();

                pstmt.clearParameters();

                /* Get the registration information from inserted records above, and forward it to NewRoomResult.jsp. */
                sql = "SELECT id, name, floor FROM rooms WHERE name = ? AND floor = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, room_name);
                pstmt.setInt(2, Integer.parseInt(floor));
                ResultSet rs = pstmt.executeQuery();

                ArrayList<String> list = new ArrayList<String>();

                if (rs.next()) {
                    list.add(String.valueOf(rs.getInt(1)));    // room_id
                    list.add(rs.getString(2));    // room_name
                    list.add(String.valueOf(rs.getInt(3)));   // floor
                    validationMap.put("registration", "successful");
                    request.setAttribute("validationMap", validationMap);
                    request.setAttribute("list", list);
                    request.getRequestDispatcher("/NewRoomResult.jsp").forward(request, response);
                } else {
                    validationMap.put("registration", "failed");
                    request.setAttribute("validationMap", validationMap);
                    request.getRequestDispatcher("/NewRoom.jsp").forward(request, response);
                }
            } catch (Exception e) {
                validationMap.put("registration", "failed");
                request.setAttribute("validationMap", validationMap);
                request.getRequestDispatcher("/NewRoom.jsp").forward(request, response);
                e.printStackTrace();
            }
        } else {
            validationMap.put("registration", "failed");
            request.setAttribute("validationMap", validationMap);
            request.getRequestDispatcher("/NewRoom.jsp").forward(request, response);
        }
    }

    protected boolean validateRoomName(String room_name) {
        if (room_name.contains("'") || room_name.contains(";")) {
            validationMap.put("room_name", "illegal characters");
            return false;
        } else if (room_name.equals("")) {
            validationMap.put("room_name", "empty");
            return false;
        } else if (room_name.length() > 30) {
            validationMap.put("room_name", "too long");
            return false;
        } else {
            validationMap.put("room_name", "OK");
            return true;
        }
    }

    protected boolean validateFloor(String floor) {
        if (floor.equals(null) || floor.equals("")) {
            validationMap.put("floor", "empty");
            return false;
        } else if (Pattern.compile("^[0-9]{1,}$").matcher(floor).find() == false) {  // must be a number
            validationMap.put("floor", "invalid format");
            return false;
        } else {
            validationMap.put("floor", "OK");
            return true;
        }
    }
}
