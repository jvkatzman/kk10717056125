/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.22
 * Generated at: 2014-03-01 05:16:35 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.WEB_002dINF.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class CategoryBannersBody_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.HashMap<java.lang.String,java.lang.Long>(2);
    _jspx_dependants.put("/WEB-INF/kk.tld", Long.valueOf(1391230460000L));
    _jspx_dependants.put("/WEB-INF/jsp/Taglibs.jsp", Long.valueOf(1391230460000L));
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
 com.konakart.appif.MiscItemIf[] miscItems = kkEng.getCategoryMgr().getCurrentCat().getMiscItems();
      out.write("\r\n");
      out.write("\r\n");
if (miscItems != null && miscItems.length > 0){
      out.write('\r');
      out.write('\n');
      out.write('	');
 com.konakart.appif.MiscItemIf banner1 = miscItems[0];
      out.write('\r');
      out.write('\n');
      out.write('	');
if (banner1.getCustom1() != null && banner1.getCustom1().length() > 0){
      out.write("\r\n");
      out.write("\t\t<a href=\"");
      out.print(banner1.getCustom1());
      out.write("\"><div id=\"banner\" class=\"rounded-corners\" style=\"background-image: url('");
      out.print(kkEng.getImageBase());
      out.write('/');
      out.print(banner1.getItemValue());
      out.write("');\"></div></a> \t\r\n");
      out.write("\t");
 } else { 
      out.write("\r\n");
      out.write("\t\t<div id=\"banner\" class=\"rounded-corners\" style=\"background-image: url('");
      out.print(kkEng.getImageBase());
      out.write('/');
      out.print(banner1.getItemValue());
      out.write("');\"></div>\r\n");
      out.write("\t");
 } 
      out.write("\t\r\n");
      out.write("\t");
if (miscItems.length > 2){
      out.write("\r\n");
      out.write("\t\t<div id=\"banners\">\r\n");
      out.write("\t\t");
 com.konakart.appif.MiscItemIf banner2 = miscItems[1];
      out.write("\r\n");
      out.write("\t\t");
if (banner2.getCustom1() != null && banner2.getCustom1().length() > 0){
      out.write("\r\n");
      out.write("\t\t\t<a href=\"");
      out.print(banner2.getCustom1());
      out.write("\"><div class=\"banner-double rounded-corners\" style=\"background-image: url('");
      out.print(kkEng.getImageBase());
      out.write('/');
      out.print(banner2.getItemValue());
      out.write("');\"></div></a> \t\r\n");
      out.write("\t\t");
 } else { 
      out.write("\r\n");
      out.write("\t\t\t<div class=\"banner-double rounded-corners\" style=\"background-image: url('");
      out.print(kkEng.getImageBase());
      out.write('/');
      out.print(banner2.getItemValue());
      out.write("');\"></div>\r\n");
      out.write("\t\t");
 } 
      out.write("\t\r\n");
      out.write("\t\t");
 com.konakart.appif.MiscItemIf banner3 = miscItems[2];
      out.write("\r\n");
      out.write("\t\t");
if (banner3.getCustom1() != null && banner3.getCustom1().length() > 0){
      out.write("\r\n");
      out.write("\t\t\t<a href=\"");
      out.print(banner3.getCustom1());
      out.write("\"><div class=\"banner-small rounded-corners last-child\" style=\"background-image: url('");
      out.print(kkEng.getImageBase());
      out.write('/');
      out.print(banner3.getItemValue());
      out.write("');\"></div></a> \t\r\n");
      out.write("\t\t");
 } else { 
      out.write("\r\n");
      out.write("\t\t\t<div class=\"banner-small rounded-corners last-child\" style=\"background-image: url('");
      out.print(kkEng.getImageBase());
      out.write('/');
      out.print(banner3.getItemValue());
      out.write("');\"></div>\r\n");
      out.write("\t\t");
 } 
      out.write("\t\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t");
 } 
      out.write('\r');
      out.write('\n');
 } 
      out.write("\r\n");
      out.write("\r\n");
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