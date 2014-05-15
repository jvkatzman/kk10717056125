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
import com.konakart.appif.MqResponseIf;

/**
 * This class shows how to read an order from a java message queue.
 */
public class MqReadOrdersFromQueue extends BaseApiExample
{
    private static final String usage = "Usage: MqReadOrdersFromQueue\n" + COMMON_USAGE;

    /**
     * @param args
     */
    public static void main(String[] args)
    {
        final String HORIZ_LINE = "--------------------------------------------------------------";

        try
        {
            parseArgs(args, usage, 0);

            /*
             * Get an instance of the KonaKart engine and login. The method called can be found in
             * BaseApiExample.java
             */
            init();

            boolean moreMessages = true;

            MqOptionsIf options = new MqOptions();
            options.setQueueName(getKonaKartConfig("mq.orders.queue"));
            options.setBrokerUrl(getKonaKartConfig("mq.broker.uri"));
            options.setUsername(getKonaKartConfig("mq.username"));
            options.setPassword(getKonaKartConfig("mq.password"));
            options.setTimeoutMS(4000L);

            int msgCount = 0;
            System.out.println(HORIZ_LINE);

            do
            {
                MqResponseIf response = eng.readMessageFromQueue(sessionId, options);

                if (response.isTimedout())
                {
                    System.out.println("Timeout reading message From Queue");
                    moreMessages = false;
                } else
                {
                    msgCount++;
                    System.out.println("Read Message " + msgCount + " From Queue:\n"
                            + response.toString());
                    System.out.println(HORIZ_LINE);
                }
            } while (moreMessages);
        } catch (Exception e)
        {
            System.out.println("There was a problem Reading an Order from the Queue");
            e.printStackTrace();
        }
    }
}
