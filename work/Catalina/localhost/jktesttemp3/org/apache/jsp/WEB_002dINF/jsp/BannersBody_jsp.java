/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.22
 * Generated at: 2014-03-01 05:53:01 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.WEB_002dINF.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class BannersBody_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      out.write("\r\n");
      out.write("\r\n");
      out.write("\t<div id=\"slideshow\"  class=\"rounded-corners\" >\r\n");
      out.write("\t\t");
if ((int) (Math.random() * 100) > 50) { 
      out.write("\r\n");
      out.write("\t\t\t<a href=\"SelectProd.action?prodId=34\"><div id=\"slide-1\" class=\"slide rounded-corners\" style=\"background-image: url('");
      out.print(kkEng.getImageBase());
      out.write("/banners/home-page/kindle-fire-hd.jpg');\"></div></a>\r\n");
      out.write("\t\t");
 } else { 
      out.write("\r\n");
      out.write("\t\t\t<a href=\"SelectProd.action?prodId=33\"><div id=\"slide-1\" class=\"slide rounded-corners\" style=\"background-image: url('");
      out.print(kkEng.getImageBase());
      out.write("/banners/home-page/delonghi.jpg');\"></div></a> \r\n");
      out.write("\t\t");
 } 
      out.write(" \r\n");
      out.write("\t</div>\r\n");
      out.write("\t<div id=\"banners\">\r\n");
      out.write("\t\t<a href=\"ShowSpecials.action\"><div id=\"banner-1\" class=\"banner-small rounded-corners\" style=\"background-image: url('");
      out.print(kkEng.getImageBase());
      out.write("/banners/home-page/electronics-sale.jpg');\"></div></a>\r\n");
      out.write("\t\t<a href=\"SelectCat.action?catId=24\"><div id=\"banner-2\" class=\"banner-small rounded-corners\" style=\"background-image: url('");
      out.print(kkEng.getImageBase());
      out.write("/banners/home-page/gifts-for-the-home.jpg');\"></div></a>\r\n");
      out.write("\r\n");
      out.write("\t\t");
if ((int) (Math.random() * 100) > 50) { 
      out.write("\r\n");
      out.write("\t\t<a href=\"SelectProd.action?prodId=32\"><div id=\"banner-2\" class=\"banner-small rounded-corners\" style=\"background-image: url('");
      out.print(kkEng.getImageBase());
      out.write("/banners/home-page/windows-8.jpg');\"></div></a>\r\n");
      out.write("\t\t");
 } else { 
      out.write("\r\n");
      out.write("\t\t<a href=\"SelectCat.action?catId=23\"><div id=\"banner-2\" class=\"banner-small rounded-corners\" style=\"background-image: url('");
      out.print(kkEng.getImageBase());
      out.write("/banners/home-page/electronics-sale-2.jpg');\"></div></a>\r\n");
      out.write("\t\t");
 } 
      out.write(" \r\n");
      out.write("\r\n");
      out.write("\t\t<a href=\"SelectProd.action?prodId=35\"><div id=\"banner-2\" class=\"banner-small rounded-corners last-child\" style=\"background-image: url('");
      out.print(kkEng.getImageBase());
      out.write("/banners/home-page/iphone-5.jpg');\"></div></a>\r\n");
      out.write("\t</div>\r\n");
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
