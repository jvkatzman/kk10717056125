package com.konakartadmin.app;

import com.konakartadmin.bl.KKAdmin;

/**
 *  The KonaKart Custom Engine - GetKonakartAdminPropsFilePath - Generated by CreateKKAdminCustomEng
 */
@SuppressWarnings("all")
public class GetKonakartAdminPropsFilePath
{
    KKAdmin kkAdminEng = null;

    /**
     * Constructor
     */
     public GetKonakartAdminPropsFilePath(KKAdmin _kkAdminEng)
     {
         kkAdminEng = _kkAdminEng;
     }

     public String getKonakartAdminPropsFilePath() throws KKAdminException
     {
         return kkAdminEng.getKonakartAdminPropsFilePath();
     }
}