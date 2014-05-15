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

import java.util.List;

import org.apache.torque.TorqueException;
import org.apache.torque.util.BasePeer;

import com.konakart.app.DataDescriptor;
import com.konakart.app.EngineConfig;
import com.konakart.app.KKEng;
import com.konakart.app.KKException;
import com.konakart.app.ProductSearch;
import com.konakart.appif.CategoryIf;
import com.konakart.appif.DataDescriptorIf;
import com.konakart.appif.KKEngIf;
import com.konakart.appif.ProductIf;
import com.konakart.appif.ProductSearchIf;
import com.konakart.appif.ProductsIf;
import com.konakart.util.KKConstants;
import com.konakartadmin.app.AdminCategory;
import com.konakartadmin.app.AdminMiscItem;
import com.konakartadmin.app.AdminMiscItemSearchResult;
import com.konakartadmin.app.AdminMiscItemType;
import com.konakartadmin.app.AdminProduct;
import com.konakartadmin.app.AdminSearch;
import com.konakartadmin.app.KKAdminException;
import com.workingdogs.village.DataSetException;
import com.workingdogs.village.Record;

/**
 * This class shows how to insert Miscellaneous Items and Item Types and how to retrieve them for an
 * object (Category and Product) using both the Admin and Store-Front APIs.
 * 
 * Before running you may have to edit BaseApiExample.java to change the username and password used
 * to log into the engine. The default values are admin@konakart.com / princess .
 */
public class MiscellaneousItems extends BaseApiExample
{
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
            parseArgs(args, COMMON_USAGE, 0);

            /*
             * Get an instance of the Admin KonaKart engine and login. The method called can be
             * found in BaseApiExample.java
             */
            init(getEngineMode(), getStoreId(), getEngClassName(), isCustomersShared(),
                    isProductsShared(), isCategoriesShared(), null);
            
            /*
             * Get an instance of the App KonaKart engine
             */
            KKEngIf appEng = getAppEng();
            
            /*
             * Get the category id for the Drama category
             */
            int catId = getCategoryIdForName("Drama");

            /*
             * Get a product id
             */
            int prodId = getProductIdForModel("MSIMPRO");

            /*
             * Get a language id
             */
            int langId = getLanguageIdForCode("en");

            /*
             * Delete any example data we create so that the example may be run multiple times
             */
            deleteExampleData(catId, prodId);

            /*
             * Create and insert a miscellaneous object type
             */
            AdminMiscItemType miType0 = new AdminMiscItemType();
            miType0.setLanguageId(langId);
            miType0.setName("Documentation");
            miType0.setDescription("PDF documents common to products in this category");
            int typeId = getEng().insertMiscItemType(sessionId, new AdminMiscItemType[]
            { miType0 });

            /*
             * Insert a miscellaneous item for a category
             */
            AdminMiscItem mi0 = new AdminMiscItem();
            mi0.setItemValue("doc_abc_123.pdf");
            mi0.setKkMiscItemTypeId(typeId);
            mi0.setKkObjId(catId);
            mi0.setKkObjTypeId(KKConstants.OBJECT_TYPE_CATEGORY);
            mi0.setKkMiscItemId(getEng().insertMiscItems(sessionId, new AdminMiscItem[]
            { mi0 }));

            /*
             * Read the category using the Admin API
             */
            AdminCategory aCat = getEng().getCategory(catId, /* getChildren */false, langId);
            System.out.println("Value of the Cat Misc Item using the Admin App = "
                    + aCat.getMiscItems()[0].getItemValue());

            /*
             * Read the category using the App API
             */
            CategoryIf cat = appEng.getCategory(catId, langId);
            System.out.println("Value of the Cat Misc Item using the Store-Front App = "
                    + cat.getMiscItems()[0].getItemValue());

            /*
             * Insert a miscellaneous item for a product
             */
            AdminMiscItem mi1 = new AdminMiscItem();
            mi1.setItemValue("doc_xyz_567.pdf");
            mi1.setKkMiscItemTypeId(typeId);
            mi1.setKkObjId(prodId);
            mi1.setKkObjTypeId(KKConstants.OBJECT_TYPE_PRODUCT);
            mi1.setKkMiscItemId(getEng().insertMiscItems(sessionId, new AdminMiscItem[]
            { mi1 }));

            /*
             * Read the product using the Admin API
             */
            AdminProduct aProd = getEng().getProduct(sessionId, prodId);
            System.out.println("Value of the Prod Misc Item using the Admin App = "
                    + aProd.getMiscItems()[0].getItemValue());

            /*
             * Read the product using the App API
             */
            ProductIf prod = appEng.getProduct(null, prodId, langId);
            System.out.println("Value of the Prod Misc Item using the Store-Front App = "
                    + prod.getMiscItems()[0].getItemValue());

            /*
             * Read the product using a search. Note that if fillMiscItems isn't set to true
             * in the DataDescriptor, the miscelaneous attributes aren't populated.
             */
            DataDescriptorIf dd = new DataDescriptor();
            dd.setFillMiscItems(true);
            ProductSearchIf search = new ProductSearch();
            search.setSearchText("MSIMPRO");
            ProductsIf prods = appEng.searchForProducts(null, dd, search, langId);
            System.out.println("Value of the Prod Misc Item using the Store-Front App Search= "
                    + prods.getProductArray()[0].getMiscItems()[0].getItemValue());

        } catch (Exception e)
        {
            e.printStackTrace();
        }
    }

    /**
     * Helper method to instantiate an Application Engine
     * 
     * @return Returns an instance of an application engine
     * @throws KKException
     */
    private static KKEngIf getAppEng() throws KKException
    {
        EngineConfig engConf = new EngineConfig();
        engConf.setMode(getEngineMode());
        engConf.setStoreId(getStoreId());
        engConf.setCustomersShared(isCustomersShared());
        engConf.setProductsShared(isProductsShared());

        KKEngIf appEng = new KKEng(engConf);

        return appEng;
    }

    /**
     * Delete any example data we create so that the example may be run multiple times
     * 
     * @throws KKAdminException
     */
    private static void deleteExampleData(int catId, int prodId) throws KKAdminException
    {
        AdminSearch mis = new AdminSearch();
        mis.setId3(catId);
        mis.setId4(KKConstants.OBJECT_TYPE_CATEGORY);
        AdminMiscItemSearchResult amisr = getEng().getMiscItems(sessionId, null, 0, 500);
        if (amisr.getMiscItems() != null && amisr.getMiscItems().length > 0)
        {
            for (int i = 0; i < amisr.getMiscItems().length; i++)
            {
                AdminMiscItem mi = amisr.getMiscItems()[i];
                getEng().deleteMiscItem(sessionId, mi.getId());
            }
        }

        mis.setId3(prodId);
        mis.setId4(KKConstants.OBJECT_TYPE_PRODUCT);
        amisr = getEng().getMiscItems(sessionId, null, 0, 500);
        if (amisr.getMiscItems() != null && amisr.getMiscItems().length > 0)
        {
            for (int i = 0; i < amisr.getMiscItems().length; i++)
            {
                AdminMiscItem mi = amisr.getMiscItems()[i];
                getEng().deleteMiscItem(sessionId, mi.getId());
            }
        }
    }

    /**
     * Helper method to find a category id
     * 
     * @param name
     *            category name
     * @return Returns the category id
     * @throws DataSetException
     * @throws TorqueException
     * @throws KKAdminException
     */
    private static int getCategoryIdForName(String name) throws DataSetException, TorqueException,
            KKAdminException
    {
        String query = "select categories_id from categories_description where categories_name = '"
                + name + "'";
        if (getEngineMode() == EngineConfig.MODE_MULTI_STORE_SHARED_DB)
        {
            query = query + " and store_id='" + getStoreId() + "'";
        }
        List<Record> recList = BasePeer.executeQuery(query);
        int id = recList.get(0).getValue(1).asInt();
        return id;
    }

    /**
     * Helper method to find a product id
     * 
     * @param model
     *            Product model
     * @return Returns the product id
     * @throws DataSetException
     * @throws TorqueException
     * @throws KKAdminException
     */
    private static int getProductIdForModel(String model) throws DataSetException, TorqueException,
            KKAdminException
    {
        String query = "select products_id from products where products_model = '" + model + "'";

        if (getEngineMode() == EngineConfig.MODE_MULTI_STORE_SHARED_DB && !isProductsShared())
        {
            query = query + " and store_id='" + getStoreId() + "'";
        }
        List<Record> recList = BasePeer.executeQuery(query);
        int id = recList.get(0).getValue(1).asInt();
        return id;
    }

    /**
     * Helper method to find a language id
     * 
     * @param code
     * @return Returns the language id
     * @throws DataSetException
     * @throws TorqueException
     * @throws KKAdminException
     */
    private static int getLanguageIdForCode(String code) throws DataSetException, TorqueException,
            KKAdminException
    {
        String query = "select languages_id from languages where code = '" + code + "'";
        if (getEngineMode() == EngineConfig.MODE_MULTI_STORE_SHARED_DB && !isProductsShared())
        {
            query = query + " and store_id='" + getStoreId() + "'";
        }
        List<Record> recList = BasePeer.executeQuery(query);
        int id = recList.get(0).getValue(1).asInt();
        return id;
    }
}
