<nav aria-label="Page navigation example" class="mt-4">
	<ul class="pagination justify-content-center">
			<% if (pi.getCpage() == 1 ) { %>          
		        <li class="page-item">
			    	<span class="page-link" aria-hidden="true">&laquo;</span>
			    </li>
			<% } else if (pi.getCpage() > 1)  { %>
				<li class="page-item">
			        <a class="page-link" href="<%= request.getAttribute("url") %>?cpage=<%=pi.getCpage() - 1 %><%=pi.getSchargs() %>" aria-label="Previous">
			        	<span aria-hidden="true">&laquo;</span>
			        </a>
			    </li>
			<% }
			int endPage = (pi.getSpage() + pi.getBsize() - 1 <= pi.getPcnt()) ? pi.getSpage() + pi.getBsize() - 1 : pi.getPcnt();
			for (int i = pi.getSpage(); i <= endPage; i++) { 
				if (i == pi.getCpage()) { 	%>
			        <li class="page-item active"><a class="page-link" ><%=i%></a></li>
			<% } else if (i != pi.getCpage()) { %>
					<li class="page-item"><a class="page-link" href="<%= request.getAttribute("url") %>?cpage=<%=i%><%=pi.getSchargs() %>"><%=i%></a></li>
			<% }
			}	%>
			<%  if (pi.getCpage() < pi.getPcnt()) { %>             
		        <li class="page-item">
		          <a class="page-link" href="<%= request.getAttribute("url") %>?cpage=<%=pi.getCpage() + 1 %><%=pi.getSchargs() %>" aria-label="Next">
		            <span aria-hidden="true">&raquo;</span>
		          </a>
		        </li>
			<% } else if (pi.getCpage() == pi.getPcnt()) { %>     
				<li class="page-item">
		           <span class="page-link" aria-hidden="true">&raquo;</span>
		      	</li>
		<% 	} %>  
	</ul>
</nav>