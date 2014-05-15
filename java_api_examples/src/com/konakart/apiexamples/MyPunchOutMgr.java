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

import java.math.BigDecimal;
import java.util.List;

import com.konakart.app.NameValue;
import com.konakart.appif.KKEngIf;
import com.konakart.appif.OrderIf;
import com.konakart.appif.OrderProductIf;
import com.konakart.appif.PunchOutOptionsIf;
import com.konakart.bl.PunchOutMgr;
import com.konakart.blif.PunchOutMgrIf;

/**
 * An example of how to customize the PunchOutMgr to modify the message it generates. The
 * konakart.properties file must be edited so that the customized manager is used rather than the
 * standard one:
 * 
 * konakart.manager.PunchOutMgr = com.konakart.apiexamples.MyPunchOutMgr
 * 
 */
public class MyPunchOutMgr extends PunchOutMgr implements PunchOutMgrIf
{
    /**
     * Constructor
     * 
     * @param eng
     * @throws Exception
     */
    public MyPunchOutMgr(KKEngIf eng) throws Exception
    {
        super(eng);
    }
    
    /**
     * In your own implementation of the PunchOut manager you can override this method to customize
     * the data being returned. The parameters are set using code similar to:<br>
     * <code>nvList.add(new NameValue("NEW_ITEM-DESCRIPTION[" + index + "]", op.getName()));</code>
     * 
     * @param order
     *            The order
     * @param op
     *            The order product
     * @param nvList
     *            List of NameValue pairs. New data is added to the list.
     * @param index
     *            Index used for creating the name value pairs
     * @param scale
     *            Scale used for formatting the currency
     * @param options
     *            PunchOutOptions
     */
    protected void getData_OCI_HTML(OrderIf order, OrderProductIf op, List<NameValue> nvList,
            int index, int scale, PunchOutOptionsIf options)
    {

        // NEW_ITEM-DESCRIPTION
        nvList.add(new NameValue("NEW_ITEM-DESCRIPTION[" + index + "]", op.getName()));

        // NEW_ITEM-VENDORMAT
        if (op.getSku() != null)
        {
            nvList.add(new NameValue("NEW_ITEM-VENDORMAT[" + index + "]", op.getSku()));
        }

        // NEW_ITEM-EXT_PRODUCT_ID
        nvList.add(new NameValue("NEW_ITEM-EXT_PRODUCT_ID[" + index + "]", op.getProductId()));

        // NEW_ITEM-QUANTITY
        nvList.add(new NameValue("NEW_ITEM-QUANTITY[" + index + "]", op.getQuantity()));

        // NEW_ITEM-UNIT
        nvList.add(new NameValue("NEW_ITEM-UNIT[" + index + "]", "EA"));

        // NEW_ITEM-CURRENCY
        nvList.add(new NameValue("NEW_ITEM-CURRENCY[" + index + "]", order.getCurrencyCode()));

        // NEW_ITEM-PRICE Price of an item per price unit
        BigDecimal opPrice = op.getPrice().setScale(scale, BigDecimal.ROUND_HALF_UP);
        if (op.getQuantity() > 1)
        {
            opPrice = opPrice.divide(new BigDecimal(op.getQuantity()), BigDecimal.ROUND_HALF_UP);
        }

        nvList.add(new NameValue("NEW_ITEM-PRICE[" + index + "]", opPrice.toPlainString()));

        // NEW_ITEM-PRICEUNIT
        nvList.add(new NameValue("NEW_ITEM-PRICEUNIT[" + index + "]", "1"));

    }


    /**
     * In your own implementation of the PunchOut manager you can override this method to provide
     * your own data for the various tags and tag attributes.
     * 
     * @param tagName
     *            The name of the tag as it appears in the XML
     * @param attrName
     *            The name of the attribute as it appears in the XML
     * @param orderProduct
     *            The OrderProduct object. In most cases it will have an attached Product object
     * @param options
     *            The PunchOut options
     * @return Returns the data that will be added to the message. Default values are used if null
     *         is returned
     */
    protected String getData_OCI_XML(String tagName, String attrName, OrderProductIf orderProduct,
            PunchOutOptionsIf options)
    {
        if (tagName.equals("Price") && attrName == null)
        {
            /*
             * Return an empty string to not display the price
             */
            return "";
        } else if (tagName.equals("ItemText") && attrName == null)
        {
            /*
             * The product description isn't returned in the standard implementation
             */
            if (orderProduct.getProduct() != null)
            {
                return "<![CDATA[" + orderProduct.getProduct().getDescription() + "]]>";
            }
        } else if (tagName.equals("LeadTime") && attrName == null)
        {
            /*
             * The lead time isn't returned in the standard implementation. It could be saved in one
             * of the Product custom fields.
             */
            if (orderProduct.getProduct() != null)
            {
                return orderProduct.getProduct().getCustom1();
            }
        }

        return null;

    }

}
