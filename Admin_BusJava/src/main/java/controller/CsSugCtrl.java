package controller;

import java.io.*;
import java.net.*;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.*;

import javax.servlet.http.*;
import java.util.*;
import service.*;
import vo.*;

@Controller
public class CsSugCtrl {
	private CsSugSvc csSugSvc;
	
	public void setCsSugSvc(CsSugSvc csSugSvc) {
		this.csSugSvc = csSugSvc;
	}
	
	@GetMapping("/suggestionList")
	public String SuggestionList(Model model, HttpServletRequest request) throws Exception {

		return "/cs/suggestion_list";
	}
	
	
}
