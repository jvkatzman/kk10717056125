//
// (c) 2006 DS Data Systems UK Ltd, All rights reserved.
//
// DS Data Systems and KonaKart and their respective logos, are 
// trademarks of DS Data Systems UK Ltd. All rights reserved.
//
// The information in this document is the proprietary property of
// DS Data Systems UK Ltd. and is protected by English copyright law,
// the laws of foreign jurisdictions, and international treaties,
// as applicable. No part of this document may be reproduced,
// transmitted, transcribed, transferred, modified, published, or
// translated into any language, in any form or by any means, for
// any purpose other than expressly permitted by DS Data Systems UK Ltd.
// in writing.
//
package com.konakart.importer.xml;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.lang.reflect.InvocationTargetException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import org.apache.commons.lang.exception.ExceptionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.konakart.app.KKException;
import com.konakart.importer.xml.app.AdminProductsXML;
import com.konakart.util.KKConstants;
import com.konakartadmin.app.AdminDataDescriptor;
import com.konakartadmin.app.AdminEngineConfig;
import com.konakartadmin.app.AdminProduct;
import com.konakartadmin.app.AdminProductSearch;
import com.konakartadmin.app.AdminProducts;
import com.konakartadmin.app.KKAdminException;
import com.konakartadmin.appif.KKAdminIf;
import com.konakartadmin.ws.KKAdminEngineMgr;

/**
 * Creates the KonaKart objects from XML files and calls the KonaKart engine to import them
 */
public class ImportXml
{
    /** the log */
    protected static Log log = LogFactory.getLog(ImportXml.class);

    static final String usage = "Usage: ImportXml\n"
            + "     -i  import-file-name       - import file name                               \n"
            + "     -o  output-file-name       - file to report details about the import        \n"
            + "    [-u  username]              - username                                       \n"
            + "    [-p  password]              - password                                       \n"
            + "    [-s  storeId]               - storeId                                        \n"
            + "    [-se sessionId]             - sessionId                                      \n"
            + "    [-e  (0|1|2)]               - engine mode                                    \n"
            + "    [-c]                        - shared customers - default is not shared       \n"
            + "    [-ps]                       - shared products - default is not shared        \n"
            + "    [-cs]                       - shared categories - default is not shared      \n"
            + "    [-ae adminengine classname] - default is com.konakartadmin.bl.KKAdmin        \n"
            + "    [-pr propsFilename]         - default is konakartadmin.properties            \n"
            + "    [-?]                        - shows this usage information                   \n";

    // Properties filename to use
    private String propsFileName = KKConstants.KONAKARTADMIN_PROPERTIES_FILE;

    // StoreId
    private String storeId = KKConstants.KONAKART_DEFAULT_STORE_ID;

    // Username
    private String username = "admin@konakart.com";

    // Password
    private String password = "princess";

    // Admin Engine Classname
    private String adminEngineClassname = "com.konakartadmin.bl.KKAdmin";

    // Import file name
    private String importFileName = null;

    // Output file name
    private String outputFileName = null;

    // Engine Mode
    private int engineMode = 0;

    // customers Shared ?
    private boolean customersShared = false;

    // products Shared ?
    private boolean productsShared = false;

    // categories Shared ?
    private boolean categoriesShared = false;

    /** The Admin Engine */
    private KKAdminIf adminEng = null;

    /** The Session Id */
    private String sessionId = null;

    // Writer for log file
    private BufferedWriter bw = null;

    /** Log file timestamp formatter */
    private SimpleDateFormat logTimestampFormat = null;

    /**
     * Empty Constructor
     */
    public ImportXml()
    {
    }

    /**
     * Constructor
     * 
     * @param adminEng
     */
    public ImportXml(KKAdminIf adminEng)
    {
        this.adminEng = adminEng;
    }

    /**
     * @param args
     */
    public static void main(String[] args)
    {
        new ImportXml().importXml(args);
    }

    /**
     * Import the XML Data
     * 
     * @param args
     *            command line arguments
     * @return a String describing the success/failure of the method
     */
    public String importXml(String[] args)
    {
        if (args != null && args.length > 0 && args[0] != null && args[0].equals("-?"))
        {
            System.out.println("\n" + usage);
            return usage;
        }

        if (args == null || args.length < 4)
        {
            System.out.println("Insufficient arguments:\n\n" + usage);
            return usage;
        }

        for (int a = 0; a < args.length; a++)
        {
            if (args[a].equals("-i"))
            {
                setImportFileName(args[a + 1]);
                a++;
            } else if (args[a].equals("-o"))
            {
                setOutputFileName(args[a + 1]);
                a++;
            } else if (args[a].equals("-u"))
            {
                setUsername(args[a + 1]);
                a++;
            } else if (args[a].equals("-p"))
            {
                setPassword(args[a + 1]);
                a++;
            } else if (args[a].equals("-s"))
            {
                setStoreId(args[a + 1]);
                a++;
            } else if (args[a].equals("-se"))
            {
                setSessionId(args[a + 1]);
                a++;
            } else if (args[a].equals("-ae"))
            {
                setAdminEngineClassname(args[a + 1]);
                a++;
            } else if (args[a].equals("-e"))
            {
                setEngineMode(Integer.parseInt(args[a + 1]));
                a++;
            } else if (args[a].equals("-c"))
            {
                setCustomersShared(true);
            } else if (args[a].equals("-ps"))
            {
                setProductsShared(true);
            } else if (args[a].equals("-cs"))
            {
                setCategoriesShared(true);
            } else if (args[a].equals("-pr"))
            {
                setPropsFileName(args[a + 1]);
                a++;
            } else if (args[a].equals("-?"))
            {
                System.out.println("\n" + usage);
                return usage;
            } else
            {
                String msg = "Unknown argument: " + args[a] + "\n" + usage;
                System.out.println(msg);
                return msg;
            }
        }

        if (isProductsShared() && !isCustomersShared())
        {
            String msg = "Illegal Mode Specified.  "
                    + "If you specify shared products you must also specify shared customers\n"
                    + usage;
            System.out.println(msg);
            return msg;
        }

        if (isCategoriesShared() && !isProductsShared())
        {
            String msg = "Illegal Mode Specified.  "
                    + "If you specify shared categories you must also specify shared products\n"
                    + usage;
            System.out.println(msg);
            return msg;
        }

        if (getImportFileName() == null)
        {
            String msg = "No Import file name specified \n" + usage;
            System.out.println(msg);
            return msg;
        }

        if (getOutputFileName() == null)
        {
            String msg = "No Output file name specified \n" + usage;
            System.out.println(msg);
            return msg;
        }

        return importXml(getSessionId(), getImportFileName(), getOutputFileName());
    }

    /**
     * Import of KonaKart Data from XML files
     * <p>
     * Currently this Importer only supports Product XML files.
     * <p>
     * It will import data only if all the referenced objects are present (eg.. manufacturer ids,
     * language ids etc)
     * <p>
     * For products it will not import duplicates. It will determine if the product to be imported
     * is already present by comparing the product SKU. If it's present, no import is executed.
     * 
     * @param sessionId1
     * @param dataFilename
     * @param logFilename
     * @return a String describing the success/failure of the method
     */
    public String importXml(String sessionId1, String dataFilename, String logFilename)
    {
        try
        {
            long startTime = System.currentTimeMillis();

            // Set up the output file for logging

            bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(logFilename),
                    "UTF-8"));

            // Create an Admin Engine
            if (getAdminEng() == null)
            {
                setAdminEng(getAnEng());
            }

            // Get a session
            if (getSessionId() == null)
            {
                if (sessionId1 != null)
                {
                    setSessionId(sessionId1);
                } else
                {
                    if (getUsername() == null)
                    {
                        throw new KKAdminException("Failed to login user not specified");
                    }
                    if (getPassword() == null)
                    {
                        throw new KKAdminException("Failed to login password not specified");
                    }
                    setSessionId(getAdminEng().login(getUsername(), getPassword()));
                    writeInfo("importXml() Username          " + getUsername());
                    writeInfo("importXml() Created SessionId " + getSessionId());

                    if (getSessionId() == null)
                    {
                        throw new KKAdminException("Failed to login user " + getUsername()
                                + " to store " + storeId);
                    }
                }
            }

            writeInfo("Import " + dataFilename);

            boolean result = importXmlFile(dataFilename); // returns true if there are no problems

            long timeTaken = (System.currentTimeMillis() - startTime) / 1000;
            if (result)
            {
                String msg = "importXml() Imported data successfully - Total Time Taken = "
                        + timeTaken + "s";
                writeInfo(msg);
                return msg;
            } else
            {
                String msg = "importXml() Failed to import data successfully";
                writeWarning(msg);
                return msg;
            }
        } catch (Throwable e)
        {
            String msg = "importXml() Failed to import data successfully";
            writeWarning(msg);
            e.printStackTrace();
            write(ExceptionUtils.getStackTrace(e));
            return msg;
        } finally
        {
            if (bw != null)
            {
                try
                {
                    bw.close();
                } catch (IOException e)
                {
                    // No recovery
                }
            }
        }
    }

    /**
     * Import of KonaKart Data from XML file
     * <p>
     * This should inspect the file and determine what kind of XML data is contained.. then import
     * that type of data. Currently this Importer only supports Product XML files.
     * 
     * @param dataFilename
     * @return true if the import was successful, otherwise false
     * @throws KKException
     * @throws IOException
     * @throws KKAdminException
     * @throws JAXBException
     */
    public boolean importXmlFile(String dataFilename) throws KKException, IOException,
            KKAdminException, JAXBException
    {
        return importProducts(dataFilename);
    }

    /**
     * All the products in the specified XML file are imported.
     * 
     * @param dataFilename
     * @return true if the import was successful, otherwise false
     * @throws KKAdminException
     * @throws IOException
     * @throws JAXBException
     * @throws KKException
     */
    private boolean importProducts(String dataFilename) throws KKAdminException, IOException,
            JAXBException, KKException
    {
        writeInfo("Import Products from " + dataFilename);

        File prodPath = new File(dataFilename);
        if (!prodPath.exists())
        {
            writeWarning("The specified file does not exist : " + dataFilename);
            return false;
        }

        FileInputStream fis = null;
        InputStreamReader in = null;

        /*
         * Import all of the products. Insert them or edit existing one
         */
        try
        {
            JAXBContext context = JAXBContext.newInstance(AdminProductsXML.class);
            Unmarshaller u = context.createUnmarshaller();

            fis = new FileInputStream(dataFilename);
            in = new InputStreamReader(fis, "UTF-8");

            AdminProductsXML prodX = (AdminProductsXML) u.unmarshal(in);
            return importProducts(prodX);

        } catch (Exception e)
        {
            writeWarning("Could not import products from file " + dataFilename);
            writeWarning(ExceptionUtils.getStackTrace(e));
            return false;
        } finally
        {
            if (in != null)
            {
                in.close();
            }
            if (fis != null)
            {
                fis.close();
            }
        }
    }

    /**
     * All the products in the specified XML file are imported.
     * 
     * @param prodX
     *            an object containing the products to import
     * @return true if the import was successful, otherwise false
     * @throws KKAdminException
     * @throws IOException
     * @throws JAXBException
     * @throws KKException
     */
    private boolean importProducts(AdminProductsXML prodX) throws KKAdminException, IOException,
            JAXBException, KKException
    {
        int count = 0;

        for (int p = 0; p < prodX.getProducts().length; p++)
        {
            AdminProduct prod = prodX.getProducts()[p];
            try
            {
                if (insertProduct(prod))
                {
                    count++;
                }
            } catch (KKAdminException e)
            {
                writeWarning("Could not import product with Model name = " + prod.getModel());
                writeWarning(ExceptionUtils.getStackTrace(e));
            } catch (Exception e)
            {
                writeWarning("Unrecognised Exception importing product with Model name = "
                        + prod.getModel());
                writeWarning(ExceptionUtils.getStackTrace(e));
                return false;
            }
        }

        writeInfo("importProducts() Imported " + count + " products successfully");
        return true;
    }

    /**
     * Insert the product if we don't find one with the same SKU
     * 
     * @param prod
     * @throws KKAdminException
     * @throws KKException
     * @throws IOException
     * @return true if the product was inserted succesfully otherwise false
     */
    private boolean insertProduct(AdminProduct prod) throws KKAdminException, KKException,
            IOException
    {
        if (log.isInfoEnabled())
        {
            writeline();
        }

        // Check whether a product exists for this SKU
        if (prod.getSku() != null && prod.getSku().length() > 0)
        {
            AdminProductSearch search = new AdminProductSearch();
            search.setSku(prod.getSku());
            AdminDataDescriptor dd = new AdminDataDescriptor(AdminDataDescriptor.ORDER_BY_ID, 0,
                    100);
            dd.setShowInvisible(true);
            AdminProducts prods = getAdminEng().searchForProducts(getSessionId(), dd, search, -1);
            if (prods != null && prods.getTotalNumProducts() >= 1)
            {
                writeInfo("insertProduct() Product with SKU " + prod.getSku()
                        + " already exists and will not be imported");
                return false;
            }
        }

        // Insert the product

        writeDebug("insertProduct() Insert product with Model = " + prod.getModel());
        int newProdId = getAdminEng().insertProduct(getSessionId(), prod);
        writeDebug("insertProduct() Inserted product as Id = " + newProdId);
        return true;
    }

    private KKAdminIf getAnEng() throws KKAdminException, IllegalArgumentException,
            InstantiationException, IllegalAccessException, ClassNotFoundException,
            InvocationTargetException
    {
        if (getAdminEng() != null)
        {
            return getAdminEng();
        }

        AdminEngineConfig engConf = new AdminEngineConfig();
        engConf.setMode(getEngineMode());
        engConf.setPropertiesFileName(getPropsFileName());
        engConf.setStoreId(getStoreId());
        engConf.setCustomersShared(isCustomersShared());
        engConf.setProductsShared(isProductsShared());
        engConf.setCategoriesShared(isCategoriesShared());

        writeDebug("getAnEng() " + engConf.toString());

        return new KKAdminEngineMgr().getKKAdminByName(getAdminEngineClassname(), engConf);
    }

    private void writeline() throws IOException
    {
        String LINE = "-----------------------------------------";
        write(LINE + LINE + LINE);
    }

    private void write(String str)
    {
        try
        {
            if (bw != null)
            {
                bw.write(str + "\n");
            }
        } catch (Exception e)
        {
            // Quite unexpected
            System.err.print(e);
        }
    }

    private void writeDebug(String str)
    {
        if (log.isDebugEnabled())
        {
            log.debug(str);
        }

        write(logTimeStamp() + " DEBUG:   " + str);
    }

    private void writeInfo(String str)
    {
        if (log.isInfoEnabled())
        {
            log.info(str);
        }
        write(logTimeStamp() + " INFO:    " + str);
    }

    private void writeWarning(String str)
    {
        if (log.isWarnEnabled())
        {
            log.warn(str);
        }
        write(logTimeStamp() + " WARNING: " + str);
    }

    private String logTimeStamp()
    {
        return getLogTimestampFormat().format(new Date());
    }

    private SimpleDateFormat getLogTimestampFormat()
    {
        if (logTimestampFormat == null)
        {
            logTimestampFormat = new SimpleDateFormat("dd-MMM HH:mm.ss");
        }

        return logTimestampFormat;
    }

    /**
     * @return the adminEng
     */
    public KKAdminIf getAdminEng()
    {
        return adminEng;
    }

    /**
     * @param adminEng
     *            the adminEng to set
     */
    public void setAdminEng(KKAdminIf adminEng)
    {
        this.adminEng = adminEng;
    }

    /**
     * @return the sessionId
     */
    public String getSessionId()
    {
        return sessionId;
    }

    /**
     * @param sessionId
     *            the sessionId to set
     */
    public void setSessionId(String sessionId)
    {
        this.sessionId = sessionId;
    }

    /**
     * @return the propsFileName
     */
    public String getPropsFileName()
    {
        return propsFileName;
    }

    /**
     * @param propsFileName
     *            the propsFileName to set
     */
    public void setPropsFileName(String propsFileName)
    {
        this.propsFileName = propsFileName;
    }

    /**
     * @return the storeId
     */
    public String getStoreId()
    {
        return storeId;
    }

    /**
     * @param storeId
     *            the storeId to set
     */
    public void setStoreId(String storeId)
    {
        this.storeId = storeId;
    }

    /**
     * @return the username
     */
    public String getUsername()
    {
        return username;
    }

    /**
     * @param username
     *            the username to set
     */
    public void setUsername(String username)
    {
        this.username = username;
    }

    /**
     * @return the password
     */
    public String getPassword()
    {
        return password;
    }

    /**
     * @param password
     *            the password to set
     */
    public void setPassword(String password)
    {
        this.password = password;
    }

    /**
     * @return the adminEngineClassname
     */
    public String getAdminEngineClassname()
    {
        return adminEngineClassname;
    }

    /**
     * @param adminEngineClassname
     *            the adminEngineClassname to set
     */
    public void setAdminEngineClassname(String adminEngineClassname)
    {
        this.adminEngineClassname = adminEngineClassname;
    }

    /**
     * @return the importFileName
     */
    public String getImportFileName()
    {
        return importFileName;
    }

    /**
     * @param importFileName
     *            the importFileName to set
     */
    public void setImportFileName(String importFileName)
    {
        this.importFileName = importFileName;
    }

    /**
     * @return the outputFileName
     */
    public String getOutputFileName()
    {
        return outputFileName;
    }

    /**
     * @param outputFileName
     *            the outputFileName to set
     */
    public void setOutputFileName(String outputFileName)
    {
        this.outputFileName = outputFileName;
    }

    /**
     * @return the engineMode
     */
    public int getEngineMode()
    {
        return engineMode;
    }

    /**
     * @param engineMode
     *            the engineMode to set
     */
    public void setEngineMode(int engineMode)
    {
        this.engineMode = engineMode;
    }

    /**
     * @return the customersShared
     */
    public boolean isCustomersShared()
    {
        return customersShared;
    }

    /**
     * @param customersShared
     *            the customersShared to set
     */
    public void setCustomersShared(boolean customersShared)
    {
        this.customersShared = customersShared;
    }

    /**
     * @return the productsShared
     */
    public boolean isProductsShared()
    {
        return productsShared;
    }

    /**
     * @param productsShared
     *            the productsShared to set
     */
    public void setProductsShared(boolean productsShared)
    {
        this.productsShared = productsShared;
    }

    /**
     * @return the categoriesShared
     */
    public boolean isCategoriesShared()
    {
        return categoriesShared;
    }

    /**
     * @param categoriesShared
     *            the categoriesShared to set
     */
    public void setCategoriesShared(boolean categoriesShared)
    {
        this.categoriesShared = categoriesShared;
    }
}
