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

import com.konakart.app.Basket;
import com.konakart.app.Booking;
import com.konakart.app.OrderStatusHistory;
import com.konakart.app.OrderUpdate;
import com.konakart.app.ProductSearch;
import com.konakart.appif.BasketIf;
import com.konakart.appif.CustomerIf;
import com.konakart.appif.DataDescriptorIf;
import com.konakart.appif.OrderIf;
import com.konakart.appif.OrderStatusHistoryIf;
import com.konakart.appif.OrderUpdateIf;
import com.konakart.appif.PaymentDetailsIf;
import com.konakart.appif.ProductSearchIf;
import com.konakart.appif.ProductsIf;
import com.konakart.appif.ShippingQuoteIf;
import com.konakart.util.KKConstants;

/**
 * This class shows how to call the KonaKart API to create some bookings.
 */
public class CreateBookings extends BaseApiExample
{
    private static final String usage = "Usage: CreateBookings\n" + COMMON_USAGE;

    // Order status of Pending
    private static int PENDING = 1;

    // Order status of Processing
    private static int PROCESSING = 2;

    /**
     * @param args
     */
    public static void main(String[] args)
    {
        try
        {
            /*
             * Parse the command line arguments
             */
            parseArgs(args, usage, 0);

            /*
             * Get an instance of the KonaKart engine and login. The method called can be found in
             * BaseApiExample.java
             */
            init();

            // get the customer
            CustomerIf cust = eng.getCustomer(sessionId);
            if (cust == null)
            {
                System.out.println("Cannot create a booking.  No customer called doe@konakart.com");
                return;
            }
            int custId = cust.getId();

            // Find a bookable product to order
            ProductSearchIf prodSearch = new ProductSearch();
            prodSearch.setProductType(KKConstants.BOOKABLE_PRODUCT_TYPE);
            DataDescriptorIf dataDesc = null;
            ProductsIf prods = getEng().searchForProducts(sessionId, dataDesc, prodSearch,
                    DEFAULT_LANGUAGE);
            if (prods.getTotalNumProducts() == 0)
            {
                System.out.println("Cannot create a booking.  No bookable products found");
                return;
            }
            int prodId = prods.getProductArray()[0].getId();

            // create an order
            BasketIf basketItem = new Basket();

            // Set the product id for the basket item
            basketItem.setProductId(prodId);

            // Set the quantity of products to buy
            basketItem.setQuantity(1);

            // Add this basket item to the basket
            eng.addToBasket(sessionId, 0, basketItem);

            /*
             * Now we can get the engine to create an order for us.
             */
            // Retrieve the basket items from the engine. We need to save them and then read them
            // back, because the engine populates many attributes that are required to create the
            // order
            BasketIf[] items = eng.getBasketItemsPerCustomer(sessionId, 0, DEFAULT_LANGUAGE);

            // Get an order from the engine by passing it the basket items. Note that this order is
            // not yet saved to the DB since the shipping and payment information is missing.
            OrderIf order = eng.createOrder(sessionId, items, DEFAULT_LANGUAGE);

            /*
             * Normally we would get an order from the engine at the beginning of the checkout
             * process. As the customer chooses the shipping method and the payment type, more
             * information is added to the order which may affect the total order amount.
             */

            // Get shipping quotes for the order and choose the first one in the list for this order
            ShippingQuoteIf[] sQuotes = eng.getShippingQuotes(order, DEFAULT_LANGUAGE);
            if (sQuotes != null && sQuotes.length > 0)
            {
                order.setShippingQuote(sQuotes[0]);
            }

            // Get payment gateways / types available for the order and choose the first one in the
            // list for this order
            PaymentDetailsIf[] pGateways = eng.getPaymentGateways(order, DEFAULT_LANGUAGE);
            if (pGateways != null && pGateways.length > 0)
            {
                order.setPaymentDetails(pGateways[0]);
            }

            /*
             * Now that the order has been completed with all necessary information we can ask the
             * engine to calculate the order totals. We send it the order and receive back the same
             * order which includes order totals that the customer may check before confirming.
             */
            order = eng.getOrderTotals(order, DEFAULT_LANGUAGE);

            /*
             * We set the status of the order which it should have when first saved. In our default
             * DB, a status id == 1, means that the order is pending. i.e. it has been saved, but no
             * other action has been taken.
             */
            order.setStatus(PENDING);

            /*
             * The order has an array of OrderStatusHistory objects which track the various states
             * that an order may pass through, throughout its lifecycle. In all effects it keeps an
             * audit trail. We must set the first item in this array to say that it is in the
             * pending state. We may also add a comment such as "waiting for payment" to make it
             * obvious what needs to be done next.
             */
            OrderStatusHistoryIf status = new OrderStatusHistory();
            status.setOrderStatusId(PENDING);
            status.setUpdatedById(order.getCustomerId());
            status.setComments("Waiting for Payment");

            OrderStatusHistoryIf[] statusArray = new OrderStatusHistoryIf[]
            { status };
            order.setStatusTrail(statusArray);

            // The order has custom fields which may be set with custom information.
            order.setCustom1("custom1");
            order.setCustom5("custom5");

            // Now , finally the order can be saved.
            int orderId = eng.saveOrder(sessionId, order, DEFAULT_LANGUAGE);

            /*
             * Let's now assume that we have just received an instant payment notification from a
             * payment gateway to say that the order has been paid. When this happens we need to
             * change the state of the order to reflect the payment, and we may want to update the
             * inventory to reduce the stock level of the product that has been ordered.
             */

            // Change the status. This call changes the status and adds an element to the status
            // trail.

            OrderUpdateIf updateOrder = new OrderUpdate();
            updateOrder.setUpdatedById(order.getCustomerId());

            eng.updateOrder(sessionId, orderId, PROCESSING, /* Notify customer */false,
                    "Payment Received... now process the order", updateOrder);

            // Update the inventory
            eng.updateInventory(sessionId, orderId);

            System.out.println("Order " + orderId + " created");

            // Read the order the customer just made
            order = getEng().getOrder(sessionId, orderId, DEFAULT_LANGUAGE);

            // Add 3 bookings
            Booking booking1 = new Booking();
            booking1.setCustomerId(custId);
            booking1.setProductId(prodId);
            booking1.setQuantity(1);
            booking1.setFirstName(cust.getFirstName());
            booking1.setLastName(cust.getLastName());
            booking1.setCustom1("custom1_1");
            booking1.setCustom2("custom2_1");
            booking1.setCustom3("custom3_1");
            booking1.setOrderId(orderId);
            booking1.setOrderProductId(order.getOrderProducts()[0].getId());
            int bookingId1 = getEng().insertBooking(sessionId, booking1, null);

            System.out.println("Inserted booking " + bookingId1);

            Booking booking2 = new Booking();
            booking2.setCustomerId(custId);
            booking2.setProductId(prodId);
            booking2.setQuantity(2);
            booking2.setFirstName(cust.getFirstName() + "_2");
            booking2.setLastName(cust.getLastName() + "_2");
            booking2.setCustom1("custom1_2");
            booking2.setCustom2("custom2_2");
            booking2.setCustom3("custom3_2");
            booking2.setOrderId(orderId);
            booking2.setOrderProductId(order.getOrderProducts()[0].getId());
            int bookingId2 = getEng().insertBooking(sessionId, booking2, null);

            System.out.println("Inserted booking " + bookingId2);

            Booking booking3 = new Booking();
            booking3.setCustomerId(custId);
            booking3.setProductId(prodId);
            booking3.setQuantity(3);
            booking3.setFirstName(cust.getFirstName() + "_3");
            booking3.setLastName(cust.getLastName() + "_3");
            booking3.setCustom1("custom1_3");
            booking3.setCustom2("custom2_3");
            booking3.setCustom3("custom3_3");
            booking3.setOrderId(orderId);
            booking3.setOrderProductId(order.getOrderProducts()[0].getId());
            int bookingId3 = getEng().insertBooking(sessionId, booking3, null);

            System.out.println("Inserted booking " + bookingId3);

        } catch (Exception e)
        {
            e.printStackTrace();
        }
    }
}
