package com.konakartadmin.app;

import com.konakartadmin.appif.*;
import com.konakartadmin.bl.KKAdmin;

/**
 *  The KonaKart Custom Engine - GetManufacturers - Generated by CreateKKAdminCustomEng
 */
@SuppressWarnings("all")
public class GetManufacturers
{
    KKAdmin kkAdminEng = null;

    /**
     * Constructor
     */
     public GetManufacturers(KKAdmin _kkAdminEng)
     {
         kkAdminEng = _kkAdminEng;
     }

     public AdminManufacturerSearchResult getManufacturers(String sessionId, AdminManufacturerSearch search, int offset, int size) throws KKAdminException
     {
         return kkAdminEng.getManufacturers(sessionId, search, offset, size);
     }
}
