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
package com.konakart.al;

import java.math.BigDecimal;
import java.util.HashMap;

import com.konakart.actions.BaseAction;
import com.konakart.app.AddToBasketOptions;
import com.konakart.app.CustomerTag;
import com.konakart.app.KKException;
import com.konakart.appif.AddToBasketOptionsIf;
import com.konakart.appif.BasketIf;
import com.konakart.appif.CustomerTagIf;
import com.konakart.appif.KKEngIf;
import com.konakart.bl.ConfigConstants;

/**
 * Contains methods to add and remove products from the shopping basket.
 */
public class BasketMgr extends BaseMgr
{
    // Basket total
    private BigDecimal basketTotal = new BigDecimal(0.0);
    
    // Number of items
    private int numberOfItems = 0;

    // Hash Map to contain tags
    private HashMap<String, Boolean> tagMap = new HashMap<String, Boolean>();

    /**
     * Constructor
     * 
     * @param eng
     * @param kkAppEng
     * @throws KKException
     */
    protected BasketMgr(KKEngIf eng, KKAppEng kkAppEng) throws KKException
    {
        this.eng = eng;
        this.kkAppEng = kkAppEng;
    }

    /**
     * Get the basket items for a customer and language and set them on the customer customer object
     * of the customerMgr. Each item has a fully populated product object.
     * 
     * @throws KKException
     * @throws KKAppException
     */
    public void getBasketItemsPerCustomer() throws KKException, KKAppException
    {
        if (kkAppEng.getCustomerMgr().getCurrentCustomer() != null)
        {
            BasketIf[] bArray = eng.getBasketItemsPerCustomerWithOptions(kkAppEng.getSessionId(),
                    kkAppEng.getCustomerMgr().getCurrentCustomer().getId(), kkAppEng.getLangId(),
                    getAddToBasketOptions());
            kkAppEng.getCustomerMgr().getCurrentCustomer().setBasketItems(bArray);
            updateBasketTotal();
        }
    }

    /**
     * Calculate the total for the basket and set the local "basketTotal" variable. We just have to
     * add up the value of all of the items.
     * 
     * @throws KKAppException
     * @throws KKException
     */
    private void updateBasketTotal() throws KKException, KKAppException
    {
        if (kkAppEng.getCustomerMgr().getCurrentCustomer() != null)
        {
            BigDecimal total = new BigDecimal(0.0);
            int items = 0;
            StringBuffer prodsSB = new StringBuffer();
            if (kkAppEng.getCustomerMgr().getCurrentCustomer().getBasketItems() != null
                    && kkAppEng.getCustomerMgr().getCurrentCustomer().getBasketItems().length > 0)
            {
                prodsSB.append(CustomerTag.DELIM);
                if (kkAppEng.displayPriceWithTax())
                {
                    for (int i = 0; i < kkAppEng.getCustomerMgr().getCurrentCustomer()
                            .getBasketItems().length; i++)
                    {
                        BasketIf item = kkAppEng.getCustomerMgr().getCurrentCustomer()
                                .getBasketItems()[i];
                        total = total.add(item.getFinalPriceIncTax());
                        prodsSB.append(item.getProductId());
                        prodsSB.append(CustomerTag.DELIM);
                        items += item.getQuantity();
                    }
                } else
                {
                    for (int i = 0; i < kkAppEng.getCustomerMgr().getCurrentCustomer()
                            .getBasketItems().length; i++)
                    {
                        BasketIf item = kkAppEng.getCustomerMgr().getCurrentCustomer()
                                .getBasketItems()[i];
                        total = total.add(item.getFinalPriceExTax());
                        prodsSB.append(item.getProductId());
                        prodsSB.append(CustomerTag.DELIM);
                        items += item.getQuantity();
                    }
                }
            }
            basketTotal = total;
            numberOfItems = items;
            setCustomerTags(prodsSB.toString());
        }
    }


    /**
     * If Customer cart tags are enabled we set tags for the products in the cart and the value of
     * the cart total. We have to ensure that the customer tags exist in the database. We do this
     * once and store the result in a hash map.
     * 
     * @param prodIds
     * @throws KKException
     * @throws KKAppException
     */
    private void setCustomerTags(String prodIds) throws KKException, KKAppException
    {
        String enabled = kkAppEng.getConfig(ConfigConstants.ENABLE_CUSTOMER_CART_TAGS);
        if (enabled != null && enabled.equalsIgnoreCase("true"))
        {
            Boolean setProdsInCart = tagMap.get(BaseAction.TAG_PRODUCTS_IN_CART);
            Boolean setCartTotal = tagMap.get(BaseAction.TAG_CART_TOTAL);
            if (setProdsInCart == null)
            {
                CustomerTagIf ct = eng.getCustomerTag(null, BaseAction.TAG_PRODUCTS_IN_CART);
                if (ct == null)
                {
                    tagMap.put(BaseAction.TAG_PRODUCTS_IN_CART, new Boolean(false));
                    setProdsInCart = new Boolean(false);
                } else
                {
                    tagMap.put(BaseAction.TAG_PRODUCTS_IN_CART, new Boolean(true));
                    setProdsInCart = new Boolean(true);
                }
            }
            if (setCartTotal == null)
            {
                CustomerTagIf ct = eng.getCustomerTag(null, BaseAction.TAG_CART_TOTAL);
                if (ct == null)
                {
                    tagMap.put(BaseAction.TAG_CART_TOTAL, new Boolean(false));
                    setCartTotal = new Boolean(false);
                } else
                {
                    tagMap.put(BaseAction.TAG_CART_TOTAL, new Boolean(true));
                    setCartTotal = new Boolean(true);
                }
            }
            if (setProdsInCart)
            {
                kkAppEng.getCustomerTagMgr().insertCustomerTag(BaseAction.TAG_PRODUCTS_IN_CART, prodIds);
            }
            if (setCartTotal)
            {
                CustomerTag ct = new CustomerTag();
                ct.setValueAsBigDecimal(basketTotal);
                ct.setName(BaseAction.TAG_CART_TOTAL);
                kkAppEng.getCustomerTagMgr().insertCustomerTag(ct);
            }
        }
    }

    /**
     * All items in the basket are removed from the database and the array of basket items for the
     * current customer, are deleted.
     * 
     * @throws KKException
     * @throws KKAppException
     * 
     */
    public void emptyBasket() throws KKException, KKAppException
    {

        // Remove basket from server
        eng.removeBasketItemsPerCustomer(kkAppEng.getSessionId(), 0);
        // Update basket in UI
        getBasketItemsPerCustomer();
    }

    /**
     * The Basket object is removed from the database and so no longer appears in the customer's
     * basket. We read a new list from the database and refresh the current customer's basket if
     * refresh is set to true.
     * 
     * @param item
     *            The basket object to be removed
     * @param refresh
     *            If set to true, the current customer's basket is refreshed
     * @throws KKException
     * @throws KKAppException
     */
    public void removeFromBasket(BasketIf item, boolean refresh) throws KKException, KKAppException
    {
        if (item != null && kkAppEng.getCustomerMgr().getCurrentCustomer() != null)
        {
            eng.removeFromBasket(kkAppEng.getSessionId(), kkAppEng.getCustomerMgr()
                    .getCurrentCustomer().getId(), item);
            if (refresh)
            {
                getBasketItemsPerCustomer();
            }
        }
    }

    /**
     * Saves a new Basket object in the database for the current customer. We read a new list from
     * the database and refresh the current customer's basket if refresh is set to true.
     * 
     * @param item
     *            The basket object to be added
     * @param refresh
     *            If set to true, the current customer's basket is refreshed
     * @throws KKException
     * @throws KKAppException
     */
    public void addToBasket(BasketIf item, boolean refresh) throws KKException, KKAppException
    {
        if (item != null && kkAppEng.getCustomerMgr().getCurrentCustomer() != null)
        {
            eng.addToBasketWithOptions(kkAppEng.getSessionId(), kkAppEng.getCustomerMgr()
                    .getCurrentCustomer().getId(), item, getAddToBasketOptions());
            if (refresh)
            {
                getBasketItemsPerCustomer();
            }
        }
    }

    /**
     * Saves a new Basket object in the database for the current customer. We read a new list from
     * the database and refresh the current customer's basket if refresh is set to true. It receives
     * an options object as input in order to configure certain aspects of the method.
     * 
     * @param item
     *            The basket object to be added
     * @param options
     *            An object containing options for the method. It may be set to null.
     * @param refresh
     *            If set to true, the current customer's basket is refreshed
     * @throws KKException
     * @throws KKAppException
     */
    public void addToBasketWithOptions(BasketIf item, AddToBasketOptionsIf options, boolean refresh)
            throws KKException, KKAppException
    {
        if (item != null && kkAppEng.getCustomerMgr().getCurrentCustomer() != null)
        {
            eng.addToBasketWithOptions(kkAppEng.getSessionId(), kkAppEng.getCustomerMgr()
                    .getCurrentCustomer().getId(), item, options);
            if (refresh)
            {
                getBasketItemsPerCustomer();
            }
        }
    }

    /**
     * Updates the Basket object in the database. The only attribute that may be changed is
     * quantity. We read a new list from the database and refresh the current customer's basket if
     * refresh is set to true.
     * 
     * @param item
     *            The basket object to be updated
     * @param refresh
     *            If set to true, the current customer's basket is refreshed
     * @throws KKException
     * @throws KKAppException
     */
    public void updateBasket(BasketIf item, boolean refresh) throws KKException, KKAppException
    {
        if (item != null && kkAppEng.getCustomerMgr().getCurrentCustomer() != null)
        {
            eng.updateBasketWithOptions(kkAppEng.getSessionId(), kkAppEng.getCustomerMgr()
                    .getCurrentCustomer().getId(), item, getAddToBasketOptions());
            if (refresh)
            {
                getBasketItemsPerCustomer();
            }
        }
    }

    /**
     * Returns the total price of the basket as a formatted string so that it may be used directly
     * in the UI.
     * 
     * @return Total value of basket already formatted
     * @throws KKException
     * @throws KKAppException
     */
    public String getFormattedBasketTotal() throws KKException, KKAppException
    {
        return kkAppEng.formatPrice(basketTotal);
    }
    
    /**
     * Returns the total price of the basket as a BigDecimalValue
     * 
     * @return Total value of basket already formatted
     * @throws KKException
     * @throws KKAppException
     */
    public BigDecimal getBasketTotal() throws KKException, KKAppException
    {
        return basketTotal;
    }

    /**
     * Creates an AddToBasketOptionsIf based on the current FetchProductOptions stored in the
     * AppEng.
     * 
     * @return Returns an AddToBasketOptionsIf object
     */
    public AddToBasketOptionsIf getAddToBasketOptions()
    {
        AddToBasketOptionsIf atbo = null;
        if (kkAppEng.getFetchProdOptions() != null)
        {
            atbo = new AddToBasketOptions();
            atbo.setCatalogId(kkAppEng.getFetchProdOptions().getCatalogId());
            atbo.setPriceDate(kkAppEng.getFetchProdOptions().getPriceDate());
            atbo.setUseExternalPrice(kkAppEng.getFetchProdOptions().isUseExternalPrice());
            atbo.setUseExternalQuantity(kkAppEng.getFetchProdOptions().isUseExternalQuantity());
        }

        String allowMultiple = kkAppEng.getConfig(ConfigConstants.ALLOW_MULTIPLE_BASKET_ENTRIES);
        if (allowMultiple != null && allowMultiple.equalsIgnoreCase("true"))
        {
            if (atbo == null)
            {
                atbo = new AddToBasketOptions();
            }
            atbo.setAllowMultipleEntriesForSameProduct(true);
        }
        return atbo;
    }
    
    /**
     * @return Returns the number of items in the basket
     */
    public int getNumberOfItems()
    {
        return numberOfItems;
    }


}
