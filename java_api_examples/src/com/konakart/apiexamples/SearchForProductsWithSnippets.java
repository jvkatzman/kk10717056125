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
package com.konakart.apiexamples;

import com.konakart.app.DataDescConstants;
import com.konakart.app.DataDescriptor;
import com.konakart.app.ProductSearch;
import com.konakart.app.SnippetOptions;
import com.konakart.appif.ProductIf;
import com.konakart.appif.ProductsIf;

/**
 * This class shows how to call the KonaKart API to search for products. It covers the case where
 * the products may be digital download products and be indexed in the SOLR search engine. In this
 * case it is useful to get snippets of text surrounding the search keywords. Note that snippets can
 * be returned from product descriptions even for non digital download products.
 * 
 * Before running you may have to edit BaseApiExample.java to change the username and password used
 * to log into the engine. The default values are doe@konakart.com / password .
 */
public class SearchForProductsWithSnippets extends BaseApiExample
{
    private static final String usage = "Usage: SearchForProductsWithSnippets\n" + COMMON_USAGE;

    /**
     * @param args
     */
    public static void main(String[] args)
    {
        parseArgs(args, usage, 0);

        try
        {
            /*
             * Get an instance of the KonaKart engine and login. The method called can be found in
             * BaseApiExample.java
             */
            init();

            // Create a product search object
            ProductSearch ps = new ProductSearch();
            ps.setSearchText("Scotland");
            ps.setWhereToSearch(ProductSearch.SEARCH_IN_PRODUCT_DESCRIPTION);

            // Create a snippet options object and attach it to the search object
            SnippetOptions so = new SnippetOptions();
            ps.setSnippetOptions(so);
            so.setEnableSnippets(true);
            so.setPreKeywordHighlight("<b>");
            so.setPostKeywordHighlight("</b>");
            so.setNumberOfSnippets(5);
            so.setSnippetSizeInChars(200);
            so.setEscapeHTML(false);

            // Create a data descriptor
            DataDescriptor datadesc = new DataDescriptor();
            datadesc.setOffset(0);
            datadesc.setLimit(DataDescConstants.MAX_ROWS);

            // Now we can search for the products.
            ProductsIf prods = eng.searchForProducts(/* sessionId */null, datadesc, ps,
                    DEFAULT_LANGUAGE);

            System.out.println("Total number of Products: " + prods.getTotalNumProducts());

            if (prods.getProductArray() != null)
            {
                for (int i = 0; i < prods.getProductArray().length; i++)
                {
                    ProductIf prod = prods.getProductArray()[i];
                    System.out.println("Product Name: " + prod.getName());
                    if (prod.getSnippets() != null)
                    {
                        for (int j = 0; j < prod.getSnippets().length; j++)
                        {
                            String snippet = prod.getSnippets()[j];
                            System.out.println("Snippet: " + snippet);
                        }
                    }
                }
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
    }
}
