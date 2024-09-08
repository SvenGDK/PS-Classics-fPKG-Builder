using Avalonia;
using Avalonia.Media.Imaging;
using System.Runtime.InteropServices;

namespace makePSClassicsfPKG
{
    public class Utils
    {
        public static Bitmap ConvertTo24bppPNG(byte[] rgbPixelData, int width, int height)
        {
            Vector dpi = new(96, 96);
            var NewBitmap = new WriteableBitmap(new PixelSize(width, height), dpi, Avalonia.Platform.PixelFormats.Rgb24);
            using (var frameBuffer = NewBitmap.Lock())
            {
                Marshal.Copy(rgbPixelData, 0, frameBuffer.Address, rgbPixelData.Length);
            }
            return NewBitmap;
        }
    }
}