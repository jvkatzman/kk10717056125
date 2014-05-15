package com.konakartadmin.apiexamples;

import com.konakartadmin.app.KKAdminException;
import com.konakartadmin.appif.KKAdminIf;
import com.konakartadmin.bl.AdminSolrMgr;
import com.konakartadmin.blif.AdminSolrMgrIf;

/**
 * An example of how to customize the Admin SOLR manager in order to override the method that adds
 * terms to SOLR which are returned in the suggested search list. The konakartadmin.properties file
 * must be edited so that the customized manager is used rather than the standard one:
 * 
 * konakart.admin_manager.AdminSolrMgr = com.konakartadmin.apiexamples.MySolrMgr
 */
public class MySolrMgr extends AdminSolrMgr implements AdminSolrMgrIf
{

    /**
     * Constructor
     * 
     * @param eng
     * @throws Exception
     */
    public MySolrMgr(KKAdminIf eng) throws Exception
    {
        super(eng);
    }

    /**
     * The KonaKart suggested search functionality uses SOLR terms. For each product a number of
     * terms are stored. The suggested search list is ordered by popularity of the term, so the more
     * times a term has been saved, the greater chance it has of appearing in the search list. Each
     * term is given an id so that it can be identified by this method in order to decide whether to
     * allow the term to be stored or not. For example, if all of your products have the same
     * manufacturer, then you may not want to store the terms containing manufacturer information.
     * The IDs are:
     * <ul>
     * <li>TT_CAT - The category name(s) for the product</li>
     * <li>TT_MANU - The name of the product manufacturer</li>
     * <li>TT_CAT_MANU - Category by Manufacturer (i.e. Televisions by SONY)</li>
     * <li>TT_MANU_CAT - Manufacturer in Category (i.e. Philips in Hairdryers, Philips in
     * Televisions</li>
     * <li>TT_NAME - Product name</li>
     * <li>TT_MODEL - Product Model</li>
     * </ul>
     * In the case of TT_CAT_MANU the text "by" is read from the admin message catalog label
     * "label.by" and for TT_MANU_CAT the text "in" is read from the admin message catalog label
     * "label.in".
     * 
     * @param type
     *            Used when specializing this method to decide whether to not include certain terms
     *            in the search.
     * @param sb
     *            The string buffer to which the term information is added. The data in this buffer
     *            eventually is sent to SOLR.
     * @param langCode
     *            The language code because the terms are language dependent.
     * @param term
     *            The term string
     * @param prodId
     *            The id of the product or negative if not applicable.
     * @param catId
     *            The id of the category or negative if not applicable.
     * @param manuId
     *            The id of the manufacturer or negative if not applicable.
     * @param storeId
     *            The id of the store
     * @throws KKAdminException
     */
    protected void addTerm(int type, StringBuffer sb, String langCode, String term, int prodId,
            int catId, int manuId, String storeId) throws KKAdminException
    {
        /*
         * In this example we decide not to save two term types
         */
        if (type != TT_CAT_MANU && type != TT_MANU_CAT)
        {
            super.addTerm(type, sb, langCode, term, prodId, catId, manuId, storeId);
        }
    }

}
