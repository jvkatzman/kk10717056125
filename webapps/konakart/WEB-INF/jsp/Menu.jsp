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
<% com.konakart.al.CategoryMgr catMgr = kkEng.getCategoryMgr();%>

<script type="text/javascript">
    // Space out menu evenly
	$(function() {
		var total=0;
		var itemArray = new Array();
		$("#main-menu a").each(function(index){
			var margin = $(this).css("margin-right");
			var marginInt = parseInt(margin.substring(0, margin.length-2)); // remove px
			total += ($(this).width()+marginInt);
			itemArray[index]=$(this).width();
		});		
		var width =  $("#page").css("width");
		var widthInt = parseInt(width.substring(0, width.length-2)); // remove px	
		var extra = widthInt-total;
		extra = Math.floor((extra / itemArray.length));
		$("#main-menu a").each(function(index){$(this).width(itemArray[index]+extra);});		
	});				
</script>

<div id="main-menu">
	<div id="main-menu-container">

	
	<a href="SelectCat.action?catId=1" class="menu-item rounded-corners" style="width: 114px;">Computers</a>
	<a href="SelectCat.action?catId=1" class="menu-item rounded-corners" style="width: 114px;">Games</a>
		<a href="SelectCat.action?catId=1" class="menu-item rounded-corners" style="width: 114px;">Movies</a>
		<a href="SelectCat.action?catId=1" class="menu-item rounded-corners last-child" style="width: 114px;">Electronics</a>
		<a href="SelectCat.action?catId=1" class="menu-item rounded-corners last-child" style="width: 114px;">Phones</a>
		<a href="SelectCat.action?catId=1" class="menu-item rounded-corners last-child" style="width: 114px;">Office</a>
		<a href="SelectCat.action?catId=1" class="menu-item rounded-corners last-child" style="width: 114px;">Power</a>
		<a href="SelectCat.action?catId=1" class="menu-item rounded-corners last-child" style="width: 114px;">Home</a>

		<a href="SelectCat.action?catId=1" class="menu-item rounded-corners last-child" style="width: 114px;">Garden</a>




	</div>		
</div>
