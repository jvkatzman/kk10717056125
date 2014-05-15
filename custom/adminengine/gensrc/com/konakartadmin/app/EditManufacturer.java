package com.konakartadmin.app;

import com.konakartadmin.appif.*;
import com.konakartadmin.bl.KKAdmin;

/**
 *  The KonaKart Custom Engine - EditManufacturer - Generated by CreateKKAdminCustomEng
 */
@SuppressWarnings("all")
public class EditManufacturer
{
    KKAdmin kkAdminEng = null;

    /**
     * Constructor
     */
     public EditManufacturer(KKAdmin _kkAdminEng)
     {
         kkAdminEng = _kkAdminEng;
     }

     public void editManufacturer(String sessionId, AdminManufacturer manu) throws KKAdminException
     {
         kkAdminEng.editManufacturer(sessionId, manu);
     }
}
