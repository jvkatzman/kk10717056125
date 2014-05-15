package com.konakartadmin.app;

import com.konakartadmin.appif.*;
import com.konakartadmin.bl.KKAdmin;

/**
 *  The KonaKart Custom Engine - InsertCategory - Generated by CreateKKAdminCustomEng
 */
@SuppressWarnings("all")
public class InsertCategory
{
    KKAdmin kkAdminEng = null;

    /**
     * Constructor
     */
     public InsertCategory(KKAdmin _kkAdminEng)
     {
         kkAdminEng = _kkAdminEng;
     }

     public int insertCategory(String sessionId, AdminCategory cat) throws KKAdminException
     {
         return kkAdminEng.insertCategory(sessionId, cat);
     }
}