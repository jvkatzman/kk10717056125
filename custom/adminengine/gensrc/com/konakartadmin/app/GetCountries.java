package com.konakartadmin.app;

import com.konakartadmin.appif.*;
import com.konakartadmin.bl.KKAdmin;

/**
 *  The KonaKart Custom Engine - GetCountries - Generated by CreateKKAdminCustomEng
 */
@SuppressWarnings("all")
public class GetCountries
{
    KKAdmin kkAdminEng = null;

    /**
     * Constructor
     */
     public GetCountries(KKAdmin _kkAdminEng)
     {
         kkAdminEng = _kkAdminEng;
     }

     public AdminCountrySearchResult getCountries(AdminCountrySearch search, int offset, int size) throws KKAdminException
     {
         return kkAdminEng.getCountries(search, offset, size);
     }
}
