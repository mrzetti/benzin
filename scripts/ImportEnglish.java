import com.jpexs.decompiler.flash.SWF;
import com.jpexs.decompiler.flash.configuration.Configuration;
import com.jpexs.decompiler.flash.importers.TextImporter;
import com.jpexs.decompiler.flash.importers.ImageImporter;
import com.jpexs.decompiler.flash.tags.base.*;
import java.awt.Font;
import java.awt.Color;
import java.awt.RenderingHints;
import javax.imageio.ImageIO;
import java.io.*;
import java.nio.file.*;

// Fail the build on import errors; embed missing Latin glyphs using an installed
// sans-serif font rather than silently dropping letters absent from the SWF.
class ImportEnglish {
    public static void main(String[] args) throws Exception {
        Configuration.resetLetterSpacingOnTextImport.set(true);
        SWF swf;
        try (var in = new FileInputStream(args[0])) { swf = new SWF(in, false, "UTF-8"); }
        // The original subset fonts carry French-specific spacing and lack
        // several English glyphs. Re-embed a complete, consistent Latin set.
        for (int id : new int[]{239, 249, 414}) {
            FontTag font = swf.getFont(id);
            swf.sourceFontNamesMap.put(id, "Liberation Sans Bold");
            Font latin = new Font("Liberation Sans", Font.BOLD, 1024);
            for (char c = 32; c < 127; c++) {
                if (!font.addCharacter(c, latin)) throw new IllegalStateException("Cannot embed " + c);
            }
        }
        var importer = new TextImporter(new MissingCharacterHandler() {
            public boolean handle(TextTag text, FontTag font, char character) {
                Font fallback = new Font("Liberation Sans", font.isBold() ? Font.BOLD : Font.PLAIN, 1024);
                if (!fallback.canDisplay(character)) throw new IllegalStateException("Missing glyph " + character);
                return font.addCharacter(character, fallback);
            }
        }, new TextImportErrorHandler() {
            public boolean handle(TextTag text) { throw new IllegalStateException("Text import failed: " + text); }
            public boolean handle(TextTag text, String message, long line) { throw new IllegalStateException(message); }
        });
        importer.importTextsMultipleFiles(args[2], swf);
        if (!String.join("", swf.getText(250).getTexts()).trim().equals("PLAY")) {
            throw new IllegalStateException("English PLAY label was not imported");
        }
        // The historical album announcement is raster artwork, not a text tag.
        var imageTag = swf.getImage(233);
        var image = imageTag.getImageCached().getBufferedImage();
        var graphics = image.createGraphics();
        graphics.copyArea(378, 220, 210, 100, 0, -135);
        graphics.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
        graphics.setColor(Color.WHITE);
        graphics.setFont(new Font("Liberation Sans", Font.BOLD, 24));
        graphics.drawString("NEW ALBUM", 403, 118);
        graphics.setFont(new Font("Liberation Sans", Font.BOLD, 20));
        graphics.drawString("OUT 28 OCTOBER", 390, 168);
        graphics.dispose();
        var png = new ByteArrayOutputStream();
        ImageIO.write(image, "png", png);
        new ImageImporter().importImage(imageTag, png.toByteArray());
        try (var out = new FileOutputStream(args[1])) { swf.saveTo(out); }
    }
}
