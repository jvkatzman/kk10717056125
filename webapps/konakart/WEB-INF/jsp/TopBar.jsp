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
<% int basketItems = kkEng.getBasketMgr().getNumberOfItems();%>
<% com.konakart.al.CustomerMgr customerMgr = kkEng.getCustomerMgr();%>
<% com.konakart.appif.CustomerIf currentCustomer = customerMgr.getCurrentCustomer();%>

<%int wishlistItems = 0;%>
<%if (currentCustomer.getWishLists() != null){%>
	<% for (int i = 0; i < currentCustomer.getWishLists().length; i++){ %>
		<% com.konakart.appif.WishListIf wishList = currentCustomer.getWishLists()[i];%>
		<%if (wishList.getListType()== com.konakart.al.WishListMgr.WISH_LIST_TYPE && wishList.getWishListItems()!= null){%>
			<%wishlistItems = wishList.getWishListItems().length;%>
		<%}%>
	<%}%>		
<%}%>		


<script type="text/javascript">	
$(function() {
	$('#lang-select').selectBoxIt({
		downArrowIcon: "selectboxit-down-arrow"
    });	 	
	$('#currency-select').selectBoxIt({
		downArrowIcon: "selectboxit-down-arrow"
    });	 
});
</script>


<div id="top-bar-container">
  	<div id="top-bar">

	  	<div id="options-account">
	  		<%if (kkEng.getSessionId() != null && kkEng.getSessionId().length() > 0) {%>	
		  		<div  class="top-bar-menu-item">
		  			<a href="LogOut.action" class="header2-top"><kk:msg  key="header.logout.page"/></a>
		  		</div>
			<% } %>	  		
	  		<div id="my-account" class="top-bar-menu-item">
	  			<a href="LogIn.action"><kk:msg  key="header.my.account"/></a>
	  		</div>
	  		<%if (kkEng.getConfigAsBoolean("ENABLE_GIFT_REGISTRY", false)) {%>	
		  		<div id="gift-registry" class="top-bar-menu-item">	  			
		  			<a href="GiftRegistrySearch.action" class="header2-top"><kk:msg  key="header.gift.registries"/></a>
		  		</div>	
			<%}%>	
			<%if (kkEng.isWishListEnabled()) { %>
		  		<div id="wish-list" class="top-bar-menu-item" style="display: none;">	  			
		  			<kk:msg  key="wishlist.tile.wishlist"/>
			  		<%if (wishlistItems > 0) { %>			 	
						(<%=wishlistItems%>)
					<%}%>				  		
		  		</div>	
			   	<div id="wish-list-container" style="display: none;">
			   		<div id="wish-list-mouseover-shadow" class="slide-out-shadow"></div>
				  	<div id="wish-list-contents" class="slide-out-contents shadow">			  	
			  			<%if (wishlistItems==0){%>
			  				<kk:msg  key="wishlist.tile.empty"/>
			  			<%}else{%>
					  		<div id="wish-list-items">	
					  			<% com.konakart.appif.WishListIf selectedWishList = null;%>
								<% for (int i = 0; i < currentCustomer.getWishLists().length; i++){ %>		
									<% com.konakart.appif.WishListIf wishList = currentCustomer.getWishLists()[i];%>			
									<%if (wishList.getListType()== com.konakart.al.WishListMgr.WISH_LIST_TYPE){%>
										<% selectedWishList = wishList; %>
										<%if (wishList.getWishListItems() != null && wishList.getWishListItems().length > 0){%>
											<% for (int j = 0; j < wishList.getWishListItems().length; j++){ %>
												<% com.konakart.appif.WishListItemIf item = wishList.getWishListItems()[j];%>
												<%if (item.getProduct() != null) { %>		
													<div class="shopping-cart-item">
													
													<!-- //jk changed 2/27/2014 -->
													
													<%-- <a href='<%="SelectProd.action?prodId="+item.getProduct().getId()%>'><img src="<%=kkEng.getProdImageBase(item.getProduct())+"_1_tiny1"+ kkEng.getProdImageExtension(item.getProduct())%>" border="0" alt="<%=item.getProduct().getName()%>" title=" <%=item.getProduct().getName()%> "></a> --%>
													
															 <% com.konakart.appif.ProductIf prod =  item.getProduct();%>
 														<a href='<%="SelectProd.action?prodId="+item.getProduct().getId()%>'><img src="<%=kkEng.getProdImageBase(item.getProduct()).replaceAll("null", "") + "Thumbnail/" + prod.getCustom1Int() + ".jpg" %>" border="0" alt="<%=item.getProduct().getName()%>" title=" <%=item.getProduct().getName()%> "></a>
													
											  			<%-- <a href='<%="SelectProd.action?prodId="+item.getProduct().getId()%>'><img src="<%=kkEng.getProdImageBase(item.getProduct())+"_1_tiny1"+ kkEng.getProdImageExtension(item.getProduct())%>" border="0" alt="<%=item.getProduct().getName()%>" title=" <%=item.getProduct().getName()%> "></a> --%>
											  		
											  		
											  		
											  			<a href='<%="SelectProd.action?prodId="+item.getProduct().getId()%>' class="shopping-cart-item-title"><%=item.getProduct().getName()%></a>


										  				<%if (item.getOpts() != null && item.getOpts().length > 0){ %>
															<% for (int l = 0; l < item.getOpts().length; l++){ %>
																<% com.konakart.appif.OptionIf opt = item.getOpts()[l];%>
																<%if (opt.getType() == com.konakart.app.Option.TYPE_VARIABLE_QUANTITY){ %>
																	<br><span class="shopping-cart-item-option"> - <%=opt.getName()%>  <%=opt.getQuantity()%> <%=opt.getValue()%></span>
																<% } else { %>
																	<br><span class="shopping-cart-item-option"> - <%=opt.getName()%> <%=opt.getValue()%></span>
																<% } %>
															<% } %>																								
														<% } %>
											  			<div class="shopping-cart-item-price">
												  			<%if (kkEng.displayPriceWithTax()) { %>		
												  				<%=kkEng.formatPrice(item.getFinalPriceIncTax())%>
												  			<%}else{%>
												  				<%=kkEng.formatPrice(item.getFinalPriceExTax())%>
												  			<%}%>					  			
											  			</div>
									  				</div>							
												<%}%>										
											<%}%>
										<%}%>		    																											
									<%}%>
								<%}%>
						  	</div>	
						  	<div id="wish-list-subtotal">
						  		<div class="subtotal">
						  			<div class="subtotal-label"><kk:msg  key="common.subtotal"/></div>
									<%if (kkEng.displayPriceWithTax()){%>
										<div class="subtotal-amount"><%=kkEng.formatPrice(selectedWishList.getFinalPriceIncTax())%></div>
									<%}else{%>
										<div class="subtotal-amount"><%=kkEng.formatPrice(selectedWishList.getFinalPriceExTax())%></div>
									<%}%>		    																											
						  		</div>
						  	</div>
				  		<%}%>				  				  	
				  	</div>	
				</div> 
			<%}%>
		</div>
  	</div>
</div>  