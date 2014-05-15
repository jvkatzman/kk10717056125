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

import java.net.URLEncoder;

import com.konakart.app.Language;
import com.konakart.appif.DataDescriptorIf;
import com.konakart.appif.KKEngIf;
import com.konakart.appif.ProductSearchIf;
import com.konakart.bl.LanguageMgr;
import com.konakart.bl.SolrMgr;
import com.konakart.blif.SolrMgrIf;
import com.konakart.util.KKConstants;

/**
 * An example of how to customize the Solr manager in order to modify the standard behavior. The
 * konakart.properties file must be edited so that the customized manager is used rather than the
 * standard one:
 * 
 * konakart.manager.SolrMgr = com.konakart.bl.MySolrMgr
 * 
 * Solr behaves differently when compared to a relational database so the following customizations
 * allow you to configure the searching behavior in order to satisfy your requirements. For example,
 * the standard KonaKart behavior when searching for a product using a search string is to add a
 * wild card before and after the string in order to make the search work reliably. Lets say that
 * the name of a product is Hewlett Packard LaserJet 1100Xi and I search for Laserjet. With a
 * relational database, the product will not be found unless it has a leading and trailing wildcard.
 * i.e. I search for %laserjet%. However, with Solr the string is tokenized and the search for
 * laserjet returns a result without requiring any wild cards. Also the latest release of Solr
 * requires the search string to be made lower case when adding a wild card otherwise the search
 * becomes case sensitive.
 * 
 * However if I search for Laser, the relational database with its wild cards will return a result
 * whereas Solr will not return a result unless wild cards are added.
 */
public class MySolrMgr extends SolrMgr implements SolrMgrIf
{

    /**
     * Constructor
     * 
     * @param eng
     * @throws Exception
     */
    public MySolrMgr(KKEngIf eng) throws Exception
    {
        super(eng);
    }

    /**
     * Creates a search string based on the rule. Adds wild cards if necessary. This is called for
     * product searches based on product name, description and manufacturer name. Note that the
     * default search behavior for KonaKart is to add a wild card before and after the search string
     * in order to return results when using a relational database. By default in the SolrMgr these
     * wild cards are not added.
     * 
     * @param searchString
     *            The search string
     * @param rule
     *            The rule for determining whether to introduce a wild card
     * @return Returns a search string with wild cards if appropriate
     */
    protected String getTextSearchString(String searchString, int rule)
    {
        if (searchString == null || searchString.length() == 0)
        {
            return searchString;
        }

        switch (rule)
        {
        case KKConstants.SEARCH_ADD_WILDCARD_AFTER:
            return searchString.toLowerCase() + "*";
        case KKConstants.SEARCH_ADD_WILDCARD_BEFORE:
            return "*" + searchString.toLowerCase();
        case KKConstants.SEARCH_ADD_WILDCARD_BEFORE_AND_AFTER:
            return searchString;
        case KKConstants.SEARCH_EXACT:
            return searchString;
        }

        return searchString;
    }

    /**
     * Creates a search string based on the rule. Adds wild cards if necessary. This is called for
     * searching for products base don values within custom fields.
     * 
     * @param searchString
     *            The search string
     * @param rule
     *            The rule for determining whether to introduce a wild card
     * @param customFieldNum
     *            Used to detect which custom field is being used
     * @return Returns a search string with wild cards if appropriate
     */
    protected String getCustomSearchString(String searchString, int rule, int customFieldNum)
    {

        if (searchString == null || searchString.length() == 0)
        {
            return searchString;
        }

        switch (rule)
        {
        case KKConstants.SEARCH_ADD_WILDCARD_AFTER:
            return searchString.toLowerCase() + "*";
        case KKConstants.SEARCH_ADD_WILDCARD_BEFORE:
            return "*" + searchString.toLowerCase();
        case KKConstants.SEARCH_ADD_WILDCARD_BEFORE_AND_AFTER:
            return "*" + searchString.toLowerCase() + "*";
        case KKConstants.SEARCH_EXACT:
            return searchString;
        }

        return searchString;
    }

    /**
     * Method that can be used to customize the query string. The query string does not include the
     * SOLR URL.<br>
     * This example shows how to modify the query string to search for all search terms ANDED
     * together. i.e. Rather than searching for "explorer microsoft" it searches for
     * "explorer AND microsoft" in order to find any text where both words appear in any order.
     * 
     * @param queryString
     * @param dataDesc
     * @param prodSearch
     * @param languageId
     * @return Returns the query string
     * @throws Exception
     */
    protected String beforeSendQuery(String sessionId, String queryString,
            DataDescriptorIf dataDesc, ProductSearchIf prodSearch, int languageId) throws Exception
    {

        // The query should look something like:
        // q=%28manu%3A%22explorer+microsoft%22+OR+model%3A%22explorer+microsoft%22+OR+name_en%3A%22explorer+microsoft%22+OR+desc_en%3A%22explorer+microsoft%22%29+AND+invisible%3Afalse+AND+status%3Atrue&fl=id&start=0&rows=21&sort=price0+asc
        /*
         * By default we search manu (manufacturer), model, name. Searching in the description
         * (desc) is optional. Since it searches for "explorer microsoft" it doesn't find anything
         * in our default database.
         */
        if (log.isDebugEnabled())
        {
            log.debug("Before query string SOLR -> ");
            log.debug(queryString);
        }

        /*
         * Let's split the query up into two pieces. One which we'll customize and the other which
         * we won't.
         */
        int index = queryString.indexOf("+AND+invisible%3A");
        String customizablePart = queryString.substring(0, index);
        String secondPart = queryString.substring(index);

        if (log.isDebugEnabled())
        {
            log.debug("Customizable Part = " + customizablePart);
            log.debug("Second Part = " + secondPart);
        }

        // Get the language object in order to get the language code
        int langId = languageId;
        if (langId == LanguageMgr.DEFAULT_LANG)
        {
            langId = getLangMgr().getDefaultLanguageId();
        }
        Language lang = getLangMgr().getLanguagePerId(langId);

        /*
         * split the search text into individual tokens and create a new search string. In this case
         * we'll search only in the name field in order to keep things simple
         */
        String[] wordArray = prodSearch.getSearchText().split(" ");
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < wordArray.length; i++)
        {
            String word = wordArray[i];
            if (word != null && word.trim().length() > 0)
            {
                if (sb.length() != 0)
                {
                    sb.append(AND);
                } else
                {
                    sb.append("q=" + OPEN_BRACKETS);
                }
                sb.append("name_" + lang.getCode() + COLON);
                sb.append(URLEncoder.encode(word, POST_ENCODING));
            }
        }
        sb.append(CLOSE_BRACKETS);

        // Append the 2nd part to form the completed new query
        sb.append(secondPart);

        if (log.isDebugEnabled())
        {
            // Should look like :  q=%28name_en%3Aexplorer+AND+name_en%3Amicrosoft%29+AND+invisible%3Afalse+AND+status%3Atrue&fl=id&start=0&rows=21&sort=price0+asc
            log.debug("New Query = " + sb.toString());
        }

        return sb.toString();
    }

}
