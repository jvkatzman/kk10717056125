package com.konakartadmin.app;

import com.konakartadmin.appif.*;
import com.konakartadmin.bl.KKAdmin;

/**
 *  The KonaKart Custom Engine - GetAllManufacturers - Generated by CreateKKAdminCustomEng
 */
@SuppressWarnings("all")
public class GetAllManufacturers
{
    KKAdmin kkAdminEng = null;

    /**
     * Constructor
     */
     public GetAllManufacturers(KKAdmin _kkAdminEng)
     {
         kkAdminEng = _kkAdminEng;
     }

     public AdminManufacturer[] getAllManufacturers() throws KKAdminException
     {
         return kkAdminEng.getAllManufacturers();
     }
}
