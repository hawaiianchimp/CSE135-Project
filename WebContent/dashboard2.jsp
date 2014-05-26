<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>


<t:header title="Dashboard2" />

<%
	Class.forName("org.postgresql.Driver");

	String uid = "" + session.getAttribute("id");
	if(uid.equals("null")) //redirect if not logged in
	{
		response.sendRedirect("redirect.jsp");
	}

	String role = ""+session.getAttribute("role");
	String action = ""+request.getParameter("action");
	String submit = ""+request.getParameter("submit");
	String category_name = ((""+request.getParameter("category")).equals("null")) ? "all":""+request.getParameter("category");
	String cid = ""+request.getParameter("cid");
	String pid = ""+request.getParameter("pid");
	String keyword = ""+request.getParameter("keyword");

	int c_offset = (request.getParameter("c_offset") != null) ? Integer.parseInt(""+request.getParameter("c_offset")):0;
	int r_offset = (request.getParameter("r_offset") != null) ? Integer.parseInt(""+request.getParameter("r_offset")):0;
	String disabled = "";
	if(c_offset + r_offset != 0)
	{
		disabled = "disabled";
	}
	keyword = (keyword.equals("null"))? "":keyword;
	
	
					Connection conn = DriverManager.getConnection(
				            "jdbc:postgresql://localhost/CSE135?" +
				            "user=Bonnie");  
					
	PreparedStatement pstmt = null, d_pstmt = null;
	Statement statement = null, d_statement = null;
	ResultSet rs = null, d_rs = null;
	String sql = null;
%>	

<!-- category menu -->
<%
	Connection c_conn = null;
	PreparedStatement c_pstmt = null;
	ResultSet c_rs = null;


		Class.forName("org.postgresql.Driver");
		c_pstmt = conn.prepareStatement("SELECT * FROM categories");
		c_rs = c_pstmt.executeQuery();
%>
	
	<!-- product search -->
	<div class="row">
		<div class="col-sm-4">
			<form class="navbar-form navbar-left" role="search" method="GET">
				<select class="form-control" name="scope">
		        	<option value="customers">Customers</option>
		        	
		        </select>
		        <input type="submit" value="Run Query" class="btn btn-default"/>
		    </form>
		    </div>
		<div class="col-sm-1">
		</div>
		<div class="col-sm-7">
		<form class="navbar-form navbar-left" role="search" action="dashboard.jsp" method="GET">
		        <select class="form-control" name="ages" <%= disabled %>>
		        	<option value="all">All Ages</option>
		        	<option value="1">12-18</option>
		        	<option value="2">18-45</option>
		        	<option value="3">45-65</option>
		        	<option value="4">65-</option>
		        </select>
		        <select class="form-control" name="category" <%= disabled %>>
		        	<option>All Categories</option>
		        	<% while(c_rs.next())
		        		{%>
		        		<option value="<%= c_rs.getString("id") %>"><%= c_rs.getString("name")%></option>
		        		<% }
		        		%>
		        </select>
		        <select class="form-control" name="state" <%= disabled %>>
		        	<option value="all">All States</option>
					<option value="AL">Alabama</option>
					<option value="AK">Alaska</option>
					<option value="AZ">Arizona</option>
					<option value="AR">Arkansas</option>
					<option value="CA">California</option>
					<option value="CO">Colorado</option>
					<option value="CT">Connecticut</option>
					<option value="DE">Delaware</option>
					<option value="DC">District Of Columbia</option>
					<option value="FL">Florida</option>
					<option value="GA">Georgia</option>
					<option value="HI">Hawaii</option>
					<option value="ID">Idaho</option>
					<option value="IL">Illinois</option>
					<option value="IN">Indiana</option>
					<option value="IA">Iowa</option>
					<option value="KS">Kansas</option>
					<option value="KY">Kentucky</option>
					<option value="LA">Louisiana</option>
					<option value="ME">Maine</option>
					<option value="MD">Maryland</option>
					<option value="MA">Massachusetts</option>
					<option value="MI">Michigan</option>
					<option value="MN">Minnesota</option>
					<option value="MS">Mississippi</option>
					<option value="MO">Missouri</option>
					<option value="MT">Montana</option>
					<option value="NE">Nebraska</option>
					<option value="NV">Nevada</option>
					<option value="NH">New Hampshire</option>
					<option value="NJ">New Jersey</option>
					<option value="NM">New Mexico</option>
					<option value="NY">New York</option>
					<option value="NC">North Carolina</option>
					<option value="ND">North Dakota</option>
					<option value="OH">Ohio</option>
					<option value="OK">Oklahoma</option>
					<option value="OR">Oregon</option>
					<option value="PA">Pennsylvania</option>
					<option value="RI">Rhode Island</option>
					<option value="SC">South Carolina</option>
					<option value="SD">South Dakota</option>
					<option value="TN">Tennessee</option>
					<option value="TX">Texas</option>
					<option value="UT">Utah</option>
					<option value="VT">Vermont</option>
					<option value="VA">Virginia</option>
					<option value="WA">Washington</option>
					<option value="WV">West Virginia</option>
					<option value="WI">Wisconsin</option>
					<option value="WY">Wyoming</option>
				</select>
				<input type="hidden" name="query" value="true"/>
		        <input type="submit"  class="btn btn-default"/>
		      </form>
		</div>
	</div>
	<div class="row">
		<!-- category menu -->
		<div class="col-sm-12">
			<%

class Item 
{
	private int id=0;
	private String name=null;
	private float amount_price=0f;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public float getAmount_price() {
		return amount_price;
	}
	public void setAmount_price(float amount_price) {
		this.amount_price = amount_price;
	}
}
ArrayList<Item> p_list=new ArrayList<Item>();
ArrayList<Item> s_list=new ArrayList<Item>();
Item item=null;
Statement stmt,stmt_2,stmt_3;
ResultSet rs_2=null,rs_3=null;
String SQL=null;
try
{
	try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
	stmt = conn.createStatement();
	stmt_2 =conn.createStatement();
	stmt_3 =conn.createStatement();
	/**SQL_1 for (state, amount)**/
		
	String SQL_1="select p.id, p.name, sum(c.quantity*p.price) as amount from products p, sales c "+
				 "where c.pid=p.id "+
				 "group by p.name,p.id "+
				 "order by  p.name asc "+
				 "limit 9" +
				 "offset " + c_offset;
	String SQL_2="select  u.state, sum(c.quantity*p.price) as amount from users u, sales c,  products p "+
				  "where c.uid=u.id and c.pid=p.id "+ 
				  "group by u.state "+ 
				  "order by u.state asc "+
				  "limit 19" +
				  "offset " + r_offset;

	rs=stmt.executeQuery(SQL_1);
	int p_id=0;
	String p_name=null;
	float p_amount_price=0;
	while(rs.next())
	{
		p_id=rs.getInt(1);
		p_name=rs.getString(2);
		p_amount_price=rs.getFloat(3);
		item=new Item();
		item.setId(p_id);
		item.setName(p_name);
		item.setAmount_price(p_amount_price);
		p_list.add(item);
	
	}
	
	rs_2=stmt_2.executeQuery(SQL_2);//state not id, many users in one state
	String s_name=null;
	float s_amount_price=0;
	while(rs_2.next())
	{
		s_name=rs_2.getString(1);
		s_amount_price=rs_2.getFloat(2);
		item=new Item();
		item.setName(s_name);
		item.setAmount_price(s_amount_price);
		s_list.add(item);
	}	
//    out.println("product #:"+p_list.size()+"<br>state #:"+s_list.size()+"<p>");
	int i=0,j=0;
	String SQL_3="";	
	float amount=0;
%>
	<table class="table">
		<tr align="center">
			<td><strong><font color="#FF0000">STATE</font></strong></td>
<%	
	for(i=0;i<p_list.size();i++)
	{
		p_id			=   p_list.get(i).getId();
		p_name			=	p_list.get(i).getName();
		p_amount_price	=	p_list.get(i).getAmount_price();
		out.print("<td> <strong>"+p_name+"<br>["+p_amount_price+"]</strong></td>");
	}
		
%>
			<td><form>
				<input type="hidden" name="r_offset" value="<%= (r_offset + 10) %>"/>
				<input type="hidden" name="c_offset" value="<%= c_offset%>"/>
				<input type="submit" class="btn btn-default" value="Next 10" />
			</form></td>
		</tr>
<%	
	for(i=0;i<s_list.size();i++)
	{
		s_name			=	s_list.get(i).getName();
		s_amount_price	=	s_list.get(i).getAmount_price();
		out.println("<tr  align=\"center\">");
		out.println("<td><strong>"+s_name+"[$"+s_amount_price+"]</strong></td>");
		for(j=0;j<p_list.size();j++)
		{
			p_id			=   p_list.get(j).getId();
			p_name			=	p_list.get(j).getName();
			p_amount_price	=	p_list.get(j).getAmount_price();
			
			SQL_3="select sum(c.quantity*p.price) as amount from users u, products p, sales c "+
				 "where c.uid=u.id and c.pid=p.id and u.state='"+s_name+"' and p.id='"+p_id+"' group by u.state, p.name";

			 rs_3=stmt_3.executeQuery(SQL_3);
			 if(rs_3.next())
			 {
				 amount=rs_3.getFloat(1);
				 out.print("<td><font color='#0000ff'>"+amount+"</font></td>");
			 }
			 else
			 {
			 	out.println("<td><font color='#ff0000'>0</font></td>");
			 }

		}
		out.println("</tr>");
	}
	
	session.setAttribute("TOP_10_Products",p_list);
%>
	</table>
<%
}
catch(Exception e)
{
	//out.println("<font color='#ff0000'>Error.<br><a href=\"login.jsp\" target=\"_self\"><i>Go Back to Home Page.</i></a></font><br>");
  out.println(e.getMessage());
}
finally
{
	conn.close();
}	
%>	
			<form>
				<input type="hidden" name="c_offset" value="<%= (c_offset + 20) %>"/>
				<input type="hidden" name="r_offset" value="<%= r_offset%>"/>
				<input type="submit" class="btn btn-default" value="Next 20 customers" />
			</form>
	
		</div>
	</div>
<t:footer />
