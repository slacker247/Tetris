package AS.States
{
	/**
	* The HighScore class is the visual representation
	* of the high scores.  This class also contains the
	* high scores.  Later we can add the capability to
	* handle persistant high scores.
	*/
	public class HighScore extends MovieClip
	{
		/**
		* The m_List variable contains the high scores.
		* The index value is a string which is the names
		* and the value is the score.
		*/
		private var m_List:Array = new Array();
		
		/**
		* This is the constructor for the HighScore class.
		* It creates an instance of the object.
		*
		* @return Returns and instance of this object.
		*/
		public function HighScore()
		{
		}
		
		/**
		* The addPlayer function adds a player to the high score
		* list.
		*
		* @param lName is the name of the player.
		*
		* @param lScore is the score for the player.
		*
		* @return This function does not return a value.
		*/
		public function addPlayer(lName:String, lScore:Number)
		{
		}
		
		/**
		* The isHighScore function checks to see if the score
		* is among the high scores.
		*
		* @param lScore is the score to be checked.
		*
		* @return Returns <code>true</code> if the score is in the
		* high scores and <code>false</code> if it is not.
		*/
		public function isHighScore(lScore:Number):Boolean
		{
		}
	}
}