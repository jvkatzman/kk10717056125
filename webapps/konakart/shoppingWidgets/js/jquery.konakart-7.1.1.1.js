/*!
(c) 2011 DS Data Systems UK Ltd, All rights reserved.

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
 * Called by the Callback to convert the JSON returned by KonaKart to an object
 */
function decodeJson(jsonResult) {
	if (jsonResult == null) {
		return "";
	}
	var ret = jsonResult.r;
	if (ret == null) {
		var result = $.evalJSON(jsonResult);
		if (result != null && result.e != null) {
			alert("Exception:\t" + result.e + "\nMessage:\t" + result.m);
			return "";
		}
	}
	return ret;
}

/*
 * Used to configure the local KonaKart engine object
 */
function engineConfig(url) {
	this.url = url;
	this.storeId = null;
	this.protocol = 'json';
}

/*
 * Used to create an instance of the local KonaKart engine passed to all API
 * calls
 */
function kkEng(config) {
	this.url = config.url;
	this.storeId = config.storeId;
	this.protocol = config.protocol;
}

/*
 * Used to post the JSON request to the server side KonaKart engine. Actually we
 * do a GET because we use JSONP in order to get around all of the problems
 * associated with cross domain communications.
 */
function callEng(parms, callback, context, eng) {

	if (eng.protocol == 'jsonp') {
		$
				.ajax({
					type : 'GET',
					timeout : '20000',
					scriptCharset: "utf-8" ,
					contentType: "application/json; charset=utf-8",
					url : eng.url,
					data : parms,
					context : context,
					success : callback,
					error : function(jqXHR, textStatus, errorThrown) {
						var errorMsg = "JSONP API call to KonaKart engine wasn't successful. Verify that the KonaKart engine is available at the URL:\n"
								+ eng.url
								+ ", and that JSON is enabled for the engine.";
						if (textStatus != null && textStatus != '') {
							errorMsg += "\nStatus:\t" + textStatus;
						}
						if (errorThrown != null && errorThrown != '') {
							errorMsg += "\nError:\t" + errorThrown;
						}
						alert(errorMsg);
					},
					dataType : 'jsonp'
				});
	} else {
		$
				.ajax({
					type : 'POST',
					timeout : '20000',
					scriptCharset: "utf-8" ,
					contentType: "application/json; charset=utf-8",
					url : eng.url,
					data : parms,
					context : context,
					success : callback,
					error : function(jqXHR, textStatus, errorThrown) {
						var errorMsg = "JSON API call to KonaKart engine wasn't successful. Verify that the KonaKart engine is available at the URL:\n"
								+ eng.url
								+ ", and that JSON is enabled for the engine.";
						if (textStatus != null && textStatus != '') {
							errorMsg += "\nStatus:\t" + textStatus;
						}
						if (errorThrown != null && errorThrown != '') {
							errorMsg += "\nError:\t" + errorThrown;
						}
						alert(errorMsg);
					},
					dataType : 'json'
				});
	}
}

/*
 * Called by the generated JavaScript API calls to create a request for the
 * server side KonaKart engine in JSON format
 */
function createJsonParmString(funcName, parmArray, eng) {
	var ret = "{";
	if (parmArray != null) {
		for ( var i = 0; i < parmArray.length; i = i + 2) {
			if (i != 0) {
				ret = ret + ",";
			}
			var name = parmArray[i];
			var value = parmArray[i + 1];
			if ((typeof value == 'string')
					&& (value.charAt(0) == '{' || value.charAt(0) == '[')) {
				ret = ret + '"' + name + '":' + value;
			} else {
				ret = ret + '"' + name + '":"' + value + '"';
			}
		}
		ret = ret + ',';
	}
	ret = ret + '"f":"' + funcName + '"';
	if (eng.storeId != null) {
		ret = ret + ',"s":"' + eng.storeId + '"}';
	} else {
		ret = ret + '}';
	}
	return ret;
}

/*
 * API Calls
 */

kkEng.getLanguages=function(search,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (search != null) {
		parmArray[index++] = "search";
		parmArray[index++] = $.toJSON(search);
	}
	var jsonParms = createJsonParmString("getLanguages",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getAllLanguages=function(callback,context,eng){
	var jsonParms = createJsonParmString("getAllLanguages",null,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getDefaultLanguage=function(callback,context,eng){
	var jsonParms = createJsonParmString("getDefaultLanguage",null,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getLanguagePerCode=function(code,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (code != null) {
		parmArray[index++] = "code";
		parmArray[index++] = code;
	}
	var jsonParms = createJsonParmString("getLanguagePerCode",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getLanguagePerId=function(languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getLanguagePerId",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getCategoryTree=function(languageId,getNumProducts,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	parmArray[index++] = "getNumProducts";
	parmArray[index++] = getNumProducts;
	var jsonParms = createJsonParmString("getCategoryTree",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getProductsPerCategory=function(sessionId,dataDesc,categoryId,searchInSubCats,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "categoryId";
	parmArray[index++] = categoryId;
	parmArray[index++] = "searchInSubCats";
	parmArray[index++] = searchInSubCats;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getProductsPerCategory",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getProductsPerCategoryWithOptions=function(sessionId,dataDesc,categoryId,searchInSubCats,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "categoryId";
	parmArray[index++] = categoryId;
	parmArray[index++] = "searchInSubCats";
	parmArray[index++] = searchInSubCats;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getProductsPerCategoryWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getProductsPerCategoryPerManufacturer=function(sessionId,dataDesc,categoryId,manufacturerId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "categoryId";
	parmArray[index++] = categoryId;
	parmArray[index++] = "manufacturerId";
	parmArray[index++] = manufacturerId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getProductsPerCategoryPerManufacturer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getProductsPerCategoryPerManufacturerWithOptions=function(sessionId,dataDesc,categoryId,manufacturerId,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "categoryId";
	parmArray[index++] = categoryId;
	parmArray[index++] = "manufacturerId";
	parmArray[index++] = manufacturerId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getProductsPerCategoryPerManufacturerWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getProductsPerManufacturer=function(sessionId,dataDesc,manufacturerId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "manufacturerId";
	parmArray[index++] = manufacturerId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getProductsPerManufacturer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getProductsPerManufacturerWithOptions=function(sessionId,dataDesc,manufacturerId,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "manufacturerId";
	parmArray[index++] = manufacturerId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getProductsPerManufacturerWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getProduct=function(sessionId,productId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "productId";
	parmArray[index++] = productId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getProduct",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getProductWithOptions=function(sessionId,productId,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "productId";
	parmArray[index++] = productId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getProductWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getCategoriesPerManufacturer=function(manufacturerId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "manufacturerId";
	parmArray[index++] = manufacturerId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getCategoriesPerManufacturer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getCategoriesPerProduct=function(productId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "productId";
	parmArray[index++] = productId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getCategoriesPerProduct",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getManufacturersPerCategory=function(categoryId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "categoryId";
	parmArray[index++] = categoryId;
	var jsonParms = createJsonParmString("getManufacturersPerCategory",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getManufacturers=function(dataDesc,search,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	if (search != null) {
		parmArray[index++] = "search";
		parmArray[index++] = $.toJSON(search);
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getManufacturers",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getAllManufacturers=function(callback,context,eng){
	var jsonParms = createJsonParmString("getAllManufacturers",null,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getManufacturerPerProduct=function(productId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "productId";
	parmArray[index++] = productId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getManufacturerPerProduct",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getManufacturer=function(manufacturerId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "manufacturerId";
	parmArray[index++] = manufacturerId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getManufacturer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getCategory=function(categoryId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "categoryId";
	parmArray[index++] = categoryId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getCategory",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getSpecialsPerCategory=function(sessionId,dataDesc,categoryId,searchInSubCats,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "categoryId";
	parmArray[index++] = categoryId;
	parmArray[index++] = "searchInSubCats";
	parmArray[index++] = searchInSubCats;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getSpecialsPerCategory",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getAllSpecials=function(sessionId,dataDesc,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getAllSpecials",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getAllProducts=function(sessionId,dataDesc,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getAllProducts",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getAllProductsWithOptions=function(sessionId,dataDesc,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getAllProductsWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getReviewsPerProduct=function(dataDesc,productId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "productId";
	parmArray[index++] = productId;
	var jsonParms = createJsonParmString("getReviewsPerProduct",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getReview=function(reviewId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "reviewId";
	parmArray[index++] = reviewId;
	var jsonParms = createJsonParmString("getReview",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getAllReviews=function(dataDesc,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	var jsonParms = createJsonParmString("getAllReviews",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getReviews=function(dataDesc,search,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	if (search != null) {
		parmArray[index++] = "search";
		parmArray[index++] = $.toJSON(search);
	}
	var jsonParms = createJsonParmString("getReviews",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.searchForProducts=function(sessionId,dataDesc,prodSearch,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	if (prodSearch != null) {
		parmArray[index++] = "prodSearch";
		parmArray[index++] = $.toJSON(prodSearch);
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("searchForProducts",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.searchForProductsWithOptions=function(sessionId,dataDesc,prodSearch,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	if (prodSearch != null) {
		parmArray[index++] = "prodSearch";
		parmArray[index++] = $.toJSON(prodSearch);
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("searchForProductsWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.registerCustomer=function(custReg,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (custReg != null) {
		parmArray[index++] = "custReg";
		parmArray[index++] = $.toJSON(custReg);
	}
	var jsonParms = createJsonParmString("registerCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.forceRegisterCustomer=function(custReg,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (custReg != null) {
		parmArray[index++] = "custReg";
		parmArray[index++] = $.toJSON(custReg);
	}
	var jsonParms = createJsonParmString("forceRegisterCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getAllCountries=function(callback,context,eng){
	var jsonParms = createJsonParmString("getAllCountries",null,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.login=function(emailAddr,password,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (emailAddr != null) {
		parmArray[index++] = "emailAddr";
		parmArray[index++] = emailAddr;
	}
	if (password != null) {
		parmArray[index++] = "password";
		parmArray[index++] = password;
	}
	var jsonParms = createJsonParmString("login",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.logout=function(sessionId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	var jsonParms = createJsonParmString("logout",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getAddressesPerCustomer=function(sessionId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	var jsonParms = createJsonParmString("getAddressesPerCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getAddressesPerManufacturer=function(manufacturerId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "manufacturerId";
	parmArray[index++] = manufacturerId;
	var jsonParms = createJsonParmString("getAddressesPerManufacturer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getAddressesPerProduct=function(productId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "productId";
	parmArray[index++] = productId;
	var jsonParms = createJsonParmString("getAddressesPerProduct",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getAddressesPerStore=function(addressStoreId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (addressStoreId != null) {
		parmArray[index++] = "addressStoreId";
		parmArray[index++] = addressStoreId;
	}
	var jsonParms = createJsonParmString("getAddressesPerStore",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getDefaultAddressPerCustomer=function(sessionId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	var jsonParms = createJsonParmString("getDefaultAddressPerCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.setDefaultAddressPerCustomer=function(sessionId,addressId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "addressId";
	parmArray[index++] = addressId;
	var jsonParms = createJsonParmString("setDefaultAddressPerCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.addAddressToCustomer=function(sessionId,addr,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (addr != null) {
		parmArray[index++] = "addr";
		parmArray[index++] = $.toJSON(addr);
	}
	var jsonParms = createJsonParmString("addAddressToCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.deleteAddressFromCustomer=function(sessionId,addressId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "addressId";
	parmArray[index++] = addressId;
	var jsonParms = createJsonParmString("deleteAddressFromCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.editCustomerAddress=function(sessionId,addr,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (addr != null) {
		parmArray[index++] = "addr";
		parmArray[index++] = $.toJSON(addr);
	}
	var jsonParms = createJsonParmString("editCustomerAddress",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getCustomer=function(sessionId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	var jsonParms = createJsonParmString("getCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.editCustomer=function(sessionId,cust,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (cust != null) {
		parmArray[index++] = "cust";
		parmArray[index++] = $.toJSON(cust);
	}
	var jsonParms = createJsonParmString("editCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getKonakartTimeStamp=function(callback,context,eng){
	var jsonParms = createJsonParmString("getKonakartTimeStamp",null,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.writeReview=function(sessionId,review,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (review != null) {
		parmArray[index++] = "review";
		parmArray[index++] = $.toJSON(review);
	}
	var jsonParms = createJsonParmString("writeReview",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.checkSession=function(sessionId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	var jsonParms = createJsonParmString("checkSession",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.addToBasket=function(sessionId,customerId,item,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	if (item != null) {
		parmArray[index++] = "item";
		parmArray[index++] = $.toJSON(item);
	}
	var jsonParms = createJsonParmString("addToBasket",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.addToBasketWithOptions=function(sessionId,customerId,item,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	if (item != null) {
		parmArray[index++] = "item";
		parmArray[index++] = $.toJSON(item);
	}
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("addToBasketWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.mergeBaskets=function(sessionId,customerFromId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "customerFromId";
	parmArray[index++] = customerFromId;
	var jsonParms = createJsonParmString("mergeBaskets",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.mergeBasketsWithOptions=function(sessionId,customerFromId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "customerFromId";
	parmArray[index++] = customerFromId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("mergeBasketsWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.updateBasket=function(sessionId,customerId,item,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	if (item != null) {
		parmArray[index++] = "item";
		parmArray[index++] = $.toJSON(item);
	}
	var jsonParms = createJsonParmString("updateBasket",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.updateBasketWithOptions=function(sessionId,customerId,item,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	if (item != null) {
		parmArray[index++] = "item";
		parmArray[index++] = $.toJSON(item);
	}
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("updateBasketWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.removeFromBasket=function(sessionId,customerId,item,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	if (item != null) {
		parmArray[index++] = "item";
		parmArray[index++] = $.toJSON(item);
	}
	var jsonParms = createJsonParmString("removeFromBasket",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.removeBasketItemsPerCustomer=function(sessionId,customerId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	var jsonParms = createJsonParmString("removeBasketItemsPerCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getBasketItemsPerCustomer=function(sessionId,customerId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getBasketItemsPerCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getBasketItemsPerCustomerWithOptions=function(sessionId,customerId,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getBasketItemsPerCustomerWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getDefaultCurrency=function(callback,context,eng){
	var jsonParms = createJsonParmString("getDefaultCurrency",null,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getAllCurrencies=function(callback,context,eng){
	var jsonParms = createJsonParmString("getAllCurrencies",null,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getConfigurations=function(callback,context,eng){
	var jsonParms = createJsonParmString("getConfigurations",null,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getConfiguration=function(key,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (key != null) {
		parmArray[index++] = "key";
		parmArray[index++] = key;
	}
	var jsonParms = createJsonParmString("getConfiguration",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getConfigurationValue=function(key,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (key != null) {
		parmArray[index++] = "key";
		parmArray[index++] = key;
	}
	var jsonParms = createJsonParmString("getConfigurationValue",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getConfigurationValueAsInt=function(key,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (key != null) {
		parmArray[index++] = "key";
		parmArray[index++] = key;
	}
	var jsonParms = createJsonParmString("getConfigurationValueAsInt",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getConfigurationValueAsIntWithDefault=function(key,def,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (key != null) {
		parmArray[index++] = "key";
		parmArray[index++] = key;
	}
	parmArray[index++] = "def";
	parmArray[index++] = def;
	var jsonParms = createJsonParmString("getConfigurationValueAsIntWithDefault",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getConfigurationValueAsBigDecimal=function(key,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (key != null) {
		parmArray[index++] = "key";
		parmArray[index++] = key;
	}
	var jsonParms = createJsonParmString("getConfigurationValueAsBigDecimal",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getConfigurationValueAsBigDecimalWithDefault=function(key,def,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (key != null) {
		parmArray[index++] = "key";
		parmArray[index++] = key;
	}
	if (def != null) {
		parmArray[index++] = "def";
		parmArray[index++] = def;
	}
	var jsonParms = createJsonParmString("getConfigurationValueAsBigDecimalWithDefault",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getConfigurationValueAsBool=function(key,def,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (key != null) {
		parmArray[index++] = "key";
		parmArray[index++] = key;
	}
	if (def != null) {
		parmArray[index++] = "def";
		parmArray[index++] = def;
	}
	var jsonParms = createJsonParmString("getConfigurationValueAsBool",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.editConfiguration=function(key,value,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (key != null) {
		parmArray[index++] = "key";
		parmArray[index++] = key;
	}
	if (value != null) {
		parmArray[index++] = "value";
		parmArray[index++] = value;
	}
	var jsonParms = createJsonParmString("editConfiguration",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.changePassword=function(sessionId,currentPassword,newPassword,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (currentPassword != null) {
		parmArray[index++] = "currentPassword";
		parmArray[index++] = currentPassword;
	}
	if (newPassword != null) {
		parmArray[index++] = "newPassword";
		parmArray[index++] = newPassword;
	}
	var jsonParms = createJsonParmString("changePassword",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getProductNotificationsPerCustomer=function(sessionId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getProductNotificationsPerCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getProductNotificationsPerCustomerWithOptions=function(sessionId,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getProductNotificationsPerCustomerWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.addProductNotificationToCustomer=function(sessionId,productId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "productId";
	parmArray[index++] = productId;
	var jsonParms = createJsonParmString("addProductNotificationToCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.deleteProductNotificationFromCustomer=function(sessionId,productId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "productId";
	parmArray[index++] = productId;
	var jsonParms = createJsonParmString("deleteProductNotificationFromCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.updateProductViewedCount=function(productId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "productId";
	parmArray[index++] = productId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("updateProductViewedCount",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getBestSellers=function(dataDesc,categoryId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "categoryId";
	parmArray[index++] = categoryId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getBestSellers",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getBestSellersWithOptions=function(dataDesc,categoryId,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "categoryId";
	parmArray[index++] = categoryId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getBestSellersWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getOrdersPerCustomer=function(dataDesc,sessionId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getOrdersPerCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.searchForOrdersPerCustomer=function(sessionId,dataDesc,orderSearch,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	if (orderSearch != null) {
		parmArray[index++] = "orderSearch";
		parmArray[index++] = $.toJSON(orderSearch);
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("searchForOrdersPerCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getOrder=function(sessionId,orderId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "orderId";
	parmArray[index++] = orderId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getOrder",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getCurrency=function(currencyCode,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (currencyCode != null) {
		parmArray[index++] = "currencyCode";
		parmArray[index++] = currencyCode;
	}
	var jsonParms = createJsonParmString("getCurrency",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.createOrder=function(sessionId,basketItemArray,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (basketItemArray != null) {
		parmArray[index++] = "basketItemArray";
		parmArray[index++] = $.toJSON(basketItemArray);
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("createOrder",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.createOrderWithOptions=function(sessionId,basketItemArray,options,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (basketItemArray != null) {
		parmArray[index++] = "basketItemArray";
		parmArray[index++] = $.toJSON(basketItemArray);
	}
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("createOrderWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getOrderHistory=function(dataDesc,sessionId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getOrderHistory",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getOrderHistoryWithOptions=function(dataDesc,sessionId,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getOrderHistoryWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getAlsoPurchased=function(sessionId,dataDesc,productId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "productId";
	parmArray[index++] = productId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getAlsoPurchased",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getAlsoPurchasedWithOptions=function(sessionId,dataDesc,productId,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "productId";
	parmArray[index++] = productId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getAlsoPurchasedWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getRelatedProducts=function(sessionId,dataDesc,productId,relationType,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "productId";
	parmArray[index++] = productId;
	parmArray[index++] = "relationType";
	parmArray[index++] = relationType;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getRelatedProducts",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getRelatedProductsWithOptions=function(sessionId,dataDesc,productId,relationType,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "productId";
	parmArray[index++] = productId;
	parmArray[index++] = "relationType";
	parmArray[index++] = relationType;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getRelatedProductsWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getCountryPerName=function(countryName,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (countryName != null) {
		parmArray[index++] = "countryName";
		parmArray[index++] = countryName;
	}
	var jsonParms = createJsonParmString("getCountryPerName",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getCountry=function(countryId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "countryId";
	parmArray[index++] = countryId;
	var jsonParms = createJsonParmString("getCountry",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getShippingQuotes=function(order,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (order != null) {
		parmArray[index++] = "order";
		parmArray[index++] = $.toJSON(order);
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getShippingQuotes",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getShippingQuote=function(order,moduleName,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (order != null) {
		parmArray[index++] = "order";
		parmArray[index++] = $.toJSON(order);
	}
	if (moduleName != null) {
		parmArray[index++] = "moduleName";
		parmArray[index++] = moduleName;
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getShippingQuote",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.changeDeliveryAddress=function(sessionId,order,deliveryAddress,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (order != null) {
		parmArray[index++] = "order";
		parmArray[index++] = $.toJSON(order);
	}
	if (deliveryAddress != null) {
		parmArray[index++] = "deliveryAddress";
		parmArray[index++] = $.toJSON(deliveryAddress);
	}
	var jsonParms = createJsonParmString("changeDeliveryAddress",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getTaxRate=function(countryId,zoneId,taxClassId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "countryId";
	parmArray[index++] = countryId;
	parmArray[index++] = "zoneId";
	parmArray[index++] = zoneId;
	parmArray[index++] = "taxClassId";
	parmArray[index++] = taxClassId;
	var jsonParms = createJsonParmString("getTaxRate",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getTax=function(cost,countryId,zoneId,taxClassId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (cost != null) {
		parmArray[index++] = "cost";
		parmArray[index++] = cost;
	}
	parmArray[index++] = "countryId";
	parmArray[index++] = countryId;
	parmArray[index++] = "zoneId";
	parmArray[index++] = zoneId;
	parmArray[index++] = "taxClassId";
	parmArray[index++] = taxClassId;
	var jsonParms = createJsonParmString("getTax",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.addTax=function(cost,countryId,zoneId,taxClassId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (cost != null) {
		parmArray[index++] = "cost";
		parmArray[index++] = cost;
	}
	parmArray[index++] = "countryId";
	parmArray[index++] = countryId;
	parmArray[index++] = "zoneId";
	parmArray[index++] = zoneId;
	parmArray[index++] = "taxClassId";
	parmArray[index++] = taxClassId;
	var jsonParms = createJsonParmString("addTax",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getOrderTotals=function(order,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (order != null) {
		parmArray[index++] = "order";
		parmArray[index++] = $.toJSON(order);
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getOrderTotals",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getPaymentGateways=function(order,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (order != null) {
		parmArray[index++] = "order";
		parmArray[index++] = $.toJSON(order);
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getPaymentGateways",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getPaymentGateway=function(order,moduleName,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (order != null) {
		parmArray[index++] = "order";
		parmArray[index++] = $.toJSON(order);
	}
	if (moduleName != null) {
		parmArray[index++] = "moduleName";
		parmArray[index++] = moduleName;
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getPaymentGateway",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getPaymentDetails=function(sessionId,moduleCode,orderId,hostAndPort,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (moduleCode != null) {
		parmArray[index++] = "moduleCode";
		parmArray[index++] = moduleCode;
	}
	parmArray[index++] = "orderId";
	parmArray[index++] = orderId;
	if (hostAndPort != null) {
		parmArray[index++] = "hostAndPort";
		parmArray[index++] = hostAndPort;
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getPaymentDetails",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getPaymentDetailsPerOrder=function(sessionId,moduleCode,order,hostAndPort,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (moduleCode != null) {
		parmArray[index++] = "moduleCode";
		parmArray[index++] = moduleCode;
	}
	if (order != null) {
		parmArray[index++] = "order";
		parmArray[index++] = $.toJSON(order);
	}
	if (hostAndPort != null) {
		parmArray[index++] = "hostAndPort";
		parmArray[index++] = hostAndPort;
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getPaymentDetailsPerOrder",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.saveOrder=function(sessionId,order,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (order != null) {
		parmArray[index++] = "order";
		parmArray[index++] = $.toJSON(order);
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("saveOrder",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getStatusText=function(statusId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "statusId";
	parmArray[index++] = statusId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getStatusText",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.updateOrder=function(sessionId,orderId,status,customerNotified,comments,updateOrder,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "orderId";
	parmArray[index++] = orderId;
	parmArray[index++] = "status";
	parmArray[index++] = status;
	parmArray[index++] = "customerNotified";
	parmArray[index++] = customerNotified;
	if (comments != null) {
		parmArray[index++] = "comments";
		parmArray[index++] = comments;
	}
	if (updateOrder != null) {
		parmArray[index++] = "updateOrder";
		parmArray[index++] = $.toJSON(updateOrder);
	}
	var jsonParms = createJsonParmString("updateOrder",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.changeOrderStatus=function(sessionId,orderId,status,customerNotified,comments,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "orderId";
	parmArray[index++] = orderId;
	parmArray[index++] = "status";
	parmArray[index++] = status;
	parmArray[index++] = "customerNotified";
	parmArray[index++] = customerNotified;
	if (comments != null) {
		parmArray[index++] = "comments";
		parmArray[index++] = comments;
	}
	var jsonParms = createJsonParmString("changeOrderStatus",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.updateInventory=function(sessionId,orderId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "orderId";
	parmArray[index++] = orderId;
	var jsonParms = createJsonParmString("updateInventory",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.updateInventoryWithOptions=function(sessionId,orderId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "orderId";
	parmArray[index++] = orderId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("updateInventoryWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.sendNewPassword=function(emailAddr,subject,countryCode,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (emailAddr != null) {
		parmArray[index++] = "emailAddr";
		parmArray[index++] = emailAddr;
	}
	if (subject != null) {
		parmArray[index++] = "subject";
		parmArray[index++] = subject;
	}
	if (countryCode != null) {
		parmArray[index++] = "countryCode";
		parmArray[index++] = countryCode;
	}
	var jsonParms = createJsonParmString("sendNewPassword",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.sendNewPassword1=function(emailAddr,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (emailAddr != null) {
		parmArray[index++] = "emailAddr";
		parmArray[index++] = emailAddr;
	}
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("sendNewPassword1",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.sendWelcomeEmail=function(customerId,mailSubject,countryCode,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	if (mailSubject != null) {
		parmArray[index++] = "mailSubject";
		parmArray[index++] = mailSubject;
	}
	if (countryCode != null) {
		parmArray[index++] = "countryCode";
		parmArray[index++] = countryCode;
	}
	var jsonParms = createJsonParmString("sendWelcomeEmail",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.sendWelcomeEmail1=function(customerId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("sendWelcomeEmail1",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.sendOrderConfirmationEmail=function(sessionId,orderId,mailSubject,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "orderId";
	parmArray[index++] = orderId;
	if (mailSubject != null) {
		parmArray[index++] = "mailSubject";
		parmArray[index++] = mailSubject;
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("sendOrderConfirmationEmail",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.sendOrderConfirmationEmail1=function(sessionId,orderId,langIdForOrder,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "orderId";
	parmArray[index++] = orderId;
	parmArray[index++] = "langIdForOrder";
	parmArray[index++] = langIdForOrder;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("sendOrderConfirmationEmail1",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getSecretKeyForOrderId=function(orderId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "orderId";
	parmArray[index++] = orderId;
	var jsonParms = createJsonParmString("getSecretKeyForOrderId",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getOrderIdFromSecretKey=function(secretKey,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (secretKey != null) {
		parmArray[index++] = "secretKey";
		parmArray[index++] = secretKey;
	}
	var jsonParms = createJsonParmString("getOrderIdFromSecretKey",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.deleteOrderIdForSecretKey=function(secretKey,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (secretKey != null) {
		parmArray[index++] = "secretKey";
		parmArray[index++] = secretKey;
	}
	var jsonParms = createJsonParmString("deleteOrderIdForSecretKey",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.saveIpnHistory=function(sessionId,ipnHistory,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (ipnHistory != null) {
		parmArray[index++] = "ipnHistory";
		parmArray[index++] = $.toJSON(ipnHistory);
	}
	var jsonParms = createJsonParmString("saveIpnHistory",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.updateManufacturerViewedCount=function(manufacturerId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "manufacturerId";
	parmArray[index++] = manufacturerId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("updateManufacturerViewedCount",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getZonesPerCountry=function(countryId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "countryId";
	parmArray[index++] = countryId;
	var jsonParms = createJsonParmString("getZonesPerCountry",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.searchForZones=function(search,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (search != null) {
		parmArray[index++] = "search";
		parmArray[index++] = $.toJSON(search);
	}
	var jsonParms = createJsonParmString("searchForZones",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.updateCachedConfigurations=function(callback,context,eng){
	var jsonParms = createJsonParmString("updateCachedConfigurations",null,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.doesCustomerExistForEmail=function(emailAddr,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (emailAddr != null) {
		parmArray[index++] = "emailAddr";
		parmArray[index++] = emailAddr;
	}
	var jsonParms = createJsonParmString("doesCustomerExistForEmail",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.isEmailValid=function(emailAddr,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (emailAddr != null) {
		parmArray[index++] = "emailAddr";
		parmArray[index++] = emailAddr;
	}
	var jsonParms = createJsonParmString("isEmailValid",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.updateBasketWithStockInfo=function(basketItems,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (basketItems != null) {
		parmArray[index++] = "basketItems";
		parmArray[index++] = $.toJSON(basketItems);
	}
	var jsonParms = createJsonParmString("updateBasketWithStockInfo",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.updateBasketWithStockInfoWithOptions=function(basketItems,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (basketItems != null) {
		parmArray[index++] = "basketItems";
		parmArray[index++] = $.toJSON(basketItems);
	}
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("updateBasketWithStockInfoWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getProductQuantity=function(encodedProductId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (encodedProductId != null) {
		parmArray[index++] = "encodedProductId";
		parmArray[index++] = encodedProductId;
	}
	var jsonParms = createJsonParmString("getProductQuantity",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getProductQuantityWithOptions=function(encodedProductId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (encodedProductId != null) {
		parmArray[index++] = "encodedProductId";
		parmArray[index++] = encodedProductId;
	}
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getProductQuantityWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.createAndSaveOrder=function(emailAddr,password,custReg,basketItemArray,shippingModule,paymentModule,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (emailAddr != null) {
		parmArray[index++] = "emailAddr";
		parmArray[index++] = emailAddr;
	}
	if (password != null) {
		parmArray[index++] = "password";
		parmArray[index++] = password;
	}
	if (custReg != null) {
		parmArray[index++] = "custReg";
		parmArray[index++] = $.toJSON(custReg);
	}
	if (basketItemArray != null) {
		parmArray[index++] = "basketItemArray";
		parmArray[index++] = $.toJSON(basketItemArray);
	}
	if (shippingModule != null) {
		parmArray[index++] = "shippingModule";
		parmArray[index++] = shippingModule;
	}
	if (paymentModule != null) {
		parmArray[index++] = "paymentModule";
		parmArray[index++] = paymentModule;
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("createAndSaveOrder",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getSku=function(orderProd,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (orderProd != null) {
		parmArray[index++] = "orderProd";
		parmArray[index++] = $.toJSON(orderProd);
	}
	var jsonParms = createJsonParmString("getSku",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.setEndpoint=function(wsEndpoint,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (wsEndpoint != null) {
		parmArray[index++] = "wsEndpoint";
		parmArray[index++] = wsEndpoint;
	}
	var jsonParms = createJsonParmString("setEndpoint",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.insertDigitalDownload=function(sessionId,productId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "productId";
	parmArray[index++] = productId;
	var jsonParms = createJsonParmString("insertDigitalDownload",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getDigitalDownloads=function(sessionId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	var jsonParms = createJsonParmString("getDigitalDownloads",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.updateDigitalDownloadCount=function(sessionId,productId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "productId";
	parmArray[index++] = productId;
	var jsonParms = createJsonParmString("updateDigitalDownloadCount",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.updateDigitalDownloadCountById=function(sessionId,digitalDownloadId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "digitalDownloadId";
	parmArray[index++] = digitalDownloadId;
	var jsonParms = createJsonParmString("updateDigitalDownloadCountById",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getTempCustomerId=function(callback,context,eng){
	var jsonParms = createJsonParmString("getTempCustomerId",null,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getAllCustomerGroups=function(languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getAllCustomerGroups",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getCustomerGroup=function(customerGroupId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "customerGroupId";
	parmArray[index++] = customerGroupId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getCustomerGroup",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.sendTemplateEmailToCustomer=function(customerId,templateName,message,countryCode,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	if (templateName != null) {
		parmArray[index++] = "templateName";
		parmArray[index++] = templateName;
	}
	if (message != null) {
		parmArray[index++] = "message";
		parmArray[index++] = message;
	}
	if (countryCode != null) {
		parmArray[index++] = "countryCode";
		parmArray[index++] = countryCode;
	}
	var jsonParms = createJsonParmString("sendTemplateEmailToCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.sendTemplateEmailToCustomer1=function(customerId,message,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	if (message != null) {
		parmArray[index++] = "message";
		parmArray[index++] = message;
	}
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("sendTemplateEmailToCustomer1",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.loginByAdmin=function(adminSession,customerId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (adminSession != null) {
		parmArray[index++] = "adminSession";
		parmArray[index++] = adminSession;
	}
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	var jsonParms = createJsonParmString("loginByAdmin",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.custom=function(input1,input2,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (input1 != null) {
		parmArray[index++] = "input1";
		parmArray[index++] = input1;
	}
	if (input2 != null) {
		parmArray[index++] = "input2";
		parmArray[index++] = input2;
	}
	var jsonParms = createJsonParmString("custom",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.customSecure=function(sessionId,input1,input2,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (input1 != null) {
		parmArray[index++] = "input1";
		parmArray[index++] = input1;
	}
	if (input2 != null) {
		parmArray[index++] = "input2";
		parmArray[index++] = input2;
	}
	var jsonParms = createJsonParmString("customSecure",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getTagGroupsPerCategory=function(categoryId,getProdCount,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "categoryId";
	parmArray[index++] = categoryId;
	parmArray[index++] = "getProdCount";
	parmArray[index++] = getProdCount;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getTagGroupsPerCategory",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getTagGroupsPerCategoryWithOptions=function(categoryId,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "categoryId";
	parmArray[index++] = categoryId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getTagGroupsPerCategoryWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getTagsPerCategory=function(categoryId,getProdCount,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "categoryId";
	parmArray[index++] = categoryId;
	parmArray[index++] = "getProdCount";
	parmArray[index++] = getProdCount;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getTagsPerCategory",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getTagGroup=function(tagGroupId,getProdCount,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "tagGroupId";
	parmArray[index++] = tagGroupId;
	parmArray[index++] = "getProdCount";
	parmArray[index++] = getProdCount;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getTagGroup",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getTag=function(tagId,getProdCount,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "tagId";
	parmArray[index++] = tagId;
	parmArray[index++] = "getProdCount";
	parmArray[index++] = getProdCount;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getTag",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getDefaultCustomer=function(callback,context,eng){
	var jsonParms = createJsonParmString("getDefaultCustomer",null,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getEngConf=function(callback,context,eng){
	var jsonParms = createJsonParmString("getEngConf",null,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getStoreIds=function(callback,context,eng){
	var jsonParms = createJsonParmString("getStoreIds",null,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.setCreditCardDetailsOnOrder=function(sessionId,orderId,card,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "orderId";
	parmArray[index++] = orderId;
	if (card != null) {
		parmArray[index++] = "card";
		parmArray[index++] = $.toJSON(card);
	}
	var jsonParms = createJsonParmString("setCreditCardDetailsOnOrder",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.addToWishList=function(sessionId,wishListItem,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (wishListItem != null) {
		parmArray[index++] = "wishListItem";
		parmArray[index++] = $.toJSON(wishListItem);
	}
	var jsonParms = createJsonParmString("addToWishList",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.addToWishListWithOptions=function(sessionId,wishListItem,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (wishListItem != null) {
		parmArray[index++] = "wishListItem";
		parmArray[index++] = $.toJSON(wishListItem);
	}
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("addToWishListWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.createWishList=function(sessionId,wishList,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (wishList != null) {
		parmArray[index++] = "wishList";
		parmArray[index++] = $.toJSON(wishList);
	}
	var jsonParms = createJsonParmString("createWishList",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.createWishListWithOptions=function(sessionId,wishList,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (wishList != null) {
		parmArray[index++] = "wishList";
		parmArray[index++] = $.toJSON(wishList);
	}
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("createWishListWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.editWishList=function(sessionId,wishList,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (wishList != null) {
		parmArray[index++] = "wishList";
		parmArray[index++] = $.toJSON(wishList);
	}
	var jsonParms = createJsonParmString("editWishList",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.editWishListWithOptions=function(sessionId,wishList,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (wishList != null) {
		parmArray[index++] = "wishList";
		parmArray[index++] = $.toJSON(wishList);
	}
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("editWishListWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.deleteWishList=function(sessionId,wishListId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "wishListId";
	parmArray[index++] = wishListId;
	var jsonParms = createJsonParmString("deleteWishList",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.deleteWishListWithOptions=function(sessionId,wishListId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "wishListId";
	parmArray[index++] = wishListId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("deleteWishListWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getWishListWithItems=function(sessionId,wishListId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "wishListId";
	parmArray[index++] = wishListId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getWishListWithItems",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getWishListWithItemsWithOptions=function(sessionId,wishListId,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "wishListId";
	parmArray[index++] = wishListId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getWishListWithItemsWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getWishList=function(sessionId,wishListId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "wishListId";
	parmArray[index++] = wishListId;
	var jsonParms = createJsonParmString("getWishList",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getWishListWithOptions=function(sessionId,wishListId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "wishListId";
	parmArray[index++] = wishListId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getWishListWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getWishListItemsWithOptions=function(sessionId,dataDesc,wishListId,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "wishListId";
	parmArray[index++] = wishListId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getWishListItemsWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getWishListItems=function(sessionId,dataDesc,wishListId,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "wishListId";
	parmArray[index++] = wishListId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getWishListItems",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.removeFromWishList=function(sessionId,wishListItemId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "wishListItemId";
	parmArray[index++] = wishListItemId;
	var jsonParms = createJsonParmString("removeFromWishList",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.removeFromWishListWithOptions=function(sessionId,wishListItemId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "wishListItemId";
	parmArray[index++] = wishListItemId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("removeFromWishListWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.mergeWishListsWithOptions=function(sessionId,customerFromId,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "customerFromId";
	parmArray[index++] = customerFromId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("mergeWishListsWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.searchForWishLists=function(sessionId,dataDesc,customerSearch,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	if (customerSearch != null) {
		parmArray[index++] = "customerSearch";
		parmArray[index++] = $.toJSON(customerSearch);
	}
	var jsonParms = createJsonParmString("searchForWishLists",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getStore=function(callback,context,eng){
	var jsonParms = createJsonParmString("getStore",null,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.addCustomDataToSession=function(sessionId,data,position,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (data != null) {
		parmArray[index++] = "data";
		parmArray[index++] = data;
	}
	parmArray[index++] = "position";
	parmArray[index++] = position;
	var jsonParms = createJsonParmString("addCustomDataToSession",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getCustomDataFromSession=function(sessionId,position,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "position";
	parmArray[index++] = position;
	var jsonParms = createJsonParmString("getCustomDataFromSession",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.setCookie=function(cookie,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (cookie != null) {
		parmArray[index++] = "cookie";
		parmArray[index++] = $.toJSON(cookie);
	}
	var jsonParms = createJsonParmString("setCookie",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getCookie=function(customerUuid,attrId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (customerUuid != null) {
		parmArray[index++] = "customerUuid";
		parmArray[index++] = customerUuid;
	}
	if (attrId != null) {
		parmArray[index++] = "attrId";
		parmArray[index++] = attrId;
	}
	var jsonParms = createJsonParmString("getCookie",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getAllCookies=function(customerUuid,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (customerUuid != null) {
		parmArray[index++] = "customerUuid";
		parmArray[index++] = customerUuid;
	}
	var jsonParms = createJsonParmString("getAllCookies",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.deleteCookie=function(customerUuid,attrId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (customerUuid != null) {
		parmArray[index++] = "customerUuid";
		parmArray[index++] = customerUuid;
	}
	if (attrId != null) {
		parmArray[index++] = "attrId";
		parmArray[index++] = attrId;
	}
	var jsonParms = createJsonParmString("deleteCookie",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getGeoZonesPerZone=function(zone,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (zone != null) {
		parmArray[index++] = "zone";
		parmArray[index++] = $.toJSON(zone);
	}
	var jsonParms = createJsonParmString("getGeoZonesPerZone",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.insertCustomerTag=function(sessionId,tag,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (tag != null) {
		parmArray[index++] = "tag";
		parmArray[index++] = $.toJSON(tag);
	}
	var jsonParms = createJsonParmString("insertCustomerTag",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.insertCustomerTagForGuest=function(customerId,tag,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	if (tag != null) {
		parmArray[index++] = "tag";
		parmArray[index++] = $.toJSON(tag);
	}
	var jsonParms = createJsonParmString("insertCustomerTagForGuest",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.addToCustomerTag=function(sessionId,tagName,tagValue,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (tagName != null) {
		parmArray[index++] = "tagName";
		parmArray[index++] = tagName;
	}
	parmArray[index++] = "tagValue";
	parmArray[index++] = tagValue;
	var jsonParms = createJsonParmString("addToCustomerTag",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.addToCustomerTagForGuest=function(customerId,tagName,tagValue,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	if (tagName != null) {
		parmArray[index++] = "tagName";
		parmArray[index++] = tagName;
	}
	parmArray[index++] = "tagValue";
	parmArray[index++] = tagValue;
	var jsonParms = createJsonParmString("addToCustomerTagForGuest",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getCustomerTag=function(sessionId,tagName,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (tagName != null) {
		parmArray[index++] = "tagName";
		parmArray[index++] = tagName;
	}
	var jsonParms = createJsonParmString("getCustomerTag",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getCustomerTagForGuest=function(customerId,tagName,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	if (tagName != null) {
		parmArray[index++] = "tagName";
		parmArray[index++] = tagName;
	}
	var jsonParms = createJsonParmString("getCustomerTagForGuest",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getCustomerTagValue=function(sessionId,tagName,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (tagName != null) {
		parmArray[index++] = "tagName";
		parmArray[index++] = tagName;
	}
	var jsonParms = createJsonParmString("getCustomerTagValue",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getCustomerTagValueForGuest=function(customerId,tagName,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	if (tagName != null) {
		parmArray[index++] = "tagName";
		parmArray[index++] = tagName;
	}
	var jsonParms = createJsonParmString("getCustomerTagValueForGuest",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.deleteCustomerTag=function(sessionId,tagName,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (tagName != null) {
		parmArray[index++] = "tagName";
		parmArray[index++] = tagName;
	}
	var jsonParms = createJsonParmString("deleteCustomerTag",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.deleteCustomerTagForGuest=function(customerId,tagName,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	if (tagName != null) {
		parmArray[index++] = "tagName";
		parmArray[index++] = tagName;
	}
	var jsonParms = createJsonParmString("deleteCustomerTagForGuest",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getCustomerTags=function(sessionId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	var jsonParms = createJsonParmString("getCustomerTags",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getCustomerTagsForGuest=function(customerId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	var jsonParms = createJsonParmString("getCustomerTagsForGuest",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.evaluateExpression=function(sessionId,expressionId,expressionName,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "expressionId";
	parmArray[index++] = expressionId;
	if (expressionName != null) {
		parmArray[index++] = "expressionName";
		parmArray[index++] = expressionName;
	}
	var jsonParms = createJsonParmString("evaluateExpression",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.evaluateExpressionForGuest=function(customerId,expressionId,expressionName,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	parmArray[index++] = "expressionId";
	parmArray[index++] = expressionId;
	if (expressionName != null) {
		parmArray[index++] = "expressionName";
		parmArray[index++] = expressionName;
	}
	var jsonParms = createJsonParmString("evaluateExpressionForGuest",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getExpression=function(sessionId,expressionId,expressionName,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "expressionId";
	parmArray[index++] = expressionId;
	if (expressionName != null) {
		parmArray[index++] = "expressionName";
		parmArray[index++] = expressionName;
	}
	var jsonParms = createJsonParmString("getExpression",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getExpressionForGuest=function(customerId,expressionId,expressionName,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	parmArray[index++] = "expressionId";
	parmArray[index++] = expressionId;
	if (expressionName != null) {
		parmArray[index++] = "expressionName";
		parmArray[index++] = expressionName;
	}
	var jsonParms = createJsonParmString("getExpressionForGuest",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.pointsAvailable=function(sessionId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	var jsonParms = createJsonParmString("pointsAvailable",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.addPoints=function(sessionId,points,code,description,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "points";
	parmArray[index++] = points;
	if (code != null) {
		parmArray[index++] = "code";
		parmArray[index++] = code;
	}
	if (description != null) {
		parmArray[index++] = "description";
		parmArray[index++] = description;
	}
	var jsonParms = createJsonParmString("addPoints",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.deletePoints=function(sessionId,points,code,description,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "points";
	parmArray[index++] = points;
	if (code != null) {
		parmArray[index++] = "code";
		parmArray[index++] = code;
	}
	if (description != null) {
		parmArray[index++] = "description";
		parmArray[index++] = description;
	}
	var jsonParms = createJsonParmString("deletePoints",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.reservePoints=function(sessionId,points,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "points";
	parmArray[index++] = points;
	var jsonParms = createJsonParmString("reservePoints",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.deleteReservedPoints=function(sessionId,reservationId,code,description,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "reservationId";
	parmArray[index++] = reservationId;
	if (code != null) {
		parmArray[index++] = "code";
		parmArray[index++] = code;
	}
	if (description != null) {
		parmArray[index++] = "description";
		parmArray[index++] = description;
	}
	var jsonParms = createJsonParmString("deleteReservedPoints",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.freeReservedPoints=function(sessionId,reservationId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "reservationId";
	parmArray[index++] = reservationId;
	var jsonParms = createJsonParmString("freeReservedPoints",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.setRewardPointReservationId=function(sessionId,orderId,reservationId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "orderId";
	parmArray[index++] = orderId;
	parmArray[index++] = "reservationId";
	parmArray[index++] = reservationId;
	var jsonParms = createJsonParmString("setRewardPointReservationId",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getRewardPoints=function(sessionId,dataDesc,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	var jsonParms = createJsonParmString("getRewardPoints",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.insertSubscription=function(sessionId,subscription,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (subscription != null) {
		parmArray[index++] = "subscription";
		parmArray[index++] = $.toJSON(subscription);
	}
	var jsonParms = createJsonParmString("insertSubscription",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.updateSubscription=function(sessionId,subscription,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (subscription != null) {
		parmArray[index++] = "subscription";
		parmArray[index++] = $.toJSON(subscription);
	}
	var jsonParms = createJsonParmString("updateSubscription",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getPaymentSchedule=function(id,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "id";
	parmArray[index++] = id;
	var jsonParms = createJsonParmString("getPaymentSchedule",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getSubscriptionsPerCustomer=function(sessionId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	var jsonParms = createJsonParmString("getSubscriptionsPerCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.searchForSubscriptionsPerCustomer=function(sessionId,dataDesc,subscriptionSearch,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	if (subscriptionSearch != null) {
		parmArray[index++] = "subscriptionSearch";
		parmArray[index++] = $.toJSON(subscriptionSearch);
	}
	var jsonParms = createJsonParmString("searchForSubscriptionsPerCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getProductPerSkuWithOptions=function(sessionId,sku,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (sku != null) {
		parmArray[index++] = "sku";
		parmArray[index++] = sku;
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getProductPerSkuWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getProductPerSku=function(sessionId,sku,languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (sku != null) {
		parmArray[index++] = "sku";
		parmArray[index++] = sku;
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getProductPerSku",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getIpnHistory=function(sessionId,orderId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "orderId";
	parmArray[index++] = orderId;
	var jsonParms = createJsonParmString("getIpnHistory",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getPdf=function(sessionId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getPdf",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getDigitalDownloadById=function(sessionId,digitalDownloadId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "digitalDownloadId";
	parmArray[index++] = digitalDownloadId;
	var jsonParms = createJsonParmString("getDigitalDownloadById",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.editDigitalDownload=function(sessionId,digitalDownload,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (digitalDownload != null) {
		parmArray[index++] = "digitalDownload";
		parmArray[index++] = $.toJSON(digitalDownload);
	}
	var jsonParms = createJsonParmString("editDigitalDownload",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getMsgValue=function(key,type,locale,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (key != null) {
		parmArray[index++] = "key";
		parmArray[index++] = key;
	}
	parmArray[index++] = "type";
	parmArray[index++] = type;
	if (locale != null) {
		parmArray[index++] = "locale";
		parmArray[index++] = locale;
	}
	var jsonParms = createJsonParmString("getMsgValue",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getMessages=function(type,locale,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "type";
	parmArray[index++] = type;
	if (locale != null) {
		parmArray[index++] = "locale";
		parmArray[index++] = locale;
	}
	var jsonParms = createJsonParmString("getMessages",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.postMessageToQueue=function(sessionId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("postMessageToQueue",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.readMessageFromQueue=function(sessionId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("readMessageFromQueue",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.insertCustomerEvent=function(event,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (event != null) {
		parmArray[index++] = "event";
		parmArray[index++] = $.toJSON(event);
	}
	var jsonParms = createJsonParmString("insertCustomerEvent",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getSuggestedSearchItems=function(sessionId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getSuggestedSearchItems",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getProductsFromIdsWithOptions=function(sessionId,dataDesc,prodIdArray,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	if (prodIdArray != null) {
		parmArray[index++] = "prodIdArray";
		parmArray[index++] = $.toJSON(prodIdArray);
	}
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getProductsFromIdsWithOptions",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getBookingsPerProduct=function(dataDesc,productId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "productId";
	parmArray[index++] = productId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getBookingsPerProduct",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getBookingsPerCustomer=function(sessionId,dataDesc,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getBookingsPerCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.insertBooking=function(sessionId,booking,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (booking != null) {
		parmArray[index++] = "booking";
		parmArray[index++] = $.toJSON(booking);
	}
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("insertBooking",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getBookableProductConflict=function(sessionId,bookableProd,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (bookableProd != null) {
		parmArray[index++] = "bookableProd";
		parmArray[index++] = $.toJSON(bookableProd);
	}
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getBookableProductConflict",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getOrderStatus=function(sessionId,orderId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "orderId";
	parmArray[index++] = orderId;
	var jsonParms = createJsonParmString("getOrderStatus",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getAllOrderStatuses=function(languageId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	var jsonParms = createJsonParmString("getAllOrderStatuses",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.saveSSOToken=function(token,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (token != null) {
		parmArray[index++] = "token";
		parmArray[index++] = $.toJSON(token);
	}
	var jsonParms = createJsonParmString("saveSSOToken",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getSSOToken=function(secretKey,deleteToken,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (secretKey != null) {
		parmArray[index++] = "secretKey";
		parmArray[index++] = secretKey;
	}
	parmArray[index++] = "deleteToken";
	parmArray[index++] = deleteToken;
	var jsonParms = createJsonParmString("getSSOToken",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.enableCustomer=function(secretKey,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (secretKey != null) {
		parmArray[index++] = "secretKey";
		parmArray[index++] = secretKey;
	}
	var jsonParms = createJsonParmString("enableCustomer",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.checkCoupon=function(couponCode,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (couponCode != null) {
		parmArray[index++] = "couponCode";
		parmArray[index++] = couponCode;
	}
	var jsonParms = createJsonParmString("checkCoupon",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getAllPromotions=function(callback,context,eng){
	var jsonParms = createJsonParmString("getAllPromotions",null,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getPromotionsPerProducts=function(sessionId,customerId,products,promotions,couponCodes,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	parmArray[index++] = "customerId";
	parmArray[index++] = customerId;
	if (products != null) {
		parmArray[index++] = "products";
		parmArray[index++] = $.toJSON(products);
	}
	if (promotions != null) {
		parmArray[index++] = "promotions";
		parmArray[index++] = $.toJSON(promotions);
	}
	if (couponCodes != null) {
		parmArray[index++] = "couponCodes";
		parmArray[index++] = $.toJSON(couponCodes);
	}
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getPromotionsPerProducts",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getConfigData=function(sessionId,key,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (key != null) {
		parmArray[index++] = "key";
		parmArray[index++] = key;
	}
	var jsonParms = createJsonParmString("getConfigData",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getKonaKartVersion=function(callback,context,eng){
	var jsonParms = createJsonParmString("getKonaKartVersion",null,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getPunchOutMessage=function(sessionId,order,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (order != null) {
		parmArray[index++] = "order";
		parmArray[index++] = $.toJSON(order);
	}
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getPunchOutMessage",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.addCustomerNotifications=function(options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("addCustomerNotifications",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.deleteCustomerNotifications=function(options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("deleteCustomerNotifications",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getAddressFormatTemplate=function(templateId,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	parmArray[index++] = "templateId";
	parmArray[index++] = templateId;
	var jsonParms = createJsonParmString("getAddressFormatTemplate",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getBundlesThatProductBelongsTo=function(sessionId,dataDesc,productId,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	parmArray[index++] = "productId";
	parmArray[index++] = productId;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getBundlesThatProductBelongsTo",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getBundlesThatProductsBelongTo=function(sessionId,dataDesc,productIds,exactMatch,languageId,options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (sessionId != null) {
		parmArray[index++] = "sessionId";
		parmArray[index++] = sessionId;
	}
	if (dataDesc != null) {
		parmArray[index++] = "dataDesc";
		parmArray[index++] = $.toJSON(dataDesc);
	}
	if (productIds != null) {
		parmArray[index++] = "productIds";
		parmArray[index++] = $.toJSON(productIds);
	}
	parmArray[index++] = "exactMatch";
	parmArray[index++] = exactMatch;
	parmArray[index++] = "languageId";
	parmArray[index++] = languageId;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getBundlesThatProductsBelongTo",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};
kkEng.getProductImages=function(options,callback,context,eng){
	var parmArray = new Array();
	var index = 0;
	if (options != null) {
		parmArray[index++] = "options";
		parmArray[index++] = $.toJSON(options);
	}
	var jsonParms = createJsonParmString("getProductImages",parmArray,eng);
	callEng(jsonParms, callback, context, eng);
};

/*
 * API Objects
 */

function OrderUpdate() {
 }
function ManufacturerSearch() {
 }
function CreateOrderOptions() {
 }
function Promotion() {
 }
function Order() {
 }
function Basket() {
 }
function WishListItem() {
 }
function DigitalDownload() {
 }
function BookableProductOptions() {
 }
function CreditCard() {
 }
function CustomerEvent() {
 }
function AddToWishListOptions() {
 }
function FetchProductOptions() {
 }
function ZoneSearch() {
 }
function OrderSearch() {
 }
function ProductSearch() {
 }
function NotificationOptions() {
 }
function SubscriptionSearch() {
 }
function FetchTagGroupOptions() {
 }
function KKCookie() {
 }
function Zone() {
 }
function CustomerRegistration() {
 }
function OrderProduct() {
 }
function PromotionOptions() {
 }
function Customer() {
 }
function PdfOptions() {
 }
function ReviewSearch() {
 }
function ProductImagesOptions() {
 }
function MqOptions() {
 }
function Product() {
 }
function EmailOptions() {
 }
function PunchOutOptions() {
 }
function SSOToken() {
 }
function Review() {
 }
function Booking() {
 }
function LanguageSearch() {
 }
function Subscription() {
 }
function IpnHistory() {
 }
function CustomerTag() {
 }
function CustomerSearch() {
 }
function Address() {
 }
function AddToBasketOptions() {
 }
function WishList() {
 }
function DataDescriptor() {
 }
function SuggestedSearchOptions() {
 }
