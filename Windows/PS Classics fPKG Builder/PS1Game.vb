Imports System.IO

Public Class PS1Game

    Public Shared Function GetPS1GameTitleFromDatabaseList(GameID As String) As String
        Dim FoundGameTitle As String = ""

        For Each GameTitle As String In File.ReadLines(My.Computer.FileSystem.CurrentDirectory + "\Tools\ps1ids.txt")
            If GameTitle.Contains(GameID) Then
                FoundGameTitle = GameTitle.Split(";"c)(1)
                Exit For
            End If
        Next

        If String.IsNullOrEmpty(FoundGameTitle) Then
            Return ""
        Else
            Return FoundGameTitle
        End If
    End Function

    Public Shared Function IsGameProtected(GameID As String) As String
        Dim FoundValue As String = ""

        For Each GameIDInFile As String In File.ReadLines(My.Computer.FileSystem.CurrentDirectory + "\Tools\libcrypt.txt")
            If GameIDInFile.Contains(GameID) Then
                FoundValue = GameIDInFile.Split(" "c)(1)
                Exit For
            End If
        Next

        Return FoundValue
    End Function

End Class
