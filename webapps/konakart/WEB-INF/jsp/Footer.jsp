<%--
//
// (c) 2012 DS Data Systems UK Ltd, All rights reserved.
//
// DS Data Systems and KonaKart and their respective logos, are 
// trademarks of DS Data Systems UK Ltd. All rights reserved.
//
// The information in this document is free software; you can redistribute 
// it and/or modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
// 
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
--%>
<%@include file="Taglibs.jsp" %>

<% com.konakart.al.KKAppEng kkEng = (com.konakart.al.KKAppEng) session.getAttribute("konakartKey");%>

<script>
function onBlur(el) {
    if (el.value == '') {
        el.value = el.defaultValue;
    }
}
function onFocus(el) {
    if (el.value == el.defaultValue) {
        el.value = '';
    }
}

$(function() {
	$("#newsletter-input").keydown(function (e){
	    if(e.keyCode == 13){
	    	submitNewsletterForm();
	    }
	});
});		
</script>


<div id="kkfooter">
    <div id="brand1" class="brands footer-area narrow"><img src="/konakart/images/brand-asus.png"/></div>
    <div id="brand2" class="brands footer-area narrow"><img src="/konakart/images/brand-samsung.png"/></div>
    <div id="brand4" class="brands footer-area narrow"><img src="/konakart/images/brand-hp.png"/></div>
    <div id="brand5" class="brands footer-area narrow"><img src="/konakart/images/brand-lenovo.png"/></div>
    <div id="brand6" class="brands footer-area narrow"><img src="/konakart/images/brand-cisco.png"/></div>

    <div id="brand7" class="brands footer-area narrow last-child"><img src="/konakart/images/brand-intel.png"/></div>

   	<div id="newsletter" class="footer-area wide">
    <h3>NEWSLETTER</h3>
      <kk:msg  key="footer.subscribe"/><br /><br/>
 		<input type="text" id="newsletter-input" class="rounded-corners-left" onblur="onBlur(this)" onfocus="onFocus(this)" value="<kk:msg  key="footer.your.email"/>">
		<a id="newsletter-button" class="rounded-corners-right"><kk:msg  key="footer.signup"/></a>
		<div id="newsletter-msg"></div>

   	</div>

    <div id="followus" class="footer-area wide"><h3>FOLLOW BITCOINSTORE</h3>
		<a href="http://www.twitter.com" target="_blank"><img src="/konakart/images/social/twitter_icon.png"/></a>
		<a href="http://www.facebook.com" target="_blank" ><img src="/konakart/images/social/fb_icon.png"/></a>
		<a href="http://plus.google.com" target="_blank" ><img src="/konakart/images/social/g_plus_icon.png"/></a>
	</div>

    <div id="WELOVE" class="footer-area wide last-child" >
    <img src="/konakart/images/bitcoin-accepted.png"/><br/>
    	Proudly supporting the bitcoin community since 2012.
   	</div>

   	<div id="account" class="links footer-area">
		<h3>INFO</h3>		
		
		<a href ="PrivacyPolicy.action"><kk:msg  key="footer.privacy.policy"/></a><br />
		<a href ="TermsOfUse.action"><kk:msg  key="footer.terms.of.use"/></a><br /><br/>
				<a href ="https://bitcoinstore.groovehq.com/help_center" class="button small-rounded-corners" style="color:#fff;"><kk:msg  key="footer.help"/></a>

   	</div>

   	<div id="links-1" class="links footer-area">
   		<h3>BUY BITCOINS</h3>
   		LocalBitcoins.com<br/>
   		Coinbase.com<br/>
   		HowDoYouBuyBitcoins   	
   	</div>

   	<div id="links-2" class="links footer-area">

   		<h3>BITCOIN NEWS</h3>
   		CoinDesk<br/>
   		r/bitcoin<br/>
   		bitcointalk
   	</div>

   	<div id="links-3" class="links footer-area last-child">
   	</div>

</div>