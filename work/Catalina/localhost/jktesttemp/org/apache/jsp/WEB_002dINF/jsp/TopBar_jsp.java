/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.22
 * Generated at: 2014-03-01 05:16:21 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.WEB_002dINF.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class TopBar_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.HashMap<java.lang.String,java.lang.Long>(2);
    _jspx_dependants.put("/WEB-INF/kk.tld", Long.valueOf(1391230460000L));
    _jspx_dependants.put("/WEB-INF/jsp/Taglibs.jsp", Long.valueOf(1391230460000L));
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
 int basketItems = kkEng.getBasketMgr().getNumberOfItems();
      out.write('\r');
      out.write('\n');
 com.konakart.al.CustomerMgr customerMgr = kkEng.getCustomerMgr();
      out.write('\r');
      out.write('\n');
 com.konakart.appif.CustomerIf currentCustomer = customerMgr.getCurrentCustomer();
      out.write("\r\n");
      out.write("\r\n");
int wishlistItems = 0;
      out.write('\r');
      out.write('\n');
if (currentCustomer.getWishLists() != null){
      out.write('\r');
      out.write('\n');
      out.write('	');
 for (int i = 0; i < currentCustomer.getWishLists().length; i++){ 
      out.write("\r\n");
      out.write("\t\t");
 com.konakart.appif.WishListIf wishList = currentCustomer.getWishLists()[i];
      out.write("\r\n");
      out.write("\t\t");
if (wishList.getListType()== com.konakart.al.WishListMgr.WISH_LIST_TYPE && wishList.getWishListItems()!= null){
      out.write("\r\n");
      out.write("\t\t\t");
wishlistItems = wishList.getWishListItems().length;
      out.write("\r\n");
      out.write("\t\t");
}
      out.write('\r');
      out.write('\n');
      out.write('	');
}
      out.write("\t\t\r\n");
}
      out.write("\t\t\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("<script type=\"text/javascript\">\t\r\n");
      out.write("$(function() {\r\n");
      out.write("\t$('#lang-select').selectBoxIt({\r\n");
      out.write("\t\tdownArrowIcon: \"selectboxit-down-arrow\"\r\n");
      out.write("    });\t \t\r\n");
      out.write("\t$('#currency-select').selectBoxIt({\r\n");
      out.write("\t\tdownArrowIcon: \"selectboxit-down-arrow\"\r\n");
      out.write("    });\t \r\n");
      out.write("});\r\n");
      out.write("</script>");
      out.write("\r\n");
      out.write("\r\n");
      out.write("<div id=\"top-bar-container\">\r\n");
      out.write("  \t<div id=\"top-bar\">\r\n");
      out.write("  \t\t<div id=\"options\">\r\n");
      out.write("\t  \t\t<div id=\"language-selector\" class=\"top-bar-menu-item\">\r\n");
      out.write("\t  \t\t\t<form action=\"SetLocale.action\" method=\"post\">  \r\n");
      out.write("\t\t\t\t\t<select id=\"lang-select\" name=\"locale\"  onchange=\"submit()\">\r\n");
      out.write("\t\t\t\t\t\t<option  value=\"en_GB\" data-icon=\"flag flag-en-GB\" ");
      out.print(kkEng.getLocale().equals("en_GB")?"selected=\"selected\"":"");
      out.write(">English</option>\r\n");
      out.write("\t\t\t\t\t\t<option  value=\"de_DE\" data-icon=\"flag flag-de-DE\"  ");
      out.print(kkEng.getLocale().equals("de_DE")?"selected=\"selected\"":"");
      out.write(">Deutsch</option>\r\n");
      out.write("\t\t\t\t\t\t<option  value=\"es_ES\" data-icon=\"flag flag-es-ES\"  ");
      out.print(kkEng.getLocale().equals("es_ES")?"selected=\"selected\"":"");
      out.write(">Español</option>\r\n");
      out.write("\t\t\t\t\t\t<option  value=\"pt_BR\" data-icon=\"flag flag-pt-BR\"  ");
      out.print(kkEng.getLocale().equals("pt_BR")?"selected=\"selected\"":"");
      out.write(">Português</option>\r\n");
      out.write("\t\t\t\t\t</select>\r\n");
      out.write("\t\t\t\t</form>\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t  \t\t</div>\r\n");
      out.write("\t  \t\t<div id=\"currency-selector\"  class=\"top-bar-menu-item\">\r\n");
      out.write("\t\t\t\t<form action=\"SelectCurrency.action\" method=\"post\">  \r\n");
      out.write("\t\t\t\t\t<select id=\"currency-select\" name=\"currencyCode\"  onchange=\"submit()\">\r\n");
      out.write("\t\t\t\t\t\t");
 for (int i = 0; i < kkEng.getCurrencies().length; i++){ 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t");
 com.konakart.appif.CurrencyIf currency = kkEng.getCurrencies()[i];
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t");
 if (currency != null) { 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t<option  value=\"");
      out.print(currency.getCode());
      out.write('"');
      out.write('>');
      out.print(currency.getTitle());
      out.write("</option>\r\n");
      out.write("\t\t\t\t\t\t\t");
 } 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t");
 } 
      out.write("\r\n");
      out.write("\t\t\t\t\t</select>\r\n");
      out.write("\t\t\t\t</form>\t\t\t\t\t\t\t\t\t\t  \t\t\t\r\n");
      out.write("\t  \t\t</div>\r\n");
      out.write("\t  \t\t");
if (kkEng.getSessionId() != null && kkEng.getSessionId().length() > 0) {
      out.write("\t\r\n");
      out.write("\t\t  \t\t<div  class=\"top-bar-menu-item\">\r\n");
      out.write("\t\t  \t\t\t<a href=\"LogOut.action\" class=\"header2-top\">");
      if (_jspx_meth_kk_005fmsg_005f0(_jspx_page_context))
        return;
      out.write("</a>\r\n");
      out.write("\t\t  \t\t</div>\r\n");
      out.write("\t\t\t");
 } 
      out.write("\t  \t\t\r\n");
      out.write("\t  \t\t<div id=\"my-account\" class=\"top-bar-menu-item\">\r\n");
      out.write("\t  \t\t\t<a href=\"LogIn.action\">");
      if (_jspx_meth_kk_005fmsg_005f1(_jspx_page_context))
        return;
      out.write("</a>\r\n");
      out.write("\t  \t\t</div>\r\n");
      out.write("\t  \t\t");
if (kkEng.getConfigAsBoolean("ENABLE_GIFT_REGISTRY", false)) {
      out.write("\t\r\n");
      out.write("\t\t  \t\t<div id=\"gift-registry\" class=\"top-bar-menu-item\">\t  \t\t\t\r\n");
      out.write("\t\t  \t\t\t<a href=\"GiftRegistrySearch.action\" class=\"header2-top\">");
      if (_jspx_meth_kk_005fmsg_005f2(_jspx_page_context))
        return;
      out.write("</a>\r\n");
      out.write("\t\t  \t\t</div>\t\r\n");
      out.write("\t\t\t");
}
      out.write("\t\r\n");
      out.write("\t\t\t");
if (kkEng.isWishListEnabled()) { 
      out.write("\r\n");
      out.write("\t\t  \t\t<div id=\"wish-list\" class=\"top-bar-menu-item\">\t  \t\t\t\r\n");
      out.write("\t\t  \t\t\t");
      if (_jspx_meth_kk_005fmsg_005f3(_jspx_page_context))
        return;
      out.write("\r\n");
      out.write("\t\t\t  \t\t");
if (wishlistItems > 0) { 
      out.write("\t\t\t \t\r\n");
      out.write("\t\t\t\t\t\t(");
      out.print(wishlistItems);
      out.write(")\r\n");
      out.write("\t\t\t\t\t");
}
      out.write("\t\t\t\t  \t\t\r\n");
      out.write("\t\t  \t\t</div>\t\r\n");
      out.write("\t\t\t   \t<div id=\"wish-list-container\">\r\n");
      out.write("\t\t\t   \t\t<div id=\"wish-list-mouseover-shadow\" class=\"slide-out-shadow\"></div>\r\n");
      out.write("\t\t\t\t  \t<div id=\"wish-list-contents\" class=\"slide-out-contents shadow\">\t\t\t  \t\r\n");
      out.write("\t\t\t  \t\t\t");
if (wishlistItems==0){
      out.write("\r\n");
      out.write("\t\t\t  \t\t\t\t");
      if (_jspx_meth_kk_005fmsg_005f4(_jspx_page_context))
        return;
      out.write("\r\n");
      out.write("\t\t\t  \t\t\t");
}else{
      out.write("\r\n");
      out.write("\t\t\t\t\t  \t\t<div id=\"wish-list-items\">\t\r\n");
      out.write("\t\t\t\t\t  \t\t\t");
 com.konakart.appif.WishListIf selectedWishList = null;
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t");
 for (int i = 0; i < currentCustomer.getWishLists().length; i++){ 
      out.write("\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t");
 com.konakart.appif.WishListIf wishList = currentCustomer.getWishLists()[i];
      out.write("\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t");
if (wishList.getListType()== com.konakart.al.WishListMgr.WISH_LIST_TYPE){
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t");
 selectedWishList = wishList; 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t");
if (wishList.getWishListItems() != null && wishList.getWishListItems().length > 0){
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t");
 for (int j = 0; j < wishList.getWishListItems().length; j++){ 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t");
 com.konakart.appif.WishListItemIf item = wishList.getWishListItems()[j];
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t");
if (item.getProduct() != null) { 
      out.write("\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t<div class=\"shopping-cart-item\">\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t");
      out.write("<!-- //jk changed 2/27/2014 -->");
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t");
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t ");
 com.konakart.appif.ProductIf prod =  item.getProduct();
      out.write("\r\n");
      out.write(" \t\t\t\t\t\t\t\t\t\t\t\t\t\t<a href='");
      out.print("SelectProd.action?prodId="+item.getProduct().getId());
      out.write("'><img src=\"");
      out.print(kkEng.getProdImageBase(item.getProduct()).replaceAll("null", "") + "Thumbnail/" + prod.getCustom1Int() + ".jpg" );
      out.write("\" border=\"0\" alt=\"");
      out.print(item.getProduct().getName());
      out.write("\" title=\" ");
      out.print(item.getProduct().getName());
      out.write(" \"></a>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t  \t\t\t<a href='");
      out.print("SelectProd.action?prodId="+item.getProduct().getId());
      out.write("'><img src=\"");
      out.print(kkEng.getProdImageBase(item.getProduct())+"_1_tiny1"+ kkEng.getProdImageExtension(item.getProduct()));
      out.write("\" border=\"0\" alt=\"");
      out.print(item.getProduct().getName());
      out.write("\" title=\" ");
      out.print(item.getProduct().getName());
      out.write(" \"></a>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t  \t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t  \t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t  \t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t  \t\t\t<a href='");
      out.print("SelectProd.action?prodId="+item.getProduct().getId());
      out.write("' class=\"shopping-cart-item-title\">");
      out.print(item.getProduct().getName());
      out.write("</a>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t  \t\t\t\t");
if (item.getOpts() != null && item.getOpts().length > 0){ 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t");
 for (int l = 0; l < item.getOpts().length; l++){ 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t");
 com.konakart.appif.OptionIf opt = item.getOpts()[l];
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t");
if (opt.getType() == com.konakart.app.Option.TYPE_VARIABLE_QUANTITY){ 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t<br><span class=\"shopping-cart-item-option\"> - ");
      out.print(opt.getName());
      out.write(' ');
      out.write(' ');
      out.print(opt.getQuantity());
      out.write(' ');
      out.print(opt.getValue());
      out.write("</span>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t");
 } else { 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t<br><span class=\"shopping-cart-item-option\"> - ");
      out.print(opt.getName());
      out.write(' ');
      out.print(opt.getValue());
      out.write("</span>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t");
 } 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t");
 } 
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t\t");
 } 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t  \t\t\t<div class=\"shopping-cart-item-price\">\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t  \t\t\t");
if (kkEng.displayPriceWithTax()) { 
      out.write("\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t  \t\t\t\t");
      out.print(kkEng.formatPrice(item.getFinalPriceIncTax()));
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t  \t\t\t");
}else{
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t  \t\t\t\t");
      out.print(kkEng.formatPrice(item.getFinalPriceExTax()));
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t  \t\t\t");
}
      out.write("\t\t\t\t\t  \t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t  \t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t  \t\t\t\t</div>\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t");
}
      out.write("\t\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t");
}
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t");
}
      out.write("\t\t    \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t");
}
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t");
}
      out.write("\r\n");
      out.write("\t\t\t\t\t\t  \t</div>\t\r\n");
      out.write("\t\t\t\t\t\t  \t<div id=\"wish-list-subtotal\">\r\n");
      out.write("\t\t\t\t\t\t  \t\t<div class=\"subtotal\">\r\n");
      out.write("\t\t\t\t\t\t  \t\t\t<div class=\"subtotal-label\">");
      if (_jspx_meth_kk_005fmsg_005f5(_jspx_page_context))
        return;
      out.write("</div>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t");
if (kkEng.displayPriceWithTax()){
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<div class=\"subtotal-amount\">");
      out.print(kkEng.formatPrice(selectedWishList.getFinalPriceIncTax()));
      out.write("</div>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t");
}else{
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<div class=\"subtotal-amount\">");
      out.print(kkEng.formatPrice(selectedWishList.getFinalPriceExTax()));
      out.write("</div>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t");
}
      out.write("\t\t    \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t  \t\t</div>\r\n");
      out.write("\t\t\t\t\t\t  \t</div>\r\n");
      out.write("\t\t\t\t  \t\t");
}
      out.write("\t\t\t\t  \t\t\t\t  \t\r\n");
      out.write("\t\t\t\t  \t</div>\t\r\n");
      out.write("\t\t\t\t</div> \r\n");
      out.write("\t\t\t");
}
      out.write("\r\n");
      out.write("\t\t\t<div id=\"shopping-cart\" class=\"top-bar-menu-item\">\r\n");
      out.write("\t\t  \t\t");
      if (_jspx_meth_kk_005fmsg_005f6(_jspx_page_context))
        return;
      out.write("\r\n");
      out.write("\t\t  \t\t");
if (basketItems > 0) { 
      out.write("\t\t\t \t\r\n");
      out.write("\t\t\t\t\t(");
      out.print(basketItems);
      out.write(")\r\n");
      out.write("\t\t\t\t");
}
      out.write("\r\n");
      out.write("\t\t  \t</div>\r\n");
      out.write("\t\t    <div id=\"shopping-cart-container\">\r\n");
      out.write("\t\t\t  \t<div id=\"shopping-cart-mouseover-shadow\" class=\"slide-out-shadow\"></div>\r\n");
      out.write("\t\t\t  \t<div id=\"shopping-cart-contents\" class=\"slide-out-contents shadow\">\r\n");
      out.write("\t\t\t\t\t");
if (basketItems==0 || customerMgr.getCurrentCustomer()==null || customerMgr.getCurrentCustomer().getBasketItems()==null) { 
      out.write("\t\r\n");
      out.write("\t\t\t\t\t\t");
      if (_jspx_meth_kk_005fmsg_005f7(_jspx_page_context))
        return;
      out.write("\r\n");
      out.write("\t\t\t\t\t");
}else{
      out.write("\r\n");
      out.write("\t\t\t\t  \t\t<div id=\"shopping-cart-items\">\t\r\n");
      out.write("\t\t\t\t\t\t\t\t");
 for (int i = 0; i < customerMgr.getCurrentCustomer().getBasketItems().length; i++){ 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t");
 com.konakart.appif.BasketIf item = customerMgr.getCurrentCustomer().getBasketItems()[i];
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t");
if (item.getProduct() != null) { 
      out.write("\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t<div class=\"shopping-cart-item\">\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t");
      out.write("<!-- //jk changed 2/27/2014 -->");
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t");
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t ");
 com.konakart.appif.ProductIf prod =  item.getProduct();
      out.write("\r\n");
      out.write(" \t\t\t\t\t\t\t\t\t\t<a href='");
      out.print("SelectProd.action?prodId="+item.getProduct().getId());
      out.write("'><img src=\"");
      out.print(kkEng.getProdImageBase(item.getProduct()).replaceAll("null", "") + "Thumbnail/" + prod.getCustom1Int() + ".jpg" );
      out.write("\" border=\"0\" alt=\"");
      out.print(item.getProduct().getName());
      out.write("\" title=\" ");
      out.print(item.getProduct().getName());
      out.write(" \"></a>\r\n");
      out.write(" \t\t\t\t\t\t\t\t\t\t<a href='");
      out.print("SelectProd.action?prodId="+item.getProduct().getId());
      out.write("' class=\"shopping-cart-item-title\">");
      out.print(item.getProduct().getName());
      out.write("</a>\r\n");
      out.write("\t\t\t\t\t\t\t  \t\t\t\t");
if (item.getOpts() != null && item.getOpts().length > 0){ 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t");
 for (int l = 0; l < item.getOpts().length; l++){ 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t");
 com.konakart.appif.OptionIf opt = item.getOpts()[l];
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t");
if (opt.getType() == com.konakart.app.Option.TYPE_VARIABLE_QUANTITY){ 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t\t<br><span class=\"shopping-cart-item-option\"> - ");
      out.print(opt.getName());
      out.write(' ');
      out.write(' ');
      out.print(opt.getQuantity());
      out.write(' ');
      out.print(opt.getValue());
      out.write("</span>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t");
 } else { 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t\t<br><span class=\"shopping-cart-item-option\"> - ");
      out.print(opt.getName());
      out.write(' ');
      out.print(opt.getValue());
      out.write("</span>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t");
 } 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t");
 } 
      out.write("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t\t\t");
 } 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t  \t\t\t<div class=\"shopping-cart-item-price\">\r\n");
      out.write("\t\t\t\t\t\t\t\t\t  \t\t\t");
if (kkEng.displayPriceWithTax()) { 
      out.write("\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t  \t\t\t\t");
      out.print(kkEng.formatPrice(item.getFinalPriceIncTax()));
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t  \t\t\t");
}else{
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t  \t\t\t\t");
      out.print(kkEng.formatPrice(item.getFinalPriceExTax()));
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t  \t\t\t");
}
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t  \t\t\t&nbsp;");
      if (_jspx_meth_kk_005fmsg_005f8(_jspx_page_context))
        return;
      out.write(':');
      out.print(item.getQuantity());
      out.write("\t\t\t\t\t  \t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t  \t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t  \t\t\t\t</div>\t\t\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\t\t");
}
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t");
}
      out.write("\r\n");
      out.write("\t\t\t\t\t  \t</div>\r\n");
      out.write("\t\t\t\t\t  \t<div id=\"subtotal-and-checkout\">\r\n");
      out.write("\t\t\t\t\t  \t\t<div class=\"subtotal\">\r\n");
      out.write("\t\t\t\t\t  \t\t\t<div class=\"subtotal-label\">");
      if (_jspx_meth_kk_005fmsg_005f9(_jspx_page_context))
        return;
      out.write("</div>\r\n");
      out.write("\t\t\t\t\t  \t\t\t<div class=\"subtotal-amount\">");
      out.print(kkEng.getBasketMgr().getFormattedBasketTotal());
      out.write("</div>\r\n");
      out.write("\t\t\t\t\t  \t\t\t<div id=\"shopping-cart-checkout-button\" class=\"button small-rounded-corners\">");
      if (_jspx_meth_kk_005fmsg_005f10(_jspx_page_context))
        return;
      out.write("</div>\r\n");
      out.write("\t\t\t\t\t  \t\t</div>\r\n");
      out.write("\t\t\t\t\t  \t</div>\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t");
}
      out.write("\t\t\t\t  \t\t\r\n");
      out.write("\t\t\t  \t</div>\t\r\n");
      out.write("\t\t\t</div>\r\n");
      out.write("\t\t</div>\r\n");
      out.write("  \t</div>\r\n");
      out.write("</div>  ");
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
    // /WEB-INF/jsp/TopBar.jsp(74,51) name = key type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_kk_005fmsg_005f0.setKey("header.logout.page");
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
    // /WEB-INF/jsp/TopBar.jsp(78,29) name = key type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_kk_005fmsg_005f1.setKey("header.my.account");
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
    // /WEB-INF/jsp/TopBar.jsp(82,63) name = key type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_kk_005fmsg_005f2.setKey("header.gift.registries");
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
    // /WEB-INF/jsp/TopBar.jsp(87,7) name = key type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_kk_005fmsg_005f3.setKey("wishlist.tile.wishlist");
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
    // /WEB-INF/jsp/TopBar.jsp(96,9) name = key type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_kk_005fmsg_005f4.setKey("wishlist.tile.empty");
    int _jspx_eval_kk_005fmsg_005f4 = _jspx_th_kk_005fmsg_005f4.doStartTag();
    if (_jspx_th_kk_005fmsg_005f4.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f4);
      return true;
    }
    _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f4);
    return false;
  }

  private boolean _jspx_meth_kk_005fmsg_005f5(javax.servlet.jsp.PageContext _jspx_page_context)
          throws java.lang.Throwable {
    javax.servlet.jsp.PageContext pageContext = _jspx_page_context;
    javax.servlet.jsp.JspWriter out = _jspx_page_context.getOut();
    //  kk:msg
    com.konakart.kktags.MsgTag _jspx_th_kk_005fmsg_005f5 = (com.konakart.kktags.MsgTag) _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.get(com.konakart.kktags.MsgTag.class);
    _jspx_th_kk_005fmsg_005f5.setPageContext(_jspx_page_context);
    _jspx_th_kk_005fmsg_005f5.setParent(null);
    // /WEB-INF/jsp/TopBar.jsp(148,39) name = key type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_kk_005fmsg_005f5.setKey("common.subtotal");
    int _jspx_eval_kk_005fmsg_005f5 = _jspx_th_kk_005fmsg_005f5.doStartTag();
    if (_jspx_th_kk_005fmsg_005f5.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f5);
      return true;
    }
    _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f5);
    return false;
  }

  private boolean _jspx_meth_kk_005fmsg_005f6(javax.servlet.jsp.PageContext _jspx_page_context)
          throws java.lang.Throwable {
    javax.servlet.jsp.PageContext pageContext = _jspx_page_context;
    javax.servlet.jsp.JspWriter out = _jspx_page_context.getOut();
    //  kk:msg
    com.konakart.kktags.MsgTag _jspx_th_kk_005fmsg_005f6 = (com.konakart.kktags.MsgTag) _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.get(com.konakart.kktags.MsgTag.class);
    _jspx_th_kk_005fmsg_005f6.setPageContext(_jspx_page_context);
    _jspx_th_kk_005fmsg_005f6.setParent(null);
    // /WEB-INF/jsp/TopBar.jsp(161,6) name = key type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_kk_005fmsg_005f6.setKey("cart.tile.shoppingcart");
    int _jspx_eval_kk_005fmsg_005f6 = _jspx_th_kk_005fmsg_005f6.doStartTag();
    if (_jspx_th_kk_005fmsg_005f6.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f6);
      return true;
    }
    _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f6);
    return false;
  }

  private boolean _jspx_meth_kk_005fmsg_005f7(javax.servlet.jsp.PageContext _jspx_page_context)
          throws java.lang.Throwable {
    javax.servlet.jsp.PageContext pageContext = _jspx_page_context;
    javax.servlet.jsp.JspWriter out = _jspx_page_context.getOut();
    //  kk:msg
    com.konakart.kktags.MsgTag _jspx_th_kk_005fmsg_005f7 = (com.konakart.kktags.MsgTag) _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.get(com.konakart.kktags.MsgTag.class);
    _jspx_th_kk_005fmsg_005f7.setPageContext(_jspx_page_context);
    _jspx_th_kk_005fmsg_005f7.setParent(null);
    // /WEB-INF/jsp/TopBar.jsp(170,6) name = key type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_kk_005fmsg_005f7.setKey("cart.tile.empty");
    int _jspx_eval_kk_005fmsg_005f7 = _jspx_th_kk_005fmsg_005f7.doStartTag();
    if (_jspx_th_kk_005fmsg_005f7.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f7);
      return true;
    }
    _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f7);
    return false;
  }

  private boolean _jspx_meth_kk_005fmsg_005f8(javax.servlet.jsp.PageContext _jspx_page_context)
          throws java.lang.Throwable {
    javax.servlet.jsp.PageContext pageContext = _jspx_page_context;
    javax.servlet.jsp.JspWriter out = _jspx_page_context.getOut();
    //  kk:msg
    com.konakart.kktags.MsgTag _jspx_th_kk_005fmsg_005f8 = (com.konakart.kktags.MsgTag) _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.get(com.konakart.kktags.MsgTag.class);
    _jspx_th_kk_005fmsg_005f8.setPageContext(_jspx_page_context);
    _jspx_th_kk_005fmsg_005f8.setParent(null);
    // /WEB-INF/jsp/TopBar.jsp(201,20) name = key type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_kk_005fmsg_005f8.setKey("cart.tile.quantity");
    int _jspx_eval_kk_005fmsg_005f8 = _jspx_th_kk_005fmsg_005f8.doStartTag();
    if (_jspx_th_kk_005fmsg_005f8.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f8);
      return true;
    }
    _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f8);
    return false;
  }

  private boolean _jspx_meth_kk_005fmsg_005f9(javax.servlet.jsp.PageContext _jspx_page_context)
          throws java.lang.Throwable {
    javax.servlet.jsp.PageContext pageContext = _jspx_page_context;
    javax.servlet.jsp.JspWriter out = _jspx_page_context.getOut();
    //  kk:msg
    com.konakart.kktags.MsgTag _jspx_th_kk_005fmsg_005f9 = (com.konakart.kktags.MsgTag) _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.get(com.konakart.kktags.MsgTag.class);
    _jspx_th_kk_005fmsg_005f9.setPageContext(_jspx_page_context);
    _jspx_th_kk_005fmsg_005f9.setParent(null);
    // /WEB-INF/jsp/TopBar.jsp(209,38) name = key type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_kk_005fmsg_005f9.setKey("common.subtotal");
    int _jspx_eval_kk_005fmsg_005f9 = _jspx_th_kk_005fmsg_005f9.doStartTag();
    if (_jspx_th_kk_005fmsg_005f9.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f9);
      return true;
    }
    _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f9);
    return false;
  }

  private boolean _jspx_meth_kk_005fmsg_005f10(javax.servlet.jsp.PageContext _jspx_page_context)
          throws java.lang.Throwable {
    javax.servlet.jsp.PageContext pageContext = _jspx_page_context;
    javax.servlet.jsp.JspWriter out = _jspx_page_context.getOut();
    //  kk:msg
    com.konakart.kktags.MsgTag _jspx_th_kk_005fmsg_005f10 = (com.konakart.kktags.MsgTag) _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.get(com.konakart.kktags.MsgTag.class);
    _jspx_th_kk_005fmsg_005f10.setPageContext(_jspx_page_context);
    _jspx_th_kk_005fmsg_005f10.setParent(null);
    // /WEB-INF/jsp/TopBar.jsp(211,87) name = key type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_kk_005fmsg_005f10.setKey("common.checkout");
    int _jspx_eval_kk_005fmsg_005f10 = _jspx_th_kk_005fmsg_005f10.doStartTag();
    if (_jspx_th_kk_005fmsg_005f10.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f10);
      return true;
    }
    _005fjspx_005ftagPool_005fkk_005fmsg_0026_005fkey_005fnobody.reuse(_jspx_th_kk_005fmsg_005f10);
    return false;
  }
}
