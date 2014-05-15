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
import com.konakartadmin.app.AdminProdAttrDesc;
import com.konakartadmin.app.AdminProdAttrDescSearch;
import com.konakartadmin.app.AdminProdAttrDescSearchResult;
import com.konakartadmin.app.AdminProdAttrTemplate;
import com.konakartadmin.app.AdminProdAttrTemplateSearch;
import com.konakartadmin.app.AdminProdAttrTemplateSearchResult;
import com.konakartadmin.app.AdminProduct;
import com.konakartadmin.app.AdminProductAttribute;
import com.konakartadmin.app.AdminProductDescription;

/**
 * This class shows how to call the KonaKart Admin API to insert a product into the database. Before
 * insertion we insert an AdminProdAttrDesc object, attach it to a template and then attach the
 * template to the product. Before running you may have to edit BaseApiExample.java to change the
 * username and password used to log into the engine. The default values are admin@konakart.com /
 * princess .
 */
public class InsertProductWithCustAttrs extends BaseApiExample
{
    private static final String usage = "Usage: InsertProductWithCustAttrs\n" + COMMON_USAGE;

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
             * Insert a couple of AdminProdAttrDesc objects to define the custom attributes
             */
            AdminProdAttrDesc custAttr1 = new AdminProdAttrDesc();
            custAttr1.setName("ScreenSize");
            custAttr1.setType(AdminProdAttrDesc.INT_TYPE);
            int custAttr1Id;
            try
            {
                custAttr1Id = eng.insertProdAttrDesc(sessionId, custAttr1);
                custAttr1.setId(custAttr1Id);
            } catch (Exception e)
            {
                // Cust attr already exists
                AdminProdAttrDescSearch search = new AdminProdAttrDescSearch();
                search.setName("ScreenSize");
                AdminProdAttrDescSearchResult res = eng.getProdAttrDescs(sessionId, search, 0, 1);
                custAttr1 = res.getProdAttrDescs()[0];
            }

            AdminProdAttrDesc custAttr2 = new AdminProdAttrDesc();
            custAttr2.setName("ScreenTechnology");
            custAttr2.setType(AdminProdAttrDesc.STRING_TYPE);
            custAttr2.setSetFunction("option(led=label.led,lcd=label.lcd,plasma=label.plasma)");
            int custAttr2Id;
            try
            {
                custAttr2Id = eng.insertProdAttrDesc(sessionId, custAttr2);
                custAttr2.setId(custAttr2Id);
            } catch (Exception e)
            {
                // Cust attr already exists
                AdminProdAttrDescSearch search = new AdminProdAttrDescSearch();
                search.setName("ScreenTechnology");
                AdminProdAttrDescSearchResult res = eng.getProdAttrDescs(sessionId, search, 0, 1);
                custAttr2 = res.getProdAttrDescs()[0];
            }

            /*
             * Insert a template
             */
            AdminProdAttrTemplate template = new AdminProdAttrTemplate();
            template.setName("tvTemplate");
            int templateId;
            try
            {
                templateId = eng.insertProdAttrTemplate(sessionId, template);
                template.setId(templateId);
            } catch (Exception e)
            {
                // Template already exists
                AdminProdAttrTemplateSearch search = new AdminProdAttrTemplateSearch();
                search.setName("tvTemplate");
                AdminProdAttrTemplateSearchResult res = eng.getProdAttrTemplates(sessionId, search,
                        0, 1);
                template = res.getProdAttrTemplates()[0];
            }

            /*
             * Add the custom attribute descriptions to the template
             */
            eng.addProdAttrDescsToTemplate(sessionId, new AdminProdAttrDesc[]
            { custAttr1, custAttr2 }, template.getId());

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
            // Product price before applying tax
            prod.setPriceExTax(new BigDecimal(55.99));
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
            // Custom attribute. Can contain custom data.
            prod.setCustom1("custom1");
            // Custom attribute. Can contain custom data.
            prod.setCustom2("custom2");
            // Custom attribute. Can contain custom data.
            prod.setCustom3("custom3");
            // Custom attribute. Can contain custom data.
            prod.setCustom4("custom4");
            // Custom attribute. Can contain custom data.
            prod.setCustom5("custom5");
            // Set the template Id
            prod.setTemplateId(template.getId());

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

            // We will add two attributes
            AdminProductAttribute[] attrs = new AdminProductAttribute[2];

            // Attribute 1
            AdminProductAttribute prodAttr1 = new AdminProductAttribute();
            // This points to the option in the products_options table with id = 4 (Memory in demo
            // DB)
            prodAttr1.setOptionId(4);
            // This points to the option value in the products_options_values table with id = 1 (4MB
            // in demo DB)
            prodAttr1.setOptionValueId(1);
            // This option costs an extra 20 if selected
            prodAttr1.setPrice(new BigDecimal(20));
            prodAttr1.setPricePrefix("+");
            attrs[0] = prodAttr1;

            // Attribute 2
            AdminProductAttribute prodAttr2 = new AdminProductAttribute();
            // This points to the option in the products_options table with id = 3 (Model in demo
            // DB)
            prodAttr2.setOptionId(3);
            // This points to the option value in the products_options_values table with id = 5
            // (Value model
            // in demo DB)
            prodAttr2.setOptionValueId(5);
            // The product price is reduced by 10 if this option is selected
            prodAttr2.setPrice(new BigDecimal(10));
            prodAttr2.setPricePrefix("-");
            attrs[1] = prodAttr2;

            // Add the attributes to the product
            prod.setAttributes(attrs);

            // Get the custom product attr desc objects for the template and give them values
            AdminProdAttrDesc[] attrDescs = eng.getProdAttrDescsForTemplate(sessionId, template
                    .getId());
            for (int i = 0; i < attrDescs.length; i++)
            {
                AdminProdAttrDesc attr = attrDescs[i];
                if (attr.getName().equals("ScreenSize"))
                {
                    attr.setValue("40");
                } else if (attr.getName().equals("ScreenTechnology"))
                {
                    attr.setValue("led");
                }
            }

            // Attach the array to the product
            prod.setCustomAttrArray(attrDescs);

            // Insert the product and get the product Id
            int prodId = eng.insertProduct(sessionId, prod);

            System.out.println("Product Id of inserted product = " + prodId);

            // Read the product from the database
            prod = eng.getProduct(sessionId, prodId);

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

            // Delete the template and custom attributes descriptors
            eng.deleteProdAttrTemplate(sessionId, template.getId());
            eng.deleteProdAttrDesc(sessionId, custAttr1.getId());
            eng.deleteProdAttrDesc(sessionId, custAttr2.getId());

        } catch (Exception e)
        {
            e.printStackTrace();
        }

    }

}
