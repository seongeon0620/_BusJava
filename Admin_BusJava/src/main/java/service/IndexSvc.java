package service;

import java.util.*;

import com.fasterxml.jackson.core.JsonProcessingException;

import dao.*;
import vo.*;

public class IndexSvc {
   private IndexDao indexDao;

   public void setIndexDao(IndexDao indexDao) {
      this.indexDao = indexDao;
   }

   public List<HashMap<String, Object>> getSales() {
      return indexDao.getSales();
   }

   public String getTopLine(String lineType) throws JsonProcessingException {
	   if (lineType.equals("high"))	lineType = "고속";
	   else	lineType = "시외";
      return indexDao.getTopLine(lineType);
   }

	public List<String> getSalesByQuarter(int i, String lineType) {
		if (lineType.equals("high")) lineType = "고속";
		else lineType = "시외";
		
		return indexDao.getSalesByQuarter(i, lineType);
	}
}