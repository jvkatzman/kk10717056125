$(function() {
	if ($("#product-reviews-tab").length) {

		$(window).scroll(function() {
			 $.cookie('y_cookie', $(window).scrollTop(), { expires: 7, path: '/' });
		});
		
		var y = $.cookie('y_cookie');
		if (y != null && y.length > 0) {
			$(window).scrollTop(y);
		}
		
		$("#AddToCartForm").submit(function(){
			var formInput=$(this).serialize();			
			if (document.getElementById('kk_portlet_id')) {
				var postArray = new Array();
				var parmArray = formInput.split('&');
				var j=0;
				for ( var i = 0; i < parmArray.length; i++) {
					var parms = parmArray[i];
					var parmsArray = parms.split("=");
					postArray[j++] = parmsArray[0];
					postArray[j++] = parmsArray[1];
				}
				if (document.getElementById('addToWishList').value=="true") {
					if (document.getElementById('wishListId').value!="-1") {
						callAction(postArray, addToGiftRegistryCallback, 'AddToCartOrWishListFromPost.action');
					} else {
						callAction(postArray, addToWishListCallback, 'AddToCartOrWishListFromPost.action');
					} 		
				} else {
			 		callAction(postArray, addToCartCallback, 'AddToCartOrWishListFromPost.action');
				}
			} else {			
				if (document.getElementById('addToWishList').value=="true") {
					if (document.getElementById('wishListId').value!="-1") {
						$.getJSON('AddToCartOrWishListFromPost.action', formInput, addToGiftRegistryCallback);
					} else {
						$.getJSON('AddToCartOrWishListFromPost.action', formInput, addToWishListCallback);
					} 		
				} else {
			 		$.getJSON('AddToCartOrWishListFromPost.action', formInput, addToCartCallback);
				}
			}			
			return false;					
		});
	
		jQuery('#related-carousel').jcarousel({
	        vertical: true,
	        scroll: 3,
	        itemFallbackDimension: 300,
	        initCallback: relatedCarousel_initCallback,
	        buttonNextCallback: relatedCarousel_nextCallback,
	        buttonPrevCallback: relatedCarousel_prevCallback,
	        // This tells jCarousel NOT to autobuild prev/next buttons
	        buttonNextHTML: null,
	        buttonPrevHTML: null
	    });
		
		jQuery('#also-bought-carousel').jcarousel({
	        vertical: true,
	        scroll: 3,
	        itemFallbackDimension: 300,
	        initCallback: alsoBought_initCallback,
	        buttonNextCallback: alsoBought_nextCallback,
	        buttonPrevCallback: alsoBought_prevCallback,
	        // This tells jCarousel NOT to autobuild prev/next buttons
	        buttonNextHTML: null,
	        buttonPrevHTML: null
	    });
	
		
		// Tabs
		if ($("#product-reviews-tab").attr("class").indexOf("selected-product-content-tab") >= 0) {
			$("#product-description").hide();
		} else {
			$("#product-reviews").hide();
			$(window).scrollTop(0);
		}
		$("#product-specifications").hide();
		
		$("#product-reviews-tab").click(function() {
			$("#product-description-tab").removeClass("selected-product-content-tab");
			$("#product-specifications-tab").removeClass("selected-product-content-tab");
			$("#product-reviews-tab").addClass("selected-product-content-tab");
			$("#product-description").hide();
			$("#product-specifications").hide();
			$("#product-reviews").show();
		});
		
		$("#product-specifications-tab").click(function() {
			$("#product-description-tab").removeClass("selected-product-content-tab");
			$("#product-specifications-tab").addClass("selected-product-content-tab");
			$("#product-reviews-tab").removeClass("selected-product-content-tab");
			$("#product-description").hide();
			$("#product-specifications").show();
			$("#product-reviews").hide();
		});
		
		$("#product-description-tab").click(function() {
			$("#product-description-tab").addClass("selected-product-content-tab");
			$("#product-specifications-tab").removeClass("selected-product-content-tab");
			$("#product-reviews-tab").removeClass("selected-product-content-tab");
			$("#product-description").show();
			$("#product-specifications").hide();
			$("#product-reviews").hide();
		});
			
		// Images

		//jk changed 2/19/2014
		// need format: https://content.etilize.com/images/300/300/1013040928.jpg
		// current: src="/konakart/images/prod/6/8/9/6/68965D51-0E5B913_1_medium.jpg

		
	/*	var imgBase = document.getElementById('gallery_nav_base').value   		//https://content.etilize.com/images/
					  +document.getElementById('gallery_nav_dir').value  		//""
					  +document.getElementById('gallery_nav_uuid').value;		//12345
	*/	
		//var extension = document.getElementById('gallery_nav_extension').value; //.jpg
		
		var imagesSmallArray = new Array();
		var imagesLargeArray = new Array();
		
		for ( var i = 0; i < jsImageArray.length; i++ ){
			imagesSmallArray[i] = jsImageArray[i];
			imagesLargeArray[i]= jsImageArray[i];
		
		}
		
		$("#gallery_nav").empty();
		$("#gallery_output").empty();
		var imagesSmall = "";
		var imagesLarge = "";
		for ( var i = 0; i < 11; i++) {
			if(imagesSmallArray[i]!=""){
				//jk changed 2/20/2014
				//var imgSrcSmall = imgBase + "_" + i + "_small"+extension;
				var imgSrcSmall =   imagesSmallArray[i]; 
				
				//var imgSrcLarge = imgBase + "_" + i + "_big"+extension;
				var imgSrcLarge = imagesLargeArray[i];  

			if(imgExists(imgSrcSmall)) {
				
				imagesSmall += '<a rel="img' + i
					
					 + '" href="javascript:;"><img width="30px" height="30px"   src="' + imgSrcSmall
					//jk just for test '" href="javascript:;"><img width="30px" height="30px"   src="https://content.etilize.com/images/300/300/1013040928.jpg"'
				+ '"/></a>';
						if(imgExists(imgSrcLarge)) {
						
				imagesLarge += '<img id="img' + i + '" src="' + imgSrcLarge + '"/>';
							} 
			} else {
				break;
					
										
				}// imgExists(imgSrcSmall)	
			} // imagesSmallArray[i]!=""
		}// for var i
		

		if (imagesLarge.length == 0) {
			//var imgSrcLarge = imgBase + '/' + name + "_big"+extension;
			var imgSrcLarge = document.getElementById('gallery_nav_base').value  + "300/300/"+ document.getElementById('gallery_nav_uuid').value + ".jpg"; 
			
			if(imgExists(imgSrcLarge)) {
				imagesLarge += '<img id="img' + i + '" src="' + imgSrcLarge + '"/>';
			}
		}
		
		$("#gallery_nav").append(imagesSmall);
		$("#gallery_output").append(imagesLarge);
	
		
		$("#gallery_output img").not(":first").hide();
		$("#gallery_output img").eq(0).addpowerzoom();
	
		$("#gallery a").click(function() {
			var id = "#" + this.rel;
			if ($(id).is(":hidden")) {
				$("#gallery_output img").slideUp();
				$(id).slideDown( function() {
					$(id).addpowerzoom();
				});
			}
		});	
	}	
});

// Carousel init
function relatedCarousel_initCallback(carousel) {
	
    jQuery('#kk-up-rc').bind('click', function() {
        carousel.next();
        return false;
    });

    jQuery('#kk-down-rc').bind('click', function() {
        carousel.prev();
        return false;
    });
};

// Up
function relatedCarousel_nextCallback(carousel,control,flag) {
    if (flag) {
    	jQuery('#kk-up-rc').addClass("next-items-up").removeClass("next-items-up-inactive");
	} else {
    	jQuery('#kk-up-rc').addClass("next-items-up-inactive").removeClass("next-items-up");
		
	}
};

// Down
function relatedCarousel_prevCallback(carousel,control,flag) {
    if (flag) {
    	jQuery('#kk-down-rc').addClass("previous-items-down").removeClass("previous-items-down-inactive");
	} else {
    	jQuery('#kk-down-rc').addClass("previous-items-down-inactive").removeClass("previous-items-down");
		
	}
};

//Carousel init
function alsoBought_initCallback(carousel) {
	
    jQuery('#kk-up-ab').bind('click', function() {
        carousel.next();
        return false;
    });

    jQuery('#kk-down-ab').bind('click', function() {
        carousel.prev();
        return false;
    });
};

// Up
function alsoBought_nextCallback(carousel,control,flag) {
    if (flag) {
    	jQuery('#kk-up-ab').addClass("next-items-up").removeClass("next-items-up-inactive");
	} else {
    	jQuery('#kk-up-ab').addClass("next-items-up-inactive").removeClass("next-items-up");
		
	}
};

// Down
function alsoBought_prevCallback(carousel,control,flag) {
    if (flag) {
    	jQuery('#kk-down-ab').addClass("previous-items-down").removeClass("previous-items-down-inactive");
	} else {
    	jQuery('#kk-down-ab').addClass("previous-items-down-inactive").removeClass("previous-items-down");
		
	}
};

function setAddToWishList() {
			document.getElementById('addToWishList').value="true";
			document.getElementById('wishListId').value="-1";
		}
	
function resetAddToWishList() {
		    document.getElementById('addToWishList').value="false";
		}

function setWishListId(id) {
	document.getElementById('wishListId').value=id;
	document.getElementById('addToWishList').value="true";
}

		
function addtoCartOrWishListFunc(){
	// Random value needed to stop IE thinking that it doesn't have to send the request again because it hasn't changed
	var d = new Date();
	document.getElementById('random').value=d.getMilliseconds();
	$("#AddToCartForm").submit();	
}

/*
function checkImage(imgPath) {
	 var http = jQuery.ajax({
		    type:"HEAD",
		    url: imgPath,
		    async: false,
		    crossDomain:true
		  });
		  return http.status!=404;			
	 }

function jktest(imgPath) {
	 jQuery.ajax({
		 type: "HEAD",
		  url: imgPath,
		  async: false,
		  dataType: "text/html",
		  statusCode: {
			    404: function() {
			      alert( "404 - " + imgPath );
			    }
		  },
		  statusCode: {
			    200: function() {
			      alert( "200 - " + imgPath );
			    }
		  },
		  statusCode: {
			    304: function() {
			      alert( "304 - " + imgPath );
			    }
		  },
		  success: function(data, textStatus, jqXHR){
			  alert("good");
			  if(jqXHR.status === 200){
			  console.log('Got a good request');
			  } else {
			  console.log('Hey, a 304 request');
			  }
			  console.log('Data: ' + data);
			  },
		  error: function(jqXHR, textStatus, errorThrown) {
		    alert("error - "  + " - "+jqXHR.statusText+" - "+ jqXHR.status+" - "+textStatus + imgPath);
		  },
		  
	 });
		  	 }


*/
function imgExists(src) {
		if (src=="null") {
			return false;
		} else {
			return true;
		}
	
}



/*
 * Used to update the wish list
 */
var addToGiftRegistryCallback = function(result, textStatus, jqXHR) {	
	var id = document.getElementById('wishListId').value;
	return redirect(getURL("ShowWishListItems.action", new Array("wishListId",id)));
};

function callAjax(url, callback){
    var xmlhttp;
    // compatible with IE7+, Firefox, Chrome, Opera, Safari
    xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function(){
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200){
            callback(xmlhttp.responseText);
        }
    };
    xmlhttp.open("GET", url, true);
    xmlhttp.send();
}

		
