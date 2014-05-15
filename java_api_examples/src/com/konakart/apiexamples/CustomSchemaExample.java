//
// (c) 2006 DS Data Systems UK Ltd, All rights reserved.
//
// DS Data Systems and KonaKart and their respective logos, are 
// trademarks of DS Data Systems UK Ltd. All rights reserved.
//
// The information in this document is free software; you can redistribute 
// it and/or modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
// 
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
package com.konakart.apiexamples;

import java.util.Iterator;
import java.util.List;

import org.apache.torque.util.BasePeer;
import org.apache.torque.util.UniqueList;

import com.konakart.bl.KKCriteria;
import com.konakart.bl.KKRecord;
import com.konakart.om.BaseCustomCustomerPeer;
import com.konakart.om.CustomCustomer;
import com.workingdogs.village.Record;
import com.workingdogs.village.DataSetException;

/**
 * This class shows how to call objects defined in the Custom Schema
 */
public class CustomSchemaExample extends BaseApiExample
{
    private static final String usage = "Usage: CustomSchemaExample\n" + COMMON_USAGE;

    /**
     * @param args
     */
    public static void main(String[] args)
    {
        parseArgs(args, usage, 0);

        try
        {
            /*
             * Get an instance of the Admin KonaKart engine and login. The method called can be
             * found in BaseApiExample.java
             */
            init();

            // Make a select query to retrieve all the customers...

            KKCriteria c = new KKCriteria();

            c.addSelectColumn(BaseCustomCustomerPeer.CUSTOMERS_ID);
            c.addSelectColumn(BaseCustomCustomerPeer.CUSTOMERS_FIRSTNAME);
            c.addSelectColumn(BaseCustomCustomerPeer.CUSTOMERS_LASTNAME);
            c.addSelectColumn(BaseCustomCustomerPeer.STORE_ID);

            List<Record> rows = BasePeer.doSelect(c);

            if (rows.isEmpty())
            {
                System.out.println("No customers found");
            } else
            {
                System.out.println(rows.size() + " customers found:");

                CustomCustomer[] custList = new CustomCustomer[rows.size()];

                int i = 0;
                for (Iterator<Record> iter = rows.iterator(); iter.hasNext();)
                {
                    CustomCustomer myCust = getNewCustomCustomer(iter.next(), c);
                    System.out.println("\t" + myCust.getCustomersFirstname() + " "
                            + myCust.getCustomersLastname());
                }
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
    }

    private static CustomCustomer getNewCustomCustomer(Record vr, KKCriteria c) throws DataSetException
    {
        CustomCustomer cust = new CustomCustomer();
        
        // Create a KKRecord from the Village Record
        KKRecord r = new KKRecord(vr);

        UniqueList colList = c.getSelectColumns();

        for (int i = 0; i < colList.size();)
        {
            String colName = (String) colList.get(i++);

            if (colName.equals(BaseCustomCustomerPeer.CUSTOMERS_ID))
            {
                cust.setCustomersId(r.getValue(i).asInt());
            } else if (colName.equals(BaseCustomCustomerPeer.CUSTOMERS_FIRSTNAME))
            {
                cust.setCustomersFirstname(r.getValue(i).asString());
            } else if (colName.equals(BaseCustomCustomerPeer.CUSTOMERS_LASTNAME))
            {
                cust.setCustomersLastname(r.getValue(i).asString());
            } else if (colName.equals(BaseCustomCustomerPeer.STORE_ID))
            {
                cust.setStoreId(r.getValue(i).asString());
            }
        }
        
        return cust;
    }

    protected static String getUsage()
    {
        return usage;
    }
}