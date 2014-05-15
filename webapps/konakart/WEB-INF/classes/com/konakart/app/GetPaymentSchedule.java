package com.konakart.app;

import com.konakart.appif.*;

/**
 *  The KonaKart Custom Engine - GetPaymentSchedule - Generated by CreateKKCustomEng
 */
@SuppressWarnings("all")
public class GetPaymentSchedule
{
    KKEng kkEng = null;

    /**
     * Constructor
     */
     public GetPaymentSchedule(KKEng _kkEng)
     {
         kkEng = _kkEng;
     }

     public PaymentScheduleIf getPaymentSchedule(int id) throws KKException
     {
         return kkEng.getPaymentSchedule(id);
     }
}