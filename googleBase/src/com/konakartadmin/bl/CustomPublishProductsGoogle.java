//
// (c) 2006 DS Data Systems UK Ltd, All rights reserved.
//
// DS Data Systems and KonaKart and their respective logos, are 
// trademarks of DS Data Systems UK Ltd. All rights reserved.
//
// The information in this document is the proprietary property of
// DS Data Systems UK Ltd. and is protected by English copyright law,
// the laws of foreign jurisdictions, and international treaties,
// as applicable. No part of this document may be reproduced,
// transmitted, transcribed, transferred, modified, published, or
// translated into any language, in any form or by any means, for
// any purpose other than expressly permitted by DS Data Systems UK Ltd.
// in writing.
//

package com.konakartadmin.bl;

import java.util.Random;

import com.konakart.util.Utils;
import com.konakartadmin.app.AdminProduct;
import com.konakartadmin.app.PublishData;
import com.konakartadmin.appif.KKAdminIf;
import com.konakartadmin.bl.google.model.Product;

/**
 * This is a utility for publishing products to Google using the Content API For Shopping.
 * <p>
 * This is an example of how you can customize the behaviour of the default code that publishes
 * products to Google by extending PublishProductsGoogle.
 */
public class CustomPublishProductsGoogle extends PublishProductsGoogle
{
    Random rand = new Random();
    
    /**
     * Constructor
     * 
     * @param adminEng
     *            A KKAdminIf engine
     * @param pData
     *            Publishing metadata
     */
    public CustomPublishProductsGoogle(KKAdminIf adminEng, PublishData pData)
    {
        super(adminEng, pData);
    }

    /**
     * Create a Google Product from a KonaKart AdminProduct
     * <p>
     * This is a good place to set values in the Google Product from custom fields (or other places)
     * in user-specific domains.
     * <p>
     * For example this would be a good place to set the GTIN if you have that for your products.
     */
    protected Product createGoogleProduct(AdminProduct adminProduct)
    {
        if (adminProduct == null)
        {
            return null;
        }

        Product product = super.createGoogleProduct(adminProduct);

        // As an example we'll just add an " X" to the end of the Title.  
        if (adminProduct.getName() != null)
        {
            product.title = adminProduct.getName() + " X";
        }

        return product;
    }

    protected String googleProductToString(Product googleProduct)
    {
        String str = super.googleProductToString(googleProduct);
        return str;
    }

    protected String googleProductToStringBrief(Product googleProduct)
    {
        if (googleProduct == null)
        {
            return null;
        }

        return "Google Product: Id: " + Utils.padLeft(googleProduct.externalId, 6) + "  Title = "
                + googleProduct.title;
    }
}
