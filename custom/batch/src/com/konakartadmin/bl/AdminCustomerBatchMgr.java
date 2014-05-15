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
package com.konakartadmin.bl;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.torque.util.BasePeer;
import org.apache.torque.util.Criteria;

import com.konakart.bl.KKCriteria;
import com.konakart.bl.RewardPointCore;
import com.konakart.om.BaseCustomersBasketAttributesPeer;
import com.konakart.om.BaseCustomersBasketPeer;
import com.konakart.om.BaseCustomersInfoPeer;
import com.konakart.om.BaseCustomersPeer;
import com.konakart.om.BaseKkCookiePeer;
import com.konakart.om.BaseKkCustomersToTagPeer;
import com.konakart.om.BaseKkRewardPointsPeer;
import com.konakart.om.BaseKkWishlistItemPeer;
import com.konakart.om.BaseKkWishlistPeer;
import com.konakart.om.BaseSessionsPeer;
import com.konakartadmin.app.AdminCustomer;
import com.konakartadmin.app.AdminOrder;
import com.konakartadmin.appif.KKAdminIf;
import com.konakartadmin.blif.AdminCustomerMgrIf;
import com.workingdogs.village.Record;

/**
 * The CustomerBatchMgr
 */
public class AdminCustomerBatchMgr extends AdminBatchBaseMgr
{

    /**
     * @param eng
     * @throws Exception
     */
    public AdminCustomerBatchMgr(KKAdminIf eng) throws Exception
    {
        super.init(eng);
    }

    /**
     * Each existing customer is read from the database in a loop, and for each customer object we
     * detect whether it has one or more expired session records and no non expired record. If this
     * is the case, the customer and the session records are deleted. If no session records exist,
     * then the creation time of the customer is read and the customer is deleted if it has existed
     * for a few seconds, in order to avoid deleting customers that are in the process of being
     * created and registered.
     * 
     * This batch is used for the case where KonaKart mustn't store customer information so this
     * information is stored only temporarily to allow a customer to place an order and then is
     * deleted.
     * 
     * @param logName
     *            The name of the log which shouldn't include the path or extension. i.e. It should
     *            be myLog rather than /logs/myLog.txt.
     * @param appendLogStr
     *            If set to false, a new log will be created every time the batch job is run.
     *            Otherwise new data will be appended to the existing log. It defaults to false.
     * @param recordFetchSizeStr
     *            It the batch involves reading many records in a loop, this determines the maximum
     *            number read in any one loop. It defaults to 100.
     * @param permanentCustTypesStr
     *            An array of customer types that won't be deleted. They are in a format "3-6-8"
     *            where "-" is a delimiter between the integers.
     * @return Returns the number of customers removed
     * @throws Exception
     */
    public String removeExpiredCustomersBatch(String logName, String appendLogStr,
            String recordFetchSizeStr, String permanentCustTypesStr) throws Exception
    {
        // Attributes to configure the batch job
        int recordFetchSize = getInt(recordFetchSizeStr, 100, true);
        boolean appendLog = getBoolean(appendLogStr, true, true);
        int[] permanentCustTypes = getIntArray(permanentCustTypesStr);

        // Create the full log name
        String fullLogName = getBatchLogName(logName, appendLog);

        BufferedWriter bw = null;
        try
        {
            if (fullLogName != null)
            {
                File logFile = new File(fullLogName);
                bw = new BufferedWriter(new FileWriter(logFile, appendLog));
                if (appendLog)
                {
                    bw.newLine();
                    bw.write(timestampStr() + " removeExpiredCustomersBatch starting");
                    bw.newLine();
                }
            }
            // Get the customer mgr
            AdminCustomerMgrIf custMgr = getAdminCustMgr();

            /*
             * Get customers in a loop. For each customer figure out whether it has an expired
             * session and if so, delete it. If it has no session, then see when the account was
             * created, in order to figure out whether to delete it.
             */
            KKCriteria c = getCustomerCriteria(recordFetchSize, permanentCustTypes);
            int lastCustIdRead = 0;
            int customersDeleted = 0;
            CustRetList crl = getCustomers(c, lastCustIdRead);
            List<AdminCustomer> custList = crl.getCustList();
            lastCustIdRead = crl.getCustId();

            KKCriteria sessionCrit = getSessionCriteria();
            KKCriteria sessionDelCrit = getNewCriteria(/* AllStores */true);
            while (custList != null)
            {
                for (Iterator<AdminCustomer> iterator = custList.iterator(); iterator.hasNext();)
                {
                    AdminCustomer cust = iterator.next();
                    int deleted = deleteCustomer(cust, sessionCrit, sessionDelCrit, custMgr);
                    customersDeleted += deleted;
                    if (bw != null)
                    {
                        if (deleted == 1)
                        {
                            bw.write(timestampStr() + " Deleted Customer " + cust.getEmailAddr()
                                    + " (Id " + cust.getId() + ")");
                            bw.newLine();
                        }
                    }
                }
                crl = getCustomers(c, lastCustIdRead);
                custList = crl.getCustList();
                lastCustIdRead = crl.getCustId();
            }

            if (bw != null)
            {
                bw.write(timestampStr() + " Deleted " + customersDeleted + " customers");
                bw.newLine();
            }

            return Integer.toString(customersDeleted);
        } catch (Exception e)
        {
            throw e;
        } finally
        {
            if (bw != null)
            {
                bw.flush();
                bw.close();
            }
        }
    }

    protected int deleteCustomer(AdminCustomer cust, KKCriteria sessionCrit,
            KKCriteria sessionDelCrit, AdminCustomerMgrIf custMgr) throws Exception
    {
        int ret = 0;

        sessionCrit.add(BaseSessionsPeer.CUSTOMER_ID, cust.getId());

        List<Record> rows = BasePeer.doSelect(sessionCrit);
        if (rows != null && rows.size() > 0 && rows.get(0) != null)
        {
            int expiryInSecs = rows.get(0).getValue(1).asInt();
            if (hasSessionExpired(expiryInSecs))
            {
                custMgr.deleteCustomer(cust.getId());
                ret = 1;

                // Delete session objects for customer
                for (Iterator<Record> iterator = rows.iterator(); iterator.hasNext();)
                {
                    Record record = iterator.next();
                    sessionDelCrit.clear();
                    sessionDelCrit.add(BaseSessionsPeer.SESSKEY, record.getValue(2).asString());
                    BasePeer.doKKDelete(sessionDelCrit, BaseSessionsPeer.TABLE_NAME);
                }
            }
        } else
        {
            /*
             * If there are no session objects for the customer we determine how long ago the
             * customer was created to decide whether to delete him
             */
            int expiryMillis = 30 * 1000;
            if (cust.getAccountCreated() != null)
            {
                long existanceInMillis = System.currentTimeMillis()
                        - cust.getAccountCreated().getTime();
                if (existanceInMillis > expiryMillis)
                {
                    custMgr.deleteCustomer(cust.getId());
                    ret = 1;
                }
            }
        }

        return ret;
    }

    protected boolean hasSessionExpired(int expiryInSecs)
    {
        int currentTime = (int) (System.currentTimeMillis() / 1000);

        if (currentTime > expiryInSecs)
        {
            return true;
        }
        return false;
    }

    /**
     * The method returns a null list within the return object when all of the customers have been
     * read. The caller can stop looping when he receives null.
     * 
     * @param c
     * @return Returns a list of AdminCustomers and the last customer Id
     * @throws Exception
     */
    protected CustRetList getCustomers(KKCriteria c, int custId) throws Exception
    {
        CustRetList custRetList = new CustRetList();

        // Add offset
        c.add(BaseCustomersPeer.CUSTOMERS_ID, custId, Criteria.GREATER_THAN);

        // Get the customers
        List<Record> rows = BasePeer.doSelect(c);
        if (rows.size() == 0)
        {
            return custRetList;
        }

        List<AdminCustomer> retList = new ArrayList<AdminCustomer>();
        AdminCustomer cust = null;
        for (Iterator<Record> iterator = rows.iterator(); iterator.hasNext();)
        {
            Record row = iterator.next();
            cust = new AdminCustomer(row, c);
            retList.add(cust);
        }
        if (cust != null)
        {
            custRetList.setCustId(cust.getId());
        }
        custRetList.setCustList(retList);

        return custRetList;
    }

    /**
     * Get the criteria object to search for a customer's session
     * 
     * @return Returns a criteria object
     */
    protected KKCriteria getSessionCriteria()
    {
        KKCriteria c = getNewCriteria(/* AllStores */true);

        c.addSelectColumn(BaseSessionsPeer.EXPIRY);
        c.addSelectColumn(BaseSessionsPeer.SESSKEY);

        // Add order by to get the last session created first
        c.addDescendingOrderByColumn(BaseSessionsPeer.EXPIRY);

        return c;
    }

    /**
     * Get the criteria object to search for customers
     * 
     * @param size
     * @param permanentCustTypes
     * @return Returns a criteria object
     */
    protected KKCriteria getCustomerCriteria(int size, int[] permanentCustTypes)
    {
        KKCriteria c = getNewCriteria(/* AllStores */true);

        c.addSelectColumn(BaseCustomersPeer.CUSTOMERS_ID);
        c.addSelectColumn(BaseCustomersPeer.CUSTOMERS_TYPE);
        c.addSelectColumn(BaseCustomersPeer.CUSTOMERS_EMAIL_ADDRESS);
        c.addJoin(BaseCustomersPeer.CUSTOMERS_ID, BaseCustomersInfoPeer.CUSTOMERS_INFO_ID);
        c.addSelectColumn(BaseCustomersInfoPeer.CUSTOMERS_INFO_DATE_ACCOUNT_CREATED);

        // Add criteria
        if (permanentCustTypes != null && permanentCustTypes.length > 0)
        {
            for (int i = 0; i < permanentCustTypes.length; i++)
            {
                int j = permanentCustTypes[i];
                Criteria.Criterion state = c.getNewCriterion(BaseCustomersPeer.CUSTOMERS_TYPE, j,
                        Criteria.NOT_EQUAL);
                if (i == 0)
                {
                    c.add(state);
                } else
                {
                    c.and(state);
                }
            }
        }

        // Add order by
        c.addAscendingOrderByColumn(BaseCustomersPeer.CUSTOMERS_ID);

        // Set limit
        c.setLimit(size);

        return c;
    }

    /**
     * A return object containing a list of Customers and the last customer Id processed
     * 
     */
    protected class CustRetList
    {
        int custId;

        List<AdminCustomer> custList;

        /**
         * @return the custId
         */
        public int getCustId()
        {
            return custId;
        }

        /**
         * @param custId
         *            the custId to set
         */
        public void setCustId(int custId)
        {
            this.custId = custId;
        }

        /**
         * @return the custList
         */
        public List<AdminCustomer> getCustList()
        {
            return custList;
        }

        /**
         * @param custList
         *            the custList to set
         */
        public void setCustList(List<AdminCustomer> custList)
        {
            this.custList = custList;
        }

    }

    /**
     * This batch is used to expire reward points after a certain time limit, which is entered as a
     * number of days in the <code>numDays</code> parameter. The expired attribute of each expired
     * reward points record is set to non zero by the batch.
     * 
     * @param logName
     *            The name of the log which shouldn't include the path or extension. i.e. It should
     *            be myLog rather than /logs/myLog.txt.
     * @param appendLogStr
     *            If set to false, a new log will be created every time the batch job is run.
     *            Otherwise new data will be appended to the existing log. It defaults to false.
     * @param numDaysStr
     *            If current time - numDays is greater than the date when the reward point
     *            transaction was added, then the points added in that transaction are expired.
     * @throws Exception
     */
    public void expiredRewardPointBatch(String logName, String appendLogStr, String numDaysStr)
            throws Exception
    {
        // Attributes to configure the batch job
        boolean appendLog = getBoolean(appendLogStr, true, true);
        int numDays = getInt(numDaysStr, 0, false);

        // Create the full log name
        String fullLogName = getBatchLogName(logName, appendLog);

        BufferedWriter bw = null;
        try
        {
            if (fullLogName != null)
            {
                File logFile = new File(fullLogName);
                bw = new BufferedWriter(new FileWriter(logFile, appendLog));
                if (appendLog)
                {
                    bw.newLine();
                    bw.write(timestampStr() + " expiredRewardPointBatch starting");
                    bw.newLine();
                }
            }
            // Calculate the time constraint
            long daysInMillis = numDays * 24 * 60 * 60 * 1000L;
            long expiryTimeInMillis = System.currentTimeMillis() - daysInMillis;
            Date expiryDate = new Date(expiryTimeInMillis);

            KKCriteria selectC = getNewCriteria(isMultiStoreShareCustomers());
            KKCriteria updateC = getNewCriteria(isMultiStoreShareCustomers());

            selectC.add(BaseKkRewardPointsPeer.EXPIRED, 0);
            selectC.add(BaseKkRewardPointsPeer.TX_TYPE, RewardPointCore.TX_TYPE_ADD_POINTS);
            selectC.add(BaseKkRewardPointsPeer.DATE_ADDED, expiryDate, Criteria.LESS_THAN);

            updateC.addForInsert(BaseKkRewardPointsPeer.EXPIRED, 1);

            BasePeer.doUpdate(selectC, updateC);

            if (bw != null)
            {
                bw.write(timestampStr() + " expiredRewardPointBatch finished");
                bw.newLine();
            }
        } catch (Exception e)
        {
            throw e;
        } finally
        {
            if (bw != null)
            {
                bw.flush();
                bw.close();
            }
        }
    }

    /**
     * This batch is used to delete temporary data in order to keep your KonaKart store running
     * efficiently. It deletes :
     * <ul>
     * <li>Expired sessions which remain in the sessions table if a customer doesn't log off the
     * storefront application.</li>
     * <li>KonaKart cookies from the kk_cookie table. These cookie records are used to identify
     * temporary returning customers (i.e. returning customers that never registered) so that their
     * cart items can be persisted. The associated customers_basket, customers_basket_attributes,
     * kk_wishlist, kk_wishlist_item, kk_customers_to_tag records are also deleted.</li>
     * </ul>
     * 
     * @param logName
     *            The name of the log which shouldn't include the path or extension. i.e. It should
     *            be myLog rather than /logs/myLog.txt.
     * @param appendLogStr
     *            If set to false, a new log will be created every time the batch job is run.
     *            Otherwise new data will be appended to the existing log. It defaults to false.
     * @param numDaysStr
     *            kk_cookie records are deleted if current time - numDays is greater than the date
     *            when the cookie was last read or actually created (for the case when it has never
     *            been read).
     * @throws Exception
     */
    public void deleteTemporaryDataBatch(String logName, String appendLogStr, String numDaysStr)
            throws Exception
    {
        // Attributes to configure the batch job
        boolean appendLog = getBoolean(appendLogStr, true, true);
        int numDays = getInt(numDaysStr, 0, false);

        // Create the full log name
        String fullLogName = getBatchLogName(logName, appendLog);

        BufferedWriter bw = null;
        try
        {
            if (fullLogName != null)
            {
                File logFile = new File(fullLogName);
                bw = new BufferedWriter(new FileWriter(logFile, appendLog));
                if (appendLog)
                {
                    bw.newLine();
                    bw.write(timestampStr() + " deleteTemporaryDataBatch starting");
                    bw.newLine();
                }
            }

            /*
             * Delete Expired Sessions
             */
            int timeInSecs = getTimeInSecs();
            // Add a 5 sec margin to avoid race conditions
            timeInSecs = timeInSecs - 5;
            BasePeer.executeStatement("delete from sessions where expiry < " + timeInSecs);

            /*
             * Delete counter records
             */
            BasePeer.executeStatement("delete from counter");

            /*
             * Delete kk_cookie records. Loop through kk_cookie records and delete basket records as
             * well
             */
            long expiryTimeInMillis = System.currentTimeMillis()
                    - (numDays * 24L * 60L * 60L * 1000);
            Date expiryDate = new Date(expiryTimeInMillis);

            KKCriteria c = getNewCriteria(/* AllStores */true);
            c.setLimit(100);
            c.setOffset(0);
            KKCriteria d = getNewCriteria(/* AllStores */true);
            KKCriteria wlc = getNewCriteria(/* AllStores */true);

            // Define criteria
            Criteria.Criterion c1 = c.getNewCriterion(BaseKkCookiePeer.LAST_READ,
                    "LAST_READ is null", Criteria.CUSTOM);
            Criteria.Criterion c2 = c.getNewCriterion(BaseKkCookiePeer.DATE_ADDED, expiryDate,
                    Criteria.LESS_THAN);
            Criteria.Criterion c3 = c.getNewCriterion(BaseKkCookiePeer.LAST_READ, expiryDate,
                    Criteria.LESS_THAN);

            /*
             * Find all records that have never been read and were created more than numDays ago OR
             * were last read more than numDays ago.
             */
            c.add((c1.and(c2)).or(c3));

            // Only delete the GUEST_CUSTOMER_ID cookies
            Criteria.Criterion c4 = c.getNewCriterion(BaseKkCookiePeer.ATTRIBUTE_ID,
                    "GUEST_CUSTOMER_ID", Criteria.EQUAL);
            c.add(c4);

            // Return the temporary customer id and uuid
            c.addSelectColumn(BaseKkCookiePeer.ATTRIBUTE_VALUE);
            c.addSelectColumn(BaseKkCookiePeer.CUSTOMER_UUID);

            int custId;
            List<Record> rows = BasePeer.doSelect(c);
            while (rows.size() > 0)
            {
                for (Iterator<Record> iterator = rows.iterator(); iterator.hasNext();)
                {
                    Record rec = iterator.next();
                    String custIdStr = rec.getValue(1).asString();
                    try
                    {
                        custId = Integer.parseInt(custIdStr);
                    } catch (Exception e)
                    {
                        // Delete the cookie record and continue. This should never run.
                        d.clear();
                        d.add(BaseKkCookiePeer.CUSTOMER_UUID, rec.getValue(2).asString());
                        BasePeer.doKKDelete(d, BaseKkCookiePeer.TABLE_NAME);
                        continue;
                    }

                    // Delete cookie record
                    d.clear();
                    d.add(BaseKkCookiePeer.CUSTOMER_UUID, rec.getValue(2).asString());
                    BasePeer.doKKDelete(d, BaseKkCookiePeer.TABLE_NAME);

                    // Delete basket records
                    d.clear();
                    d.add(BaseCustomersBasketPeer.CUSTOMERS_ID, custId);
                    BasePeer.doKKDelete(d, BaseCustomersBasketPeer.TABLE_NAME);

                    // Delete basket_attributes records
                    d.clear();
                    d.add(BaseCustomersBasketAttributesPeer.CUSTOMERS_ID, custId);
                    BasePeer.doKKDelete(d, BaseCustomersBasketAttributesPeer.TABLE_NAME);

                    // Delete customer_tag records
                    d.clear();
                    d.add(BaseKkCustomersToTagPeer.CUSTOMERS_ID, custId);
                    BasePeer.doKKDelete(d, BaseKkCustomersToTagPeer.TABLE_NAME);

                    // Get wish lists and delete them
                    wlc.clear();
                    wlc.addSelectColumn(BaseKkWishlistPeer.KK_WISHLIST_ID);
                    wlc.add(BaseKkWishlistPeer.CUSTOMERS_ID, custId);
                    List<Record> rows1 = BasePeer.doSelect(wlc);
                    for (Iterator<Record> iterator2 = rows1.iterator(); iterator2.hasNext();)
                    {
                        Record wlRec = iterator2.next();
                        int wlId = wlRec.getValue(1).asInt();

                        // Delete wish list
                        d.clear();
                        d.add(BaseKkWishlistPeer.KK_WISHLIST_ID, wlId);
                        BasePeer.doKKDelete(d, BaseKkWishlistPeer.TABLE_NAME);

                        // Delete wish list items
                        d.clear();
                        d.add(BaseKkWishlistItemPeer.KK_WISHLIST_ID, wlId);
                        BasePeer.doKKDelete(d, BaseKkWishlistItemPeer.TABLE_NAME);
                    }

                }
                rows = BasePeer.doSelect(c);
            }

            if (bw != null)
            {
                bw.write(timestampStr() + " deleteTemporaryDataBatch finished");
                bw.newLine();
            }
        } catch (Exception e)
        {
            throw e;
        } finally
        {
            if (bw != null)
            {
                bw.flush();
                bw.close();
            }
        }
    }

    /**
     * Utility method to return the current time in seconds
     * 
     * @return Returns the time
     */
    public int getTimeInSecs()
    {
        int timeInSecs = (int) (System.currentTimeMillis() / 1000);
        return timeInSecs;
    }

    /**
     * The method returns null when all of the orders have been read. The caller can stop looping
     * when he receives null.
     * 
     * @param c
     * @return Returns a list of AdminOrders
     * @throws Exception
     */
    protected List<AdminOrder> getUnpaidOrders(KKCriteria c) throws Exception
    {
        // Get the orders
        List<Record> rows = BasePeer.doSelect(c);
        if (rows.size() == 0)
        {
            return null;
        }

        List<AdminOrder> retList = new ArrayList<AdminOrder>();
        AdminOrder o = null;
        for (Iterator<Record> iterator = rows.iterator(); iterator.hasNext();)
        {
            Record row = iterator.next();
            o = new AdminOrder(row, c);
            retList.add(o);
        }

        return retList;
    }

    /**
     * This batch is a simple example that can be used to demonstrate how the ExecuteMultiStoreBatch
     * class can be used to execute batch jobs for each store.
     * <p>
     * It simply counts the number of customers in the store and writes out this number.
     * 
     * @param logName
     *            The name of the log which shouldn't include the path or extension. i.e. It should
     *            be myLog rather than /logs/myLog.txt.
     * @param appendLogStr
     *            If set to false, a new log will be created every time the batch job is run.
     *            Otherwise new data will be appended to the existing log. It defaults to false.
     * @throws Exception
     */
    public void countCustomersBatch(String logName, String appendLogStr) throws Exception
    {
        // Attributes to configure the batch job
        boolean appendLog = getBoolean(appendLogStr, true, true);

        // Create the full log name
        String fullLogName = getBatchLogName(logName, appendLog);

        BufferedWriter bw = null;
        try
        {
            if (fullLogName != null)
            {
                File logFile = new File(fullLogName);
                bw = new BufferedWriter(new FileWriter(logFile, appendLog));
            }

            /*
             * Count the customers
             */
            int custCount = getAdminCustMgr().getCustomersCount(null);

            if (bw != null)
            {
                bw.write(timestampStr() + " countCustomersBatch : " + custCount
                        + " customers found in " + getStoreId());
                bw.newLine();
            }

            // This sleep can be removed ... it's used to check the status of executing jobs
            Thread.sleep(15000);

        } catch (Exception e)
        {
            throw e;
        } finally
        {
            if (bw != null)
            {
                bw.flush();
                bw.close();
            }
        }
    }
}