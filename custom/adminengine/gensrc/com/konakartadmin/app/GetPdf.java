package com.konakartadmin.app;

import com.konakartadmin.appif.*;
import com.konakart.app.*;
import com.konakartadmin.bl.KKAdmin;

/**
 *  The KonaKart Custom Engine - GetPdf - Generated by CreateKKAdminCustomEng
 */
@SuppressWarnings("all")
public class GetPdf
{
    KKAdmin kkAdminEng = null;

    /**
     * Constructor
     */
     public GetPdf(KKAdmin _kkAdminEng)
     {
         kkAdminEng = _kkAdminEng;
     }

     public PdfResult getPdf(String sessionId, PdfOptions options) throws KKAdminException
     {
         return kkAdminEng.getPdf(sessionId, options);
     }
}
