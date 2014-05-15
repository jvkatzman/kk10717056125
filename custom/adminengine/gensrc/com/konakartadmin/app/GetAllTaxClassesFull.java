package com.konakartadmin.app;

import com.konakartadmin.appif.*;
import com.konakartadmin.bl.KKAdmin;

/**
 *  The KonaKart Custom Engine - GetAllTaxClassesFull - Generated by CreateKKAdminCustomEng
 */
@SuppressWarnings("all")
public class GetAllTaxClassesFull
{
    KKAdmin kkAdminEng = null;

    /**
     * Constructor
     */
     public GetAllTaxClassesFull(KKAdmin _kkAdminEng)
     {
         kkAdminEng = _kkAdminEng;
     }

     public AdminTaxClass[] getAllTaxClassesFull() throws KKAdminException
     {
         return kkAdminEng.getAllTaxClassesFull();
     }
}
