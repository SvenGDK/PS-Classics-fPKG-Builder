Imports System.Drawing

Public Class Utils

    Public Shared Function ResizeAsImage(InputImage As Image, NewSizeX As Integer, NewSizeY As Integer) As Image
        Return New Bitmap(InputImage, New Size(NewSizeX, NewSizeY))
    End Function

    Public Shared Function ConvertTo24bppPNG(ImageToConvert As Image) As Bitmap
        Dim NewBitmap As New Bitmap(ImageToConvert.Width, ImageToConvert.Height, Imaging.PixelFormat.Format24bppRgb)
        Using NewGraphics As Graphics = Graphics.FromImage(NewBitmap)
            NewGraphics.DrawImage(ImageToConvert, New Rectangle(0, 0, ImageToConvert.Width, ImageToConvert.Height))
        End Using
        Return NewBitmap
    End Function

End Class
