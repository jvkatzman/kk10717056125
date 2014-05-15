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

import com.konakart.app.MqOptions;
import com.konakart.appif.MqOptionsIf;
import com.konakart.appif.OrderIf;

/**
 * This class shows how to call the KonaKart API to post an order on a java message queue. Before
 * running you may have to edit BaseApiExample.java to change the username and password used to log
 * into the engine. The default values are doe@konakart.com / password .
 */
public class MqPostOrderOnQueue extends BaseApiExample
{
    private static final String usage = "Usage: MqPostOrderOnQueue\n" + COMMON_USAGE;

    /**
     * @param args
     */
    public static void main(String[] args)
    {
        OrderIf order = null;

        try
        {
            // First we'll insert an order
            InsertOrder myInsertOrder = new InsertOrder();
            order = myInsertOrder.insertOrder(args, usage);
        } catch (Exception e)
        {
            System.out.println("There was a problem Inserting an Order");
            e.printStackTrace();
            System.exit(2);
            return;
        }

        try
        {
            MqOptionsIf options = new MqOptions();
            options.setQueueName(getKonaKartConfig("mq.orders.queue"));
            options.setBrokerUrl(getKonaKartConfig("mq.broker.uri"));
            options.setUsername(getKonaKartConfig("mq.username"));
            options.setPassword(getKonaKartConfig("mq.password"));

            options.setMsgText("Order: " + order.getId() + " for " + order.getCustomerName());
            eng.postMessageToQueue(sessionId, options);

            System.out.println("Message Posted Successfully");
        } catch (Exception e)
        {
            System.out.println("There was a problem Posting an Order on the Queue");
            e.printStackTrace();
        }
    }
}
