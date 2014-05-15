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
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.apache.torque.TorqueException;
import org.apache.torque.util.BasePeer;
import org.apache.torque.util.Criteria;

import com.konakart.app.PdfOptions;
import com.konakart.app.PdfResult;
import com.konakart.bl.KKCriteria;
import com.konakart.bl.OrderMgr;
import com.konakart.om.BaseOrdersPeer;
import com.konakart.om.BaseOrdersProductsPeer;
import com.konakart.util.KKConstants;
import com.konakartadmin.app.AdminCustomer;
import com.konakartadmin.app.AdminOrder;
import com.konakartadmin.app.AdminOrderProduct;
import com.konakartadmin.app.AdminPaymentSchedule;
import com.konakartadmin.app.AdminSubscription;
import com.konakartadmin.app.AdminSubscriptionSearch;
import com.konakartadmin.app.AdminSubscriptionSearchResult;
import com.konakartadmin.appif.KKAdminIf;
import com.konakartadmin.blif.AdminBillingMgrIf;
import com.konakartadmin.blif.AdminCustomerMgrIf;
import com.konakartadmin.blif.AdminLanguageMgrIf;
import com.konakartadmin.blif.AdminOrderMgrIf;
import com.konakartadmin.blif.AdminPdfMgrIf;
import com.konakartadmin.blif.AdminProductMgrIf;
import com.workingdogs.village.Record;

/**
 * The OrderBatchMgr
 */
public class AdminOrderBatchMgr extends AdminBatchBaseMgr
{
    /**
     * @param eng
     * @throws Exception
     */
    public AdminOrderBatchMgr(KKAdminIf eng) throws Exception
    {
        super.init(eng);
    }

    /**
     * An email is sent to all customers when a number of days has passed since they submitted their
     * order and the order is not in one of the valid order states. When the eMail has been sent,
     * the order is set to a new state. If a customer has more than one unpaid order, only one mail
     * is sent for all orders.
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
     * @param emailTemplateName
     *            The name of the eMail template if the batch involves sending eMails to customers.
     *            The name should not include the extension or the underscore+country code. i.e. It
     *            should be myTemplate rather than myTemplate_en.vm. The country code and file
     *            extension will be added automatically.
     * @param numEmailThreadsStr
     *            If the batch involves sending eMails to customers, this determines how many eMail
     *            sender threads are used. It defaults to 5.
     * @param numDaysStr
     *            The number of days that needs to have passed before a mail is sent
     * @param validOrderStatesStr
     *            An array of integers that determine valid order states. If the order is in a valid
     *            state then a mail is not sent. They are in a format "1-4-7" where "-" is the
     *            delimiter.
     * @param newStateStr
     *            The state that the order should be set to once a mail has been sent.
     * @return Returns the number of mails sent
     * 
     * @throws Exception
     */
    public String unpaidOrderNotificationBatch(String logName, String appendLogStr,
            String recordFetchSizeStr, String emailTemplateName, String numEmailThreadsStr,
            String numDaysStr, String validOrderStatesStr, String newStateStr) throws Exception
    {
        checkRequired(emailTemplateName, "String", "EmailTemplateName");
        validateTemplate(emailTemplateName);

        // Attributes to configure the batch job
        int recordFetchSize = getInt(recordFetchSizeStr, 100, true);
        boolean appendLog = getBoolean(appendLogStr, true, true);
        int numEmailThreads = getInt(numEmailThreadsStr, 5, true);
        int numDays = getInt(numDaysStr, 0, false);
        int[] validOrderStates = getIntArray(validOrderStatesStr);
        int newState = getInt(newStateStr, 0, false);

        // Create the full log name
        String fullLogName = getBatchLogName(logName, appendLog);

        // Begin sending the mails
        ExecutorService executor = null;
        BufferedWriter bw = null;
        int numMailsSent = 0;
        try
        {
            if (fullLogName != null)
            {
                File logFile = new File(fullLogName);
                bw = new BufferedWriter(new FileWriter(logFile, appendLog));
                if (appendLog)
                {
                    bw.newLine();
                    bw.write(timestampStr() + " unpaidOrderNotificationBatch starting");
                    bw.newLine();
                }
            }
            /*
             * Create an executor which is an object with a fixed number of threads to send the
             * emails
             */
            executor = Executors.newFixedThreadPool(numEmailThreads);

            // Get the criteria for the database queries
            KKCriteria c = getUnpaidOrderCriteria(recordFetchSize, numDays, validOrderStates);
            KKCriteria selectCrit = getNewCriteria(/* AllStores */true);
            KKCriteria updateCrit = getNewCriteria(/* AllStores */true);

            // Get these here to save unnecessary method calls
            AdminOrderMgrIf orderMgr = getAdminOrderMgr();
            AdminCustomerMgrIf custMgr = getAdminCustMgr();

            /*
             * A customer may have more than one order but we only want to send one eMail so we
             * group them
             */
            List<AdminOrder> orderList = getUnpaidOrders(c);
            while (orderList != null)
            {
                int currentCustId = -1;
                List<AdminOrder> ordersForCustomer = new ArrayList<AdminOrder>();
                for (Iterator<AdminOrder> iterator = orderList.iterator(); iterator.hasNext();)
                {
                    AdminOrder order = iterator.next();

                    /*
                     * Send a mail for the orders in the list if the order's customer is different
                     * to the current customer. Once the mail has been sent, add the new order to
                     * the list.Otherwise just add it to the list.
                     */
                    if (order.getCustomerId() == currentCustId)
                    {
                        ordersForCustomer.add(order);
                    } else
                    {
                        if (ordersForCustomer.size() > 0)
                        {
                            sendUnpaidOrderEmail(bw, orderMgr, custMgr,
                                    getOrderArrayFromList(ordersForCustomer), selectCrit,
                                    updateCrit, emailTemplateName, executor, newState);
                            ordersForCustomer.clear();
                            numMailsSent++;
                        }
                        ordersForCustomer.add(order);
                    }

                    // We are dealing with the last record in the list
                    if (!iterator.hasNext())
                    {
                        /*
                         * Send a mail for the orders in the list if the order's customer is equal
                         * to the current customer and we have reached the bottom of the list
                         */
                        if (ordersForCustomer.size() > 0 && order.getCustomerId() == currentCustId)
                        {
                            sendUnpaidOrderEmail(bw, orderMgr, custMgr,
                                    getOrderArrayFromList(ordersForCustomer), selectCrit,
                                    updateCrit, emailTemplateName, executor, newState);
                            ordersForCustomer.clear();
                            numMailsSent++;
                        }

                        /*
                         * Send a mail for the current order since this would have been sent the
                         * next time around the loop.
                         */
                        if (order.getCustomerId() != currentCustId)
                        {
                            sendUnpaidOrderEmail(bw, orderMgr, custMgr, new AdminOrder[]
                            { order }, selectCrit, updateCrit, emailTemplateName, executor,
                                    newState);
                            ordersForCustomer.clear();
                            numMailsSent++;
                        }
                    }

                    // Set the control variables
                    currentCustId = order.getCustomerId();
                }

                orderList = getUnpaidOrders(c);
            }

            if (bw != null)
            {
                bw.write(timestampStr() + " unpaidOrderNotificationBatch sent " + numMailsSent
                        + " emails");
                bw.newLine();
            }

            return Integer.toString(numMailsSent);
        } catch (Exception e)
        {
            throw e;
        } finally
        {
            shutdownGracefully(executor, bw);
        }
    }

    /**
     * The method detects orders that haven't been fully delivered because one or more products were
     * out of stock when the order was placed. It detects the products that were out of stock and
     * that didn't have an Available Date set when they were ordered. If the available date is now
     * available, an eMail is sent to the customer (one eMail even for multiple products) and the
     * state of the OrderProduct object is changed so that the eMail is not sent again next time the
     * method is run.
     * <ul>
     * <li>Loop through all of the OrderProducts that have a certain state and group them by order.</li>
     * <li>For each OrderProduct in an order figure out if the product has a new delivery date.</li>
     * <li>For all of the order products in the order with new delivery dates, get an array of
     * products and send the email and log the event. Only send one mail per customer.</li>
     * <li>Once the eMail has been sent, change the state of the OrderProduct</li>
     * </ul>
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
     * @param emailTemplateName
     *            The name of the eMail template if the batch involves sending eMails to customers.
     *            The name should not include the extension or the underscore+country code. i.e. It
     *            should be myTemplate rather than myTemplate_en.vm. The country code and file
     *            extension will be added automatically.
     * @param numEmailThreadsStr
     *            If the batch involves sending eMails to customers, this determines how many eMail
     *            sender threads are used. It defaults to 5.
     * @return Returns the number of eMails sent
     * 
     * @throws Exception
     */
    public String productAvailabilityNotificationBatch(String logName, String appendLogStr,
            String recordFetchSizeStr, String emailTemplateName, String numEmailThreadsStr)
            throws Exception
    {
        checkRequired(emailTemplateName, "String", "EmailTemplateName");
        validateTemplate(emailTemplateName);

        // Attributes to configure the batch job
        int recordFetchSize = getInt(recordFetchSizeStr, 100, true);
        boolean appendLog = getBoolean(appendLogStr, true, true);
        int numEmailThreads = getInt(numEmailThreadsStr, 5, true);

        // Create the full log name
        String fullLogName = getBatchLogName(logName, appendLog);

        // Begin sending the mails
        ExecutorService executor = null;
        BufferedWriter bw = null;
        HashMap<String, OrderProdStatus> skuHM = new HashMap<String, OrderProdStatus>();
        HashMap<Integer, OrderProdStatus> idHM = new HashMap<Integer, OrderProdStatus>();
        int numMailsSent = 0;
        try
        {
            if (fullLogName != null)
            {
                File logFile = new File(fullLogName);
                bw = new BufferedWriter(new FileWriter(logFile, appendLog));
                if (appendLog)
                {
                    bw.newLine();
                    bw.write(timestampStr() + " productAvailabilityNotificationBatch starting");
                    bw.newLine();
                }
            }

            /*
             * Create an executor which is an object with a fixed number of threads to send the
             * emails
             */
            executor = Executors.newFixedThreadPool(numEmailThreads);

            // Get the criteria for the database queries
            KKCriteria c = getOrderProductCriteria(recordFetchSize);
            KKCriteria selectCrit = getNewCriteria();
            KKCriteria updateCrit = getNewCriteria();

            // Get these here to save unnecessary method calls
            AdminOrderMgrIf orderMgr = getAdminOrderMgr();
            AdminCustomerMgrIf custMgr = getAdminCustMgr();

            /*
             * There may be many order products so we fetch them from the database in a loop
             */
            int searchFromOrderId = 0;
            OrderProdList opListRet = getOrderProducts(c, searchFromOrderId, skuHM, idHM);
            List<AdminOrderProduct> opList = opListRet.getOrderProdList();
            searchFromOrderId = opListRet.getOrderId();
            while (opList != null)
            {
                int currentOrderId = -1;
                List<AdminOrderProduct> opForOrderList = new ArrayList<AdminOrderProduct>();
                for (Iterator<AdminOrderProduct> iterator = opList.iterator(); iterator.hasNext();)
                {
                    AdminOrderProduct op = iterator.next();

                    /*
                     * Send a mail for the order products in the list if the current order product
                     * belongs to a different order. Otherwise we just add it to the list. Once
                     * we've sent the mail, we add the current order product to the list.
                     */
                    if (op.getOrderId() == currentOrderId)
                    {
                        opForOrderList.add(op);
                    } else
                    {
                        if (opForOrderList.size() > 0)
                        {
                            sendProductAvailabilityEmail(bw, orderMgr, custMgr,
                                    getOrderProdArrayFromList(opForOrderList), selectCrit,
                                    updateCrit, emailTemplateName, executor);
                            opForOrderList.clear();
                            numMailsSent++;
                        }
                        opForOrderList.add(op);
                    }

                    // Last record in list
                    if (!iterator.hasNext())
                    {
                        /*
                         * Send a mail for the order products in the list if the current order
                         * product belongs to the same order and we have reached the bottom of the
                         * list
                         */
                        if (opForOrderList.size() > 0 && op.getOrderId() == currentOrderId)
                        {
                            sendProductAvailabilityEmail(bw, orderMgr, custMgr,
                                    getOrderProdArrayFromList(opForOrderList), selectCrit,
                                    updateCrit, emailTemplateName, executor);
                            opForOrderList.clear();
                            numMailsSent++;
                        }

                        /*
                         * Send a mail for the current order product since this would have got sent
                         * the next time around the loop
                         */
                        if (op.getOrderId() != currentOrderId)
                        {
                            sendProductAvailabilityEmail(bw, orderMgr, custMgr,
                                    new AdminOrderProduct[]
                                    { op }, selectCrit, updateCrit, emailTemplateName, executor);
                            opForOrderList.clear();
                            numMailsSent++;
                        }
                    }

                    // Set the control variables
                    currentOrderId = op.getOrderId();

                }
                opListRet = getOrderProducts(c, searchFromOrderId, skuHM, idHM);
                opList = opListRet.getOrderProdList();
                searchFromOrderId = opListRet.getOrderId();
            }

            if (bw != null)
            {
                bw.write(timestampStr() + " productAvailabilityNotificationBatch sent "
                        + numMailsSent + " emails");
                bw.newLine();
            }

            return Integer.toString(numMailsSent);
        } catch (Exception e)
        {
            throw e;
        } finally
        {
            shutdownGracefully(executor, bw);
        }
    }

    /**
     * The method creates invoices for all orders that currently have a null invoice_filename.
     * <p>
     * Once the invoice has been created the order is updated with the name of the filename of the
     * invoice.
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
     * @return Returns the number of invoices created
     * 
     * @throws Exception
     */
    public String createInvoicesBatch(String logName, String appendLogStr, String recordFetchSizeStr)
            throws Exception
    {
        // Attributes to configure the batch job
        int recordFetchSize = getInt(recordFetchSizeStr, 100, true);
        boolean appendLog = getBoolean(appendLogStr, true, true);

        // Create the full log name
        String fullLogName = getBatchLogName(logName, appendLog);
        BufferedWriter bw = null;

        int invoicesCreated = 0;
        try
        {
            if (fullLogName != null)
            {
                File logFile = new File(fullLogName);
                bw = new BufferedWriter(new FileWriter(logFile, appendLog));
                if (appendLog)
                {
                    bw.newLine();
                    bw.write(timestampStr() + " createInvoicesBatch starting");
                    bw.newLine();
                }
            }

            // Get the criteria for the database queries
            KKCriteria c = getInvoiceOrderCriteria(recordFetchSize);

            // Get these here to save unnecessary method calls
            AdminOrderMgrIf orderMgr = getAdminOrderMgr();
            AdminPdfMgrIf pdfMgr = getAdminPdfMgr();
            AdminLanguageMgrIf langMgr = getAdminLanguageMgr();

            /*
             * There may be many orders so we fetch them from the database in a loop
             */
            int searchFromOrderId = 0;

            AdminOrder[] orders = getOrders(c, searchFromOrderId);

            while (orders.length > 0)
            {
                AdminOrder ao = null;

                for (int ord = 0; ord < orders.length; ord++)
                {
                    ao = orderMgr.getOrderForOrderId(orders[ord].getId());

                    if (ao != null)
                    {
                        PdfOptions options = new PdfOptions();
                        options.setId(ao.getId());
                        options.setType(KKConstants.HTML_ORDER_INVOICE);
                        options.setLanguageId(langMgr.getLanguageIdForLocale(ao.getLocale()));
                        options.setReturnFileName(true);
                        options.setReturnBytes(false);
                        options.setCreateFile(true);

                        if (log.isDebugEnabled())
                        {
                            log.debug(options.toString());
                        }

                        PdfResult aPdfReturn = pdfMgr.getPdf(options);

                        if (bw != null)
                        {
                            bw.write(timestampStr()
                                    + " createInvoicesBatch created invoice for order Id "
                                    + ao.getId() + " - " + aPdfReturn.getFileNameAfterBase());
                            bw.newLine();
                        }

                        ao.setInvoiceFilename(aPdfReturn.getFileNameAfterBase());
                        try
                        {
                            orderMgr.editOrder(ao);
                        } catch (Exception e)
                        {
                            if (e.getMessage().contains("does not exist"))
                            {
                                // Must have been deleted while we were processing which is unusual
                                if (log.isInfoEnabled())
                                {
                                    log.info("Order " + ao.getId()
                                            + " was deleted while invoice was being created");
                                }
                            } else
                            {
                                // throw for all other exceptions
                                throw e;
                            }
                        }
                        invoicesCreated++;

                        searchFromOrderId = ao.getId();
                    } else
                    {
                        if (bw != null)
                        {
                            bw.write(timestampStr() + " createInvoicesBatch skipped order Id "
                                    + orders[ord].getId() + " - because it has been deleted");
                            bw.newLine();
                        }
                    }
                }

                orders = getOrders(c, searchFromOrderId);
            }

            if (bw != null)
            {
                bw.write(timestampStr() + " createInvoicesBatch created " + invoicesCreated
                        + " PDF invoices");
                bw.newLine();
            }

            return Integer.toString(invoicesCreated);
        } catch (Exception e)
        {
            log.info("Exception in createInvoicesBatch: " + e.getMessage());
            throw e;
        } finally
        {
            shutdownGracefully(bw);
        }
    }

    /**
     * The method loops through all active subscriptions that have a next billing date set to the
     * current date. The payment is made by interfacing to the payment gateway and the subscription
     * object is updated with a new next billing date. The subscription object is also updated if
     * the transaction with the payment gateway fails.
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
     * @return Returns the number of payment transactions performed
     * 
     * @throws Exception
     */
    public String recurringBillingBatch(String logName, String appendLogStr,
            String recordFetchSizeStr) throws Exception
    {
        // Attributes to configure the batch job
        int recordFetchSize = getInt(recordFetchSizeStr, 100, true);
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
                if (appendLog)
                {
                    bw.newLine();
                    bw.write(timestampStr() + " recurringBillingBatch starting");
                    bw.newLine();
                }
            }

            // Get these here to save unnecessary method calls
            AdminBillingMgrIf billingMgr = getAdminBillingMgr();
            AdminOrderMgrIf orderMgr = getAdminOrderMgr();

            /*
             * There may be many subscriptions so we fetch them from the database in a loop. We
             * fetch the ones that are active and that have reached the next billing date.
             */
            int subscriptionsBilled = 0;
            AdminSubscriptionSearch search = new AdminSubscriptionSearch();
            search.setNextBillingDate(new Date());
            search.setNextBillingDateRule(KKConstants.SEARCH_LESS_EQUAL);
            search.setOnlyActive(true);
            AdminSubscriptionSearchResult ret = billingMgr.getSubscriptions(search, 0,
                    recordFetchSize);
            AdminSubscription[] subs = ret.getSubscriptions();
            do
            {
                for (int i = 0; i < subs.length; i++)
                {
                    AdminSubscription sub = subs[i];

                    // Get the order
                    @SuppressWarnings("unused")
                    AdminOrder order = orderMgr.getOrderForOrderId(sub.getOrderId());

                    /*
                     * At this point we can get the credit card details from the order, the amount
                     * that needs to be billed from the subscription and connect to the payment
                     * gateway to make the payment. Once we've made the payment we need to update
                     * the subscription object. We should set the problem attribute and add a
                     * description of the problem if the payment gateway transaction failed.
                     */

                    /*
                     * We can connect to the payment gateway using an AdminEng API call. The example
                     * below uses AuthorizeNet
                     */
                    // PaymentOptions options = new PaymentOptions();
                    // options.setOrderId(order.getId());
                    // options.setAction(0);
                    // NameValue[] retArray = getAdminModulesMgr().callPaymentModule(
                    // "com.konakartadmin.modules.payment.authorizenet.AdminPayment", options);
                    // if (retArray != null)
                    // {
                    // // Figure out whether there was a problem. The data in retArray depends on
                    // // how the payment gateway module was coded.
                    // }
                    sub.setLastBillingDate(new Date());
                    // Figure out the next billing date
                    GregorianCalendar today = new GregorianCalendar();
                    AdminPaymentSchedule ps = sub.getPaymentSchedule();
                    switch (ps.getTimeUnit())
                    {
                    case AdminPaymentSchedule.DAILY:
                        today.add(Calendar.DAY_OF_MONTH, ps.getTimeLength());
                        break;
                    case AdminPaymentSchedule.WEEKLY:
                        today.add(Calendar.WEEK_OF_YEAR, ps.getTimeLength());
                        break;
                    case AdminPaymentSchedule.MONTHLY:
                        today.add(Calendar.MONTH, ps.getTimeLength());
                        break;
                    case AdminPaymentSchedule.YEARLY:
                        today.add(Calendar.YEAR, ps.getTimeLength());
                        break;
                    }
                    sub.setNextBillingDate(today.getTime());

                    // Update the subscription in the database
                    billingMgr.updateSubscription(sub);
                    subscriptionsBilled++;
                    if (bw != null)
                    {
                        bw.write(timestampStr() + " Executed payment for subscription id = "
                                + sub.getId());
                        bw.newLine();
                    }
                }
                ret = billingMgr.getSubscriptions(search, 0, recordFetchSize);
                subs = ret.getSubscriptions();
            } while (subs.length > 0);

            if (bw != null)
            {
                bw.write(timestampStr() + " recurringBillingBatch performed " + subscriptionsBilled
                        + " payments");
                bw.newLine();
                bw.close();
            }

            return Integer.toString(subscriptionsBilled);
        } catch (Exception e)
        {
            throw e;
        }
    }

    /**
     * Creates an array of Order Products from a list. We need to get a unique instance since it is
     * passed to a thread to send the eMail. It can't just be a pointer to the list.
     * 
     * @param opForOrderList
     * @return An array of Order Products
     */
    protected AdminOrderProduct[] getOrderProdArrayFromList(List<AdminOrderProduct> opForOrderList)
    {
        if (opForOrderList == null || opForOrderList.size() == 0)
        {
            return new AdminOrderProduct[0];
        }
        AdminOrderProduct[] opArray = new AdminOrderProduct[opForOrderList.size()];
        int i = 0;
        for (Iterator<AdminOrderProduct> iterator = opForOrderList.iterator(); iterator.hasNext();)
        {
            AdminOrderProduct op = iterator.next();
            opArray[i++] = op;
        }
        return opArray;
    }

    /**
     * Creates an array of Orders from a list. We need to get a unique instance since it is passed
     * to a thread to send the eMail. It can't just be a pointer to the list.
     * 
     * @param ordersForCustomer
     * @return An array of Orders
     */
    protected AdminOrder[] getOrderArrayFromList(List<AdminOrder> ordersForCustomer)
    {
        if (ordersForCustomer == null || ordersForCustomer.size() == 0)
        {
            return new AdminOrder[0];
        }
        AdminOrder[] orderArray = new AdminOrder[ordersForCustomer.size()];
        int i = 0;
        for (Iterator<AdminOrder> iterator = ordersForCustomer.iterator(); iterator.hasNext();)
        {
            AdminOrder order = iterator.next();
            orderArray[i++] = order;
        }
        return orderArray;
    }

    /**
     * protected method to send the eMail and then change the order states.
     * 
     * @param bw
     * @param orderMgr
     * @param custMgr
     * @param orderArray
     * @param selectCrit
     * @param updateCrit
     * @param templateName
     * @param executor
     * @param newState
     * @throws Exception
     */
    protected void sendUnpaidOrderEmail(BufferedWriter bw, AdminOrderMgrIf orderMgr,
            AdminCustomerMgrIf custMgr, AdminOrder[] orderArray, KKCriteria selectCrit,
            KKCriteria updateCrit, String templateName, ExecutorService executor, int newState)
            throws Exception
    {
        /*
         * Get the customer. If he doesn't exist we create one and set the eMail address from the
         * order
         */
        AdminCustomer cust = custMgr.getCustomerForId(orderArray[0].getCustomerId());
        if (cust == null)
        {
            cust = new AdminCustomer();
            cust.setEmailAddr(orderArray[0].getCustomerEmail());
        }

        /*
         * We need to send the eMail and then change the state of the order(s). First we fully
         * populate the orders.
         */
        for (int i = 0; i < orderArray.length; i++)
        {
            AdminOrder lightOrder = orderArray[i];
            orderArray[i] = orderMgr.getOrderForOrderId(lightOrder.getId());
        }

        AdminTemplateEmailSender sender = new AdminTemplateEmailSender();
        if (bw != null)
        {
            bw.write(timestampStr() + " " + cust.getEmailAddr());
            for (int i = 0; i < orderArray.length; i++)
            {
                AdminOrder order1 = orderArray[i];
                if (order1.getOrderNumber() != null)
                {
                    bw.write(" - order number = " + order1.getOrderNumber());
                } else
                {
                    bw.write(" - order id = " + order1.getId());
                }
            }
            bw.newLine();
        }
        sender.setup(getAdminEng(), cust, templateName, /* obj1 */
        orderArray, null, null, null, null, null);
        executor.execute(sender);
        /*
         * Change the state of the orders to say that customer has been informed
         */
        setOrderState(orderArray, newState, selectCrit, updateCrit);
    }

    /**
     * protected method to send the mail and then reset the order products
     * 
     * @param bw
     * @param orderMgr
     * @param custMgr
     * @param opArray
     * @param selectCrit
     * @param updateCrit
     * @param templateName
     * @param executor
     * @throws Exception
     */
    protected void sendProductAvailabilityEmail(BufferedWriter bw, AdminOrderMgrIf orderMgr,
            AdminCustomerMgrIf custMgr, AdminOrderProduct[] opArray, KKCriteria selectCrit,
            KKCriteria updateCrit, String templateName, ExecutorService executor) throws Exception
    {
        // We need to send the eMail and then reset the Order Products
        AdminOrder order = orderMgr.getOrderForOrderId(opArray[0].getOrderId());
        AdminCustomer cust = null;
        if (order == null)
        {
            if (bw != null)
            {
                bw.write(timestampStr() + "Error: Order not found for orderId = "
                        + opArray[0].getOrderId() + ". E-Mail not sent.");
                bw.newLine();
            }
        } else
        {
            cust = custMgr.getCustomerForId(order.getCustomerId());
            if (cust == null)
            {
                /*
                 * If the customer doesn't exist, we create one and set the eMail address since this
                 * will be used to send the mail
                 */
                cust = new AdminCustomer();
                cust.setEmailAddr(order.getCustomerEmail());
            }
        }
        if (order != null && cust != null)
        {
            AdminTemplateEmailSender sender = new AdminTemplateEmailSender();
            if (bw != null)
            {
                bw.write(timestampStr() + " " + cust.getEmailAddr());

                for (int i = 0; i < opArray.length; i++)
                {
                    AdminOrderProduct op1 = opArray[i];

                    if (op1.getSku() != null)
                    {
                        bw.write(" - sku = " + op1.getSku());
                    } else
                    {
                        bw.write(" - productId = " + op1.getProductId());
                    }
                }
                bw.newLine();
            }
            sender.setup(getAdminEng(), cust, templateName, /* obj1 */order,
            /* obj2 */opArray, null, null, null, null);
            executor.execute(sender);

            /*
             * Change the state of the order product to say that customer has been informed
             */
            setOrderProductState(opArray, OrderMgr.ORD_PROD_CUSTOMER_INFORMED_OF_DELIVERY_DATE,
                    selectCrit, updateCrit);
        }
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
     * The method returns null when all of the order products have been read. If we don't need to
     * send any emails for any of the read order products then it returns an empty list. The can
     * stop looping when he receives null.
     * 
     * We loop through the list of order products and create a return list that just contains the
     * ones that have a delivery date and weren't in stock.
     * 
     * @param c
     * @param orderId
     *            We only fetch order products for orders with an id >= to this
     * @param skuHM
     * @param idHM
     * @return Returns a list of AdminOrderProducts and last order processed
     * @throws Exception
     */
    protected OrderProdList getOrderProducts(KKCriteria c, int orderId,
            HashMap<String, OrderProdStatus> skuHM, HashMap<Integer, OrderProdStatus> idHM)
            throws Exception
    {
        // Add offset
        c.add(BaseOrdersProductsPeer.ORDERS_ID, orderId, Criteria.GREATER_THAN);

        // Get the orderProducts for this order
        List<Record> rows = BasePeer.doSelect(c);
        if (rows.size() == 0)
        {
            OrderProdList opRetList = new OrderProdList();
            return opRetList;
        }

        // Instantiate some variables for performance
        AdminProductMgrIf prodMgr = getAdminProdMgr();
        Calendar now = new GregorianCalendar();

        /*
         * Loop through the list of order products and create a return list that just contains the
         * ones that have a delivery date and weren't in stock. We keep two hash tables for
         * performance reasons. We have one for the product SKUs and one for the product ids which
         * will never be used if all products have an SKU.
         */
        OrderProdList opRetList = new OrderProdList();

        List<AdminOrderProduct> retList = new ArrayList<AdminOrderProduct>();
        for (Iterator<Record> iterator = rows.iterator(); iterator.hasNext();)
        {
            Record row = iterator.next();
            AdminOrderProduct op = new AdminOrderProduct(row, c);
            opRetList.setOrderId(op.getOrderId());

            if (op.getSku() != null)
            {
                OrderProdStatus opStatus = skuHM.get(op.getSku());
                if (opStatus == null)
                {
                    Calendar dateAvailable = prodMgr.getProductAvailability(op.getSku(), op
                            .getProductId());
                    if (dateAvailable == null || dateAvailable.before(now))
                    {
                        opStatus = new OrderProdStatus();
                        opStatus.setAvailable(false);
                        skuHM.put(op.getSku(), opStatus);
                    } else
                    {
                        opStatus = new OrderProdStatus();
                        opStatus.setAvailable(true);
                        opStatus.setDateAvailable(dateAvailable.getTime());
                        skuHM.put(op.getSku(), opStatus);
                    }
                }
                if (opStatus.isAvailable())
                {
                    op.setDateAvailable(opStatus.getDateAvailable());
                    retList.add(op);
                }
            } else
            {
                OrderProdStatus opStatus = idHM.get(new Integer(op.getId()));
                if (opStatus == null)
                {
                    Calendar dateAvailable = prodMgr.getProductAvailability(op.getSku(), op
                            .getProductId());
                    if (dateAvailable == null || dateAvailable.before(now))
                    {
                        opStatus = new OrderProdStatus();
                        opStatus.setAvailable(false);
                        idHM.put(new Integer(op.getId()), opStatus);
                    } else
                    {
                        opStatus = new OrderProdStatus();
                        opStatus.setAvailable(true);
                        opStatus.setDateAvailable(dateAvailable.getTime());
                        idHM.put(new Integer(op.getId()), opStatus);
                    }
                }
                if (opStatus.isAvailable())
                {
                    op.setDateAvailable(opStatus.getDateAvailable());
                    retList.add(op);
                }
            }
        }
        opRetList.setOrderProdList(retList);
        return opRetList;
    }

    /**
     * The method returns an array of orders which will be empty when all of the orders have been
     * read.
     * 
     * @param c
     * @return Returns a list of AdminOrderProducts and last order processed
     * @throws Exception
     */
    protected AdminOrder[] getOrders(KKCriteria c, int orderId) throws Exception
    {
        // Add offset
        c.add(BaseOrdersPeer.ORDERS_ID, orderId, Criteria.GREATER_THAN);

        // Get the orders
        List<Record> rows = BasePeer.doSelect(c);

        AdminOrder[] orders = new AdminOrder[rows.size()];

        if (rows.size() == 0)
        {
            return orders;
        }

        /*
         * Loop through the list of records returned and convert to AdminOrder records.
         */
        int orderCount = 0;
        for (Iterator<Record> iterator = rows.iterator(); iterator.hasNext();)
        {
            Record row = iterator.next();
            AdminOrder ao = new AdminOrder(row, c);
            orders[orderCount] = ao;
            orderCount++;
        }

        return orders;
    }

    /**
     * Object stored in the hash maps
     * 
     */
    protected class OrderProdStatus
    {
        boolean available;

        Date dateAvailable;

        /**
         * @return the available
         */
        public boolean isAvailable()
        {
            return available;
        }

        /**
         * @param available
         *            the available to set
         */
        public void setAvailable(boolean available)
        {
            this.available = available;
        }

        /**
         * @return the dateAvailable
         */
        public Date getDateAvailable()
        {
            return dateAvailable;
        }

        /**
         * @param dateAvailable
         *            the dateAvailable to set
         */
        public void setDateAvailable(Date dateAvailable)
        {
            this.dateAvailable = dateAvailable;
        }

    }

    /**
     * A return object containing a list of OrderProducts and the last OrderId processed
     * 
     */
    protected class OrderProdList
    {
        int orderId;

        List<AdminOrderProduct> orderProdList;

        /**
         * @return the orderId
         */
        public int getOrderId()
        {
            return orderId;
        }

        /**
         * @param orderId
         *            the orderId to set
         */
        public void setOrderId(int orderId)
        {
            this.orderId = orderId;
        }

        /**
         * @return the orderProdList
         */
        public List<AdminOrderProduct> getOrderProdList()
        {
            return orderProdList;
        }

        /**
         * @param orderProdList
         *            the orderProdList to set
         */
        public void setOrderProdList(List<AdminOrderProduct> orderProdList)
        {
            this.orderProdList = orderProdList;
        }
    }

    /**
     * Set the state of the list of order products passed in.
     * 
     * @param orderProds
     * @param newState
     * @param selectCrit
     * @param updateCrit
     * @throws TorqueException
     */
    protected void setOrderProductState(AdminOrderProduct[] orderProds, int newState,
            KKCriteria selectCrit, KKCriteria updateCrit) throws TorqueException
    {
        if (orderProds == null || orderProds.length == 0)
        {
            return;
        }

        for (int i = 0; i < orderProds.length; i++)
        {
            AdminOrderProduct op = orderProds[i];
            selectCrit.clear();
            updateCrit.clear();
            selectCrit.add(BaseOrdersProductsPeer.ORDERS_PRODUCTS_ID, op.getId());
            updateCrit.add(BaseOrdersProductsPeer.PRODUCTS_STATE, newState);
            BasePeer.doUpdate(selectCrit, updateCrit);
        }
    }

    /**
     * Set the state of the list of orders passed in.
     * 
     * @param orders
     * @param newState
     * @param selectCrit
     * @param updateCrit
     * @throws TorqueException
     */
    protected void setOrderState(AdminOrder[] orders, int newState, KKCriteria selectCrit,
            KKCriteria updateCrit) throws TorqueException
    {
        if (orders == null || orders.length == 0)
        {
            return;
        }

        for (int i = 0; i < orders.length; i++)
        {
            AdminOrder order = orders[i];

            selectCrit.clear();
            updateCrit.clear();
            selectCrit.add(BaseOrdersPeer.ORDERS_ID, order.getId());
            updateCrit.add(BaseOrdersPeer.ORDERS_STATUS, newState);
            BasePeer.doUpdate(selectCrit, updateCrit);
        }
    }

    /**
     * Create a criteria object for reading unpaid orders
     * 
     * @param size
     * @param validOrderStates
     * @return KKCriteria object
     */
    protected KKCriteria getUnpaidOrderCriteria(int size, int numDays, int[] validOrderStates)
    {
        // Create a Date object for now - numDays
        Long millis = System.currentTimeMillis() - numDays * 24 * 60 * 60 * 1000L;
        Date critDate = new Date(millis);

        KKCriteria c = getNewCriteria(/* AllStores */true);

        c.addSelectColumn(BaseOrdersPeer.ORDERS_ID);
        c.addSelectColumn(BaseOrdersPeer.CUSTOMERS_ID);
        c.addSelectColumn(BaseOrdersPeer.CUSTOMERS_EMAIL_ADDRESS);
        c.addSelectColumn(BaseOrdersPeer.DATE_PURCHASED);
        c.addSelectColumn(BaseOrdersPeer.ORDERS_STATUS);

        // Add criteria
        for (int i = 0; i < validOrderStates.length; i++)
        {
            int j = validOrderStates[i];
            Criteria.Criterion state = c.getNewCriterion(BaseOrdersPeer.ORDERS_STATUS, j,
                    Criteria.NOT_EQUAL);
            if (i == 0)
            {
                c.add(state);
            } else
            {
                c.and(state);
            }
        }

        c.add(BaseOrdersPeer.DATE_PURCHASED, critDate, Criteria.LESS_THAN);

        // Add order by
        c.addAscendingOrderByColumn(BaseOrdersPeer.CUSTOMERS_ID);
        c.addAscendingOrderByColumn(BaseOrdersPeer.ORDERS_ID);

        // Set limit
        c.setLimit(size);

        return c;
    }

    /**
     * Create a criteria object for reading the OrderProducts
     * 
     * @param size
     * @return KKCriteria object
     */
    protected KKCriteria getOrderProductCriteria(int size)
    {
        KKCriteria c = getNewCriteria();

        c.addSelectColumn(BaseOrdersProductsPeer.ORDERS_PRODUCTS_ID);
        c.addSelectColumn(BaseOrdersProductsPeer.PRODUCTS_ID);
        c.addSelectColumn(BaseOrdersProductsPeer.ORDERS_ID);
        c.addSelectColumn(BaseOrdersProductsPeer.PRODUCTS_SKU);
        c.addSelectColumn(BaseOrdersProductsPeer.PRODUCTS_STATE);
        c.addSelectColumn(BaseOrdersProductsPeer.PRODUCTS_MODEL);
        c.addSelectColumn(BaseOrdersProductsPeer.PRODUCTS_NAME);
        c.addSelectColumn(BaseOrdersProductsPeer.PRODUCTS_PRICE);
        c.addSelectColumn(BaseOrdersProductsPeer.FINAL_PRICE);
        c.addSelectColumn(BaseOrdersProductsPeer.PRODUCTS_TAX);
        c.addSelectColumn(BaseOrdersProductsPeer.PRODUCTS_QUANTITY);
        c.addSelectColumn(BaseOrdersProductsPeer.PRODUCTS_TYPE);
        c.addSelectColumn(BaseOrdersProductsPeer.CUSTOM1);
        c.addSelectColumn(BaseOrdersProductsPeer.CUSTOM2);
        c.addSelectColumn(BaseOrdersProductsPeer.CUSTOM3);
        c.addSelectColumn(BaseOrdersProductsPeer.CUSTOM4);
        c.addSelectColumn(BaseOrdersProductsPeer.CUSTOM5);

        // Add criteria
        Criteria.Criterion state1 = c.getNewCriterion(BaseOrdersProductsPeer.PRODUCTS_STATE,
                OrderMgr.ORD_PROD_OUT_OF_STOCK_AVAILABLE_DATE_UNKNOWN, Criteria.EQUAL);
        Criteria.Criterion state2 = c.getNewCriterion(BaseOrdersProductsPeer.PRODUCTS_STATE,
                OrderMgr.ORD_PROD_PARTIALLY_OUT_OF_STOCK_AVAILABLE_DATE_UNKNOWN, Criteria.EQUAL);
        c.add(state1.or(state2));

        // Add order by
        c.addAscendingOrderByColumn(BaseOrdersProductsPeer.ORDERS_ID);
        c.addAscendingOrderByColumn(BaseOrdersProductsPeer.PRODUCTS_ID);

        // Set limit
        c.setLimit(size);

        return c;
    }

    /**
     * Create a criteria object for reading the Orders for creating invoices
     * 
     * @param size
     * @return KKCriteria object
     */
    protected KKCriteria getInvoiceOrderCriteria(int size)
    {
        KKCriteria c = getNewCriteria(/* AllStores */true);

        c.addSelectColumn(BaseOrdersPeer.ORDERS_ID);

        // Retrieve Orders where the INVOICE_FILENAME is null or empty string
        Criteria.Criterion state1 = c.getNewCriterion(BaseOrdersPeer.INVOICE_FILENAME,
                "INVOICE_FILENAME is null", Criteria.CUSTOM);
        Criteria.Criterion state2 = c.getNewCriterion(BaseOrdersPeer.INVOICE_FILENAME, "",
                Criteria.EQUAL);
        c.add(state1.or(state2));

        // Add order by
        c.addAscendingOrderByColumn(BaseOrdersPeer.ORDERS_ID);

        // Set limit
        c.setLimit(size);

        return c;
    }
}