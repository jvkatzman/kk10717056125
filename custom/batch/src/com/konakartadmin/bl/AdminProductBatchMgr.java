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
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.math.BigDecimal;
import java.nio.charset.Charset;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.torque.Torque;
import org.apache.torque.TorqueException;
import org.apache.torque.util.BasePeer;
import org.apache.torque.util.Criteria;

import com.konakart.bl.KKCriteria;
import com.konakart.bl.KKRecord;
import com.konakart.om.BaseCategoriesPeer;
import com.konakart.om.BaseProductsDescriptionPeer;
import com.konakart.om.BaseProductsPeer;
import com.konakart.om.BaseReviewsPeer;
import com.konakart.om.BaseSpecialsPeer;
import com.konakart.util.KKConstants;
import com.konakartadmin.app.AdminCopyProductOptions;
import com.konakartadmin.app.AdminLanguage;
import com.konakartadmin.app.AdminSpecial;
import com.konakartadmin.app.KKAdminException;
import com.konakartadmin.appif.KKAdminIf;
import com.konakartadmin.blif.AdminProductMgrIf;
import com.workingdogs.village.Record;

/**
 * The ProductBatchMgr
 */
public class AdminProductBatchMgr extends AdminBatchBaseMgr
{
    /*
     * Constants for sitemap creation
     */
    private static final String HEADER = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";

    private static final String SITEMAPINDEX = "<sitemapindex xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">";

    private static final String SITEMAPINDEX_END = "</sitemapindex>";

    private static final String SITEMAP = "<sitemap>";

    private static final String SITEMAP_END = "</sitemap>";

    private static final String LOC = "<loc>";

    private static final String LOC_END = "</loc>";

    private static final String URLSET_PROD = "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\" xmlns:image=\"http://www.google.com/schemas/sitemap-image/1.1\">";

    private static final String URLSET = "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">";

    private static final String URLSET_END = "</urlset>";

    private static final String URL = "<url>";

    private static final String URL_END = "</url>";

    private static final String LASTMOD = "<lastmod>";

    private static final String LASTMOD_END = "</lastmod>";

    private static final String CHANGEFREQ = "<changefreq>";

    private static final String CHANGEFREQ_END = "</changefreq>";

    private static final String PRIORITY = "<priority>";

    private static final String PRIORITY_END = "</priority>";

    private static final String IMAGE = "<image:image>";

    private static final String IMAGE_END = "</image:image>";

    private static final String IMAGE_LOC = "<image:loc>";

    private static final String IMAGE_LOC_END = "</image:loc>";

    private static final String IMAGE_TITLE = "<image:title>";

    private static final String IMAGE_TITLE_END = "</image:title>";

    /**
     * @param eng
     * @throws Exception
     */
    public AdminProductBatchMgr(KKAdminIf eng) throws Exception
    {
        super.init(eng);
    }

    /**
     * Whenever a product review is submitted, a rating is given to the product. This method
     * calculates the average rating and number of reviews for each product and updates the product
     * rating attribute and numberReviews attribute with these values. Only visible reviews are
     * processed.
     * <p>
     * The product rating may be used by the application to filter and order products.
     * <p>
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
     * @throws Exception
     */
    public void setProductAverageRatingsBatch(String logName, String appendLogStr,
            String recordFetchSizeStr) throws Exception
    {
        boolean appendLog = getBoolean(appendLogStr, true, true);
        int recordFetchSize = getInt(recordFetchSizeStr, 100, true);
        int offset = 0;

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
                    bw.write(timestampStr() + " setProductAverageRatingsBatch starting");
                    bw.newLine();
                }
            }

            String averageTxt_DEFAULT = "avg(reviews_rating)";
            String averageTxt_MSSQL = "avg(convert(decimal,reviews_rating))";
            String averageTxt_DB2 = "avg(cast(reviews_rating as decimal))";

            String averageTxt = averageTxt_DEFAULT;
            if (KKRecord.isMSSqlServer())
            {
                averageTxt = averageTxt_MSSQL;
            } else if (KKRecord.isDB2())
            {
                averageTxt = averageTxt_DB2;
            }

            KKCriteria c = getNewCriteria(isMultiStoreShareProducts());
            c.addSelectColumn(BaseProductsPeer.PRODUCTS_ID);
            c.addSelectColumn(BaseProductsPeer.NUMBER_REVIEWS);
            c.addSelectColumn(BaseProductsPeer.RATING);
            c.addJoin(BaseProductsPeer.PRODUCTS_ID, BaseReviewsPeer.PRODUCTS_ID, Criteria.LEFT_JOIN);
            averageTxt = "reviews." + averageTxt; // need to add this for torque
            c.addSelectColumn(averageTxt);
            c.addSelectColumn("count(" + BaseReviewsPeer.PRODUCTS_ID + ")");
            c.addGroupByColumn(BaseProductsPeer.PRODUCTS_ID);
            c.addGroupByColumn(BaseProductsPeer.NUMBER_REVIEWS);
            c.addGroupByColumn(BaseProductsPeer.RATING);

            c.addAscendingOrderByColumn(BaseProductsPeer.PRODUCTS_ID);

            String qs = new String(BasePeer.createQueryString(c));
            // remove the "reviews." string we added before "avg"
            qs = qs.replace("reviews.avg", "avg");
            // Add an extra constraint to the join clause
            qs = qs.replace("products.products_id=reviews.products_id",
                    "products.products_id=reviews.products_id and reviews.state = 0");

            /*
             * Query should look like : SELECT products.products_id, products.number_reviews,
             * products.rating, avg(reviews_rating), count(reviews.products_id) FROM products LEFT
             * JOIN reviews ON products.products_id=reviews.products_id and reviews.state = 0 GROUP
             * BY products.products_id
             */

            // Run the query
            Connection con = null;
            List<Record> rows = null;
            try
            {
                bw.write(timestampStr() + " SQL = " + qs);
                bw.newLine();
                con = Torque.getConnection(Torque.getDefaultDB());
                rows = BasePeer.executeQuery(qs, offset, recordFetchSize, /* singleRecord */
                        false, con);
            } finally
            {
                Torque.closeConnection(con);
            }

            KKCriteria updateC = getNewCriteria(isMultiStoreShareProducts());
            KKCriteria selectC = getNewCriteria(isMultiStoreShareProducts());
            boolean loop = true;
            int count = 0, updateCount = 0;
            do
            {
                bw.write(timestampStr() + " Read " + rows.size() + " rows");
                bw.newLine();

                for (int r = 0; r < rows.size(); r++)
                {
                    int prodId = rows.get(r).getValue(1).asInt();
                    int prodRevCount = rows.get(r).getValue(2).asInt();
                    BigDecimal prodRating = rows.get(r).getValue(3).asBigDecimal();
                    BigDecimal rating = rows.get(r).getValue(4).asBigDecimal();
                    int revCount = rows.get(r).getValue(5).asInt();

                    prodRating = (prodRating == null) ? null : prodRating.setScale(2,
                            BigDecimal.ROUND_HALF_UP);
                    rating = (rating == null) ? null : rating.setScale(2, BigDecimal.ROUND_HALF_UP);

                    bw.write(timestampStr() + " " + r + ") prodId=" + prodId + " prodRevCount="
                            + prodRevCount + " prodRating=" + prodRating + " rating=" + rating
                            + " revCount=" + revCount);
                    bw.newLine();

                    if ((prodRevCount != revCount)
                            || (prodRating != null && rating == null && prodRating
                                    .compareTo(new BigDecimal(0)) != 0)
                            || (prodRating != null && rating != null && (prodRating
                                    .compareTo(rating) != 0)))
                    {
                        /*
                         * The product summary data doesn't match the actual review data so we
                         * update the product. If there are no reviews then rating will be null. In
                         * this case we set prodRating = 0.
                         */
                        updateC.clear();
                        selectC.clear();

                        bw.write(timestampStr() + " " + r + ") prodId=" + prodId
                                + " Update num_reviews=" + revCount + " rating="
                                + ((rating == null) ? new BigDecimal(0) : rating));
                        bw.newLine();
                        bw.write(timestampStr()
                                + "    -----------------------------------------------");
                        bw.newLine();

                        updateC.addForInsert(BaseProductsPeer.NUMBER_REVIEWS, revCount);
                        updateC.addForInsert(BaseProductsPeer.RATING,
                                ((rating == null) ? new BigDecimal(0) : rating));

                        selectC.add(BaseProductsPeer.PRODUCTS_ID, prodId);
                        BasePeer.doUpdate(selectC, updateC);
                        updateCount++;
                    }
                    count++;
                }

                if (rows.size() == 0)
                {
                    loop = false;
                } else
                {
                    offset += recordFetchSize;

                    try
                    {
                        con = Torque.getConnection(Torque.getDefaultDB());
                        rows = BasePeer.executeQuery(qs, offset, recordFetchSize, /* singleRecord */
                                false, con);
                    } finally
                    {
                        Torque.closeConnection(con);
                    }
                }

            } while (loop);

            if (bw != null)
            {
                bw.write(timestampStr() + " " + count + " products processed");
                bw.newLine();
                bw.write(timestampStr() + " " + updateCount + " products updated");
                bw.newLine();
                bw.write(timestampStr() + " setProductAverageRatingsBatch finished");
                bw.newLine();
            }

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
     * Whenever a product special price is set and active, it is used in sort / filter by price
     * queries regardless of whether it has expired or has yet to start. The price shown on the
     * product is always the correct price but when for example sorting by price, it may appear in
     * the wrong position because the special price is used to do the sorting whereas the full price
     * is displayed. The reason for this functionality is that only the special status (for
     * performance reasons) is looked at to decide which price to use when sorting / filtering.
     * <p>
     * If your policy is to set special prices on a daily basis, then this batch should be run on a
     * daily basis. It looks at the start and expiry dates of the special and disables it if the
     * current date doesn't lie in between these two dates. Otherwise the special is enabled if
     * there is a start date and the special price should have started.
     * <p>
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
     * @throws Exception
     */
    public void setSpecialPriceStateBatch(String logName, String appendLogStr,
            String recordFetchSizeStr) throws Exception
    {
        // Attributes to configure the batch job
        boolean appendLog = getBoolean(appendLogStr, true, true);
        int recordFetchSize = getInt(recordFetchSizeStr, 100, true);

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
                    bw.write(timestampStr() + " setSpecialPriceStateBatch starting");
                    bw.newLine();
                }
            }

            // Criteria to update special
            KKCriteria updateC = getNewCriteria(isMultiStoreShareProducts());
            KKCriteria selectC = getNewCriteria(isMultiStoreShareProducts());

            KKCriteria c = getNewCriteria(isMultiStoreShareProducts());
            c.addSelectColumn(BaseSpecialsPeer.SPECIALS_ID);
            c.addSelectColumn(BaseSpecialsPeer.SPECIALS_NEW_PRODUCTS_PRICE);
            c.addSelectColumn(BaseSpecialsPeer.STATUS);
            c.addSelectColumn(BaseSpecialsPeer.EXPIRES_DATE);
            c.addSelectColumn(BaseSpecialsPeer.STARTS_DATE);
            c.addAscendingOrderByColumn(BaseSpecialsPeer.SPECIALS_ID);
            c.setLimit(recordFetchSize);
            List<Record> rows = BasePeer.doSelect(c);

            int enableCount = 0, disableCount = 0;
            boolean loop = true;
            do
            {
                for (Iterator<Record> iterator = rows.iterator(); iterator.hasNext();)
                {
                    Record row = iterator.next();
                    AdminSpecial s = new AdminSpecial(row, c);

                    if ((s.hasExpired() || s.yetToStart()) && s.getStatus() == (byte) 1)
                    {
                        /*
                         * Disable the special if it has yet to start or it has expired
                         */
                        setSpecialState(updateC, selectC, s.getId(), /* enable */false);
                        if (bw != null)
                        {
                            bw.write(timestampStr() + " " + " disable id = " + s.getId());
                            bw.newLine();
                        }
                        disableCount++;
                    } else if (!s.yetToStart() && s.getStartDate() != null
                            && s.getStatus() == (byte) 0)
                    {
                        /*
                         * If the special has started because a start date is present (method will
                         * return false even if start date is null) and it is disabled, then enable
                         * it.
                         */
                        setSpecialState(updateC, selectC, s.getId(), /* enable */true);
                        if (bw != null)
                        {
                            bw.write(timestampStr() + " " + " enable id = " + s.getId());
                            bw.newLine();
                        }
                        enableCount++;
                    }
                }
                if (rows.size() == 0)
                {
                    loop = false;
                } else
                {
                    c.setOffset(c.getOffset() + recordFetchSize);
                    rows = BasePeer.doSelect(c);
                }

            } while (loop);

            if (bw != null)
            {
                bw.write(timestampStr() + " " + enableCount + " specials enabled");
                bw.newLine();
                bw.write(timestampStr() + " " + disableCount + " specials disabled");
                bw.newLine();
                bw.write(timestampStr() + " setSpecialPriceStateBatch finished");
                bw.newLine();
            }
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
     * Private method to enable or disable the special
     * 
     * @param updateC
     * @param selectC
     * @param id
     * @param enable
     * @throws TorqueException
     */
    private void setSpecialState(KKCriteria updateC, KKCriteria selectC, int id, boolean enable)
            throws TorqueException
    {
        selectC.clear();
        updateC.clear();
        selectC.add(BaseSpecialsPeer.SPECIALS_ID, id);
        updateC.add(BaseSpecialsPeer.STATUS, enable ? (byte) 1 : (byte) 0);
        BasePeer.doUpdate(selectC, updateC);
    }

    /**
     * This batch synchronizes the products in storeIdFrom with the ones in storeIdTo. It can only
     * be used if the KonaKart engine is running in shared category / shared product mode. It
     * performs the following three copy operations from the source store to the destination store:
     * <ul>
     * <li>Copy all products that have uuid equal to null. If uuid is equal to null, this means that
     * the products have never been copied.</li>
     * <li>Copy all products that have a valid uuid but the uuid doesn't exist in the destination
     * store. This situation can arise if the products have been copied before to another store
     * which isn't the destination store. They may also have been copied and then deleted from the
     * destination store.</li>
     * <li>Copy all products that have matching uuids but the dates in the masterProdDate attribute
     * do not match. This situation can arise if a product has previously been copied but then
     * modified.</li>
     * <ul>
     * A product object has two attributes to manage synchronization. One is the uuid which
     * identifies identical products in different stores. i.e. When a product is copied from one
     * store to another, the product id of the copied product is different but a uuid is generated
     * and saved in both products in order to match them. The other attribute is the masterProdDate
     * which is the last modified date of the source product. This date is maintained during the
     * copy so that it can be used to determine when the products are no longer in sync. If after
     * the copy, the source product is edited, the masterProdDate of the source product is
     * automatically modified to the new edit date and so can be used to determine that the copied
     * product in another store is now out of date.
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
     * @param storeIdFrom
     *            The id of the source store
     * @param storeIdTo
     *            The id of the destination store
     * @throws Exception
     */
    public void synchronizeStoresBatch(String logName, String appendLogStr,
            String recordFetchSizeStr, String storeIdFrom, String storeIdTo) throws Exception
    {
        // Attributes to configure the batch job
        boolean appendLog = getBoolean(appendLogStr, true, true);
        int recordFetchSize = getInt(recordFetchSizeStr, 100, true);

        // Create the full log name
        String fullLogName = getBatchLogName(logName, appendLog);

        BufferedWriter bw = null;
        int totalCount = 0;
        int warningCount = 0;
        try
        {
            if (fullLogName != null)
            {
                File logFile = new File(fullLogName);
                bw = new BufferedWriter(new FileWriter(logFile, appendLog));
                if (appendLog)
                {
                    bw.newLine();
                    bw.write(timestampStr() + " synchronizeStoresBatch starting");
                    bw.newLine();
                }
            }

            if (!isMultiStoreShareCategories())
            {
                if (bw != null)
                {
                    bw.write(timestampStr()
                            + " synchronizeStoresBatch cannot run since engine is not in multi-store shared category mode.");
                    bw.newLine();
                    return;
                }
            }

            if (storeIdFrom == null || storeIdFrom.length() == 0 || storeIdTo == null
                    || storeIdTo.length() == 0)
            {
                if (bw != null)
                {
                    bw.write(timestampStr()
                            + " synchronizeStoresBatch cannot run since both store id parameters are not set. storeIdFrom = "
                            + storeIdFrom + ". storeIdTo = " + storeIdTo);
                    bw.newLine();
                    return;
                }
            }

            // Get the product mgr
            AdminProductMgrIf prodMgr = getAdminProdMgr();

            // Create a copy options object
            AdminCopyProductOptions options = new AdminCopyProductOptions();
            options.setMode(AdminCopyProductOptions.MODE_COPY_CREATING_NEW_PRODUCT);
            options.setCopyRelatedProducts(true);

            // Define some variables
            List<Record> rows = null;
            boolean loop;
            KKCriteria c = getNewCriteria(isMultiStoreShareProducts());

            /*
             * Copy all products that have a valid uuid but the uuid doesn't exist in the
             * destination store OR where the uuid is null
             */
            StringBuffer sb = new StringBuffer();
            try
            {
                sb.append("select t1.products_id from products t1 INNER JOIN kk_product_to_stores t2 ON t1.products_id=t2.products_id where t2.store_id='");
                sb.append(storeIdFrom);
                sb.append("' and (not exists (select t3.products_id from products t3 INNER JOIN kk_product_to_stores t4 ON t3.products_id=t4.products_id where t1.product_uuid=t3.product_uuid and t4.store_id='");
                sb.append(storeIdTo);
                sb.append("')) or t1.product_uuid is null");
                rows = BasePeer.executeQuery(sb.toString(), 0, recordFetchSize, c.getDbName(), /* singleRecord */
                        false);
            } catch (Exception e1)
            {
                if (log.isDebugEnabled())
                {
                    log.debug("Database threw exception when running query : " + sb.toString(), e1);
                }
                if (bw != null)
                {
                    bw.write(timestampStr()
                            + " ERROR - Database threw exception when running query : "
                            + sb.toString() + ". Exception Message = " + e1.getMessage());
                    bw.newLine();
                }
                throw new KKAdminException(e1);
            }

            loop = true;
            do
            {
                for (Iterator<Record> iterator = rows.iterator(); iterator.hasNext();)
                {
                    Record row = iterator.next();
                    int productId = row.getValue(1).asInt();

                    try
                    {
                        int newProdId = prodMgr.copyProductToStore(productId, storeIdFrom,
                                storeIdTo, options);
                        if (bw != null)
                        {
                            bw.write(timestampStr() + " New UUID - Copied product id = "
                                    + productId + " from " + storeIdFrom + " to " + storeIdTo
                                    + ". Destination id = " + newProdId);
                            bw.newLine();
                        }
                        totalCount++;
                    } catch (Exception e)
                    {
                        if (log.isDebugEnabled())
                        {
                            log.debug("Out of Sync Product id = " + productId + " from "
                                    + storeIdFrom + " to " + storeIdTo, e);
                        }
                        if (bw != null)
                        {
                            bw.write(timestampStr()
                                    + " WARNING - New UUID - Could not copy product id = "
                                    + productId + " from " + storeIdFrom + " to " + storeIdTo
                                    + ". Exception Message = " + e.getMessage());
                            bw.newLine();
                        }
                        warningCount++;
                    }
                }
                if (rows.size() == 0)
                {
                    loop = false;
                } else
                {
                    rows = BasePeer.executeQuery(sb.toString(), 0, recordFetchSize, c.getDbName(), /* singleRecord */
                            false);
                }

            } while (loop);

            /*
             * Copy all products that have matching uuids but the dates in the masterProdDate
             * attribute do not match
             */
            sb = new StringBuffer();
            try
            {
                sb.append("select t1.products_id, t1.product_uuid from products t1 INNER JOIN kk_product_to_stores t4 ON t1.products_id=t4.products_id , products t2 INNER JOIN kk_product_to_stores t3 ON t2.products_id=t3.products_id where (t1.product_uuid=t2.product_uuid) and t3.store_id='");
                sb.append(storeIdTo);
                sb.append("' and t4.store_id='");
                sb.append(storeIdFrom);
                sb.append("' and t1.products_id <> t2.products_id and ((t1.source_last_modified <> t2.source_last_modified) or (t1.source_last_modified is null and t2.source_last_modified is not null) or (t1.source_last_modified is not null and t2.source_last_modified is null))");
                rows = BasePeer.executeQuery(sb.toString(), 0, recordFetchSize, c.getDbName(), /* singleRecord */
                        false);
            } catch (Exception e1)
            {
                if (log.isDebugEnabled())
                {
                    log.debug("Database threw exception when running query : " + sb.toString(), e1);
                }
                if (bw != null)
                {
                    bw.write(timestampStr()
                            + " ERROR - Database threw exception when running query : "
                            + sb.toString() + ". Exception Message = " + e1.getMessage());
                    bw.newLine();
                }
                throw new KKAdminException(e1);
            }

            /*
             * Keep track of products we have processed in order to stop it looping forever if
             * products exist in the from store with identical UUIDs
             */
            HashMap<String, Integer> prodMap = new HashMap<String, Integer>();
            loop = true;
            do
            {
                for (Iterator<Record> iterator = rows.iterator(); iterator.hasNext();)
                {
                    Record row = iterator.next();
                    int productId = row.getValue(1).asInt();
                    String uuid = row.getValue(2).asString();
                    Integer existingProdId = prodMap.get(uuid);
                    if (existingProdId == null)
                    {
                        prodMap.put(uuid, new Integer(productId));
                    } else
                    {
                        loop = false;
                        if (bw != null)
                        {
                            bw.write(timestampStr()
                                    + " synchronizeStoresBatch has been stopped because two products were found in store "
                                    + storeIdFrom + " with identical UUIDs " + uuid
                                    + " . The product ids are " + productId + " and "
                                    + existingProdId.intValue());
                            bw.newLine();
                        }
                        break;
                    }

                    try
                    {
                        int newProdId = prodMgr.copyProductToStore(productId, storeIdFrom,
                                storeIdTo, options);
                        if (bw != null)
                        {
                            bw.write(timestampStr() + " Out of Sync - Copied product id = "
                                    + productId + " from " + storeIdFrom + " to " + storeIdTo
                                    + ". Destination id = " + newProdId);
                            bw.newLine();
                        }
                        totalCount++;
                    } catch (Exception e)
                    {
                        if (log.isDebugEnabled())
                        {
                            log.debug("Out of Sync Product id = " + productId + " from "
                                    + storeIdFrom + " to " + storeIdTo, e);
                        }
                        if (bw != null)
                        {
                            bw.write(timestampStr()
                                    + " WARNING - Out of Sync - Could not copy product id = "
                                    + productId + " from " + storeIdFrom + " to " + storeIdTo
                                    + ". Exception Message = " + e.getMessage());
                            bw.newLine();
                        }
                        warningCount++;
                    }
                }
                if (rows.size() == 0)
                {
                    loop = false;
                } else
                {
                    rows = BasePeer.executeQuery(sb.toString(), 0, recordFetchSize, c.getDbName(), /* singleRecord */
                            false);
                }

            } while (loop);

        } finally
        {
            if (bw != null)
            {
                bw.write(timestampStr() + " synchronizeStoresBatch finished. " + totalCount
                        + " products copied");
                bw.newLine();
                if (warningCount > 0)
                {
                    bw.write(timestampStr()
                            + " There were "
                            + warningCount
                            + " warnings. Some products may not have been copied. Look at this log for further details");
                    bw.newLine();

                } else
                {
                    bw.write(timestampStr() + " There were no warnings");
                    bw.newLine();
                }
                bw.flush();
                bw.close();
            }
        }
    }

    /**
     * This method creates 4 or more files as described below:
     * <ul>
     * <li>sitemap.xml - the sitemap index file that includes the other sitemap files</li>
     * <li>sitemap-products_n.xml - includes links to all of the product detail pages. Depending on
     * the number of products in the database, multiple files may be produced named
     * sitemap-products_1.xml, sitemap-products_2.xml etc.</li>
     * <li>sitemap-categories.xml - includes links to all of the top level category landing pages</li>
     * <li>sitemap-pages.xml - includes the home page and various static pages</li>
     * </ul>
     * <p>
     * The directory into which the files are written is defined by a configuration variable and can
     * be set in the Admin App under "Configuration >> Sitemap Configuration".
     * <p>
     * More information on sitemaps can be found at http://www.sitemaps.org/.
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
     * @throws Exception
     */
    public void createSitemapBatch(String logName, String appendLogStr, String recordFetchSizeStr)
            throws Exception
    {
        String storeBaseURL = null;
        String imgBaseURL = null;
        String fileDirectory = null;

        /*
         * The names of the maps that will be created
         */
        String MAP_NAME = "sitemap.xml";
        String PROD_MAP_NAME = "sitemap-products_";
        String CAT_MAP_NAME = "sitemap-categories.xml";
        String PAGE_MAP_NAME = "sitemap-pages.xml";

        /*
         * Maximum number of products per sitemap file. If the number of products exceeds this
         * number then multiple files are created using the naming convention
         * sitemap-products_1.xml, sitemap-products_2.xml etc.
         */
        int maxProds = 20000;
        int prodMapIndex = 1;

        /*
         * Priorities to assign to URLs. 0.5 is the default.
         */
        String PRIORITY_HOME = "1";
        String PRIORITY_PROD = "0.75";
        String PRIORITY_CAT = "0.75";
        String PRIORITY_PAGE = "0.5";

        /*
         * Change frequencies to assign to URLs. Options are: always, hourly, daily, weekly,
         * monthly, yearly, never
         */
        String CHANGE_FREQ_HOME = "daily";
        String CHANGE_FREQ_PROD = "daily";
        String CHANGE_FREQ_CAT = "daily";
        String CHANGE_FREQ_PAGE = "weekly";

        /*
         * Set any of the booleans to false if you don't want to create the maps
         */
        boolean createProductsMap = true;
        boolean createCategoriesMap = true;
        boolean createPageMap = true;

        // Used to format dates for the sitemap
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");

        boolean appendLog = getBoolean(appendLogStr, true, true);
        int recordFetchSize = getInt(recordFetchSizeStr, 100, true);
        if (recordFetchSize < 1)
            recordFetchSize = 1;
        int offset = 0;

        // Create the full log name
        String fullLogName = getBatchLogName(logName, appendLog);

        BufferedWriter bw = null;
        BufferedWriter sm = null;
        try
        {
            if (fullLogName != null)
            {
                File logFile = new File(fullLogName);
                bw = new BufferedWriter(new FileWriter(logFile, appendLog));
                if (appendLog)
                {
                    bw.newLine();
                    bw.write(timestampStr() + " createSitemapBatch starting");
                    bw.newLine();
                }
            }

            // Get the store base url
            storeBaseURL = getAdminConfigMgr().getConfigurationValue(
                    KKConstants.CONF_KEY_KK_BASE_URL);
            if (storeBaseURL != null && storeBaseURL.length() > 0 && !storeBaseURL.endsWith("/"))
            {
                storeBaseURL = storeBaseURL + "/";
            }
            if (bw != null)
            {
                bw.write(timestampStr() + " Store Base URL = " + storeBaseURL);
                bw.newLine();
            }

            // Get the image base url
            imgBaseURL = getAdminConfigMgr().getConfigurationValue(
                    KKConstants.CONF_KEY_IMG_BASE_URL);
            if (imgBaseURL != null && imgBaseURL.length() > 0 && !imgBaseURL.endsWith("/"))
            {
                imgBaseURL = imgBaseURL + "/";
            }
            if (bw != null)
            {
                bw.write(timestampStr() + " Image Base URL = " + imgBaseURL);
                bw.newLine();
            }

            // Get the file directory
            fileDirectory = getAdminConfigMgr().getConfigurationValue(
                    KKConstants.CONF_KEY_SITEMAP_DIRECTORY);
            if (fileDirectory != null && fileDirectory.length() > 0 && !fileDirectory.endsWith("/"))
            {
                fileDirectory = fileDirectory + "/";
            }
            if (bw != null)
            {
                bw.write(timestampStr() + " Sitemap file creation directory = " + fileDirectory);
                bw.newLine();
            }

            /*
             * Create the product map
             */
            if (createProductsMap)
            {
                /*
                 * Get the default language
                 */
                AdminLanguage lang = getAdminLanguageMgr().getDefaultLanguage();
                if (lang == null)
                {
                    throw new KKAdminException("Cannot find default language in the database");
                }

                sm = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(fileDirectory
                        + PROD_MAP_NAME + prodMapIndex + ".xml"), Charset.forName("UTF-8")
                        .newEncoder()));

                sm.write(HEADER);
                sm.newLine();
                sm.write(URLSET_PROD);
                sm.newLine();
                /*
                 * Loop through the products, only retrieving certain attributes to make the batch
                 * perform faster. Don't include disabled or invisible products.
                 */
                KKCriteria c = getNewCriteria(isMultiStoreShareProducts());
                c.setLimit(recordFetchSize);
                c.addSelectColumn(BaseProductsPeer.PRODUCTS_ID);
                c.addSelectColumn(BaseProductsPeer.PRODUCTS_LAST_MODIFIED);
                c.addSelectColumn(BaseProductsPeer.PRODUCTS_IMAGE);
                c.addSelectColumn(BaseProductsPeer.PRODUCTS_STATUS);
                c.addSelectColumn(BaseProductsPeer.PRODUCTS_INVISIBLE);
                c.add(BaseProductsPeer.PRODUCTS_STATUS, 1);
                c.add(BaseProductsPeer.PRODUCTS_INVISIBLE, 0);

                c.addJoin(BaseProductsPeer.PRODUCTS_ID, BaseProductsDescriptionPeer.PRODUCTS_ID,
                        Criteria.INNER_JOIN);
                c.addSelectColumn(BaseProductsDescriptionPeer.PRODUCTS_NAME);
                c.add(BaseProductsDescriptionPeer.LANGUAGE_ID, lang.getId());

                c.addAscendingOrderByColumn(BaseProductsPeer.PRODUCTS_ID);

                List<Record> rows = BasePeer.doSelect(c);

                boolean loop = true;
                int count = 0;
                do
                {
                    if (bw != null)
                    {
                        bw.write(timestampStr() + " Read " + rows.size() + " products");
                        bw.newLine();
                    }
                    for (int r = 0; r < rows.size(); r++)
                    {
                        int id = rows.get(r).getValue(1).asInt();
                        Date lastMod = rows.get(r).getValue(2).asDate();
                        String image = rows.get(r).getValue(3).asString();
                        String name = rows.get(r).getValue(6).asString();

                        // Remove initial slash since imgBaseURL has a trailing slash
                        if (image != null && image.length() > 0 && image.startsWith("/"))
                        {
                            image = image.substring(1);
                        }

                        if (name != null && name.length() > 0)
                        {
                            name = StringEscapeUtils.escapeXml(name);
                        }

                        sm.write(URL);
                        sm.newLine();

                        sm.write(LOC);
                        sm.write(storeBaseURL + "SelectProd.action?prodId=" + id);
                        sm.write(LOC_END);
                        sm.newLine();

                        if (lastMod != null)
                        {
                            sm.write(LASTMOD);
                            sm.write(df.format(lastMod));
                            sm.write(LASTMOD_END);
                            sm.newLine();
                        }

                        sm.write(CHANGEFREQ);
                        sm.write(CHANGE_FREQ_PROD);
                        sm.write(CHANGEFREQ_END);
                        sm.newLine();

                        sm.write(PRIORITY);
                        sm.write(PRIORITY_PROD);
                        sm.write(PRIORITY_END);
                        sm.newLine();

                        sm.write(IMAGE);
                        sm.newLine();

                        sm.write(IMAGE_LOC);
                        sm.write(imgBaseURL + image);
                        sm.write(IMAGE_LOC_END);
                        sm.newLine();

                        sm.write(IMAGE_TITLE);
                        sm.write(name);
                        sm.write(IMAGE_TITLE_END);
                        sm.newLine();

                        sm.write(IMAGE_END);
                        sm.newLine();

                        sm.write(URL_END);
                        sm.newLine();
                    }

                    count += rows.size();

                    if (rows.size() < recordFetchSize)
                    {
                        loop = false;
                    } else
                    {
                        offset += recordFetchSize;
                        c.setOffset(offset);
                        rows = BasePeer.doSelect(c);
                        if (rows.size() > 0)
                        {
                            if (count + recordFetchSize > maxProds)
                            {
                                if (bw != null)
                                {
                                    bw.write(timestampStr() + " " + fileDirectory + PROD_MAP_NAME
                                            + prodMapIndex + ".xml" + " has been created with "
                                            + count + " products");
                                    bw.newLine();
                                }

                                // End looping through products
                                sm.write(URLSET_END);
                                sm.flush();
                                sm.close();
                                sm = null;

                                // Create new file
                                count = 0;
                                prodMapIndex++;
                                sm = new BufferedWriter(new OutputStreamWriter(
                                        new FileOutputStream(fileDirectory + PROD_MAP_NAME
                                                + prodMapIndex + ".xml"), Charset.forName("UTF-8")
                                                .newEncoder()));

                                sm.write(HEADER);
                                sm.newLine();
                                sm.write(URLSET_PROD);
                                sm.newLine();
                            }
                        } else
                        {
                            loop = false;
                        }
                    }

                } while (loop);

                if (bw != null)
                {
                    bw.write(timestampStr() + " " + fileDirectory + PROD_MAP_NAME + prodMapIndex
                            + ".xml" + " has been created with " + count + " products");
                    bw.newLine();
                }

                // End looping through products
                sm.write(URLSET_END);
                sm.flush();
                sm.close();
                sm = null;
            }

            /*
             * Create the categories map
             */
            if (createCategoriesMap)
            {
                sm = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(fileDirectory
                        + CAT_MAP_NAME), Charset.forName("UTF-8").newEncoder()));
                sm.write(HEADER);
                sm.newLine();
                sm.write(URLSET);
                sm.newLine();
                /*
                 * Loop through all of the categories
                 */
                offset = 0;
                KKCriteria c = getNewCriteria(isMultiStoreShareProducts());
                c.setLimit(recordFetchSize);
                c.addSelectColumn(BaseCategoriesPeer.CATEGORIES_ID);
                c.addSelectColumn(BaseCategoriesPeer.LAST_MODIFIED);
                c.addSelectColumn(BaseCategoriesPeer.CATEGORIES_INVISIBLE);
                c.add(BaseCategoriesPeer.CATEGORIES_INVISIBLE, 0);
                c.addAscendingOrderByColumn(BaseCategoriesPeer.CATEGORIES_ID);

                List<Record> rows = BasePeer.doSelect(c);

                boolean loop = true;
                int count = 0;
                do
                {
                    if (bw != null)
                    {
                        bw.write(timestampStr() + " Read " + rows.size() + " categories");
                        bw.newLine();
                    }
                    for (int r = 0; r < rows.size(); r++)
                    {
                        int id = rows.get(r).getValue(1).asInt();
                        Date lastMod = rows.get(r).getValue(2).asDate();

                        sm.write(URL);
                        sm.newLine();

                        sm.write(LOC);
                        sm.write(storeBaseURL + "SelectCat.action?catId=" + id);
                        sm.write(LOC_END);
                        sm.newLine();

                        if (lastMod != null)
                        {
                            sm.write(LASTMOD);
                            sm.write(df.format(lastMod));
                            sm.write(LASTMOD_END);
                            sm.newLine();
                        }

                        sm.write(CHANGEFREQ);
                        sm.write(CHANGE_FREQ_CAT);
                        sm.write(CHANGEFREQ_END);
                        sm.newLine();

                        sm.write(PRIORITY);
                        sm.write(PRIORITY_CAT);
                        sm.write(PRIORITY_END);
                        sm.newLine();

                        sm.write(URL_END);
                        sm.newLine();
                    }

                    count += rows.size();

                    if (rows.size() < recordFetchSize)
                    {
                        loop = false;
                    } else
                    {
                        offset += recordFetchSize;
                        c.setOffset(offset);
                        rows = BasePeer.doSelect(c);
                    }

                } while (loop);

                if (bw != null)
                {
                    bw.write(timestampStr() + " " + fileDirectory + CAT_MAP_NAME
                            + " has been created with " + count + " categories");
                    bw.newLine();
                }

                // End looping through categories
                sm.write(URLSET_END);
                sm.flush();
                sm.close();
                sm = null;
            }

            /*
             * Sitemap for various pages
             */
            if (createPageMap)
            {
                sm = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(fileDirectory
                        + PAGE_MAP_NAME), Charset.forName("UTF-8").newEncoder()));
                sm.write(HEADER);
                sm.newLine();
                sm.write(URLSET);
                sm.newLine();

                writeSitemapPageEntry(sm, storeBaseURL + "Welcome.action", CHANGE_FREQ_HOME,
                        PRIORITY_HOME);
                writeSitemapPageEntry(sm, storeBaseURL + "AboutUs.action", CHANGE_FREQ_PAGE,
                        PRIORITY_PAGE);
                writeSitemapPageEntry(sm, storeBaseURL + "ShippingAndHandling.action",
                        CHANGE_FREQ_PAGE, PRIORITY_PAGE);
                writeSitemapPageEntry(sm, storeBaseURL + "Returns.action", CHANGE_FREQ_PAGE,
                        PRIORITY_PAGE);
                writeSitemapPageEntry(sm, storeBaseURL + "InternationalOrders.action",
                        CHANGE_FREQ_PAGE, PRIORITY_PAGE);
                writeSitemapPageEntry(sm, storeBaseURL + "PrivacyPolicy.action", CHANGE_FREQ_PAGE,
                        PRIORITY_PAGE);
                writeSitemapPageEntry(sm, storeBaseURL + "TermsOfUse.action", CHANGE_FREQ_PAGE,
                        PRIORITY_PAGE);
                writeSitemapPageEntry(sm, storeBaseURL + "Help.action", CHANGE_FREQ_PAGE,
                        PRIORITY_PAGE);
                writeSitemapPageEntry(sm, storeBaseURL + "ContactUs.action", CHANGE_FREQ_PAGE,
                        PRIORITY_PAGE);

                if (bw != null)
                {
                    bw.write(timestampStr() + " " + fileDirectory + PAGE_MAP_NAME
                            + " has been created");
                    bw.newLine();
                }

                sm.write(URLSET_END);
                sm.flush();
                sm.close();
                sm = null;
            }

            /*
             * Create the sitemap index file
             */
            sm = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(fileDirectory
                    + MAP_NAME), Charset.forName("UTF-8").newEncoder()));

            sm.write(HEADER);
            sm.newLine();
            sm.write(SITEMAPINDEX);
            sm.newLine();
            if (createProductsMap)
            {
                for (int i = 1; i < prodMapIndex + 1; i++)
                {
                    sm.write(SITEMAP);
                    sm.newLine();
                    sm.write(LOC);
                    sm.write(storeBaseURL + PROD_MAP_NAME + i + ".xml");
                    sm.write(LOC_END);
                    sm.newLine();
                    sm.write(SITEMAP_END);
                    sm.newLine();
                }
            }
            if (createCategoriesMap)
            {
                sm.write(SITEMAP);
                sm.newLine();
                sm.write(LOC);
                sm.write(storeBaseURL + CAT_MAP_NAME);
                sm.write(LOC_END);
                sm.newLine();
                sm.write(SITEMAP_END);
                sm.newLine();
            }
            if (createPageMap)
            {
                sm.write(SITEMAP);
                sm.newLine();
                sm.write(LOC);
                sm.write(storeBaseURL + PAGE_MAP_NAME);
                sm.write(LOC_END);
                sm.newLine();
                sm.write(SITEMAP_END);
                sm.newLine();
            }
            sm.write(SITEMAPINDEX_END);
            sm.flush();
            sm.close();
            sm = null;
            if (bw != null)
            {
                bw.write(timestampStr() + " " + fileDirectory + MAP_NAME + " has been created.");
                bw.newLine();
            }

            if (bw != null)
            {
                bw.write(timestampStr() + " createSitemapBatch finished");
                bw.newLine();
            }

        } finally
        {
            if (bw != null)
            {
                bw.flush();
                bw.close();
            }
            if (sm != null)
            {
                sm.flush();
                sm.close();
            }
        }
    }

    /**
     * Utility method to write a sitemap entry for a page
     * 
     * @param sm
     * @param url
     * @param changeFreq
     * @param priority
     * @throws IOException
     */
    private void writeSitemapPageEntry(BufferedWriter sm, String url, String changeFreq,
            String priority) throws IOException
    {
        sm.write(URL);
        sm.newLine();

        sm.write(LOC);
        sm.write(url);
        sm.write(LOC_END);
        sm.newLine();

        sm.write(CHANGEFREQ);
        sm.write(changeFreq);
        sm.write(CHANGEFREQ_END);
        sm.newLine();

        sm.write(PRIORITY);
        sm.write(priority);
        sm.write(PRIORITY_END);
        sm.newLine();

        sm.write(URL_END);
        sm.newLine();
    }
}