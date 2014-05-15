package com.konakartadmin.apiexamples;

import java.awt.Point;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.w3c.dom.Element;
import org.xhtmlrenderer.css.style.CalculatedStyle;
import org.xhtmlrenderer.css.style.derived.RectPropertySet;
import org.xhtmlrenderer.extend.ReplacedElement;
import org.xhtmlrenderer.extend.ReplacedElementFactory;
import org.xhtmlrenderer.extend.UserAgentCallback;
import org.xhtmlrenderer.layout.LayoutContext;
import org.xhtmlrenderer.pdf.ITextFSFont;
import org.xhtmlrenderer.pdf.ITextOutputDevice;
import org.xhtmlrenderer.pdf.ITextReplacedElement;
import org.xhtmlrenderer.pdf.ITextReplacedElementFactory;
import org.xhtmlrenderer.render.BlockBox;
import org.xhtmlrenderer.render.PageBox;
import org.xhtmlrenderer.render.RenderingContext;
import org.xhtmlrenderer.simple.extend.FormSubmissionListener;

import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.ColumnText;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfWriter;

/**
 * Original Code by Askar Kalykov See:
 * https://groups.google.com/forum/#!topic/flying-saucer-users/n0CfuYfpQ6I
 * 
 * Updated by: Asset Technology Group Nasr City, Cairo, Egypt. See: http://www.asset.com.eg
 */
public class RTLTextReplacedElementFactory implements ReplacedElementFactory
{
    private String cssClassName;

    private ITextReplacedElementFactory defaultFactory;

    /**
     * @param outputDevice
     * @param cssClassName
     */
    public RTLTextReplacedElementFactory(ITextOutputDevice outputDevice, String cssClassName)
    {
        if (outputDevice == null || cssClassName == null)
        {
            throw new RuntimeException("outputDevice or cssClassName is null");
        }
        defaultFactory = new ITextReplacedElementFactory(outputDevice);
        this.cssClassName = cssClassName;
    }

    public ReplacedElement createReplacedElement(LayoutContext c, BlockBox box,
            UserAgentCallback uac, int cssWidth, int cssHeight)
    {
        Element element = box.getElement();
        if (element == null)
        {
            return null;
        }
        if (element.getAttribute("class").contains(cssClassName))
        {
            String text = element.getTextContent().replaceAll("(?m)\\s+", " ");
            return new RTLText(c, box, uac, cssWidth, cssHeight, text);
        } else
        {
            return defaultFactory.createReplacedElement(c, box, uac, cssWidth, cssHeight);
        }
    }

    public void reset()
    {
    }

    public void remove(Element e)
    {
    }

    public void setFormSubmissionListener(FormSubmissionListener listener)
    {
    }
}

class RTLText implements ITextReplacedElement
{
    private static final Logger logger = Logger.getLogger(RTLText.class.getName());

    private int width;

    private int height;

    private String text;

    private int align;

    private float fontSize = -1;

    private int direction = PdfWriter.RUN_DIRECTION_LTR;

    RTLText(LayoutContext c, BlockBox box, UserAgentCallback uac, int cssWidth, int cssHeight,
            String text)
    {
        this.text = text;
        initDimensions(c, box, cssWidth, cssHeight);

        align = com.lowagie.text.Element.ALIGN_LEFT;
        Element element = box.getElement();
        String as = element.getAttribute("align");
        {
            if (as.equalsIgnoreCase("left"))
            {
                align = com.lowagie.text.Element.ALIGN_LEFT;
            } else if (as.equalsIgnoreCase("center"))
            {
                align = com.lowagie.text.Element.ALIGN_CENTER;
            } else if (as.equalsIgnoreCase("right"))
            {
                align = com.lowagie.text.Element.ALIGN_RIGHT;
            }
        }
        as = element.getAttribute("direction");
        {
            if (as.equalsIgnoreCase("ltr"))
            {
                direction = PdfWriter.RUN_DIRECTION_LTR;
            } else if (as.equals("default"))
            {
                direction = PdfWriter.RUN_DIRECTION_DEFAULT;
            } else if (as.equals("no-bidi"))
            {
                direction = PdfWriter.RUN_DIRECTION_NO_BIDI;
            } else if (as.equals("rtl"))
            {
                direction = PdfWriter.RUN_DIRECTION_RTL;
            }
        }

        String efontSize = element.getAttribute("font-size");
        if (!efontSize.equals(""))
        {
            this.fontSize = Float.parseFloat(efontSize);
        }
    }

    public int getIntrinsicWidth()
    {
        return width;
    }

    public int getIntrinsicHeight()
    {
        return height;
    }

    private Point location = new Point();

    public Point getLocation()
    {
        return location;
    }

    public void setLocation(int x, int y)
    {
        location.x = x;
        location.y = y;
    }

    public void detach(LayoutContext c)
    {
    }

    public boolean isRequiresInteractivePaint()
    {
        return false;
    }

    public boolean hasBaseline()
    {
        return false;
    }

    public int getBaseline()
    {
        return 0;
    }

    public void paint(RenderingContext c, ITextOutputDevice outputDevice, BlockBox box)
    {
        try
        {
            PdfWriter writer = outputDevice.getWriter();
            PdfContentByte cb = writer.getDirectContent();

            ITextFSFont font = (ITextFSFont) box.getStyle().getFSFont(c);
            float pdfFontSize = outputDevice.getDeviceLength(font.getSize2D());
            if (fontSize != -1)
            {
                pdfFontSize = fontSize;
            }

            ColumnText ct = new ColumnText(cb);
            setupColumnCoordinates(c, outputDevice, box);
            ct.setSimpleColumn(llx, lly, urx, ury);
            ct.setSpaceCharRatio(PdfWriter.NO_SPACE_CHAR_RATIO);
            ct.setLeading(0, 1);
            ct.setRunDirection(direction);
            ct.setAlignment(align);

            ct
                    .addText(new Phrase(text, new Font(font.getFontDescription().getFont(),
                            pdfFontSize)));
            ct.go();

        } catch (DocumentException e)
        {
            logger.log(Level.WARN, "error while processing rtl text", e);
            e.printStackTrace();
        }
    }

    private int llx, lly, urx, ury;

    private void setupColumnCoordinates(RenderingContext c, ITextOutputDevice outputDevice,
            BlockBox box)
    {
        PageBox page = c.getPage();
        float dotsPerPoint = outputDevice.getDotsPerPoint();
        float marginBorderPaddingLeft = page.getMarginBorderPadding(c, CalculatedStyle.LEFT);
        float marginBorderPaddingBottom = page.getMarginBorderPadding(c, CalculatedStyle.BOTTOM);

        RectPropertySet margin = box.getMargin(c);
        RectPropertySet padding = box.getPadding(c);

        float dist = (page.getBottom() - box.getAbsY() + marginBorderPaddingBottom); // from box top
        // to page
        // bottom

        llx = (int) ((margin.left() + padding.left() + box.getAbsX() + marginBorderPaddingLeft) / dotsPerPoint);
        lly = (int) ((dist - box.getHeight()) / dotsPerPoint);

        urx = (int) ((box.getAbsX() + box.getWidth() + marginBorderPaddingLeft) / dotsPerPoint);
        ury = (int) ((dist + margin.bottom() + padding.bottom()) / dotsPerPoint);
    }

    protected void initDimensions(LayoutContext c, BlockBox box, int cssWidth, int cssHeight)
    {

        CalculatedStyle style = box.getStyle();

        Element element = box.getElement();
        float scalex = 0.1f;
        float scaley = 0.06f;
        int lines = 1;
        {
            String lines1 = element.getAttribute("lines");
            if (!lines1.equals(""))
            {
                lines = Integer.parseInt(lines1);
            }
        }

        String sx = element.getAttribute("scale-x");
        if (!sx.equals(""))
        {
            try
            {
                scalex = Float.parseFloat(sx);
            } catch (Exception e)
            {
                System.err.println("Bad scale-x attribute value: " + sx);
                // do nothing
            }
        }

        String sy = element.getAttribute("scale-y");
        if (!sy.equals(""))
        {
            try
            {
                scaley = Float.parseFloat(sy);
            } catch (Exception e)
            {
                System.err.println("Bad scale-y attribute value: " + sx);
                // do nothing
            }
        }
        String ewidth = element.getAttribute("width");
        if (!ewidth.equals(""))
        {
            width = Integer.parseInt(ewidth) * c.getDotsPerPixel();
        } else if (cssWidth != -1)
        {
            width = cssWidth;
        } else
        {
            width = (c.getTextRenderer().getWidth(c.getFontContext(), style.getFSFont(c), text) / 2);
        }

        String eheight = element.getAttribute("height");
        if (!eheight.equals(""))
        {
            height = Integer.parseInt(eheight) * c.getDotsPerPixel();
        } else if (cssHeight != -1)
        {
            height = cssHeight;
        } else
        {
            height = ((int) (style.getLineHeight(c) * lines));
        }

        width *= c.getDotsPerPixel() * scalex;
        height *= c.getDotsPerPixel() * scaley;
    }
}
