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

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.velocity.VelocityContext;

import com.konakartadmin.app.AdminEmailOptions;
import com.konakartadmin.app.KKAdminException;
import com.konakartadmin.appif.KKAdminIf;
import com.konakartadmin.blif.AdminVelocityContextMgrIf;

/**
 * The AdminVelocityContextMgr - for Managing context Maps
 */
public class AdminVelocityContextMgr extends AdminBaseMgr implements AdminVelocityContextMgrIf
{
    /** the log */
    protected static Log log = LogFactory.getLog(AdminVelocityContextMgr.class);

    /**
     * Constructor
     * 
     * @param eng
     * @throws Exception
     */
    public AdminVelocityContextMgr(KKAdminIf eng) throws Exception
    {
        super.init(eng);
    }

    public void addToContext(VelocityContext context, KKAdminIf eng, int contextType,
            int langId, AdminEmailOptions options, int customInt, String customString) throws KKAdminException
    {
        // The default implementation does nothing except log the parameters

        if (log.isDebugEnabled())
        {
            log.debug("contextType: " + contextType + " ("
                    + contextTypeToString(contextType) + ") customInt: " + customInt
                    + " customString: " + customString + " languageId: " + langId);
        }
        
        /* Example */
        
        // Example if (contextType == TEMPLATE_MAIL_TO_CUST)
        // Example {
        // Example    com.konakartadmin.app.AdminCurrency defCurrency = eng.getDefaultCurrency();
        // Example    context.put("defaultCurrency", defCurrency);
        // Example }
                
        /* End of Example */

        // This can be removed; it's another example
        context.put("KonaKartVersion", eng.getKonaKartAdminVersion());
    }

    protected String contextTypeToString(int contextType)
    {
        switch (contextType)
        {
        case TEMPLATE_MAIL_TO_CUST:
            return "TEMPLATE_MAIL_TO_CUST";
        case SEND_NEW_PASSWORD:
            return "SEND_NEW_PASSWORD";         
        case STATUS_CHANGE_EMAIL:
            return "STATUS_CHANGE_EMAIL";         
        default:
            return "(" + contextType + ") UNDEFINED";
        }
    }
}