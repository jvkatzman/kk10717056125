/*!
(c) 2012 DS Data Systems UK Ltd, All rights reserved.

DS Data Systems and KonaKart and their respective logos, are
trademarks of DS Data Systems UK Ltd. All rights reserved.

The information in this document is free software;you can redistribute
it and/or modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This software is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.
 */

/*
 * Start of configuration parameters
 */
// Change the root depending on where KK is running
// Define the root URL
var kkRoot = 'http://localhost:8780/konakart/';
// var kkRoot = 'http://www.konakart.com/konakart/';

// Define the protocol: json or jsonp
var jsonProtocol = 'json';

// Use the image base to display images from the KK store-front app
var kkImgBase = kkRoot + "images/";

// Use the script base to load the JavaScript
var kkScriptBase = kkRoot + "shoppingWidgets/js/";

// Use the css base to load the css
var kkCSSBase = kkRoot + "shoppingWidgets/css/";

// Define the libraries
var jqueryLib = 'jquery-1.7.2.min.js';
var jqueryUILib = 'jquery-ui-1.8.20.custom.min.js';
var jqueryJsonLib = 'jquery.json-2.3.min.js';
//var jqueryKKLib = 'jquery.konakart-6.5.0.0.js';
var jqueryKKLib = 'jquery.konakart-7.1.1.1.min.js';

// Define styles
var jqueryUICSS = 'jquery-ui-1.8.20.custom.css';
var kkCSS = 'kkWidget.css';

// Messages / Labels
var kkMsgCartEmpty = "Your Cart is Empty";
var kkMsgImage = 'Image';
var kkMsgDetails = 'Details';
var kkMsgCart = 'Cart';
var kkMsgReviews = 'Reviews';
var kkMsgItem = 'Item';
var kkMsgQty = 'Qty';
var kkMsgCost = 'Cost';
var kkMsgRemove = 'Remove';
var kkMsgCheckout = 'Checkout';
var kkMsgAddToCart = 'Add To Cart';
var kkMsgTotal = 'Total';
var kkMsgInc = 'Increase the quantity';
var kkMsgDec = 'Decrease the quantity';
var kkMsgRemove = 'Remove the item from the cart';

/*
 * End of configuration parameters
 */

// Constants used to pass information in div
var KK_PROD_ID = 'kkProdId';
var KK_AFFILIATE_ID = 'kkAffiliateId';

// Number of libs to call after jQuery has been loaded
var kkNumLibs = 3;
var kkLibsLoaded = 0;

// Load jQuery
if (typeof jQuery == 'undefined') {
	kkLoadJquery(kkScriptBase + jqueryLib);
} else {
	// This callback would normally get called once jQuery has been loaded
	kkJQueryLoadedCallback();
}

/*
 * Define some variables
 */

// The tab folders
var kkTabs = new Array();

// The checkout buttons
var kkCheckoutBtns = new Array();

// Cookie that store temp customer id
var KK_CUSTOMER_ID = "KK_CUSTOMER_ID";

// Default language
var DEFAULT_LANG = -1;

// Define a KK engine
var kkEngine;

// Temporary customer id
var kkCustId = null;

// Affiliate Id
var kkAffiliateId = null;

// Hash map for product options
var optionMap = new Object();

// Default Currency
var defaultCurrency = null;

/*
 * Dynamically load any JavaScript file
 */
function kkLoadJS(filename) {
	var fileref = document.createElement('script');
	fileref.setAttribute("type", "text/javascript");
	fileref.setAttribute("src", filename);
	if (fileref.readyState) {
		fileref.onreadystatechange = function() { /* IE */
			if (fileref.readyState == "loaded"
					|| fileref.readyState == "complete") {
				fileref.onreadystatechange = null;
				kkLibLoadedCallback();
			}
		};
	} else {
		fileref.onload = function() { /* Other browsers */
			kkLibLoadedCallback();
		};
	}

	// Try to find the head, otherwise default to the documentElement
	if (typeof fileref != "undefined")
		(document.getElementsByTagName("head")[0] || document.documentElement)
				.appendChild(fileref);
}

/*
 * Dynamically load jQuery
 */
function kkLoadJquery(filename) {
	var fileref = document.createElement('script');
	fileref.setAttribute("type", "text/javascript");
	fileref.setAttribute("src", filename);
	if (fileref.readyState) {
		fileref.onreadystatechange = function() { /* IE */
			if (fileref.readyState == "loaded"
					|| fileref.readyState == "complete") {
				fileref.onreadystatechange = null;
				kkJQueryLoadedCallback();
			}
		};
	} else {
		fileref.onload = function() { /* Other browsers */
			kkJQueryLoadedCallback();
		};
	}

	// Try to find the head, otherwise default to the documentElement
	if (typeof fileref != "undefined")
		(document.getElementsByTagName("head")[0] || document.documentElement)
				.appendChild(fileref);
}

/*
 * Dynamically load any CSS file
 */
function kkLoadCSS(filename) {
	var fileref = document.createElement('link');
	fileref.setAttribute("type", "text/css");
	fileref.setAttribute("href", filename);
	fileref.setAttribute("rel", "stylesheet");
	document.getElementsByTagName("head")[0].appendChild(fileref);
}

/*
 * Once all Javascript libraries have been loaded we begin to render the widgets
 */
function kkLibLoadedCallback() {
	kkLibsLoaded += 1;
	if (kkLibsLoaded == kkNumLibs) {
		initKK();
		renderKKProds();
	}
}

/*
 * Called once jQuery has been loaded
 */
function kkJQueryLoadedCallback() {
	kkLoadCSS(kkCSSBase + jqueryUICSS);
	kkLoadCSS(kkCSSBase + kkCSS);
	kkLoadJS(kkScriptBase + jqueryUILib);
	kkLoadJS(kkScriptBase + jqueryJsonLib);
	kkLoadJS(kkScriptBase + jqueryKKLib);
}

/*
 * Get a temporary customer id Callback. A KK customer that isn't logged in, is
 * identified by a temporary id which is always negative. We get this unique id
 * from the engine and use it when adding items to the cart.
 */
var kkGetTempCustomerIdCallback = function(result, textStatus, jqXHR) {
	kkCustId = decodeJson(result);
	setKKCookie(KK_CUSTOMER_ID, kkCustId, 30);
};

/*
 * Get the default currency used for formatting
 */
var kkGetDefaultCurrencyCallback = function(result, textStatus, jqXHR) {
	defaultCurrency = decodeJson(result);
};

/*
 * Initialise KK
 */
function initKK() {
	
	var conf = new engineConfig(kkRoot + 'konakartjson');
	conf.storeId = "store1";
	conf.protocol = jsonProtocol;
	kkEngine = new kkEng(conf);

	// When json and IE we change the AJAX transport to support CORS
	if (jsonProtocol == 'json') {
		ieCORSSupport();
	}

	// Get the default currency
	kkEng.getDefaultCurrency(kkGetDefaultCurrencyCallback, null, kkEngine);

	// Get a temporary customer id Eng Call
	var cookie = getKKCookie(KK_CUSTOMER_ID);
	if (cookie == null) {
		kkEng.getTempCustomerId(kkGetTempCustomerIdCallback, null, kkEngine);
	} else {
		kkCustId = cookie;
	}
}

/*
 * For IE8, IE9 we use XDomainRequest instead of XMLHttpRequest. Needed for
 * CORS.
 */
function ieCORSSupport() {
	if (!jQuery.support.cors && window.XDomainRequest) {
		$.ajaxTransport('json', function(options, originalOptions, jqXHR) {
			var xdr=null;

			return {
				send : function(_, completeCallback) {
					xdr = new XDomainRequest();
					xdr.onload = function() {
						var responses = {
							text : xdr.responseText
						};

						completeCallback(200, 'success', responses);
						// we will assume that the status code is 200,
						// XDomainRequest rejects all other successful status
						// codes
						// see bug
						// https://connect.microsoft.com/IE/feedback/ViewFeedback.aspx?FeedbackID=334804
					};
					xdr.onerror = xdr.ontimeout = function() {
						var responses = {
							text : xdr.responseText
						};
						completeCallback(400, 'failed', responses);
					};

					xdr.open(options.type, options.url);
					xdr.send(options.data);
				},
				abort : function() {
					if (xdr) {
						xdr.abort();
					}
				}
			};
		});
	}
}
/*
 * Render all of the kk product widgets found on the page with class == kk-prod
 */
function renderKKProds() {

	$('.kk-prod').each(function(i, val) {
		var prodId = $(val).attr(KK_PROD_ID);
		// All widgets should have the same affiliate id
		if (!kkAffiliateId) {
			kkAffiliateId = $(val).attr(KK_AFFILIATE_ID);
		}
		if (prodId) {
			renderKKProd(val, prodId);
		}
	});
};

/*
 * Render a single kk product widget
 */
function renderKKProd(div, prodId) {
	// Get the product from the KK engine
	kkEng.getProduct(null, prodId, DEFAULT_LANG, getKKProductCallback, div,
			kkEngine);
};

/*
 * getKKProductCallback. Once we have the product information we can render the
 * tabs.
 */
var getKKProductCallback = function(result, textStatus, jqXHR) {

	var prod = decodeJson(result);
	var prodId = prod.id;
	var containerDivId = "kk-container-" + prodId;
	var tabDivId = "kk-tabs-" + prodId;
	var imgTabId = "kk-img-tab-" + prodId;
	var detailTabId = "kk-detail-tab-" + prodId;
	var cartTabId = "kk-cart-tab-" + prodId;

	$(this).append(
			'<div id="' + containerDivId + '" ><div class="kk-tabs" id="'
					+ tabDivId + '"><ul></ul></div></div>');
	// Create folders
	kkTabs[prodId] = $("#" + tabDivId).tabs();
	kkTabs[prodId].tabs("add", "#" + imgTabId, kkMsgImage);
	kkTabs[prodId].tabs("add", "#" + detailTabId, kkMsgDetails);
	kkTabs[prodId].tabs("add", "#" + cartTabId, kkMsgCart);

	renderKKImgTab(tabDivId, imgTabId, prod);
	if (prod=="") {
		return;
	}
	renderKKDetailTab(tabDivId, detailTabId, prod);
	renderKKCartTab(tabDivId, cartTabId, prod);

	// Get the basket items from the engine
	getBasketItemsPerCustomer();

	// Get the reviews from the engine
	var dataDesc = new DataDescriptor();
	dataDesc.limit = 10;
	dataDesc.orderBy = "ORDER_BY_DATE_ADDED_DESCENDING";
	kkEng.getReviewsPerProduct(dataDesc, prod.id, getKKReviewsCallback, prod,
			kkEngine);

};


/*
 * Single entry point for fetching basket from the engine
 */
function getBasketItemsPerCustomer() {

	if (kkCustId != null && kkCustId < 0) {
		kkEng.getBasketItemsPerCustomer(null, kkCustId, DEFAULT_LANG,
				kkGetBasketItemsPerCustomerCallback, null, kkEngine);

		$('.kk-prod').each(
				function(i, val) {
					var prodId = $(val).attr(KK_PROD_ID);
					// Show a loader animated gif
					var totalTd = $('#kk-cart-total-' + prodId).find('tbody').find(
							'td:nth-child(2)');
					totalTd.html('<img src="' + kkScriptBase
							+ '../images/loader.gif">');
				});	
	}
}

/*
 * getKKReviewsCallback. Once we have the product reviews information we can
 * render the reviews tab.
 */
var getKKReviewsCallback = function(result, textStatus, jqXHR) {

	var reviews = decodeJson(result);
	var prodId = this.id;
	if (reviews && reviews.reviewArray && reviews.reviewArray.length > 0) {
		var tabDivId = "kk-tabs-" + prodId;
		var revTabId = "kk-review-tab-" + prodId;
		kkTabs[prodId].tabs("add", "#" + revTabId, kkMsgReviews);
		renderKKReviewsTab(tabDivId, revTabId, this, reviews.reviewArray);
	}
};

/*
 * Create content for the Img tab
 */
function renderKKImgTab(tabDivId, imgTabId, prod) {

	if (prod=="") {
		$("#" + tabDivId).find("#" + imgTabId).append("Product not found");
		return;
	}
	var prodId = prod.id;
	var str = '<div class="kk-img-content" id="kk-imgcontent-' + prodId
			+ '"><div id="kk-gallery-' + prodId
			+ '"><div id="kk-gallery-output-' + prodId + '">';

	for ( var i = 1; i < 5; i++) {
		var imgBase = kkImgBase + prod.imageDir + prod.uuid;
		if (imgBase) {
			var imgSrc = imgBase + "_" + i + "_big.jpg";
			str += '<img id="img-' + prodId + '-' + i + '" src="' + imgSrc
					+ '" class="kk-large-img" />';
		}
	}

	str += '</div><div id="kk-gallery-nav-' + prodId + '">';

	for ( var i = 1; i < 5; i++) {
		var imgBase = kkImgBase + prod.imageDir + prod.uuid;
		if (imgBase) {
			var imgSrc = imgBase + "_" + i + "_tiny.jpg";
			str += '<a rel="img-' + prodId + '-' + i
					+ '" href="javascript:;"><img src="' + imgSrc
					+ '" class="kk-small-img"/></a>';
		}
	}

	str += '</div><div class="clear"></div></div></div>';
	$("#" + tabDivId).find("#" + imgTabId).append(str);

	$('#kk-gallery-output-' + prodId + ' img').not(":first").hide();

	$('#kk-gallery-' + prodId + ' a').click(function() {
		if ($("#" + this.rel).is(":hidden")) {
			$('#kk-gallery-output-' + prodId + ' img').slideUp();
			$("#" + this.rel).slideDown();
		}
	});

	// Write name and price and add to cart button
	kkAddAddToCartFooter(tabDivId, imgTabId, prod);

}

/*
 * Create content for the Detail tab
 */
function renderKKDetailTab(tabDivId, detailTabId, prod) {

	var prodId = prod.id;
	var str = '<div class="kk-detail-content" id="kk-detail-content-' + prodId
			+ '">';

	str += prod.description;

	if (prod.opts && prod.opts.length > 0) {
		var optId = -1;
		str += '<table width="100%">';
		for ( var i = 0; i < prod.opts.length; i++) {
			var option = prod.opts[i];
			if (optId != option.id) {
				if (optId != -1) {
					str += '</select></td></tr>';
				}
				str += '<tr><td><span>' + option.name + '</span>:</td>';
				var id = 'kk' + "-" + prodId + "-" + option.id;
				str += '<td><select id="' + id + '">';
				optId = option.id;
			}

			// Don't add price delta if price == 0
			var priceTxt = '';
			if (option.priceExTax != 0) {
				var sign = (option.priceExTax < 0) ? '-' : '+';
				priceTxt += ' (' + sign + kkFormatCurrency(option.priceExTax)
						+ ')';
			}

			var uniqueId = 'kk' + '-' + prodId + "-" + option.id + "-"
					+ option.valueId;
			str += '<option class="kk-option-'+prodId+'" id="' + uniqueId
					+ '" value="' + option.valueId + '">' + option.value
					+ priceTxt + '</option>';
			optionMap[uniqueId] = option;
		}
		str += '</select></td></tr>';
		str += '</table>';
	}

	str += '</div>';

	$("#" + tabDivId).find("#" + detailTabId).append(str);

	// Write name and price and add to cart button
	kkAddAddToCartFooter(tabDivId, detailTabId, prod);
}

/*
 * Create content for the Reviews tab
 */
function renderKKReviewsTab(tabDivId, revTabId, prod, reviewArray) {

	var prodId = prod.id;
	var str = '<div class="kk-reviews-content" id="kk-reviews-content-'
			+ prodId + '">';

	for ( var i = 0; i < reviewArray.length; i++) {
		var rev = reviewArray[i];
		var dateAdded = new Date(rev.dateAdded);
		str += '<div class="kk-review-header">';
		str += '<span style="padding-right:10px">' + rev.customerName
				+ "</span>";
		for ( var j = 0; j < rev.rating; j++) {
			str += '<span style="display: inline-block; vertical-align:middle;" class="ui-icon ui-icon-star"/>';
		}
		for ( var j = rev.rating; j < 5; j++) {
			str += '<span style="display: inline-block; vertical-align:middle;" class="ui-icon ui-state-disabled ui-icon-star"/>';
		}
		str += '<span style="float:right;">' + formatDate(dateAdded)
				+ '</span>';
		str += "</div>";
		str += '<div class="kk-review-text"><br/>';
		str += rev.reviewText;
		str += "</div>";
	}

	$("#" + tabDivId).find("#" + revTabId).append(str);

	// Write name and price and add to cart button
	kkAddAddToCartFooter(tabDivId, revTabId, prod);
}

/*
 * Create content for the Cart tab
 */
function renderKKCartTab(tabDivId, cartTabId, prod) {

	var prodId = prod.id;

	// Cart Items
	var str = '<div class="kk-cart-empty" id="kk-cart-empty-' + prodId + '">'
			+ kkMsgCartEmpty + '</div>';
	str += '<div class="kk-cart-content" id="kk-cart-content-' + prodId + '">';
	str += '<table class="kk-cart-content-table" id="kk-cart-content-' + prodId
			+ '" width="100%" border="0">';
	str += '<thead>';
	str += '<tr class="ui-state-hover">';
	str += '<th class="first" style="width:20%;"><span class="hidden">'
			+ kkMsgImage + '</span></th>';
	str += '<th style="width:50%;">' + kkMsgItem + '</th>';
	str += '<th colspan="2" style="width:20%;">' + kkMsgQty + '</th>';
	str += '<th style="width:10%;">' + kkMsgCost + '</th>';
	str += '<th class="last" style="width:5%;">' + '' + '</th>';
	str += '</tr>';
	str += '</thead>';
	str += '<tbody>';
	str += '</tbody>';
	str += '</table></div>';

	// Order Totals
	str += '<div class="kk-cart-order-totals" id="kk-cart-order-totals-'
			+ prodId + '">';
	str += '<table class="kk-cart-order-totals-table" id="kk-cart-order-totals-table-'
			+ prodId + '" width="100%" border="0">';
	str += '<tbody></tbody>';
	str += '</table></div>';

	// Total
	str += '<table class="kk-cart-total" id="kk-cart-total-' + prodId
			+ '" width="100%" border="0">';
	str += '<tbody><tr>';
	str += '<td class="kk-total-desc">';
	str += kkMsgTotal;
	str += '</td>';
	str += '<td></td>';
	str += '<td width="30%"><a id="kk-checkout-' + prodId
			+ '" href="" style="display: none">' + kkMsgCheckout + '</a></td>';
	str += '</tr></tbody>';
	str += '</table>';

	$("#" + tabDivId).find("#" + cartTabId).append(str);

	// Create the checkout button
	kkCheckoutBtns[prodId] = $('#kk-checkout-' + prodId).button();
	kkCheckoutBtns[prodId].hide();

	// Click the checkout button
	$(kkCheckoutBtns[prodId]).click(function() {
		// Save a token containing the temporary customer id
		var ssoToken = new SSOToken();
		ssoToken.customerId = kkCustId;
		kkEng.saveSSOToken(ssoToken, kkSaveSSOTokenCallback, null, kkEngine);
		return false;
	});

}

/*
 * kkSaveSSOTokenCallback
 */
var kkSaveSSOTokenCallback = function(result, textStatus, jqXHR) {
	var secretKey = decodeJson(result);
	/*
	 * Go to the KK store-front application passing it a key from which it can
	 * retrieve the SSO token containing the temporary customer id and so
	 * retrieve the basket items. Look at the source of
	 * InitFromTokenSubmitAction to see what the KK store front app does.
	 */
	var location = kkRoot + "InitFromToken.action?key=" + secretKey;
	if (kkAffiliateId) {
		location += '&aid=' + kkAffiliateId;
	}
	top.window.location = location;
};

/*
 * Common code to add price and add to cart button
 */
function kkAddAddToCartFooter(tabDivId, singleTabDivId, prod) {

	var prodId = prod.id;

	var str = '<table class="kk-add-to-cart-footer"><tr>';
	str += '<td><span class="kk-prod-name">' + prod.name + '</span></td>';
	str += '<td><span class="kk-prod-price">'
			+ kkFormatCurrency((prod.specialPriceExTax == null) ? prod.priceExTax
					: prod.specialPriceExTax) + '</span></td>';
	str += '<td><a class="kk-add-to-cart-button" id ="kk-add-to-cart-'
			+ singleTabDivId + '" href="">' + kkMsgAddToCart + '</a></td>';
	str += '</tr></table>';
	$("#" + tabDivId).find("#" + singleTabDivId).append(str);

	// Create the add to cart button
	var addToCartBtn = $('#kk-add-to-cart-' + singleTabDivId).button();

	$(addToCartBtn).click(
			function() {
				// Create a KonaKart basket item and send it to the engine
				var basket = new Basket();
				basket.quantity = 1;
				basket.productId = prodId;

				var optionArray = $('.kk-option-'+prodId);
				if (optionArray && optionArray.length > 0) {
					var selectedOptArray = new Array();
					var j = 0;
					for ( var i = 0; i < optionArray.length; i++) {
						var option = optionArray[i];
						if (option.selected == true) {
							var mapId = option.attributes.id.nodeValue;
							var optionObject = optionMap[mapId];
							if (optionObject) {
								selectedOptArray[j++] = optionObject;
							}
						}
					}
					if (selectedOptArray.length > 0) {
						basket.opts = selectedOptArray;
					}
				}

				kkEng.addToBasket(null, kkCustId, basket,
						kkAddToBasketCallback, prodId, kkEngine);
				return false;
			});

}

/*
 * Add to basket Callback
 */
var kkAddToBasketCallback = function(result, textStatus, jqXHR) {
	// Get the basket items from the engine
	getBasketItemsPerCustomer();

	// Show cart tab
	kkTabs[this].tabs('select', 2);
};

/*
 * Get basket Callback. Called after a product is added or removed from the
 * cart. The cart items are received from the engine and displayed. We have to
 * display the cart on all product widgets that could be on the page.
 */
var kkGetBasketItemsPerCustomerCallback = function(result, textStatus, jqXHR) {
	var basketArray = decodeJson(result);

	$('.kk-prod')
			.each(
					function(i, val) {

						var prodId = $(val).attr(KK_PROD_ID);

						// Calculate the total and update the cart
						var cartList = $('#kk-cart-content-' + prodId).find(
								'tbody');

						// Remove current items
						cartList.find('tr').remove();

						// Cart is empty
						if (basketArray.length == 0) {
							// Hide the checkout button
							kkCheckoutBtns[prodId].hide();

							// Hide the cart div
							$('#kk-cart-content-' + prodId).hide();
							// Hide the OT div
							$('#kk-cart-order-totals-' + prodId).hide();
							// Hide the total
							$('#kk-cart-total-' + prodId).hide();
							// Show the Empty text
							$('#kk-cart-empty-' + prodId).show();
							return;
						}

						// Show the checkout button
						kkCheckoutBtns[prodId].show();

						// Show the cart table
						$('#kk-cart-content-' + prodId).show();
						// Show the OT div
						$('#kk-cart-order-totals-' + prodId).show();
						// Show the total
						$('#kk-cart-total-' + prodId).show();
						// Hide the Empty text
						$('#kk-cart-empty-' + prodId).hide();

						// Add new items received from KK engine
						var total = 0;
						for ( var i = 0; i < basketArray.length; i++) {
							var basket = basketArray[i];
							var str = '<tr>';
							// Img
							str += '<td class="kk-first">';
							str += '<img src="' + kkImgBase + basket.product.imageDir + basket.product.uuid
									+ "_1_tiny.jpg"
									+ '" class="kk-small-img" />';
							str += '</td>';
							// Name
							str += '<td>';
							str += '<span class="kk-cart-product-name">'
									+ basket.product.name + '</span>';
							if (basket.opts) {
								for ( var j = 0; j < basket.opts.length; j++) {
									var opt = basket.opts[j];
									str += '<span class="kk-cart-option-name"><br>'
											+ '- '
											+ opt.name
											+ ' '
											+ opt.value
											+ '</span>';
								}
							}
							str += '</td>';
							// Qty
							str += '<td style="text-align:right;">';
							str += basket.quantity;
							str += '</td>';
							str += '<td  style="text-align:left;">';
							str += '<span title="'
									+ kkMsgInc
									+ '" class="ui-icon ui-state-disabled ui-icon-plus" id="kk-basketid-inc_'
									+ prodId + '_' + basket.id + '_'
									+ (basket.quantity + 1) + '"></span>';
							str += '<span title="'
									+ kkMsgDec
									+ '"  class="ui-icon ui-state-disabled ui-icon-minus" id="kk-basketid-dec_'
									+ prodId + '_' + basket.id + '_'
									+ (basket.quantity - 1) + '"></span>';
							str += '</td>';
							// Cost
							str += '<td style="text-align:right;">';
							str += kkFormatCurrency(basket.finalPriceExTax);
							str += '</td>';
							// Remove
							str += '<td>';
							str += '<a  title="'
									+ kkMsgRemove
									+ '" class="ui-icon ui-state-disabled ui-icon-close" id="kk-basketid-'
									+ prodId + '_' + basket.id + '"></a>';
							str += '</td>';
							str += '</tr>';
							cartList.append(str);
							total += basket.finalPriceExTax;

							// Basket remove link clicked
							$('#kk-basketid-' + prodId + '_' + basket.id)
									.unbind();
							$('#kk-basketid-' + prodId + '_' + basket.id).bind(
									'click',
									function(event) {

										var basket = new Basket();
										var idStr = event.target.id;
										basket.id = (idStr.split("_"))[1];
										kkEng.removeFromBasket(null, kkCustId,
												basket,
												kkRemoveFromBasketCallback,
												prodId, kkEngine);
									});

							// Basket increment quantity clicked
							$(
									'#kk-basketid-inc_' + prodId + '_'
											+ basket.id + '_'
											+ (basket.quantity + 1)).unbind();
							$(
									'#kk-basketid-inc_' + prodId + '_'
											+ basket.id + '_'
											+ (basket.quantity + 1)).bind(
									'click',
									function(event) {

										var basket = new Basket();
										var idStr = event.target.id;
										var idArray = idStr.split("_");

										basket.productId = idArray[1];
										basket.id = idArray[2];
										basket.quantity = idArray[3];
										kkEng.updateBasket(null, kkCustId,
												basket, kkUpdateBasketCallback,
												prodId, kkEngine);
									});

							// Basket decrement quantity clicked
							$(
									'#kk-basketid-dec_' + prodId + '_'
											+ basket.id + '_'
											+ (basket.quantity - 1)).unbind();
							$(
									'#kk-basketid-dec_' + prodId + '_'
											+ basket.id + '_'
											+ (basket.quantity - 1)).bind(
									'click',
									function(event) {

										var basket = new Basket();
										var idStr = event.target.id;
										var idArray = idStr.split("_");

										basket.productId = idArray[1];
										basket.id = idArray[2];
										basket.quantity = idArray[3];
										if (basket.quantity > 0) {
											kkEng.updateBasket(null, kkCustId,
													basket,
													kkUpdateBasketCallback,
													prodId, kkEngine);
										} else if (basket.quantity == 0) {

											kkEng.removeFromBasket(null,
													kkCustId, basket,
													kkRemoveFromBasketCallback,
													prodId, kkEngine);
										}
									});

						}
					});

	/*
	 * Create a temporary order to get shipping and any discount order totals
	 */
	if (basketArray.length > 0) {
		createTempOrder(basketArray);
	}

	// Add event handlers for icons
	$(' .kk-cart-content .ui-icon').hover(function() {
		$(this).removeClass('ui-state-disabled');
	}, function() {
		$(this).addClass('ui-state-disabled');
	});

};

/*
 * Create a temporary order
 */
function createTempOrder(basketArray) {

	var options = new CreateOrderOptions();
	options.useDefaultCustomer = true;
	options.billingAddrId = -1;
	options.customerAddrId = -1;
	options.deliveryAddrId = -1;

	// Make the message lighter by removing products
	for ( var i = 0; i < basketArray.length; i++) {
		var basket = basketArray[i];
		basket.product = null;
	}

	kkEng.createOrderWithOptions(null, basketArray, options, DEFAULT_LANG,
			getKKOrderCallback, null, kkEngine);
}

// Get Order Callback
var getKKOrderCallback = function(result, textStatus, jqXHR) {

	var order = decodeJson(result);
	if (order) {

		// Make the message lighter by removing product descriptions
		for ( var i = 0; i < order.orderProducts.length; i++) {
			var orderProduct = order.orderProducts[i];
			orderProduct.product.description = null;
		}

		order.customerId = kkCustId;
		// Get the shipping quotes
		kkEng.getShippingQuotes(order, DEFAULT_LANG,
				getKKShippingQuotesCallback, order, kkEngine);
	}
};

// Get Shipping Quotes Callback
var getKKShippingQuotesCallback = function(result, textStatus, jqXHR) {

	var quotes = decodeJson(result);
	var order = this;
	if (quotes && quotes.length > 0) {
		// Pick the first quote
		var quote = quotes[0];
		order.shippingQuote = quote;
		kkEng.getOrderTotals(order, DEFAULT_LANG, getKKPopulatedOrderCallback,
				order, kkEngine);
	}
};

// Get Populated Order Callback. This is the order with Order Totals.
var getKKPopulatedOrderCallback = function(result, textStatus, jqXHR) {

	var order = decodeJson(result);
	$('.kk-prod')
			.each(
					function(i, val) {

						var prodId = $(val).attr(KK_PROD_ID);

						// Update the order totals
						var otList = $('#kk-cart-order-totals-table-' + prodId)
								.find('tbody');

						// Remove current items
						otList.find('tr').remove();

						// Add the order totals
						if (order) {
							var str = '';
							for ( var i = 0; i < order.orderTotals.length; i++) {
								var orderTotal = order.orderTotals[i];
								if (orderTotal.className == 'ot_total') {
									// Manage total
									var totalTd = $('#kk-cart-total-' + prodId)
											.find('tbody').find(
													'td:nth-child(2)');
									totalTd
											.html('<span class="kk-prod-price">'
													+ kkFormatCurrency(orderTotal.value)
													+ '</span>');
								} else {
									str += '<tr>';
									str += '<td class="kk-order-total-title">';
									str += orderTotal.title;
									str += '</td>';
									str += '<td></td>';
									str += '<td class="kk-order-total-value">';

									if (orderTotal.className == 'ot_reward_points') {
										str += orderTotal.value;
									} else if (orderTotal.className == 'ot_free_product') {
										str += orderTotal.text;
									} else {
										str += kkFormatCurrency(orderTotal.value);
									}
									str += '</td></tr>';
								}
							}
							otList.append(str);
						}
					});

};

// Remove from basket Callback
var kkRemoveFromBasketCallback = function(result, textStatus, jqXHR) {
	// Get the basket items from the engine
	getBasketItemsPerCustomer();

	// Show cart tab
	kkTabs[this].tabs('select', 2);
};

// Update basket Callback
var kkUpdateBasketCallback = function(result, textStatus, jqXHR) {
	// Get the basket items from the engine
	getBasketItemsPerCustomer();

	// Show cart tab
	kkTabs[this].tabs('select', 2);
};

/*
 * Write a cookie
 */
function setKKCookie(c_name, value, exdays) {
	var exdate = new Date();
	exdate.setDate(exdate.getDate() + exdays);
	var c_value = escape(value)
			+ ((exdays == null) ? "" : "; expires=" + exdate.toUTCString());
	document.cookie = c_name + "=" + c_value;
}

/*
 * Read a coookie
 */
function getKKCookie(c_name) {
	var i, x, y, ARRcookies = document.cookie.split(";");
	for (i = 0; i < ARRcookies.length; i++) {
		x = ARRcookies[i].substr(0, ARRcookies[i].indexOf("="));
		y = ARRcookies[i].substr(ARRcookies[i].indexOf("=") + 1);
		x = x.replace(/^\s+|\s+$/g, "");
		if (x == c_name) {
			return unescape(y);
		}
	}
}

// Format the currency
function kkFormatCurrency(amount) {
	var i = parseFloat(amount);
	if (isNaN(i)) {
		i = 0.00;
	}
	i = Math.abs(i);
	i = parseInt((i + .005) * 100);
	i = i / 100;
	s = new String(i);
	if (s.indexOf('.') < 0) {
		s += '.00';
	}
	if (s.indexOf('.') == (s.length - 2)) {
		s += '0';
	}
	if (defaultCurrency) {
		return defaultCurrency.symbolLeft + s + defaultCurrency.symbolRight;
	}
	return '$' + s;
}

// Format a date
function formatDate(value) {
	return value.getMonth() + 1 + "/" + value.getDate() + "/"
			+ value.getFullYear();
}
