package dao;

import java.util.*;
import java.sql.*;
import javax.sql.*;

import org.omg.PortableInterceptor.SYSTEM_EXCEPTION;
import org.springframework.jdbc.core.*;
import org.springframework.jdbc.support.*;
import vo.*;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class IndexDao {
   private JdbcTemplate jdbc;
   public IndexDao(DataSource dataSource) {
      this.jdbc = new JdbcTemplate(dataSource);
   }
   public List<HashMap<String, Object>> getSales() {
      String sql = "SELECT '어제' AS TITLE, COUNT(RI.RI_IDX) COUNT, IFNULL(SUM(CR.CR_PMONEY + CR.CR_PAY), 0) SALES"
    		  		+ " FROM T_COUNT_RINFO CR"
    		  		+ " JOIN T_RESERVATION_INFO RI ON CR.RI_IDX = RI.RI_IDX" 
    		  		+ " WHERE RI.RI_STATUS = '예매' AND CR.CR_DATE = adddate(curdate(), -1)"
    		  		+ " UNION ALL"
    		  		+ " SELECT '일주일', COUNT(RI.RI_IDX) COUNT, IFNULL(SUM(CR.CR_PMONEY + CR.CR_PAY), 0) SALES"
    		  		+ " FROM T_COUNT_RINFO CR"
    		  		+ " JOIN T_RESERVATION_INFO RI ON CR.RI_IDX = RI.RI_IDX" 
    		  		+ " WHERE RI.RI_STATUS = '예매' AND CR.CR_DATE >= adddate(curdate(), -7)"
    		  		+ " UNION ALL" 
    		  		+ " SELECT '이번달', COUNT(RI.RI_IDX) COUNT, IFNULL(SUM(CR.CR_PMONEY + CR.CR_PAY), 0) SALES" 
    		  		+ " FROM T_COUNT_RINFO CR"
    		  		+ " JOIN T_RESERVATION_INFO RI ON CR.RI_IDX = RI.RI_IDX"
    		  		+ " WHERE RI.RI_STATUS = '예매' AND MID(CR.CR_DATE, 6, 2) = MID(curdate(), 6, 2)"
    		  		+ " UNION ALL"
    		  		+ " SELECT '올해', COUNT(RI.RI_IDX) COUNT, IFNULL(SUM(CR.CR_PMONEY + CR.CR_PAY), 0) SALES"
    		  		+ " FROM T_COUNT_RINFO CR"
    		  		+ " JOIN T_RESERVATION_INFO RI ON CR.RI_IDX = RI.RI_IDX"
    		  		+ " WHERE RI.RI_STATUS = '예매' AND LEFT(CR.CR_DATE, 4) = LEFT(curdate(), 4)";
	List<HashMap<String, Object>> recentSales = jdbc.query(sql, new RowMapper<HashMap<String, Object>>() {
		@Override
		public HashMap<String, Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
		HashMap<String, Object> result = new HashMap<String, Object>();
			result.put("Title", rs.getString("TITLE"));
        	result.put("Count", rs.getString("COUNT"));
        	result.put("Sales", rs.getInt("SALES"));
            
            return result;
         }
      }
   );
      
      return recentSales;
   }
   public String getTopLine(String lineType) throws JsonProcessingException {
      String sql = "SELECT CONCAT(RI_FR, ' - ', RI_TO) LINE_NAME, SUM(RI_ACNT + RI_SCNT + RI_CCNT) COUNT"
    		  		+ " FROM T_RESERVATION_INFO"
    		  		+ " WHERE RI_STATUS = '예매' AND RI_LINE_TYPE = ?"
    		  		+ " GROUP BY RI_FR, RI_TO"
    		  		+ " ORDER BY COUNT DESC"
    		  		+ " LIMIT 0, 4";
    		  
      List<HashMap<String, Object>> topLineList = jdbc.query(sql, new RowMapper<HashMap<String, Object>>() {
    	  @Override
    	  public HashMap<String, Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
    		  HashMap<String, Object> result = new HashMap<String, Object>();
    		  result.put("line_name", rs.getString("LINE_NAME"));
    		  result.put("count", rs.getInt("COUNT"));
                  
    		  return result;
    	  		}
            }, lineType
         );
      
      // ObjectMapper를 사용하여 List를 JSON 문자열로 변환
      ObjectMapper objectMapper = new ObjectMapper();
      return objectMapper.writeValueAsString(topLineList);
   }
   
	public List<String> getSalesByQuarter(int i, String lineType) {
		String sql = "SELECT IFNULL(SUM(CR.CR_PMONEY + CR.CR_PAY), 0) SALES"
				+ " FROM T_COUNT_RINFO CR"
				+ " JOIN T_RESERVATION_INFO RI ON CR.RI_IDX = RI.RI_IDX"
				+ " WHERE RI.RI_LINE_TYPE = ? AND RI.RI_STATUS = '예매' AND YEAR(CR.CR_DATE) = LEFT(curdate(), 4) - " + i + " AND QUARTER(CR.CR_DATE) = 1"
				+ " UNION ALL"
				+ " SELECT IFNULL(SUM(CR.CR_PMONEY + CR.CR_PAY), 0) SALES"
				+ " FROM T_COUNT_RINFO CR"
				+ " JOIN T_RESERVATION_INFO RI ON CR.RI_IDX = RI.RI_IDX"
				+ " WHERE RI.RI_LINE_TYPE = ? AND RI.RI_STATUS = '예매' AND YEAR(CR.CR_DATE) = LEFT(curdate(), 4) - " + i + " AND QUARTER(CR.CR_DATE) = 2"
				+ " UNION ALL"
				+ " SELECT IFNULL(SUM(CR.CR_PMONEY + CR.CR_PAY), 0) SALES"
				+ " FROM T_COUNT_RINFO CR"
				+ " JOIN T_RESERVATION_INFO RI ON CR.RI_IDX = RI.RI_IDX"
				+ " WHERE RI.RI_LINE_TYPE = ? AND RI.RI_STATUS = '예매' AND YEAR(CR.CR_DATE) = LEFT(curdate(), 4) - " + i + " AND QUARTER(CR.CR_DATE) = 3"
				+ " UNION ALL"
				+ " SELECT IFNULL(SUM(CR.CR_PMONEY + CR.CR_PAY), 0) SALES"
				+ " FROM T_COUNT_RINFO CR"
				+ " JOIN T_RESERVATION_INFO RI ON CR.RI_IDX = RI.RI_IDX"
				+ " WHERE RI.RI_LINE_TYPE = ? AND RI.RI_STATUS = '예매' AND YEAR(CR.CR_DATE) = LEFT(curdate(), 4) - " + i + " AND QUARTER(CR.CR_DATE) = 4";
				
		List<String> salesQuarterList = jdbc.query(sql, (ResultSet rs, int rowNum) -> {
	        return rs.getString("sales");
	     }, lineType, lineType, lineType, lineType);
	     
	     return salesQuarterList;
	}
}