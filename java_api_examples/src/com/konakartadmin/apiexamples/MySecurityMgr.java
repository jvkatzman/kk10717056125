package com.konakartadmin.apiexamples;

import java.util.List;

import org.apache.torque.TorqueException;
import org.apache.torque.util.BasePeer;

import com.konakart.bl.KKCriteria;
import com.konakart.om.BaseSessionsPeer;
import com.konakartadmin.app.KKAdminException;
import com.konakartadmin.appif.KKAdminIf;
import com.konakartadmin.bl.AdminSecurityMgrEE;
import com.konakartadmin.blif.AdminSecurityMgrIf;
import com.workingdogs.village.DataSetException;
import com.workingdogs.village.Record;

/**
 * An example of how to customize the Enterprise Extensions security manager in order to implement
 * SSO. The konakartadmin.properties file must be edited so that the customized manager is used
 * rather than the standard one:
 * 
 * konakart.admin_manager.AdminSecurityMgr = com.konakartadmin.bl.MySecurityMgr
 */
public class MySecurityMgr extends AdminSecurityMgrEE implements AdminSecurityMgrIf
{

    /**
     * Constructor
     * 
     * @param eng
     * @throws Exception
     */
    public MySecurityMgr(KKAdminIf eng) throws Exception
    {
        super(eng);
    }

    /**
     * This method overrides the standard login method and is used to log a user into KonaKart Admin
     * and so generate a sessionId which can be used in the API calls. In order to determine whether
     * the user is logged in, we call the SSO system using the SSO token. Once we've got a
     * sessionId, we save the SSO token in the session table so that we can retrieve it in the
     * checkSession() method when we need to determine whether the user is still logged in.
     * 
     * Note that the SSO token is passed in using the user parameter and the password parameter
     * isn't used.
     * 
     * @param user
     *            The token used by the SSO system
     * @param password
     *            Not used
     * @return Returns a valid session or null if the login fails
     * @throws Exception
     */
    public String login(String user, String password) throws Exception
    {
        // Rename user to token for clarity.
        String token = user;

        /*
         * Check that the user is logged in. This is a call to an SSO system using the token. It
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
         * If we are using internal user data, then the userId should be the KonaKart userId which
         * is the email address of the admin user. Otherwise we should be able to look up user data
         * using this user id in order to register the admin user.
         */
        // userId = registerUserWithExternalData(userId);
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
     * the SSO token from the session and call the SSO system to check the token. If the user is
     * logged in, then we get the user Id from the session and return it. Otherwise an exception is
     * thrown.
     * 
     * @param sessionId
     * @param apiCall 
     * @return Returns userId
     * @throws Exception 
     * @throws TorqueException
     * @throws DataSetException
     * @throws KKAdminException
     */
    public int checkSession(String sessionId, String apiCall) throws Exception
    {
        checkRequired(sessionId, "String", "sessionId");

        /*
         * We need to get the SSO token from the sessionId. It was saved in the Custom1 attribute of
         * the session in the loginSSO() method, so we must retrieve it from there.
         */
        String token = getCustomDataFromSession(sessionId, 1);

        if (token == null || token.length() == 0)
        {
            throw new KKAdminException("An SSO token cannot be found for the session " + sessionId);
        }

        boolean isLoggedIn = false;
        // isLoggedIn = callSSO(token,String apiCall); //This is the external call to the SSO system

        if (!isLoggedIn)
        {
            throw new KKAdminException("The session " + sessionId + " has expired");
        }

        /*
         * At this point we know that the user is logged in so we just need to get the user id from
         * the session since we need to return it. It is saved in the Value attribute in String
         * format.
         */

        KKCriteria c = getNewCriteria(isMultiStoreShareCustomers());
        c.addSelectColumn(BaseSessionsPeer.CUSTOMER_ID);
        c.add(BaseSessionsPeer.SESSKEY, sessionId);

        List<Record> rows = BasePeer.doSelect(c);

        if (rows.isEmpty())
        {
            throw new KKAdminException("The session " + sessionId + " cannot be found");
        }
        Record rec = rows.get(0);
        String custIdStr = rec.getValue(1).asString();

        return Integer.parseInt(custIdStr);
    }

    /*
     * A few steps need to be taken:
     * <ul>
     * <li>We need to retrieve the store id and the roles from the SSO system.</li>
     * <li>Once we have the store id, we need to log into that store as a super user and register
     * the user. In some way the SSO system will have to provide a way for us to log into a
     * KKAdminEng as a super user.</li>
     * <li>From the SSO roles which will probably be strings, we need to determine which KK roles
     * they map to. This can be achieved by having the SSO role name in one of the KK Role custom
     * fields.</li>
     * <li>Once we have the roles and store, we can register the user and then add the roles to the
     * user. We may have to delete the user first if a user already exists with the same userId.</li>
     * <li></li>
     * </ul>
     * 
     * 
     * @return Returns the userId (emailAddr) of the registered user
     * @throws Exception
     */
    //
    //private String registerUserWithExternalData() throws Exception
    //{
    //    return null;
    //}
}
