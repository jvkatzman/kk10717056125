/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.22
 * Generated at: 2014-03-20 03:08:48 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.WEB_002dINF.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class Menu_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.HashMap<java.lang.String,java.lang.Long>(2);
    _jspx_dependants.put("/WEB-INF/kk.tld", Long.valueOf(1378962218000L));
    _jspx_dependants.put("/WEB-INF/jsp/Taglibs.jsp", Long.valueOf(1378962218000L));
  }

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
  }

  public void _jspDestroy() {
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
        throws java.io.IOException, javax.servlet.ServletException {

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write('\r');
      out.write('\n');
      out.write("\r\n");
      out.write("\r\n");
      out.write('\r');
      out.write('\n');
 com.konakart.al.KKAppEng kkEng = (com.konakart.al.KKAppEng) session.getAttribute("konakartKey");
      out.write('\r');
      out.write('\n');
 com.konakart.al.CategoryMgr catMgr = kkEng.getCategoryMgr();
      out.write("\r\n");
      out.write("\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("    // Space out menu evenly\r\n");
      out.write("\t$(function() {\r\n");
      out.write("\t\tvar total=0;\r\n");
      out.write("\t\tvar itemArray = new Array();\r\n");
      out.write("\t\t$(\"#main-menu a\").each(function(index){\r\n");
      out.write("\t\t\tvar margin = $(this).css(\"margin-right\");\r\n");
      out.write("\t\t\tvar marginInt = parseInt(margin.substring(0, margin.length-2)); // remove px\r\n");
      out.write("\t\t\ttotal += ($(this).width()+marginInt);\r\n");
      out.write("\t\t\titemArray[index]=$(this).width();\r\n");
      out.write("\t\t});\t\t\r\n");
      out.write("\t\tvar width =  $(\"#page\").css(\"width\");\r\n");
      out.write("\t\tvar widthInt = parseInt(width.substring(0, width.length-2)); // remove px\t\r\n");
      out.write("\t\tvar extra = widthInt-total;\r\n");
      out.write("\t\textra = Math.floor((extra / itemArray.length));\r\n");
      out.write("\t\t$(\"#main-menu a\").each(function(index){$(this).width(itemArray[index]+extra);});\t\t\r\n");
      out.write("\t});\t\t\t\t\r\n");
      out.write("</script>");
      out.write("\r\n");
      out.write("\r\n");
      out.write("<div id=\"main-menu\">\r\n");
      out.write("\t");
for (int i = 0; i < catMgr.getCats().length; i++) {
      out.write("\r\n");
      out.write("\t\t");
com.konakart.appif.CategoryIf cat = catMgr.getCats()[i]; 
      out.write("\r\n");
      out.write("\t\t");
String menuClass; 
      out.write("\r\n");
      out.write("\t\t");
if (i == catMgr.getCats().length-1){ 
      out.write("\r\n");
      out.write("\t\t\t");
 menuClass = "menu-item rounded-corners last-child"; 
      out.write("\r\n");
      out.write("\t\t");
 } else { 
      out.write("\r\n");
      out.write("\t\t\t");
 menuClass = "menu-item rounded-corners"; 
      out.write("\r\n");
      out.write("\t\t");
 } 
      out.write("\r\n");
      out.write("\t\t<a href='");
      out.print("SelectCat.action?catId="+cat.getId());
      out.write("' class=\"");
      out.print(menuClass);
      out.write("\" style=\"width: auto;\">");
      out.print(cat.getName());
      out.write("</a>\r\n");
      out.write("\t");
 } 
      out.write("\t\t\t\t\t\r\n");
      out.write("</div>\r\n");
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try { out.clearBuffer(); } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
