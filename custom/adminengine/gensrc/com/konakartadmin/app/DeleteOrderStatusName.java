package com.konakartadmin.app;

import com.konakartadmin.bl.KKAdmin;

/**
 *  The KonaKart Custom Engine - DeleteOrderStatusName - Generated by CreateKKAdminCustomEng
 */
@SuppressWarnings("all")
public class DeleteOrderStatusName
{
    KKAdmin kkAdminEng = null;

    /**
     * Constructor
     */
     public DeleteOrderStatusName(KKAdmin _kkAdminEng)
     {
         kkAdminEng = _kkAdminEng;
     }

     public int deleteOrderStatusName(String sessionId, int id) throws KKAdminException
     {
         return kkAdminEng.deleteOrderStatusName(sessionId, id);
     }
}