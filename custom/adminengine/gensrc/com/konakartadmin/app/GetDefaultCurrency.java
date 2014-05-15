package com.konakartadmin.app;

import com.konakartadmin.appif.*;
import com.konakartadmin.bl.KKAdmin;

/**
 *  The KonaKart Custom Engine - GetDefaultCurrency - Generated by CreateKKAdminCustomEng
 */
@SuppressWarnings("all")
public class GetDefaultCurrency
{
    KKAdmin kkAdminEng = null;

    /**
     * Constructor
     */
     public GetDefaultCurrency(KKAdmin _kkAdminEng)
     {
         kkAdminEng = _kkAdminEng;
     }

     public AdminCurrency getDefaultCurrency() throws KKAdminException
     {
         return kkAdminEng.getDefaultCurrency();
     }
}