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
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import com.konakartadmin.app.AdminBookableProduct;
import com.konakartadmin.app.AdminBookableProductOptions;
import com.konakartadmin.app.AdminCategory;
import com.konakartadmin.app.AdminProduct;
import com.konakartadmin.app.AdminProductDescription;
import com.konakartadmin.bl.KonakartAdminConstants;

/**
 * This class shows how to call the KonaKart Admin API to create a Bookable Product.
 */
public class CreateBookableProduct extends BaseApiExample
{
    private static final String usage = "Usage: CreateBookableProduct\n" + COMMON_USAGE;

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

            // Just pick out a valid Tax Class Id - we assume one will be present
            int taxClassId = getEng().getAllTaxClassesFull()[0].getTaxClassId();

            // Get the languageIds - we assume these are present
            int langIdEN = getEng().getLanguageByCode("en").getId();
            int langIdDE = getEng().getLanguageByCode("de").getId();
            int langIdPT = getEng().getLanguageByCode("pt").getId();
            int langIdES = getEng().getLanguageByCode("es").getId();

            /*
             * Instantiate an AdminProduct object and set some of its attributes
             */
            AdminProduct prod = new AdminProduct();

            // Bookable Product Type
            prod.setType(KonakartAdminConstants.BOOKABLE_PRODUCT_TYPE);

            // Assuming we have a manufacturer in the DB with id==1
            prod.setManufacturerId(1);

            // Image that will be used in the application for the product
            prod.setImage("test/bookableProduct.gif");

            // Product model
            prod.setModel("bookable model");

            // Product price before applying tax
            prod.setPriceExTax(new BigDecimal(55.99));

            // Quantity of product in stock
            prod.setQuantity(20);

            // Product status: 1=active, 0=inactive
            prod.setStatus((byte) 1);

            // The tax class of the product. Used to determine how much tax to apply.
            prod.setTaxClassId(taxClassId);

            // Weight of product. Can be used to calculate shipping cost.
            prod.setWeight(new BigDecimal(5));

            // Defines when the product will be available
            prod.setDateAvailable(new Date());

            // Custom attributes
            prod.setCustom1("custom1");
            prod.setCustom2("custom2");
            prod.setCustom3("custom3");
            prod.setCustom4("custom4");
            prod.setCustom5("custom5");

            /*
             * An Admin Product object has an array of AdminProductDescription objects, each one of
             * which contains a name, description and url for a different language. The url is
             * language dependent since it can point to the home page of the product for the country
             * in question.
             */
            AdminProductDescription[] descriptions = new AdminProductDescription[4];
            descriptions[0] = new AdminProductDescription();
            descriptions[0].setDescription("Test bookable prod - English");
            descriptions[0].setLanguageId(langIdEN);
            descriptions[0].setName("Test Bookable Prod - EN");
            descriptions[0].setUrl("www.testprod.co.uk");
            
            descriptions[1] = new AdminProductDescription();
            descriptions[1].setDescription("Test bookable prod - German");
            descriptions[1].setLanguageId(langIdDE);
            descriptions[1].setName("Test Bookable Prod - DE");
            descriptions[1].setUrl("www.testprod.de");
            
            descriptions[2] = new AdminProductDescription();
            descriptions[2].setDescription("Test bookable prod - Spanish");
            descriptions[2].setLanguageId(langIdES);
            descriptions[2].setName("Test Bookable Prod - ES");
            descriptions[2].setUrl("www.testprod.es");
            
            descriptions[3] = new AdminProductDescription();
            descriptions[3].setDescription("Test bookable prod - Portuguese");
            descriptions[3].setLanguageId(langIdPT);
            descriptions[3].setName("Test Bookable Prod - PT");
            descriptions[3].setUrl("www.testprod.pt");
            prod.setDescriptions(descriptions);

            /*
             * An Admin Product may belong to one or more categories. We create an array of
             * categories and add one category to the array (the first one returned in the tree)
             * which we then add to the product.
             */
            AdminCategory cat = getEng().getCategoryTree(langIdEN, false)[0];
            AdminCategory[] catArray = new AdminCategory[1];
            catArray[0] = cat;
            prod.setCategories(catArray);

            // Now the Bookable Product parts
            AdminBookableProductOptions options = new AdminBookableProductOptions();
            options.setThrowExeptionForExceedingMaxBookings(false);

            GregorianCalendar calStart = new GregorianCalendar(/* year */2017, /* month */
            Calendar.MARCH, /* dayOfMonth */7, /* hourOfDay */0, /* minute */0);
            
            GregorianCalendar calEnd = new GregorianCalendar(/* year */2018, /* month */
            Calendar.FEBRUARY, /* dayOfMonth */7, /* hourOfDay */23, /* minute */59);

            AdminBookableProduct bProd = new AdminBookableProduct();
            bProd.setStartDate(calStart.getTime());
            bProd.setEndDate(calEnd.getTime());
            bProd.setMonday("09:00;12:00 14:00;16:30");
            bProd.setFriday("09:30;12:15 15:30;16:30 16:30;17:30");

            prod.setBookableProd(bProd);

            // Insert the product and get the product Id
            int prodId = getEng().insertProduct(sessionId, prod);

            System.out.println("Product Id of inserted bookable product = " + prodId);

            // Read the product from the database
            prod = getEng().getProduct(sessionId, prodId);

            if (prod != null)
            {
                /*
                 * Note that the name and description of the admin product object are set to null
                 * because they are in the AdminProductDescription array for each language. If the
                 * same product is read through the KonaKart application API, the name and
                 * description will be set to the values defined by the chosen language.
                 */
                System.out.println(prod.toString());
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
