//
// (c) 2006 DS Data Systems UK Ltd, All rights reserved.
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
package com.konakartadmin.apiexamples;

import java.math.BigDecimal;
import java.util.Date;

import com.konakartadmin.app.AdminCategory;
import com.konakartadmin.app.AdminProduct;
import com.konakartadmin.app.AdminProductAttribute;
import com.konakartadmin.app.AdminProductDescription;
import com.konakartadmin.app.AdminProductMgrOptions;
import com.konakartadmin.app.AdminTierPrice;

/**
 * This class shows how to call the KonaKart Admin API to insert a product into the database. The
 * product prices will be written to an external table allowing the same product to have multiple
 * prices based on the catalog id. Before running you may have to edit BaseApiExample.java to change
 * the username and password used to log into the engine. The default values are admin@konakart.com
 * / princess .
 */
public class InsertProductWithExternalPrices extends BaseApiExample
{
    private static final String usage = "Usage: InsertProductWithExternalPrices\n" + COMMON_USAGE;

    /**
     * @param args
     */
    public static void main(String[] args)
    {
        try
        {
            /*
             * Parse the command line arguments
             */
            parseArgs(args, usage, 0);
            
            /*
             * Get an instance of the Admin KonaKart engine and login. The method called can be
             * found in BaseApiExample.java
             */
            init(getEngineMode(), getStoreId(), getEngClassName(), isCustomersShared(),
                    isProductsShared(), isCategoriesShared(), null);

            /*
             * Instantiate an AdminProduct object and set some of its attributes
             */
            AdminProduct prod = new AdminProduct();
            // Assuming we have a manufacturer in the DB with id==1
            prod.setManufacturerId(1);
            // Image that will be used in the application for the product
            prod.setImage("test/test.gif");
            // Product model
            prod.setModel("test model");
            // Product prices
            prod.setPriceExTax(new BigDecimal("10.10"));
            prod.setPrice1(new BigDecimal("20.20"));
            prod.setPrice2(new BigDecimal("30.30"));
            prod.setPrice3(new BigDecimal("40.40"));
            // Quantity of product in stock
            prod.setQuantity(20);
            // Product status: 1=active, 0=inactive
            prod.setStatus((byte) 1);
            // The tax class of the product. Used to determine how much tax to apply.
            prod.setTaxClassId(1);
            // Weight of product. Can be used to calculate shipping cost.
            prod.setWeight(new BigDecimal(5));
            // Defines when the product will be available
            prod.setDateAvailable(new Date());

            /*
             * An Admin Product object has an array of AdminProductDescription objects, each one of
             * which contains a name, description and url for a different language. The url is
             * language dependent since it can point to the home page of the product for the country
             * in question.
             */
            AdminProductDescription[] descriptions = new AdminProductDescription[2];
            descriptions[0] = new AdminProductDescription();
            descriptions[0].setDescription("Test prod - English");
            descriptions[0].setLanguageId(1);
            descriptions[0].setName("Test Prod - E");
            descriptions[0].setUrl("www.testprod.co.uk");
            descriptions[1] = new AdminProductDescription();
            descriptions[1].setDescription("Test prod - German");
            descriptions[1].setLanguageId(2);
            descriptions[1].setName("Test Prod - D");
            descriptions[1].setUrl("www.testprod.de");
            prod.setDescriptions(descriptions);

            /*
             * An Admin Product may belong to one or more categories. We create an array of
             * categories and add one category to the array which we then add to the product.
             */
            AdminCategory cat = new AdminCategory();
            // Assuming we have a category with id==1 in the database
            cat.setId(1);
            AdminCategory[] catArray = new AdminCategory[1];
            catArray[0] = cat;
            prod.setCategories(catArray);

            /*
             * The following Admin Product Attributes are optional. They are used if the product has
             * options which can be selected to configure the product. These options may add or
             * subtract a value from the final price. i.e. Size "extra small" may be -$10.00 from
             * the product price while size "extra large" may be +$10.00.
             */

            // We will add an attributes
            AdminProductAttribute[] attrs = new AdminProductAttribute[1];
            AdminProductAttribute prodAttr1 = new AdminProductAttribute();
            /*
             * This points to the option in the products_options table with id = 4 (Memory in demo
             * DB)
             */
            prodAttr1.setOptionId(4);
            /*
             * This points to the option value in the products_options_values table with id = 1 (4MB
             * in demo DB)
             */
            prodAttr1.setOptionValueId(1);

            // This option costs an extra 20 if selected
            prodAttr1.setPrice(new BigDecimal(20));
            prodAttr1.setPrice1(new BigDecimal(21));
            prodAttr1.setPrice2(new BigDecimal(22));
            prodAttr1.setPrice3(new BigDecimal(23));
            prodAttr1.setPricePrefix("+");
            attrs[0] = prodAttr1;

            // Add the attributes to the product
            prod.setAttributes(attrs);

            // Insert the product and get the product Id
            int prodId = eng.insertProduct(sessionId, prod);
            System.out.println("Product Id of inserted product = " + prodId);

            // Get the product from the DB
            prod = eng.getProduct(sessionId, prodId);

            // Add some tier prices
            AdminTierPrice tp1 = new AdminTierPrice();
            tp1.setCustom1("custom1");
            tp1.setPriceExTax(new BigDecimal("10"));
            tp1.setPrice0(new BigDecimal("10"));
            tp1.setPrice1(new BigDecimal("10"));
            tp1.setPrice2(new BigDecimal("10"));
            tp1.setPrice3(new BigDecimal("10"));
            tp1.setProductId(prodId);
            tp1.setQuantity(10);
            tp1.setUsePercentageDiscount(true);

            AdminTierPrice tp2 = new AdminTierPrice();
            tp2.setCustom1("custom2");
            tp2.setPriceExTax(new BigDecimal("20"));
            tp2.setPrice0(new BigDecimal("20"));
            tp2.setPrice1(new BigDecimal("20"));
            tp2.setPrice2(new BigDecimal("20"));
            tp2.setPrice3(new BigDecimal("20"));
            tp2.setProductId(prodId);
            tp2.setQuantity(20);
            tp2.setUsePercentageDiscount(true);

            AdminTierPrice[] tpArray = new AdminTierPrice[]
            { tp1, tp2 };

            prod.setTierPrices(tpArray);

            // Add the tier prices
            eng.editProduct(sessionId, prod);

            /*
             * Now that the product exists in the database we can set catalog prices
             */

            // Get the product from the DB
            prod = eng.getProduct(sessionId, prodId);

            prod.setPriceExTax(new BigDecimal("100.10"));
            prod.setPrice1(new BigDecimal("200.20"));
            prod.setPrice2(new BigDecimal("300.30"));
            prod.setPrice3(new BigDecimal("400.40"));

            prod.getAttributes()[0].setPrice(new BigDecimal("200"));
            prod.getAttributes()[0].setPrice1(new BigDecimal("210"));
            prod.getAttributes()[0].setPrice2(new BigDecimal("220"));
            prod.getAttributes()[0].setPrice3(new BigDecimal("230"));

            prod.getTierPrices()[0].setPrice0(new BigDecimal("15"));
            prod.getTierPrices()[0].setPrice1(new BigDecimal("15"));
            prod.getTierPrices()[0].setPrice2(new BigDecimal("15"));
            prod.getTierPrices()[0].setPrice3(new BigDecimal("15"));

            prod.getTierPrices()[1].setPrice0(new BigDecimal("25"));
            prod.getTierPrices()[1].setPrice1(new BigDecimal("25"));
            prod.getTierPrices()[1].setPrice2(new BigDecimal("25"));
            prod.getTierPrices()[1].setPrice3(new BigDecimal("25"));

            prod.setQuantity(200);

            // Create an options object to pass to the API call
            AdminProductMgrOptions mgrOptions = new AdminProductMgrOptions();
            mgrOptions.setCatalogId("cat1");
            mgrOptions.setUseExternalPrice(true);
            mgrOptions.setUseExternalQuantity(true);
            eng.editProductWithOptions(sessionId, prod, mgrOptions);

            // Read the product from the database using normal prices
            prod = eng.getProduct(sessionId, prodId);
            if (prod != null)
            {
                System.out.println("\n== Standard Prices ==");
                System.out.println("");
                System.out.println("Product Price 0          = " + prod.getPrice0());
                System.out.println("Product Price 1          = " + prod.getPrice1());
                System.out.println("Product Price 2          = " + prod.getPrice2());
                System.out.println("Product Price 3          = " + prod.getPrice3());
                System.out.println("");
                System.out.println("Product Attr Price 0     = "
                        + prod.getAttributes()[0].getPrice());
                System.out.println("Product Attr Price 1     = "
                        + prod.getAttributes()[0].getPrice1());
                System.out.println("Product Attr Price 2     = "
                        + prod.getAttributes()[0].getPrice2());
                System.out.println("Product Attr Price 3     = "
                        + prod.getAttributes()[0].getPrice3());
                System.out.println("");
                System.out.println("Product Tier Price 0     = "
                        + prod.getTierPrices()[0].getPrice0());
                System.out.println("Product Tier Price 1     = "
                        + prod.getTierPrices()[0].getPrice0());
                System.out.println("Product Tier Price 2     = "
                        + prod.getTierPrices()[0].getPrice0());
                System.out.println("Product Tier Price 3     = "
                        + prod.getTierPrices()[0].getPrice0());
                System.out.println("");
                System.out.println("Product Tier Price 0     = "
                        + prod.getTierPrices()[1].getPrice0());
                System.out.println("Product Tier Price 1     = "
                        + prod.getTierPrices()[1].getPrice0());
                System.out.println("Product Tier Price 2     = "
                        + prod.getTierPrices()[1].getPrice0());
                System.out.println("Product Tier Price 3     = "
                        + prod.getTierPrices()[1].getPrice0());
                System.out.println("");
                System.out.println("Product Quantity         = " + prod.getQuantity());
            } else
            {
                System.out.println("The product could not be read from the DB");
            }

            // Read the product with the catalog prices
            prod = eng.getProductWithOptions(sessionId, prodId, mgrOptions);
            if (prod != null)
            {
                System.out.println("\n== Catalog Prices ==");
                System.out.println("");
                System.out.println("Product Price 0          = " + prod.getPrice0());
                System.out.println("Product Price 1          = " + prod.getPrice1());
                System.out.println("Product Price 2          = " + prod.getPrice2());
                System.out.println("Product Price 3          = " + prod.getPrice3());
                System.out.println("");
                System.out.println("Product Attr Price 0     = "
                        + prod.getAttributes()[0].getPrice());
                System.out.println("Product Attr Price 1     = "
                        + prod.getAttributes()[0].getPrice1());
                System.out.println("Product Attr Price 2     = "
                        + prod.getAttributes()[0].getPrice2());
                System.out.println("Product Attr Price 3     = "
                        + prod.getAttributes()[0].getPrice3());
                System.out.println("");
                System.out.println("Product Tier Price 0     = "
                        + prod.getTierPrices()[0].getPrice0());
                System.out.println("Product Tier Price 1     = "
                        + prod.getTierPrices()[0].getPrice0());
                System.out.println("Product Tier Price 2     = "
                        + prod.getTierPrices()[0].getPrice0());
                System.out.println("Product Tier Price 3     = "
                        + prod.getTierPrices()[0].getPrice0());
                System.out.println("");
                System.out.println("Product Tier Price 0     = "
                        + prod.getTierPrices()[1].getPrice0());
                System.out.println("Product Tier Price 1     = "
                        + prod.getTierPrices()[1].getPrice0());
                System.out.println("Product Tier Price 2     = "
                        + prod.getTierPrices()[1].getPrice0());
                System.out.println("Product Tier Price 3     = "
                        + prod.getTierPrices()[1].getPrice0());
                System.out.println("");
                System.out.println("Product Quantity         = " + prod.getQuantity());
            } else
            {
                System.out.println("The product could not be read from the DB");
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }

    }

}
