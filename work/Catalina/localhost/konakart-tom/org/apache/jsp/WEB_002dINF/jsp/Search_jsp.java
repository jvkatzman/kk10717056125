/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.22
 * Generated at: 2014-03-28 20:48:26 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.WEB_002dINF.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class Search_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.HashMap<java.lang.String,java.lang.Long>(2);
    _jspx_dependants.put("/WEB-INF/kk.tld", Long.valueOf(1378962218000L));
    _jspx_dependants.put("/WEB-INF/jsp/Taglibs.jsp", Long.valueOf(1378962218000L));
  }

  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody;

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
  }

  public void _jspDestroy() {
    _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.release();
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
 boolean useSolr = kkEng.isUseSolr();
      out.write('\r');
      out.write('\n');
 boolean showCookieWarning = !kkEng.isAgreedCookies();
      out.write("\r\n");
      out.write("\r\n");
if (useSolr) { 
      out.write("\t\t\t\t\t\t\r\n");
      out.write("\t");
      out.write("<script type=\"text/javascript\">\t\r\n");
      out.write("\t/*\r\n");
      out.write("\t * Autocomplete widget\r\n");
      out.write("\t */\r\n");
      out.write("\t$(function() {\r\n");
      out.write("\t\t$( \"#search-input\" ).autocomplete({\r\n");
      out.write("\t\t\tsource: function(request, response) {\r\n");
      out.write("\t\t\t\tif (document.getElementById('kk_portlet_id'))  {\r\n");
      out.write("\t\t\t\t\tAUI().ready('liferay-portlet-url', function(A) { \r\n");
      out.write("\t\t\t\t        var renderURL = Liferay.PortletURL.createResourceURL();\r\n");
      out.write("\t\t\t\t        renderURL.setParameter(\"struts.portlet.action\", \"/SuggestedSearch.action\");\r\n");
      out.write("\t\t\t\t        renderURL.setPortletId(document.getElementById('kk_portlet_id').value);\r\n");
      out.write("\t\t\t\t        renderURL.setWindowState(\"exclusive\");\r\n");
      out.write("\t\t\t\t\t\trenderURL.setParameter(\"term\", request.term);\r\n");
      out.write("\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t$.ajax({\r\n");
      out.write("\t\t\t\t\t\ttype : 'POST',\r\n");
      out.write("\t\t\t\t\t\ttimeout : '20000',\r\n");
      out.write("\t\t\t\t\t\tscriptCharset : \"utf-8\",\r\n");
      out.write("\t\t\t\t\t\tcontentType : \"application/json; charset=utf-8\",\r\n");
      out.write("\t\t\t\t\t\turl : renderURL.toString(),\r\n");
      out.write("\t\t\t\t\t\tdataType : 'json',\r\n");
      out.write("\t\t\t\t\t\tdata : null,\r\n");
      out.write("\t\t\t\t\t       success: function(result, textStatus, jqXHR) {\t\t\t\t\t         \r\n");
      out.write("\t\t\t\t\t      \t\tresponse(result);\r\n");
      out.write("\t\t\t\t\t      }\r\n");
      out.write("\t\t\t\t\t    });\r\n");
      out.write("\t\t\t\t\t});\t\r\n");
      out.write("\t\t\t\t} else {\r\n");
      out.write("\t\t\t\t     $.ajax({\r\n");
      out.write("\t\t\t\t \t\ttype : 'POST',\r\n");
      out.write("\t\t\t\t\t\ttimeout : '20000',\r\n");
      out.write("\t\t\t\t\t\tscriptCharset : \"utf-8\",\r\n");
      out.write("\t\t\t\t\t\tcontentType : \"application/json; charset=utf-8\",\r\n");
      out.write("\t\t\t\t\t\turl : \"SuggestedSearch.action\",\r\n");
      out.write("\t\t\t\t\t\tdataType : 'json',\r\n");
      out.write("\t\t\t\t\t\tdata : '{\"term\":\"' + request.term + '\"}',\r\n");
      out.write("\t\t\t\t        success: function(result, textStatus, jqXHR) {\t\t\t\t\t         \r\n");
      out.write("\t\t\t\t       \t\tresponse(result);\r\n");
      out.write("\t\t\t\t       }\r\n");
      out.write("\t\t\t\t     });\r\n");
      out.write("\t\t\t\t}\r\n");
      out.write("\t\t\t   },\r\n");
      out.write("\t\t\tminLength: 1,\r\n");
      out.write("\t\t\tselect: function( event, ui ) {\r\n");
      out.write("\t\t\t\tdocument.getElementById('kk_key').value = ui.item.id;\r\n");
      out.write("\t\t\t\tdocument.getElementById('search-input').value = ui.item.value;\r\n");
      out.write("\t\t\t\tself.kkSearch();\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t}).data( \"autocomplete\" )._renderItem = function( ul, item ) {\r\n");
      out.write("\t           return $( \"<li></li>\" )\r\n");
      out.write("\t               .data( \"item.autocomplete\", item )\r\n");
      out.write("\t               .append( \"<a>\"+ item.label + \"</a>\" )\r\n");
      out.write("\t               .appendTo( ul );\r\n");
      out.write("\t\t};\r\n");
      out.write("\t\t\r\n");
      out.write("\t\t$(\"#search-input\").keydown(function (e){\r\n");
      out.write("\t\t    if(e.keyCode == 13){\r\n");
      out.write("\t\t    \tvar key = document.getElementById('kk_key').value;\r\n");
      out.write("\t\t    \tif (key == null || key == '') {\r\n");
      out.write("\t\t    \t\tself.kkSearch();\r\n");
      out.write("\t\t\t\t}\r\n");
      out.write("\t\t    }\r\n");
      out.write("\t\t});\r\n");
      out.write("\t});\t\r\n");
      out.write("\t</script>");
      out.write("\r\n");
      out.write("\t\r\n");
      out.write("\t");
      out.write("<!-- For posting suggested search query -->");
      out.write("\r\n");
      out.write("\t<form action=\"\" id='ssForm' method=\"post\">\r\n");
      out.write("\t\t<input id=\"searchText\" name=\"searchText\" type=\"hidden\"/>\r\n");
      out.write("\t\t<input id=\"manuId\" name=\"manuId\" type=\"hidden\"/>\r\n");
      out.write("\t\t<input id=\"catId\" name=\"catId\" type=\"hidden\"/>\r\n");
      out.write("\t</form>\r\n");
 } 
      out.write("\t\r\n");
      out.write("\r\n");
if (showCookieWarning) { 
      out.write("\t\r\n");
      out.write("\t<div id=\"cookie-container\">\r\n");
      out.write("\t\t<div id=\"cookie-warning\">\r\n");
      out.write("\t\t\t<div id=\"cookie-warning-text\">\r\n");
      out.write("\t\t\t\t");
      if (_jspx_meth_kk_005fmsg_005f0(_jspx_page_context))
        return;
      out.write("<div id=\"cookie-warn-button\" class=\"button small-rounded-corners\">");
      if (_jspx_meth_kk_005fmsg_005f1(_jspx_page_context))
        return;
      out.write("</div>\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t</div>\r\n");
 } 
      out.write("\r\n");
      out.write("\r\n");
      out.write("<div id=\"header-container\">\r\n");
      out.write("\t<div id=\"header\">\r\n");
      out.write("\t\t<div id=\"logo\">\r\n");
      out.write("\t\t\t<a href=\"Welcome.action\">KonaKart</a>\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t\t<div id=\"search\">\r\n");
      out.write("\t\t\t");
if (useSolr) { 
      out.write("\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t<input type=\"text\" id=\"search-input\" class=\"rounded-corners-left\" name=\"searchText\" onkeydown=\"javascript:kkKeydown();\">\r\n");
      out.write("\t\t\t\t<input id=\"kk_key\" type=\"hidden\"/>\r\n");
      out.write("\t\t\t\t<a id=\"search-button\" class=\"rounded-corners-right\" onclick=\"javascript:kkSearch();\">");
      if (_jspx_meth_kk_005fmsg_005f2(_jspx_page_context))
        return;
      out.write("</a>\r\n");
      out.write("\t\t\t");
 } else { 
      out.write("\t\r\n");
      out.write("\t\t\t\t<form action=\"QuickSearch.action\" id=\"quickSearchForm\" method=\"post\">\r\n");
      out.write("\t\t\t\t\t<input type=\"text\" id=\"search-input\" class=\"rounded-corners-left\" name=\"searchText\">\r\n");
      out.write("\t\t\t\t\t<a id=\"search-button\" class=\"rounded-corners-right\" onclick=\"javascript:document.getElementById('quickSearchForm').submit();\">");
      if (_jspx_meth_kk_005fmsg_005f3(_jspx_page_context))
        return;
      out.write("</a>\r\n");
      out.write("\t\t\t\t</form>\t\r\n");
      out.write("            ");
 } 
      out.write("\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t\t<a id=\"adv-search-link\" href=\"AdvancedSearch.action\">");
      if (_jspx_meth_kk_005fmsg_005f4(_jspx_page_context))
        return;
      out.write("</a>\r\n");
      out.write(" \t</div>\r\n");
      out.write("</div>");
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

  private boolean _jspx_meth_kk_005fmsg_005f0(javax.servlet.jsp.PageContext _jspx_page_context)
          throws java.lang.Throwable {
    javax.servlet.jsp.PageContext pageContext = _jspx_page_context;
    javax.servlet.jsp.JspWriter out = _jspx_page_context.getOut();
    //  kk:msg
    com.konakart.kktags.MsgTag _jspx_th_kk_005fmsg_005f0 = (com.konakart.kktags.MsgTag) _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.get(com.konakart.kktags.MsgTag.class);
    _jspx_th_kk_005fmsg_005f0.setPageContext(_jspx_page_context);
    _jspx_th_kk_005fmsg_005f0.setParent(null);
    // /WEB-INF/jsp/Search.jsp(104,4) name = key type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_kk_005fmsg_005f0.setKey("cookie.warning");
    int _jspx_eval_kk_005fmsg_005f0 = _jspx_th_kk_005fmsg_005f0.doStartTag();
    if (_jspx_th_kk_005fmsg_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f0);
      return true;
    }
    _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f0);
    return false;
  }

  private boolean _jspx_meth_kk_005fmsg_005f1(javax.servlet.jsp.PageContext _jspx_page_context)
          throws java.lang.Throwable {
    javax.servlet.jsp.PageContext pageContext = _jspx_page_context;
    javax.servlet.jsp.JspWriter out = _jspx_page_context.getOut();
    //  kk:msg
    com.konakart.kktags.MsgTag _jspx_th_kk_005fmsg_005f1 = (com.konakart.kktags.MsgTag) _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.get(com.konakart.kktags.MsgTag.class);
    _jspx_th_kk_005fmsg_005f1.setPageContext(_jspx_page_context);
    _jspx_th_kk_005fmsg_005f1.setParent(null);
    // /WEB-INF/jsp/Search.jsp(104,101) name = key type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_kk_005fmsg_005f1.setKey("common.continue");
    int _jspx_eval_kk_005fmsg_005f1 = _jspx_th_kk_005fmsg_005f1.doStartTag();
    if (_jspx_th_kk_005fmsg_005f1.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f1);
      return true;
    }
    _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f1);
    return false;
  }

  private boolean _jspx_meth_kk_005fmsg_005f2(javax.servlet.jsp.PageContext _jspx_page_context)
          throws java.lang.Throwable {
    javax.servlet.jsp.PageContext pageContext = _jspx_page_context;
    javax.servlet.jsp.JspWriter out = _jspx_page_context.getOut();
    //  kk:msg
    com.konakart.kktags.MsgTag _jspx_th_kk_005fmsg_005f2 = (com.konakart.kktags.MsgTag) _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.get(com.konakart.kktags.MsgTag.class);
    _jspx_th_kk_005fmsg_005f2.setPageContext(_jspx_page_context);
    _jspx_th_kk_005fmsg_005f2.setParent(null);
    // /WEB-INF/jsp/Search.jsp(119,89) name = key type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_kk_005fmsg_005f2.setKey("suggested.search.search");
    int _jspx_eval_kk_005fmsg_005f2 = _jspx_th_kk_005fmsg_005f2.doStartTag();
    if (_jspx_th_kk_005fmsg_005f2.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f2);
      return true;
    }
    _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f2);
    return false;
  }

  private boolean _jspx_meth_kk_005fmsg_005f3(javax.servlet.jsp.PageContext _jspx_page_context)
          throws java.lang.Throwable {
    javax.servlet.jsp.PageContext pageContext = _jspx_page_context;
    javax.servlet.jsp.JspWriter out = _jspx_page_context.getOut();
    //  kk:msg
    com.konakart.kktags.MsgTag _jspx_th_kk_005fmsg_005f3 = (com.konakart.kktags.MsgTag) _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.get(com.konakart.kktags.MsgTag.class);
    _jspx_th_kk_005fmsg_005f3.setPageContext(_jspx_page_context);
    _jspx_th_kk_005fmsg_005f3.setParent(null);
    // /WEB-INF/jsp/Search.jsp(123,131) name = key type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_kk_005fmsg_005f3.setKey("suggested.search.search");
    int _jspx_eval_kk_005fmsg_005f3 = _jspx_th_kk_005fmsg_005f3.doStartTag();
    if (_jspx_th_kk_005fmsg_005f3.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f3);
      return true;
    }
    _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f3);
    return false;
  }

  private boolean _jspx_meth_kk_005fmsg_005f4(javax.servlet.jsp.PageContext _jspx_page_context)
          throws java.lang.Throwable {
    javax.servlet.jsp.PageContext pageContext = _jspx_page_context;
    javax.servlet.jsp.JspWriter out = _jspx_page_context.getOut();
    //  kk:msg
    com.konakart.kktags.MsgTag _jspx_th_kk_005fmsg_005f4 = (com.konakart.kktags.MsgTag) _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.get(com.konakart.kktags.MsgTag.class);
    _jspx_th_kk_005fmsg_005f4.setPageContext(_jspx_page_context);
    _jspx_th_kk_005fmsg_005f4.setParent(null);
    // /WEB-INF/jsp/Search.jsp(127,55) name = key type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_kk_005fmsg_005f4.setKey("header.advanced.search");
    int _jspx_eval_kk_005fmsg_005f4 = _jspx_th_kk_005fmsg_005f4.doStartTag();
    if (_jspx_th_kk_005fmsg_005f4.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f4);
      return true;
    }
    _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f4);
    return false;
  }
}
