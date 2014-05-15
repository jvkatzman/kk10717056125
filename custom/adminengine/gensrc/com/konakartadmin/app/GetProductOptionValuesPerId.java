package com.konakartadmin.app;

import com.konakartadmin.appif.*;
import com.konakartadmin.bl.KKAdmin;

/**
 *  The KonaKart Custom Engine - GetProductOptionValuesPerId - Generated by CreateKKAdminCustomEng
 */
@SuppressWarnings("all")
public class GetProductOptionValuesPerId
{
    KKAdmin kkAdminEng = null;

    /**
     * Constructor
     */
     public GetProductOptionValuesPerId(KKAdmin _kkAdminEng)
     {
         kkAdminEng = _kkAdminEng;
     }

     public AdminProductOptionValue[] getProductOptionValuesPerId(String sessionId, int productOptionValueId) throws KKAdminException
     {
         return kkAdminEng.getProductOptionValuesPerId(sessionId, productOptionValueId);
     }
}
