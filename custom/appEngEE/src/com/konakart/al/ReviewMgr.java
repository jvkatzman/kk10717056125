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

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringEscapeUtils;

import com.konakart.app.DataDescConstants;
import com.konakart.app.DataDescriptor;
import com.konakart.app.KKException;
import com.konakart.app.Review;
import com.konakart.app.ReviewSearch;
import com.konakart.app.Reviews;
import com.konakart.appif.DataDescriptorIf;
import com.konakart.appif.KKEngIf;
import com.konakart.appif.NameNumberIf;
import com.konakart.appif.ProductIf;
import com.konakart.appif.ReviewIf;
import com.konakart.appif.ReviewSearchIf;
import com.konakart.appif.ReviewsIf;
import com.konakart.bl.ConfigConstants;

/**
 * Contains methods to read and write product reviews.
 */
public class ReviewMgr extends BaseMgr
{
    private static final String DEFAULT_ORDER_BY = DataDescConstants.ORDER_BY_DATE_ADDED_DESCENDING;

    // Result set navigation constants
    private static final String navNext = "next";

    private static final String navBack = "back";

    private static final String navStart = "start";

    // Review Information

    private final ReviewIf[] emptyRevArray = new ReviewIf[0];

    private ReviewIf[] currentReviews;

    private ReviewIf selectedReview;

    private int totalNumberOfReviews;

    private int[] ratingQuantity = new int[5];

    private int[] ratingPercentage = new int[5];

    // Data descriptor info
    private DataDescriptorIf dataDesc = new DataDescriptor();

    // Review Search
    private ReviewSearchIf revSearch = new ReviewSearch();

    private int currentOffset;

    private int currentPage;

    private int showNext;

    private int showBack;

    private long revTimestamp = 0;

    /*
     * This value is set to true when a customer attempts to navigate an old page of reviews which
     * he got to using the browser back button.
     */
    private boolean expiredResultSet = false;

    private ArrayList<Integer> pageList = new ArrayList<Integer>();

    // Max rows defined by the user
    private int maxRowsUser = 0;

    // Total number of pages in a result set
    private int numPages = 0;

    // Show reviews tab in prod details page
    private boolean showTab = false;

    /** The object containing all of the static data for this instance of the Review Manager */
    private StaticData sd = null;

    /** Hash Map that contains the static data */
    private static Map<String, StaticData> staticDataHM = Collections
            .synchronizedMap(new HashMap<String, StaticData>());

    /**
     * Constructor
     * 
     * @param eng
     * @param kkAppEng
     * @throws KKException
     */
    protected ReviewMgr(KKEngIf eng, KKAppEng kkAppEng) throws KKException
    {
        this.eng = eng;
        this.kkAppEng = kkAppEng;
        sd = staticDataHM.get(kkAppEng.getStoreId());
        if (sd == null)
        {
            sd = new StaticData();
            staticDataHM.put(kkAppEng.getStoreId(), sd);
        }
        this.reset();
    }

    /**
     * Refresh the configuration variables. This is called automatically at a regular interval.
     * 
     * @throws KKException
     * 
     */
    public void refreshConfigs() throws KKException
    {
        if (kkAppEng.getConfig(ConfigConstants.MAX_DISPLAY_PAGE_LINKS) != null)
        {
            sd.setMaxPageLinks(new Integer(kkAppEng
                    .getConfig(ConfigConstants.MAX_DISPLAY_PAGE_LINKS)).intValue());
        } else
        {
            sd.setMaxPageLinks(5);
        }

        if (kkAppEng.getConfig(ConfigConstants.MAX_DISPLAY_NEW_REVIEWS) != null)
        {
            sd.setMaxRows(new Integer(kkAppEng.getConfig(ConfigConstants.MAX_DISPLAY_NEW_REVIEWS))
                    .intValue());
        } else
        {
            sd.setMaxRows(6);
        }

        // Now the manager is ready for action
        sd.setMgrReady(true);
    }

    /**
     * Puts the ReviewContainer object back into it's original state with no reviews selected.
     * 
     * @throws KKException
     * 
     */
    public void reset() throws KKException
    {
        currentReviews = emptyRevArray;
        selectedReview = new Review();
        ratingQuantity = new int[5];
        ratingPercentage = new int[5];
        currentOffset = 0;
        showNext = 0;
        showBack = 0;
    }

    /**
     * Is the Manager Ready?
     * 
     * @return true if this manager is ready for work, otherwise returns false.
     */
    public boolean isMgrReady()
    {
        return sd.isMgrReady();
    }

    /**
     * Creates and returns a new data descriptor object with a zero offset and max rows set. It is
     * set with the default Order By.
     * 
     */
    private DataDescriptorIf createDataDesc()
    {
        // We always get an extra row in order to determine whether to show the
        // next link
        DataDescriptorIf dd = new DataDescriptor();
        dd.setLimit(getPageSize() + 1);
        dd.setOffset(0);
        dd.setOrderBy(DEFAULT_ORDER_BY);
        return dd;
    }

    /**
     * Retrieves the reviews that match the criteria in a ReviewSearch object and puts them in the
     * <code>currentReviews</code> array.
     * 
     * @param dd
     *            Used to control the data offset, limit the number of items returned and set the
     *            sort order
     * @param rs
     *            Contains information used to search for reviews
     * @return Returns a Reviews object
     * @throws KKException
     * @throws KKAppException
     */
    public ReviewsIf fetchReviews(DataDescriptorIf dd, ReviewSearchIf rs) throws KKException,
            KKAppException
    {
        this.revSearch = (rs == null) ? new ReviewSearch() : rs;
        this.dataDesc = (dd == null) ? createDataDesc() : dd;

        setDataDescOffset(navStart);

        return this.getReviews();
    }

    /**
     * This method is called to navigate through a list of reviews when the list is longer than
     * maxRows.<br>
     * <code>navDir</code> can take the following values which are retrieved using getter methods on
     * the ReviewMgr instance:
     * <ul>
     * <li>getNavNext()</li>
     * <li>getNavBack()</li>
     * <li>getNavStart()</li>
     * </ul>
     * 
     * @param navDir
     *            The navigation direction
     * @param timestamp
     *            Indicates when the result set was created. If it doesn't match the timestamp of
     *            the current result set, the operation is aborted.
     * @throws KKException
     * @throws KKAppException
     */
    public void navigateCurrentReviews(String navDir, long timestamp) throws KKException,
            KKAppException
    {
        if (timestamp != revTimestamp)
        {
            expiredResultSet = true;
            reset();
        }

        setDataDescOffset(navDir);

        getReviews();
    }

    /**
     * This method is called to change the order of a list of reviews in the currentReviews array.
     * The orderBy parameter can take a range of values. The valid orderBy values are:
     * <ul>
     * <li>DataDescConstants.ORDER_BY_DATE_ADDED</li>
     * <li>DataDescConstants.ORDER_BY_DATE_ADDED_DESCENDING</li>
     * <li>DataDescConstants.ORDER_BY_DATE_ADDED_ASCENDING</li>
     * <li>DataDescConstants.ORDER_BY_TIMES_READ</li>
     * <li>DataDescConstants.ORDER_BY_TIMES_READ_DESCENDING</li>
     * <li>DataDescConstants.ORDER_BY_TIMES_READ_ASCENDING</li>
     * <li>DataDescConstants.ORDER_BY_RATING</li>
     * <li>DataDescConstants.ORDER_BY_RATING_DESCENDING</li>
     * <li>DataDescConstants.ORDER_BY_RATING_ASCENDING</li>
     * </ul>
     * *
     * 
     * @param orderBy
     *            The order by parameter
     * @param timestamp
     *            Indicates when the result set was created. If it doesn't match the timestamp of
     *            the current result set, the operation is aborted.
     * @throws KKException
     * @throws KKAppException
     */
    public void orderCurrentReviews(String orderBy, long timestamp) throws KKException,
            KKAppException
    {
        if (timestamp != revTimestamp)
        {
            expiredResultSet = true;
            reset();
        }

        setDataDescOffset(navStart);

        if (orderBy != null)
        {
            dataDesc.setOrderBy(orderBy);
        }

        this.getReviews();
    }

    /**
     * It calls the engine to get reviews matching the current search criteria.
     * 
     * @throws KKException
     * @throws KKAppException
     */
    private ReviewsIf getReviews() throws KKException, KKAppException
    {
        if (kkAppEng.getProductMgr().getSelectedProduct() == null)
        {
            ReviewsIf ret = new Reviews();
            ret.setTotalNumReviews(0);
            ret.setReviewArray(new Review[0]);
            return ret;           
        }

        // Create a time stamp for this result set
        revTimestamp = System.currentTimeMillis();

        ReviewsIf r = eng.getReviews(dataDesc, revSearch);
        currentReviews = r.getReviewArray();
        totalNumberOfReviews = r.getTotalNumReviews();

        // Update the product cached on the session
        ProductIf prod = kkAppEng.getProductMgr().getSelectedProduct();
        if (prod != null && revSearch != null & prod.getId() == revSearch.getProductId())
        {
            prod.setNumberReviews(totalNumberOfReviews);
            prod.setRating(r.getAverageRating());
        }

        createRatingFacets(r);

        pageList = getPages( /* currentPage */
        currentPage);

        if (currentReviews != null)
        {
            // We always attempt to fetch back maxRows + 1
            if (currentReviews.length > getPageSize())
            {
                this.showNext = 1;
            } else
            {
                this.showNext = 0;
            }
        }

        if (currentOffset > 0)
        {
            this.showBack = 1;
        } else
        {
            this.showBack = 0;
        }

        return r;
    }

    /**
     * Set the ratingFacets attribute of the manager
     * 
     * @param revs
     */
    private void createRatingFacets(ReviewsIf revs)
    {
        if (revs.getRatingFacets() != null)
        {
            int[] qFacets = new int[5];
            int[] pFacets = new int[5];
            for (int i = 0; i < qFacets.length; i++)
            {
                qFacets[i] = -1;
                pFacets[i] = -1;
            }
            int totalRevs = 0;
            for (int i = 0; i < revs.getRatingFacets().length; i++)
            {
                NameNumberIf nn = revs.getRatingFacets()[i];
                totalRevs += nn.getNumber();
            }
            int index = 0;
            for (int i = 0; i < revs.getRatingFacets().length; i++)
            {
                NameNumberIf nn = revs.getRatingFacets()[i];
                index = Integer.parseInt(nn.getName()) - 1;
                qFacets[index] = nn.getNumber();
                pFacets[index] = (int) Math.round((100.0 * nn.getNumber()) / totalRevs);
            }
            for (int i = 0; i < qFacets.length; i++)
            {
                if (qFacets[i] == -1)
                {
                    qFacets[i] = 0;
                }
                if (pFacets[i] == -1)
                {
                    pFacets[i] = 0;
                }
            }
            this.ratingQuantity = qFacets;
            this.ratingPercentage = pFacets;
        } else
        {
            this.ratingQuantity = new int[5];
            this.ratingPercentage = new int[5];
        }
    }

    /**
     * Based on the action we are being asked to perform and the current offset, we set the new
     * offset before going to the engine to ask for more reviews.
     * 
     * @param action
     * @throws KKAppException
     */
    private void setDataDescOffset(String action) throws KKAppException
    {
        // Determine whether we've passed in a page number
        int requestedPage = -1;
        try
        {
            requestedPage = Integer.parseInt(action);
        } catch (NumberFormatException e)
        {
        }

        if (action.equals(navStart))
        {
            dataDesc.setOffset(0);
            currentOffset = 0;
            currentPage = 1;
        } else if (action.equals(navNext))
        {
            currentOffset += getPageSize();
            dataDesc.setOffset(currentOffset);
            currentPage = (currentOffset / getPageSize()) + 1;
        } else if (action.equals(navBack))
        {
            currentOffset -= getPageSize();
            if (currentOffset < 0)
            {
                currentOffset = 0;
            }
            dataDesc.setOffset(currentOffset);
            currentPage = (currentOffset / getPageSize()) + 1;
        } else if (requestedPage > 0)
        {
            currentOffset = getPageSize() * (requestedPage - 1);
            dataDesc.setOffset(currentOffset);
            currentPage = requestedPage;
        } else if (requestedPage <= 0)
        {
            currentOffset = 0;
            dataDesc.setOffset(currentOffset);
            currentPage = 1;
        } else
        {
            throw new KKAppException(
                    "The navigation direction parameter has an unrecognised value of " + action);
        }
    }

    /**
     * Sets selectedReview by finding it within the currentReviews array. It throws an exception if
     * the review cannot be found.
     * 
     * @param revId
     *            The id of the selected review
     * @throws KKException
     * @throws KKAppException
     */
    public void fetchReviewDetails(int revId) throws KKException, KKAppException
    {
        // Get the review from the currentReviews array and set selectedReview
        for (int i = 0; i < currentReviews.length; i++)
        {
            if (currentReviews[i].getId() == revId)
            {
                selectedReview = currentReviews[i];
                kkAppEng.getProductMgr().fetchSelectedProduct(selectedReview.getProductId());
                return;
            }
        }
        // If the review isn't found, then we try to fetch it by id
        ReviewIf rev = eng.getReview(revId);
        if (rev != null)
        {
            selectedReview = rev;
            kkAppEng.getProductMgr().fetchSelectedProduct(selectedReview.getProductId());
            return;
        }

        selectedReview = null;
    }

    /**
     * Format the description in order to truncate it and to split up very long words which could
     * ruin the page formatting. If stringLength is set to zero, then it only truncates long words
     * and doesn't truncate the string. If the description supplied is null, null is returned.
     * 
     * @param desc
     *            The description to be formatted
     * @param wordLength
     *            The maximum word length
     * @param stringLength
     *            The maximum string length
     * @return Return a truncated description
     */
    public String truncateDesc(String desc, int wordLength, int stringLength)
    {
        // int stringLength = 100;
        // int wordLength = 60;

        if (desc == null)
        {
            return null;
        }

        String truncatedStr = desc;

        if (stringLength > 0)
        {
            if (desc.length() > stringLength)
            {
                truncatedStr = desc.substring(0, stringLength);
                truncatedStr += "...";
            }
        }

        String[] s = truncatedStr.split(" ");
        StringBuffer out = new StringBuffer();
        for (int i = 0; i < s.length; i++)
        {
            if (s[i].length() > wordLength)
            {
                boolean loop = true;
                int start = 0;
                int end = wordLength;
                while (loop)
                {
                    out.append(s[i].substring(start, end) + "-<br>");
                    start += wordLength;
                    if (end + wordLength <= s[i].length())
                    {
                        end += wordLength;
                    } else
                    {
                        end = s[i].length();
                        out.append(s[i].substring(start, end) + " ");
                        loop = false;
                    }
                }
            } else
            {
                out.append(s[i] + " ");
            }
        }

        return out.toString();
    }

    /**
     * Returns the number of reviews currently retrieved.
     * 
     * @return Returns the number of reviews currently retrieved.
     */
    public int getNumberOfReviews()
    {
        // We attempt to fetch 1 more record than the number in maxRows so that
        // we can determine whether to show the next button. However, the JSP
        // should only show the number of records displayed which is limited to
        // maxRows within the JSP itself
        if (currentReviews.length == getPageSize() + 1)
        {
            return getPageSize();
        }
        return currentReviews.length;
    }

    /**
     * Save a review in the database.
     * 
     * @param reviewText
     *            the text to put into the review
     * @param rating
     *            the rating for the review
     * @param customerId
     *            id of the customer writing the review
     * @return returns the id of the review that was created
     * @throws KKException
     */
    public int writeReview(String reviewText, int rating, int customerId) throws KKException
    {
        ReviewIf rev = new Review();
        rev.setRating(rating);

        if (reviewText != null)
        {
            reviewText = StringEscapeUtils.escapeHtml4(reviewText);
        }
        rev.setReviewText(reviewText);

        rev.setProductId(kkAppEng.getProductMgr().getSelectedProduct().getId());
        rev.setLanguageId(kkAppEng.getLangId());
        rev.setCustomerId(customerId);
        return eng.writeReview(kkAppEng.getSessionId(), rev);
    }

    /**
     * Returns the currentOffset in the review array.
     * 
     * @return Returns the currentOffset.
     */
    public int getCurrentOffset()
    {
        return currentOffset;
    }

    /**
     * Returns an array of currentReviews.
     * 
     * @return Returns the currentReviews.
     */
    public ReviewIf[] getCurrentReviews()
    {
        return currentReviews;
    }

    /**
     * Maximum number of reviews to show in a list.
     * 
     * @return Returns the maxRows.
     */
    public int getMaxRows()
    {
        return sd.getMaxRows();
    }

    /**
     * Show the back button if set to 1. Don't show the back button if set to 0.
     * 
     * @return Returns the showBack.
     */
    public int getShowBack()
    {
        return showBack;
    }

    /**
     * Show the next button if set to 1. Don't show the next button if set to 0.
     * 
     * @return Returns the showNext.
     */
    public int getShowNext()
    {
        return showNext;
    }

    /**
     * Returns the selectedReview.
     * 
     * @return Returns the selectedReview.
     */
    public ReviewIf getSelectedReview()
    {
        return selectedReview;
    }

    /**
     * Static string - navigate backwards. It is the string required to pass to the
     * navigateCurrentReviews() as the <code>navdir</code> attribute when navigating backwards.
     * 
     * @return Returns the navBack.
     */
    public String getNavBack()
    {
        return navBack;
    }

    /**
     * Static string - navigate forwards. It is the string required to pass to the
     * navigateCurrentReviews() as the <code>navdir</code> attribute when navigating forwards.
     * 
     * @return Returns the navNext.
     */
    public String getNavNext()
    {
        return navNext;
    }

    /**
     * Static string - navigate to the start. It is the string required to pass to the
     * navigateCurrentReviews() as the <code>navdir</code> attribute when navigating to the start.
     * 
     * @return Returns the navStart.
     */
    public String getNavStart()
    {
        return navStart;
    }

    /**
     * Returns the totalNumberOfReviews.
     * 
     * @return Returns the totalNumberOfReviews.
     */
    public int getTotalNumberOfReviews()
    {
        return totalNumberOfReviews;
    }

    /**
     * @return the dataDesc
     */
    public DataDescriptorIf getDataDesc()
    {
        return dataDesc;
    }

    /**
     * @param dataDesc
     *            the dataDesc to set
     */
    public void setDataDesc(DataDescriptorIf dataDesc)
    {
        this.dataDesc = dataDesc;
    }

    /**
     * Used to set a user defined maximum number of reviews displayed on a page. When set to a
     * number greater than zero, this value is used instead of the value in the configuration
     * variable MAX_DISPLAY_NEW_REVIEWS.
     * 
     * @param num
     */
    public void setPageSize(int num)
    {
        if (getPageSize() != num)
        {
            currentOffset = 0;
        }
        maxRowsUser = num;
    }

    /**
     * Used to get the maximum number of reviews to display. The value is customizable by the
     * customer.
     * 
     * @return Returns the maximum number of reviews to display
     */
    public int getPageSize()
    {
        if (maxRowsUser > 0)
        {
            return maxRowsUser;
        }
        return sd.getMaxRows();
    }

    /**
     * Get an array list of pages to show
     * 
     * @param _currentPage
     * @return Returns an array List of pages to show
     */
    private ArrayList<Integer> getPages(int _currentPage)
    {
        numPages = totalNumberOfReviews / getPageSize();
        if (totalNumberOfReviews % getPageSize() != 0)
        {
            numPages++;
        }

        pageList.clear();

        return getPages(_currentPage, numPages, sd.getMaxPageLinks(), pageList);
    }

    /**
     * @return the numPages
     */
    public int getNumPages()
    {
        return numPages;
    }

    /**
     * @param numPages
     *            the numPages to set
     */
    public void setNumPages(int numPages)
    {
        this.numPages = numPages;
    }

    /**
     * @return the currentPage
     */
    public int getCurrentPage()
    {
        return currentPage;
    }

    /**
     * @param currentPage
     *            the currentPage to set
     */
    public void setCurrentPage(int currentPage)
    {
        this.currentPage = currentPage;
    }

    /**
     * @return the pageList
     */
    public ArrayList<Integer> getPageList()
    {
        return pageList;
    }

    /**
     * @param pageList
     *            the pageList to set
     */
    public void setPageList(ArrayList<Integer> pageList)
    {
        this.pageList = pageList;
    }

    /**
     * @return the revSearch
     */
    public ReviewSearchIf getRevSearch()
    {
        return revSearch;
    }

    /**
     * @param revSearch
     *            the revSearch to set
     */
    public void setRevSearch(ReviewSearchIf revSearch)
    {
        this.revSearch = revSearch;
    }

    /**
     * An array of 5 ints where index 0 contains the number of products for reviews with a 1 star
     * rating and index 4 contains the number of products for reviews with a 5 star rating.
     * 
     * @return the ratingQuantity
     */
    public int[] getRatingQuantity()
    {
        return ratingQuantity;
    }

    /**
     * An array of 5 ints where index 0 contains the number of products for reviews with a 1 star
     * rating and index 4 contains the number of products for reviews with a 5 star rating.
     * 
     * @param ratingQuantity
     *            the ratingQuantity to set
     */
    public void setRatingQuantity(int[] ratingQuantity)
    {
        this.ratingQuantity = ratingQuantity;
    }

    /**
     * An array of 5 ints where index 0 contains the percentage of products for reviews with a 1
     * star rating and index 4 contains the percentage of products for reviews with a 5 star rating.
     * 
     * @return the ratingPercentage
     */
    public int[] getRatingPercentage()
    {
        return ratingPercentage;
    }

    /**
     * An array of 5 ints where index 0 contains the percentage of products for reviews with a 1
     * star rating and index 4 contains the percentage of products for reviews with a 5 star rating.
     * 
     * @param ratingPercentage
     *            the ratingPercentage to set
     */
    public void setRatingPercentage(int[] ratingPercentage)
    {
        this.ratingPercentage = ratingPercentage;
    }

    /**
     * A timestamp for when the last review search was done. Used to detect whether a result set is
     * old when paging.
     * 
     * @return the revTimestamp
     */
    public long getRevTimestamp()
    {
        return revTimestamp;
    }

    /**
     * A timestamp for when the last review search was done. Used to detect whether a result set is
     * old when paging.
     * 
     * @param revTimestamp
     *            the revTimestamp to set
     */
    public void setRevTimestamp(long revTimestamp)
    {
        this.revTimestamp = revTimestamp;
    }

    /**
     * @return the expiredResultSet
     */
    public boolean isExpiredResultSet()
    {
        return expiredResultSet;
    }

    /**
     * @return the showTab
     */
    public boolean isShowTab()
    {
        return showTab;
    }

    /**
     * @param showTab
     *            the showTab to set
     */
    public void setShowTab(boolean showTab)
    {
        this.showTab = showTab;
    }

    /**
     * Used to store the static data of this manager
     */
    private class StaticData
    {
        // is the manager ready?
        boolean mgrReady = false;

        int maxRows;

        int maxPageLinks;

        /**
         * @return Returns the maxRows.
         */
        public int getMaxRows()
        {
            return maxRows;
        }

        /**
         * @param maxRows
         *            The maxRows to set.
         */
        public void setMaxRows(int maxRows)
        {
            this.maxRows = maxRows;
        }

        /**
         * @return the mgrReady
         */
        public boolean isMgrReady()
        {
            return mgrReady;
        }

        /**
         * @param mgrReady
         *            the mgrReady to set
         */
        public void setMgrReady(boolean mgrReady)
        {
            this.mgrReady = mgrReady;
        }

        /**
         * @return the maxPageLinks
         */
        public int getMaxPageLinks()
        {
            return maxPageLinks;
        }

        /**
         * @param maxPageLinks
         *            the maxPageLinks to set
         */
        public void setMaxPageLinks(int maxPageLinks)
        {
            this.maxPageLinks = maxPageLinks;
        }

    }
}
