package com.konakartadmin.apiexamples;

import org.xhtmlrenderer.pdf.ITextRenderer;

import com.konakartadmin.appif.KKAdminIf;
import com.konakartadmin.bl.AdminPdfMgr;
import com.konakartadmin.blif.AdminPdfMgrIf;

/**
 * An example of how to customize the Enterprise Extensions PDF manager in order to modify some of
 * the PDF processing. The konakartadmin.properties file must be edited so that the customized
 * manager is used rather than the standard one:
 * 
 * konakart.admin_manager.AdminPdfMgr = com.konakartadmin.bl.MyPdfMgr
 */
public class MyPdfMgr extends AdminPdfMgr implements AdminPdfMgrIf
{
    /**
     * Constructor
     * 
     * @param eng
     * @throws Exception
     */
    public MyPdfMgr(KKAdminIf eng) throws Exception
    {
        super(eng);
    }

    /**
     * Render the HTML and return the ITextRenderer object for further processing
     * 
     * @param html
     * @return the ITextRenderer object that contains the parsed HTML document
     */
    public ITextRenderer renderHtml(String html)
    {
        ITextRenderer renderer = new ITextRenderer();

        RTLTextReplacedElementFactory repFactory = new RTLTextReplacedElementFactory(renderer
                .getOutputDevice(), "arabic");
        renderer.getSharedContext().setReplacedElementFactory(repFactory);

        renderer.setDocumentFromString(html);
        renderer.layout();

        return renderer;
    }
}
