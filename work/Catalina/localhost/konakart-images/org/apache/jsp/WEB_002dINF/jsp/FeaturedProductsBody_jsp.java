/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.22
 * Generated at: 2014-03-20 05:43:49 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.WEB_002dINF.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class FeaturedProductsBody_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.HashMap<java.lang.String,java.lang.Long>(2);
    _jspx_dependants.put("/WEB-INF/kk.tld", Long.valueOf(1391230460000L));
    _jspx_dependants.put("/WEB-INF/jsp/Taglibs.jsp", Long.valueOf(1391230460000L));
  }

  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fkk_005fcarousel_0026_005fwidth_005ftitle_005fprods_005fnobody;

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _005fjspx_005ftagPool_005fkk_005fcarousel_0026_005fwidth_005ftitle_005fprods_005fnobody = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
  }

  public void _jspDestroy() {
    _005fjspx_005ftagPool_005fkk_005fcarousel_0026_005fwidth_005ftitle_005fprods_005fnobody.release();
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
      out.write("\r\n");
      out.write("\r\n");
 com.konakart.al.KKAppEng kkEng = (com.konakart.al.KKAppEng) session.getAttribute("konakartKey");
      out.write("\r\n");
      out.write("\t\t    \t\r\n");
      //  kk:carousel
      com.konakart.kktags.CarouselTag _jspx_th_kk_005fcarousel_005f0 = (com.konakart.kktags.CarouselTag) _005fjspx_005ftagPool_005fkk_005fcarousel_0026_005fwidth_005ftitle_005fprods_005fnobody.get(com.konakart.kktags.CarouselTag.class);
      _jspx_th_kk_005fcarousel_005f0.setPageContext(_jspx_page_context);
      _jspx_th_kk_005fcarousel_005f0.setParent(null);
      // /WEB-INF/jsp/FeaturedProductsBody.jsp(23,0) name = prods type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_kk_005fcarousel_005f0.setProds(kkEng.getProductMgr().getCustomProducts1());
      // /WEB-INF/jsp/FeaturedProductsBody.jsp(23,0) name = title type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_kk_005fcarousel_005f0.setTitle(kkEng.getMsg("featured.products.body.title"));
      // /WEB-INF/jsp/FeaturedProductsBody.jsp(23,0) name = width type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_kk_005fcarousel_005f0.setWidth(kkEng.getContentClass());
      int _jspx_eval_kk_005fcarousel_005f0 = _jspx_th_kk_005fcarousel_005f0.doStartTag();
      if (_jspx_th_kk_005fcarousel_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        _005fjspx_005ftagPool_005fkk_005fcarousel_0026_005fwidth_005ftitle_005fprods_005fnobody.reuse(_jspx_th_kk_005fcarousel_005f0);
        return;
      }
      _005fjspx_005ftagPool_005fkk_005fcarousel_0026_005fwidth_005ftitle_005fprods_005fnobody.reuse(_jspx_th_kk_005fcarousel_005f0);
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
