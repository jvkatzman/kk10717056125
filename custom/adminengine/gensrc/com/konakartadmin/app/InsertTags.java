package com.konakartadmin.app;

import com.konakartadmin.appif.*;
import com.konakartadmin.bl.KKAdmin;

/**
 *  The KonaKart Custom Engine - InsertTags - Generated by CreateKKAdminCustomEng
 */
@SuppressWarnings("all")
public class InsertTags
{
    KKAdmin kkAdminEng = null;

    /**
     * Constructor
     */
     public InsertTags(KKAdmin _kkAdminEng)
     {
         kkAdminEng = _kkAdminEng;
     }

     public int insertTags(String sessionId, AdminTag[] tags) throws KKAdminException
     {
         return kkAdminEng.insertTags(sessionId, tags);
     }
}
