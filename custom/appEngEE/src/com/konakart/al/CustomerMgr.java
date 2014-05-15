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

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.konakart.actions.BaseAction;
import com.konakart.app.AddToWishListOptions;
import com.konakart.app.Customer;
import com.konakart.app.CustomerSearch;
import com.konakart.app.CustomerTag;
import com.konakart.app.EmailOptions;
import com.konakart.app.KKException;
import com.konakart.appif.AddressIf;
import com.konakart.appif.BasketIf;
import com.konakart.appif.CountryIf;
import com.konakart.appif.CustomerIf;
import com.konakart.appif.CustomerRegistrationIf;
import com.konakart.appif.CustomerSearchIf;
import com.konakart.appif.EmailOptionsIf;
import com.konakart.appif.KKEngIf;
import com.konakart.appif.OrderIf;
import com.konakart.appif.ProductIf;
import com.konakart.appif.WishListIf;
import com.konakart.appif.WishListsIf;
import com.konakart.appif.ZoneIf;
import com.konakart.bl.ConfigConstants;

/**
 * Contains methods to manage customer details and login / logout.
 */
public class CustomerMgr extends BaseMgr
{
    /**
     * The <code>Log</code> instance for this application.
     */
    private Log log = LogFactory.getLog(CustomerMgr.class);

    /* The currently selected address object for editing or deleting */
    private AddressIf selectedAddr;

    // Current logged in user
    private CustomerIf currentCustomer = null;

    // Currently selected country
    private CountryIf selectedCountry;

    // Array of zones that a customer can choose from when registering. They depend on the selected
    // country.
    private ZoneIf[] selectedZones;

    /**
     * Constructor
     * 
     * @param eng
     * @param kkAppEng
     */
    protected CustomerMgr(KKEngIf eng, KKAppEng kkAppEng)
    {
        this.eng = eng;
        this.kkAppEng = kkAppEng;
        /* Set the selected country which also sets the selected zones. */
        String countryIdStr = kkAppEng.getConfig("STORE_COUNTRY");
        if (countryIdStr != null)
        {
            int id = 0;
            try
            {
                id = Integer.parseInt(countryIdStr);
                // Set selected country and zones
                setSelectedCountry(kkAppEng.getCountry(id));
            } catch (NumberFormatException e)
            {
                log.warn("The configuration variable STORE_COUNTRY has an invalid value - "
                        + countryIdStr + ". It should be the numeric id of the country.");
            } catch (KKException e)
            {
                log.warn("Problem calling getCountry()", e);
            }
        }
    }

    /**
     * Ensures that the selectedAddr attribute is populated. The addrId should match the id of one
     * of the addresses of the current customer.
     * 
     * @param addrId
     *            Address Id of one of the addresses of the current customer
     * @throws KKAppException
     * @throws KKException
     */
    public void setSelectedAddrFromId(int addrId) throws KKAppException, KKException
    {
        if (currentCustomer == null)
        {
            throw new KKAppException("You need to be logged in, in order to select an address.");
        }

        if (currentCustomer.getAddresses() == null)
        {
            populateCurrentCustomerAddresses(/* force */true);
        }

        if (currentCustomer.getAddresses() == null)
        {
            throw new KKAppException("The current customer has no addresses.");
        }

        AddressIf addrFound = null;

        for (int i = 0; i < currentCustomer.getAddresses().length; i++)
        {
            AddressIf addr = currentCustomer.getAddresses()[i];
            if (addr.getId() == addrId)
            {
                addrFound = addr;
                break;
            }
        }

        if (addrFound != null)
        {
            selectedAddr = addrFound;
        } else
        {
            throw new KKAppException("The address referenced by id = " + addrId
                    + " could not be found");
        }
    }

    /**
     * Call the engine to edit the customer address.
     * 
     * @param addr
     *            The address object to be edited
     * @throws KKException
     * @throws KKAppException
     */
    public void editCustomerAddress(AddressIf addr) throws KKException, KKAppException
    {
        eng.editCustomerAddress(kkAppEng.getSessionId(), addr);
        // Make sure we get the updated address from the DB
        populateCurrentCustomerAddresses(/* force */true);
    }

    /**
     * Call the engine to delete the customer address.
     * 
     * @param addrId
     *            The address Id of the address to be deleted.
     * @throws KKException
     * @throws KKAppException
     */
    public void deleteAddressFromCustomer(int addrId) throws KKException, KKAppException
    {
        eng.deleteAddressFromCustomer(kkAppEng.getSessionId(), addrId);
        // Make sure we get the updated address from the DB
        populateCurrentCustomerAddresses(/* force */true);
    }

    /**
     * Call the engine to create a new customer address which is added to the addresses of the
     * current customer.
     * 
     * @param addr
     *            The address to be added
     * @return Returns the id of the address object
     * @throws KKException
     * @throws KKAppException
     */
    public int addAddressToCustomer(AddressIf addr) throws KKException, KKAppException
    {
        int addrId = eng.addAddressToCustomer(kkAppEng.getSessionId(), addr);
        // Make sure we get the updated addresses from the DB
        populateCurrentCustomerAddresses(/* force */true);
        return addrId;
    }

    /**
     * Returns the currently selected address.
     * 
     * @return Returns the selectedAddr.
     */
    public AddressIf getSelectedAddr()
    {
        return selectedAddr;
    }

    /**
     * Sets the selected address to the one passed in as a parameter.
     * 
     * @param selectedAddr
     *            The selectedAddr to set.
     */
    public void setSelectedAddr(AddressIf selectedAddr)
    {
        this.selectedAddr = selectedAddr;
    }

    /**
     * Fetch the product notifications for a customer and language and set them on the customer
     * object. Each item has a product object which isn't however fully populated.
     * 
     * We set an empty array rather than null because an empty array indicates that there are no
     * notifications rather than null, which indicates that we haven't read them from the DB yet.
     * 
     * @throws KKException
     */
    public void fetchProductNotificationsPerCustomer() throws KKException
    {
        if (currentCustomer != null)
        {
            ProductIf[] pArray = eng.getProductNotificationsPerCustomerWithOptions(
                    kkAppEng.getSessionId(), kkAppEng.getLangId(), kkAppEng.getFetchProdOptions());
            if (pArray == null)
            {
                pArray = new ProductIf[0];
            }
            currentCustomer.setProductNotifications(pArray);
        }
    }

    /**
     * Add the product notification to the currently logged in customer.
     * 
     * @param productId
     *            The id of the product to be added
     * @throws KKException
     */
    public void addProductNotificationsToCustomer(int productId) throws KKException
    {
        if (currentCustomer != null)
        {
            eng.addProductNotificationToCustomer(kkAppEng.getSessionId(), productId);
            // Refresh the list
            fetchProductNotificationsPerCustomer();
        }
    }

    /**
     * Delete the product notification from the customer's list of notifications.
     * 
     * @param productId
     *            The id of the product to be removed
     * @throws KKException
     */
    public void deleteProductNotificationsFromCustomer(int productId) throws KKException
    {
        if (currentCustomer != null)
        {
            eng.deleteProductNotificationFromCustomer(kkAppEng.getSessionId(), productId);
            // Refresh the list
            fetchProductNotificationsPerCustomer();
        }
    }

    /**
     * Calls the engine to edit the current customer's locale
     * 
     * @param locale
     *            The new locale
     * @throws KKException
     */
    public void editCustomerLocale(String locale) throws KKException
    {
        if (currentCustomer != null && currentCustomer.getId() > -1)
        {
            currentCustomer.setLocale(locale);
            editCustomer(currentCustomer);
        }
    }

    /**
     * Calls the engine to update the customer data with the data passed in as a parameter.
     * 
     * @param cust
     *            The Customer object to be edited
     * @throws KKException
     */
    public void editCustomer(CustomerIf cust) throws KKException
    {
        eng.editCustomer(kkAppEng.getSessionId(), cust);

        // Update currentCustomer with the latest data. Making sure we don't lose the basket or the
        // wish list or orders
        BasketIf[] basketItems = currentCustomer.getBasketItems();
        WishListIf[] wishLists = currentCustomer.getWishLists();
        OrderIf[] orders = currentCustomer.getOrders();
        AddressIf[] addresses = currentCustomer.getAddresses();
        currentCustomer = eng.getCustomer(kkAppEng.getSessionId());
        currentCustomer.setBasketItems(basketItems);
        currentCustomer.setWishLists(wishLists);
        currentCustomer.setOrders(orders);
        currentCustomer.setAddresses(addresses);
    }

    /**
     * Ensures that the currentCustomer object has his default address and array of addresses
     * populated
     * 
     * @param force
     *            If set to true the addresses will be refreshed even if they already exist
     * @return Returns the customer with populated addresses
     * 
     * @throws KKException
     * @throws KKAppException
     * 
     */
    public CustomerIf populateCurrentCustomerAddresses(boolean force) throws KKException,
            KKAppException
    {

        if (currentCustomer == null)
        {
            throw new KKAppException("The user is not logged in");
        }

        if (force || currentCustomer.getAddresses() == null
                || currentCustomer.getDefaultAddr() == null)
        {
            AddressIf[] addresses = eng.getAddressesPerCustomer(kkAppEng.getSessionId());
            if (addresses == null || addresses.length == 0)
            {
                throw new KKAppException(
                        "The current user has no addresses set. All registered users should have at least one address set.");
            }
            // The first address in the array is always the default one
            currentCustomer.setDefaultAddr(addresses[0]);
            currentCustomer.setAddresses(addresses);
        }

        return currentCustomer;
    }

    /**
     * We create a customer object for a guest. We give it a negative id which will never be used by
     * a real customer. The reason we do this is so we can reuse all for the logic for the customer
     * cart even for a guest without having to create new logic in order to store a guest cart.
     * 
     * @throws KKException
     */
    protected void createGuest() throws KKException
    {

        /* get an id for the customer object. This temporary id is negative. */
        int id = kkAppEng.getEng().getTempCustomerId();

        /* Remove any existing basket items */
        eng.removeBasketItemsPerCustomer(kkAppEng.getSessionId(), id);

        /* Create the customer object */
        CustomerIf cust = new Customer();
        cust.setId(id);
        cust.setGlobalProdNotifier(0);
        currentCustomer = cust;
    }

    /**
     * Returns the current customer. If the id of the current customer is negative, this means that
     * the customer hasn't logged in yet and that it is a temporary object used so that the customer
     * can still create basket items.
     * 
     * @return Current Customer
     */
    public CustomerIf getCurrentCustomer()
    {
        return currentCustomer;
    }

    /**
     * Register a new customer.
     * 
     * @param cr
     *            The CustomerRegistration object
     * @return Returns the id of the new customer
     * @throws KKException
     */
    public int registerCustomer(CustomerRegistrationIf cr) throws KKException
    {
        cr.setLocale(kkAppEng.getLocale());
        int customerId = eng.registerCustomer(cr);
        return customerId;
    }

    /**
     * Method used when a customer is allowed to checkout without registering..
     * 
     * @param cr
     *            The CustomerRegistration object
     * @return Returns the id of the new customer
     * @throws KKException
     */
    public int forceRegisterCustomer(CustomerRegistrationIf cr) throws KKException
    {
        cr.setLocale(kkAppEng.getLocale());
        int customerId = eng.forceRegisterCustomer(cr);
        return customerId;
    }

    /**
     * Login and if successful, set the current customer object. If before login, the customer had
     * placed items in the basket, these items are not lost once the customer logs in. The session
     * id is returned but it is also stored by the client engine so that it is used automatically by
     * the client engine when it has to communicate with the server engine.
     * 
     * @param emailAddr
     *            The user id
     * @param password
     *            The password
     * @return Return the session id
     * @throws KKException
     * @throws KKAppException
     */
    public String login(String emailAddr, String password) throws KKException, KKAppException
    {
        /*
         * We only keep the affiliate id for the first login. If the customer logs in again or a new
         * customer logs in to the same engine we don't use the affiliate id.
         */
        if (this.kkAppEng.getSessionId() != null)
        {
            // Set affiliate id to null
            kkAppEng.setAffiliateId(null);
        }

        try
        {
            this.kkAppEng.setSessionId(eng.login(emailAddr, password));
        } catch (KKException e)
        {
            if (e.getCode() == KKException.KK_STORE_DELETED
                    || e.getCode() == KKException.KK_STORE_DISABLED
                    || e.getCode() == KKException.KK_STORE_UNDER_MAINTENANCE)
            {
                throw e;
            }
            log.debug(e.getMessage());
            return null;
        }

        afterLogin(/* clearAffiliateId */false);

        return this.kkAppEng.getSessionId();
    }

    /**
     * Login for the customer identified by customerId and if successful, set the current customer
     * object. The session id is returned but it is also stored by the client engine so that it is
     * used automatically by the client engine when it has to communicate with the server engine.
     * The adminSession must be a valid session belonging to an administrator.
     * 
     * @param adminSession
     *            Valid session belonging to an administrator
     * @param customerId
     *            Id of the customer being logged in
     * @return The session id
     * @throws KKException
     * @throws KKAppException
     */
    public String loginByAdmin(String adminSession, int customerId) throws KKException,
            KKAppException
    {
        try
        {
            this.kkAppEng.setSessionId(eng.loginByAdmin(adminSession, customerId));
        } catch (KKException e)
        {
            log.debug(e.getMessage());
            logout();
            return null;
        }

        afterLogin(/* clearAffiliateId */true);

        return this.kkAppEng.getSessionId();
    }

    /**
     * This method is used to enter the store-front application using the session of a logged in
     * user.
     * 
     * @param sessionId
     * @throws KKException
     * @throws KKAppException
     */
    public void loginBySession(String sessionId) throws KKException, KKAppException
    {
        this.kkAppEng.setSessionId(sessionId);

        afterLogin(/* clearAffiliateId */true);
    }

    /**
     * Private method to do some housekeeping after a successful login.
     * 
     * @param clearAffiliateId
     * 
     * @throws KKException
     * @throws KKAppException
     */
    private void afterLogin(boolean clearAffiliateId) throws KKException, KKAppException
    {
        if (this.kkAppEng.getSessionId() != null)
        {
            // Set Admin User to null
            kkAppEng.setAdminUser(null);

            // Set the punch out object to null
            kkAppEng.setPunchoutDetails(null);

            // Clear the Affiliate Id
            if (clearAffiliateId)
            {
                kkAppEng.setAffiliateId(null);
            }

            CustomerIf guest = null;
            // Save the current guest id
            if (currentCustomer != null)
            {
                guest = new Customer();
                guest.setId(currentCustomer.getId());
            }

            // Get a customer object from the login process
            currentCustomer = eng.getCustomer(this.kkAppEng.getSessionId());

            // Ensure that the customer's locale is set. If the customer was created through the
            // admin app, it will not be set.
            if (currentCustomer != null)
            {
                if (currentCustomer.getLocale() == null
                        || (currentCustomer.getLocale() != null && !currentCustomer.getLocale()
                                .equals(this.kkAppEng.getLocale())))
                {
                    editCustomerLocale(kkAppEng.getLocale());
                }
            }

            // Add any items from the guest basket to the permanent basket only if the guest id is <
            // 0. If we do a login when we are already logged in, the guest would be a real customer
            // and we would double the quantity of the basket
            if (guest != null && guest.getId() < 0)
            {
                eng.mergeBasketsWithOptions(this.kkAppEng.getSessionId(), guest.getId(),
                        this.kkAppEng.getBasketMgr().getAddToBasketOptions());
                eng.removeBasketItemsPerCustomer(null, guest.getId());

                String tagsEnabled = kkAppEng.getConfig(ConfigConstants.ENABLE_CUSTOMER_CART_TAGS);
                if (tagsEnabled != null && tagsEnabled.equalsIgnoreCase("true"))
                {
                    CustomerTag ct = new CustomerTag();
                    ct.setName(BaseAction.TAG_CART_TOTAL);
                    ct.setValue("0");
                    eng.insertCustomerTagForGuest(guest.getId(), ct);

                    ct.setName(BaseAction.TAG_PRODUCTS_IN_CART);
                    ct.setValue("");
                    eng.insertCustomerTagForGuest(guest.getId(), ct);
                }

                if (kkAppEng.getWishListMgr().allowWishListWhenNotLoggedIn())
                {
                    eng.mergeWishListsWithOptions(this.kkAppEng.getSessionId(), guest.getId(),
                            kkAppEng.getLangId(), kkAppEng.getWishListMgr()
                                    .getAddToWishListOptions());

                    // Now delete the wish lists of the temporary customer
                    CustomerSearchIf search = new CustomerSearch();
                    search.setTmpId(guest.getId());
                    WishListsIf wishLists = eng.searchForWishLists(null, null, search);
                    if (wishLists != null && wishLists.getWishListArray() != null)
                    {
                        AddToWishListOptions opts = new AddToWishListOptions();
                        opts.setCustomerId(guest.getId());
                        for (int i = 0; i < wishLists.getWishListArray().length; i++)
                        {
                            WishListIf wl = wishLists.getWishListArray()[i];
                            eng.deleteWishListWithOptions(null, wl.getId(), opts);
                        }
                    }
                }
            }

            // Refresh the data relevant to the customer such as his basket and recent orders
            refreshCustomerCachedData();
            
            // Populate the customer's addresses
            if (currentCustomer != null)
            {
                populateCurrentCustomerAddresses(/*force*/false);
            }

            // Call the callout class method where custom code can be placed
            new KKAppEngCallouts().afterLogin(getKkAppEng());
        }
    }

    /**
     * Normally called after a login to get and cache customer relevant data such as the customer's
     * basket, the customer's orders and the customer's order history. If this method isn't called,
     * then the UI will not show updated data.
     * 
     * @throws KKException
     * @throws KKAppException
     */
    public void refreshCustomerCachedData() throws KKException, KKAppException
    {
        // Get the customer's basket from the DB
        this.kkAppEng.getBasketMgr().getBasketItemsPerCustomer();

        // Populate the customer's orders array with the last three orders he made
        this.kkAppEng.getOrderMgr().populateCustomerOrders();

        // Get the digital downloads for this customer
        this.kkAppEng.getProductMgr().fetchDigitalDownloads();

        // Get wish lists for this customer
        String wishListEnabled = kkAppEng.getConfig(ConfigConstants.ENABLE_WISHLIST);
        if (wishListEnabled != null && wishListEnabled.equalsIgnoreCase("TRUE"))
        {
            this.kkAppEng.getWishListMgr().fetchCustomersWishLists();
        }

        // Remove various cached values
        this.kkAppEng.getOrderMgr().setCouponCode(null);
        this.kkAppEng.getOrderMgr().setGiftCertCode(null);
        this.kkAppEng.getOrderMgr().setRewardPoints(0);
    }

    /**
     * Log-off and reset some variables. A guest customer is created and becomes the current
     * customer.
     * 
     * @throws KKException
     */
    public void logout() throws KKException
    {
        this.kkAppEng.logout();

        // Remove various cached values
        this.kkAppEng.getOrderMgr().setCouponCode(null);
        this.kkAppEng.getOrderMgr().setGiftCertCode(null);
        this.kkAppEng.getOrderMgr().setRewardPoints(0);

        createGuest();

        // Set Admin User to null
        kkAppEng.setAdminUser(null);

        // Set affiliate id to null
        kkAppEng.setAffiliateId(null);
    }

    /**
     * Calls the engine to change the current password with the new one.
     * 
     * @param currentPassword
     *            The current password
     * @param newPassword
     *            The new password
     * @throws KKException
     */
    public void changePassword(String currentPassword, String newPassword) throws KKException
    {
        eng.changePassword(kkAppEng.getSessionId(), currentPassword, newPassword);
    }

    /**
     * Calls the engine to send a new password to the user.
     * 
     * @param emailAddr
     *            The email address where the new password will be sent
     * @throws KKException
     */
    public void sendNewPassword(String emailAddr) throws KKException
    {
        EmailOptionsIf options = new EmailOptions();
        options.setCountryCode(kkAppEng.getLocale().substring(0, 2));
        options.setTemplateName(com.konakart.bl.EmailMgr.NEW_PASSWORD_TEMPLATE);
        eng.sendNewPassword1(emailAddr, options);
    }

    /**
     * @return the selectedCountry
     */
    public CountryIf getSelectedCountry()
    {
        return selectedCountry;
    }

    /**
     * This also sets the selected zones if the country has an array of zones.
     * 
     * @param selectedCountry
     *            the selectedCountry to set
     * @throws KKException
     */
    public void setSelectedCountry(CountryIf selectedCountry) throws KKException
    {
        if (selectedCountry != null
                && (this.selectedCountry == null || this.selectedCountry.getId() != selectedCountry
                        .getId()))
        {
            // Get a new list of selected zones
            this.selectedZones = eng.getZonesPerCountry(selectedCountry.getId());
        } else if (selectedCountry == null)
        {
            this.selectedZones = null;
        }
        this.selectedCountry = selectedCountry;
    }

    /**
     * Sets the selected country from its id. This also sets the selected zones if the country has
     * an array of zones.
     * 
     * @param countryId
     * @throws KKException
     */
    public void setSelectedCountry(int countryId) throws KKException
    {
        CountryIf country = eng.getCountry(countryId);
        setSelectedCountry(country);
    }

    /**
     * @return the selectedZones
     */
    public ZoneIf[] getSelectedZones()
    {
        return selectedZones;
    }

    /**
     * @param selectedZones
     *            the selectedZones to set
     */
    public void setSelectedZones(ZoneIf[] selectedZones)
    {
        this.selectedZones = selectedZones;
    }

}
