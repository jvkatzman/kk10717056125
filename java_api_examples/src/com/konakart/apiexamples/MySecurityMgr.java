package com.konakart.apiexamples;

import java.util.List;

import org.apache.torque.TorqueException;
import org.apache.torque.util.BasePeer;

import com.konakart.app.KKException;
import com.konakart.appif.CustomerRegistrationIf;
import com.konakart.appif.KKEngIf;
import com.konakart.bl.KKCriteria;
import com.konakart.bl.SecurityMgrEE;
import com.konakart.blif.SecurityMgrIf;
import com.konakart.om.BaseSessionsPeer;
import com.workingdogs.village.DataSetException;
import com.workingdogs.village.Record;

/**
 * An example of how to customize the Enterprise Extensions security manager in order to implement
 * SSO. The konakart.properties file must be edited so that the customized manager is used rather
 * than the standard one:
 * 
 * konakart.manager.SecurityMgr = com.konakart.bl.MySecurityMgr
 */
public class MySecurityMgr extends SecurityMgrEE implements SecurityMgrIf
{
    /**
     * Constructor
     * 
     * @param eng
     * @throws Exception
     */
    public MySecurityMgr(KKEngIf eng) throws Exception
    {
        super(eng);
    }

    /**
     * This method overrides the standard login method and is used to log a customer into KonaKart
     * and so generate a sessionId which can be used in the API calls. In order to determine whether
     * the customer is logged in, we call the SSO system using the SSO token. Once we've got a
     * sessionId, we save the SSO token in the session table so that we can retrieve it in the
     * checkSession() method when we need to determine whether the customer is still logged in.
     * 
     * Note that the SSO token is passed in using the emailAddr parameter and the password parameter
     * isn't used.
     * 
     * @param emailAddr
     *            The token used by the SSO system
     * @param password
     *            Not used
     * @return Returns a valid session or null if the login fails
     * @throws Exception
     */
    public String login(String emailAddr, String password) throws Exception
    {
        // Rename emailAddr to token for clarity.
        String token = emailAddr;

        /*
         * Check that the customer is logged in. This is a call to an SSO system using the token. It
         * should return an identifier for the user if he is logged in (i.e. eMail address),
         * otherwise null.
         */
        String userId = null;
        // userId = callSSO(token); //This is the external call to the SSO system
        if (userId == null)
        {
            return null;
        }

        /*
         * If we are using internal customer data, then the userId should be the KonaKart userId
         * which is the email address of the user. Otherwise we should be able to look up customer
         * data using this user id in order to register the customer as a temporary customer.
         */
        // userId = registerCustomerWithExternalData(userId);
        /*
         * We log in the user (with the password set to null) in order to get a session Id. The
         * checkCredentials() method of the LoginIntegrationMgr should always return a positive
         * number so that KonaKart does not attempt to check credentials.
         */
        @SuppressWarnings("unused")
        String sessionId = login(userId, null);

        if (sessionId == null)
        {
            return null;
        }

        /*
         * Now we need to save the SSO token on the session so that we can retrieve it for the
         * checkSession() API call. We'll save it in the Custom1 attribute.
         */
        addCustomDataToSession(sessionId, token, 1);

        // Return the session id
        return sessionId;
    }

    /**
     * This method overrides the standard checkSession method in order to use the SSO system. We get
     * the SSO token from the session and call the SSO system to check the token. If the customer is
     * logged in, then we get the customer Id from the session and return it. Otherwise an exception
     * is thrown.
     * 
     * @param sessionId
     * @return Returns customerId
     * @throws TorqueException
     * @throws DataSetException
     * @throws KKException
     */
    public int checkSession(String sessionId) throws TorqueException, DataSetException, KKException
    {
        checkRequired(sessionId, "String", "sessionId");

        /*
         * We need to get the SSO token from the sessionId. It was saved in the Custom1 attribute of
         * the session in the loginSSO() method, so we must retrieve it from there.
         */
        String token = getCustomDataFromSession(sessionId, 1);

        if (token == null || token.length() == 0)
        {
            throw new KKException("An SSO token cannot be found for the session " + sessionId);
        }

        boolean isLoggedIn = false;
        // isLoggedIn = callSSO(token); //This is the external call to the SSO system

        if (!isLoggedIn)
        {
            throw new KKException("The session " + sessionId + " has expired");
        }

        /*
         * At this point we know that the customer is logged in so we just need to get the customer
         * id from the session since we need to return it. It is saved in the Value attribute in
         * String format.
         */

        KKCriteria c = getNewCriteria(isMultiStoreShareCustomers());
        c.addSelectColumn(BaseSessionsPeer.CUSTOMER_ID);
        c.add(BaseSessionsPeer.SESSKEY, sessionId);

        List<Record> rows = BasePeer.doSelect(c);

        if (rows.isEmpty())
        {
            throw new KKException("The session " + sessionId + " cannot be found");
        }
        Record rec = rows.get(0);
        String custIdStr = rec.getValue(1).asString();

        return Integer.parseInt(custIdStr);
    }

    /**
     * This method is used to look up customer data from an external system which is required to
     * perform a checkout process. This data is used to temporarily register the customer and this
     * temporary registration can be performed every time the login call is used in order to always
     * use the most up to date data.
     * 
     * @param userId
     *            An identifier that can be used to look up customer data externally
     * @return Returns the userId (emailAddr) of the registered customer
     * @throws Exception
     */
    @SuppressWarnings({ "unused", "null" })
    private String registerCustomerWithExternalData(String userId) throws Exception
    {
        CustomerRegistrationIf custReg = null;
        /*
         * Create a CustomerRegistration object from external data
         */
        // custReg = getDataFromExternalSystem(userId);
        getCustMgr().forceRegisterCustomer(custReg);

        return custReg.getEmailAddr();
    }
}
