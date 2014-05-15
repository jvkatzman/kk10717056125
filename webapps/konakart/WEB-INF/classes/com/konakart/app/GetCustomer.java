package com.konakart.app;

import com.konakart.appif.*;

/**
 *  The KonaKart Custom Engine - GetCustomer - Generated by CreateKKCustomEng
 */
@SuppressWarnings("all")
public class GetCustomer
{
    KKEng kkEng = null;

    /**
     * Constructor
     */
     public GetCustomer(KKEng _kkEng)
     {
         kkEng = _kkEng;
     }

     public CustomerIf getCustomer(String sessionId) throws KKException
     {
         return kkEng.getCustomer(sessionId);
     }
}