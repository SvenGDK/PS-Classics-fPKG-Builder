using System;
using System.Diagnostics;
using System.IO;

namespace makePSClassicsfPKG
{

    public class PS2Game
    {

        public static string GetPS2GameID(string GameISO)
        {
            string GameID = "";
            using var Bash = new Process();

            var StringsCMD = $"7z l -ba \"{GameISO}\"";
            var EscapedArgs = StringsCMD.Replace("\"", "\\\"");

            Bash.StartInfo.FileName = "/bin/bash";
            Bash.StartInfo.Arguments = $"-c \"{EscapedArgs}\"";
            Bash.StartInfo.RedirectStandardOutput = true;
            Bash.StartInfo.RedirectStandardError = true;
            Bash.StartInfo.UseShellExecute = false;
            Bash.StartInfo.CreateNoWindow = false;
            Bash.Start();
            Bash.WaitForExit();

            var OutputReader = Bash.StandardOutput;
            string[] ProcessOutput = OutputReader.ReadToEnd().Split(new string[] { "\r\n" }, StringSplitOptions.RemoveEmptyEntries);

            if (ProcessOutput.Length > 0)
            {
                foreach (string Line in ProcessOutput)
                {
                    if (Line.Contains("SLES_") | Line.Contains("SLUS_") | Line.Contains("SCES_") | Line.Contains("SCUS_"))
                    {
                        if (Line.Contains("Volume:")) // ID found in the ISO Header
                        {
                            if (Line.Split(new string[] { "Volume: " }, StringSplitOptions.RemoveEmptyEntries).Length > 0)
                            {
                                GameID = Line.Split(new string[] { "Volume: " }, StringSplitOptions.RemoveEmptyEntries)[1];
                                break;
                            }
                        }
                        else if (string.Join(" ", Line.Split(new char[] { }, StringSplitOptions.RemoveEmptyEntries)).Split(' ').Length > 4) // ID found in the ISO files
                        {
                            GameID = string.Join(" ", Line.Split(new char[] { }, StringSplitOptions.RemoveEmptyEntries)).Split(' ')[5].Trim();
                            break;
                        }
                    }
                }
            }

            return GameID;
        }

        public static string GetPS2GameTitleFromDatabaseList(string GameID)
        {
            string FoundGameTitle = "";
            GameID = GameID.Replace("-", "");

            foreach (string GameTitle in File.ReadLines(Directory.GetCurrentDirectory() + @"/Tools/ps2ids.txt"))
            {
                if (GameTitle.Contains(GameID))
                {
                    FoundGameTitle = GameTitle.Split(';')[1];
                    break;
                }
            }

            if (string.IsNullOrEmpty(FoundGameTitle))
            {
                return "Unknown PS2 game";
            }
            else
            {
                return FoundGameTitle;
            }
        }

    }
}