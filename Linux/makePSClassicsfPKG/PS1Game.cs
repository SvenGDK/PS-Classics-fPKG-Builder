using System.IO;

namespace makePSClassicsfPKG
{
    public class PS1Game
    {

        public static string GetPS1GameTitleFromDatabaseList(string GameID)
        {
            string FoundGameTitle = "";

            foreach (string GameTitle in File.ReadLines(Directory.GetCurrentDirectory() + @"/Tools/ps1ids.txt"))
            {
                if (GameTitle.Contains(GameID))
                {
                    FoundGameTitle = GameTitle.Split(';')[1];
                    break;
                }
            }

            if (string.IsNullOrEmpty(FoundGameTitle))
            {
                return "";
            }
            else
            {
                return FoundGameTitle;
            }
        }

        public static string IsGameProtected(string GameID)
        {
            string FoundValue = "";

            foreach (string GameIDInFile in File.ReadLines(Directory.GetCurrentDirectory() + @"/Tools/libcrypt.txt"))
            {
                if (GameIDInFile.Contains(GameID))
                {
                    FoundValue = GameIDInFile.Split(' ')[1];
                    break;
                }
            }

            return FoundValue;
        }

    }
}
