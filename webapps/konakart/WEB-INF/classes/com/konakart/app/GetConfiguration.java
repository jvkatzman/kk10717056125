package com.konakart.app;

import com.konakart.appif.*;

/**
 *  The KonaKart Custom Engine - GetConfiguration - Generated by CreateKKCustomEng
 */
@SuppressWarnings("all")
public class GetConfiguration
{
    KKEng kkEng = null;

    /**
     * Constructor
     */
     public GetConfiguration(KKEng _kkEng)
     {
         kkEng = _kkEng;
     }

     public KKConfigurationIf getConfiguration(String key) throws KKException
     {
         return kkEng.getConfiguration(key);
     }
}
