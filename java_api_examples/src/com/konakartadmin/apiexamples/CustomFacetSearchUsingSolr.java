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

import com.konakart.app.DataDescConstants;
import com.konakart.app.EngineConfig;
import com.konakart.app.KKEng;
import com.konakart.app.KKException;
import com.konakart.app.ProductSearch;
import com.konakart.appif.KKEngIf;
import com.konakart.appif.KKFacetIf;
import com.konakart.appif.NameNumberIf;
import com.konakart.appif.ProductsIf;
import com.konakart.appif.TagGroupIf;
import com.konakart.util.KKConstants;
import com.konakartadmin.app.AdminDataDescriptor;
import com.konakartadmin.app.AdminProdAttrDesc;
import com.konakartadmin.app.AdminProdAttrDescSearch;
import com.konakartadmin.app.AdminProdAttrDescSearchResult;
import com.konakartadmin.app.AdminProdAttrTemplate;
import com.konakartadmin.app.AdminProdAttrTemplateSearch;
import com.konakartadmin.app.AdminProdAttrTemplateSearchResult;
import com.konakartadmin.app.AdminProduct;
import com.konakartadmin.app.AdminProductSearch;
import com.konakartadmin.app.AdminProducts;
import com.konakartadmin.app.AdminSearch;
import com.konakartadmin.app.AdminTagGroup;
import com.konakartadmin.app.AdminTagGroupSearchResult;
import com.konakartadmin.app.KKAdminException;
import com.workingdogs.village.DataSetException;
import com.workingdogs.village.Record;

/**
 * This class contains a full example using both the Admin and App engines to demonstrate the usage
 * of SOLR for performing searches returning custom facets. It uses products which are available in
 * the KonaKart demonstration storefront database. The steps are:
 * <ul>
 * <li>Create 3 custom attributes (kkFormat, kkGenre and kkRating). Map them to facets 1, 2 and 3.</li>
 * <li>Create a custom attribute template for DVD products and add the 3 custom attributes to the
 * template.</li>
 * <li>Add the template to the 3 products in the DVD Drama Category.</li>
 * <li>Set values for the custom attributes for these 3 products</li>
 * <li>Create three tag groups for the DVD Drama Category. Each tag group corresponds to one of the
 * custom fields and maps to the same facet number</li>
 * <li>Add the tag groups to the DVD category</li>
 * <li>Enable SOLR and add the products to SOLR</li>
 * <li>Instantiate a KK Application Engine to do some product queries</li>
 * <li>Return all products for the DVD Drama Category with no constraints</li>
 * <li>Add constraints and repeat the query</li>
 * </ul>
 * 
 * 
 * Before running you may have to edit BaseApiExample.java to change the username and password used
 * to log into the engine. The default values are admin@konakart.com / princess .
 */
public class CustomFacetSearchUsingSolr extends BaseApiExample
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
             * Get the category id for the Drama category which should contain 3 DVD products
             */
            int catId = getCategoryIdForName("Drama");

            /*
             * Delete any example data we create so that the example may be run multiple times
             */
            deleteExampleData();

            /*
             * Create and insert 3 custom attributes for DVDs. Each custom field is given a facet
             * number.
             */
            AdminProdAttrDesc attr1 = new AdminProdAttrDesc();
            attr1.setFacetNumber(1);
            attr1.setName("kkFormat");

            AdminProdAttrDesc attr2 = new AdminProdAttrDesc();
            attr2.setFacetNumber(2);
            attr2.setName("kkGenre");

            AdminProdAttrDesc attr3 = new AdminProdAttrDesc();
            attr3.setFacetNumber(3);
            attr3.setName("kkRating");

            int attr1Id = getEng().insertProdAttrDesc(sessionId, attr1);
            attr1.setId(attr1Id);

            int attr2Id = getEng().insertProdAttrDesc(sessionId, attr2);
            attr2.setId(attr2Id);

            int attr3Id = getEng().insertProdAttrDesc(sessionId, attr3);
            attr3.setId(attr3Id);

            /*
             * Create and insert a template for DVDs
             */
            AdminProdAttrTemplate tmpl = new AdminProdAttrTemplate();
            tmpl.setName("kkDVDTemplate");
            tmpl.setDescription("A template containing custom fields for DVDs");
            int tmplId = getEng().insertProdAttrTemplate(sessionId, tmpl);
            tmpl.setId(tmplId);

            /*
             * Add the custom DVD attributes to the DVD template
             */
            getEng().addProdAttrDescsToTemplate(sessionId, new AdminProdAttrDesc[]
            { attr1, attr2, attr3 }, tmpl.getId());

            /*
             * Read back the custom fields
             */
            AdminProdAttrDesc[] padArray = getEng().getProdAttrDescsForTemplate(sessionId,
                    tmpl.getId());

            /*
             * Add the template to products in the DVD Drama category. There should be three
             * products here.
             */
            AdminDataDescriptor add = new AdminDataDescriptor(DataDescConstants.ORDER_BY_ID, 0, 100);
            AdminProductSearch aSearch = new AdminProductSearch();
            aSearch.setCategoryId(catId);
            AdminProducts aProds = getEng().searchForProducts(sessionId, add, aSearch,
                    KKConstants.DEFAULT_LANGUAGE_ID);
            if (aProds.getProductArray() == null || aProds.getProductArray().length != 3)
            {
                System.out.println("Did not find 3 products in the category with id = " + catId);
                return;
            }

            /*
             * Loop through the 3 products. Add the template and set the custom fields with values
             */
            for (int i = 0; i < aProds.getProductArray().length; i++)
            {
                AdminProduct prodLight = aProds.getProductArray()[i];
                AdminProduct prod = getEng().getProduct(sessionId, prodLight.getId());
                prod.setTemplateId(tmpl.getId());
                if (i == 0)
                {
                    // kkFormat
                    padArray[0].setValue("Blu-ray");
                    // kkGenre
                    padArray[1].setValue("Drama");
                    // kkRating
                    padArray[2].setValue("G");
                } else if (i == 1)
                {
                    // kkFormat
                    padArray[0].setValue("Blu-ray");
                    // kkGenre
                    padArray[1].setValue("Drama");
                    // kkRating
                    padArray[2].setValue("PG");
                } else if (i == 2)
                {
                    // kkFormat
                    padArray[0].setValue("HD-DVD");
                    // kkGenre
                    padArray[1].setValue("Drama");
                    // kkRating
                    padArray[2].setValue("R");
                }
                prod.setCustomAttrArray(padArray);

                getEng().editProduct(sessionId, prod);
            }

            /*
             * Create three tag groups for the drama category. Each tag group corresponds to one of
             * the custom fields and maps to the same facet number
             */
            int langId = getLanguageIdForCode("en");

            AdminTagGroup tg1 = new AdminTagGroup();
            tg1.setName("kkFormat");
            tg1.setLanguageId(langId);
            tg1.setDescription("DVD format group");
            tg1.setFacetNumber(1);
            int tg1Id = getEng().insertTagGroup(sessionId, tg1);
            tg1.setId(tg1Id);

            AdminTagGroup tg2 = new AdminTagGroup();
            tg2.setName("kkGenre");
            tg2.setLanguageId(langId);
            tg2.setDescription("DVD Genre group");
            tg2.setFacetNumber(2);
            int tg2Id = getEng().insertTagGroup(sessionId, tg2);
            tg2.setId(tg2Id);

            AdminTagGroup tg3 = new AdminTagGroup();
            tg3.setName("kkRating");
            tg3.setLanguageId(langId);
            tg3.setDescription("DVD Rating group");
            tg3.setFacetNumber(3);
            int tg3Id = getEng().insertTagGroup(sessionId, tg3);
            tg3.setId(tg3Id);

            /*
             * Associate the tag groups with the Drama category
             */
            getEng().addTagGroupsToCategory(sessionId, new AdminTagGroup[]
            { tg1, tg2, tg3 }, catId);

            /*
             * Enable SOLR
             */
            getEng().setConfigurationValue(sessionId, "USE_SOLR_SEARCH", "true");
            getEng().updateCachedConfigurations(sessionId);

            /*
             * Add all products to SOLR
             */
            getEng().addAllProductsToSearchEngine(sessionId, /* async */false);

            /*
             * Now that we've set up some products with a template and custom attributes mapped to
             * SOLR facets, and we've set up Tag Groups mapped to the same SOLR facets, we need to
             * use the application engine to perform some product searches.
             */
            KKEngIf appEng = getAppEng();

            /*
             * Get the tag groups for the category
             */
            TagGroupIf[] groups = appEng.getTagGroupsPerCategory(catId,/* getProdCount */false,
                    KKConstants.DEFAULT_LANGUAGE_ID);
            if (groups == null || groups.length != 3)
            {
                System.out
                        .println("Could not find three tag groups for the category id = " + catId);
                return;
            }

            /*
             * Perform a search that should return facet values for the 3 custom fields
             */
            ProductSearch ps = new ProductSearch();
            ps.setReturnCustomFacets(true);
            ps.setCategoryId(catId);
            ps.setTagGroups(groups);

            ProductsIf prods = appEng.searchForProducts(sessionId, null, ps,
                    KKConstants.DEFAULT_LANGUAGE_ID);
            if (prods.getCustomFacets() == null || prods.getCustomFacets().length == 0)
            {
                System.out.println("No facets were returned from the SOLR search");
                return;
            }
            System.out.println("----- Get all facets with no filters applied -----");
            printResults(prods.getCustomFacets());

            /*
             * Do the search again after applying a filter where format needs to be Blu-ray. The
             * filter is specified in the tag group. The kkFormat tag group is the first one in the
             * list.
             */
            groups[0].setFacetConstraint("Blu-ray");
            ps.setTagGroups(groups);
            prods = appEng.searchForProducts(sessionId, null, ps, KKConstants.DEFAULT_LANGUAGE_ID);
            System.out.println("\n----- Get facets with Blu-ray filter applied -----");
            printResults(prods.getCustomFacets());

            /*
             * Do the search again after applying a filter where format needs to be Blu-ray and
             * rating needs to be G. The filter is specified in the tag group. The kkFormat tag
             * group is the first one in the list and the kkRating is the last one
             */
            groups[0].setFacetConstraint("Blu-ray");
            groups[2].setFacetConstraint("G");
            prods = appEng.searchForProducts(sessionId, null, ps, KKConstants.DEFAULT_LANGUAGE_ID);
            System.out.println("\n----- Get facets with Blu-ray and G filter applied -----");
            printResults(prods.getCustomFacets());

            /*
             * Do the search again after applying a filter where format needs to be "invalid". The
             * filter is specified in the tag group. The kkFormat tag group is the first one in the
             * list. It should return no results.
             */
            groups[0].setFacetConstraint("invalid");
            groups[2].setFacetConstraint(null);
            prods = appEng.searchForProducts(sessionId, null, ps, KKConstants.DEFAULT_LANGUAGE_ID);
            System.out.println("\n----- Get facets with invalid filter applied -----");
            printResults(prods.getCustomFacets());

        } catch (Exception e)
        {
            e.printStackTrace();
        }
    }

    /**
     * Method use to print out results
     * 
     * @param facets
     */
    private static void printResults(KKFacetIf[] facets)
    {
        /*
         * Loop through the facet data and print it out
         */
        for (int i = 0; i < facets.length; i++)
        {
            KKFacetIf facet = facets[i];
            System.out.println("\n" + facet.getName() + ", mapped to facet number "
                    + facet.getNumber() + ", contains the value(s):");
            if (facet.getValues() == null)
            {
                System.out.println("NONE");
            } else
            {
                for (int j = 0; j < facet.getValues().length; j++)
                {
                    NameNumberIf nn = facet.getValues()[j];
                    System.out.println(nn.getName() + "(" + nn.getNumber() + ")");
                }
            }
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
    private static void deleteExampleData() throws KKAdminException
    {

        /*
         * Delete any product templates starting with kk
         */
        AdminProdAttrTemplateSearch tsearch = new AdminProdAttrTemplateSearch();
        tsearch.setName("kk");
        tsearch.setNameRule(KKConstants.SEARCH_ADD_WILDCARD_AFTER);
        AdminProdAttrTemplateSearchResult tres = getEng().getProdAttrTemplates(sessionId, tsearch,
                0, 100);
        if (tres.getProdAttrTemplates() != null && tres.getProdAttrTemplates().length > 0)
        {
            for (int i = 0; i < tres.getProdAttrTemplates().length; i++)
            {
                AdminProdAttrTemplate tmpl = tres.getProdAttrTemplates()[i];
                getEng().deleteProdAttrTemplate(sessionId, tmpl.getId());
            }
        }

        /*
         * Delete any custom product attributes starting with kk
         */
        AdminProdAttrDescSearch dsearch = new AdminProdAttrDescSearch();
        dsearch.setName("kk");
        dsearch.setNameRule(KKConstants.SEARCH_ADD_WILDCARD_AFTER);
        AdminProdAttrDescSearchResult dres = getEng().getProdAttrDescs(sessionId, dsearch, 0, 100);
        if (dres.getProdAttrDescs() != null && dres.getProdAttrDescs().length > 0)
        {
            for (int i = 0; i < dres.getProdAttrDescs().length; i++)
            {
                AdminProdAttrDesc attrDesc = dres.getProdAttrDescs()[i];
                getEng().deleteProdAttrDesc(sessionId, attrDesc.getId());
            }
        }

        /*
         * Delete any tag groups starting with kk
         */
        AdminSearch adminSearch = new AdminSearch();
        adminSearch.setName("kk");
        adminSearch.setNameRule(KKConstants.SEARCH_ADD_WILDCARD_AFTER);
        AdminTagGroupSearchResult result = getEng().getTagGroups(sessionId, adminSearch, 0, 100);
        if (result != null && result.getTagGroups() != null && result.getTagGroups().length > 0)
        {
            for (int t = 0; t < result.getTagGroups().length; t++)
            {
                int thisTagGroupId = result.getTagGroups()[t].getId();
                getEng().deleteTagGroup(sessionId, thisTagGroupId);
            }
        }
    }

    /**
     * Helper method to find a category id
     * 
     * @param name
     *            category name
     * @param storeId
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