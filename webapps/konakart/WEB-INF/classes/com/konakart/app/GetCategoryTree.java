package com.konakart.app;

import com.konakart.appif.*;

/**
 *  The KonaKart Custom Engine - GetCategoryTree - Generated by CreateKKCustomEng
 */
@SuppressWarnings("all")
public class GetCategoryTree
{
    KKEng kkEng = null;

    /**
     * Constructor
     */
     public GetCategoryTree(KKEng _kkEng)
     {
         kkEng = _kkEng;
     }

     public CategoryIf[] getCategoryTree(int languageId, boolean getNumProducts) throws KKException
     {
         return kkEng.getCategoryTree(languageId, getNumProducts);
     }
}
