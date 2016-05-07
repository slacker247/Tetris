package AS.Util
{
	import flash.events.KeyboardEvent;
	
	/**
	*  The KeyInput class will handle all of the
	*  keyboard inputs.  There are two functions
	*  for the key press and release events and a
	*  function to poll the keys.  Then there are
	*  check functions to see which keys are press.
	*/
	public class KeyInput
	{
		/**
		*  The KEY_COUNT var is to keep track of how
		*  many keys there are.
		*/
		private static var KEY_COUNT = 256;

		/**
		*  These vars are for the different states
		*  a key can exist in.
		*/
        public static var KEY_RELEASED = 0; // Not down
        public static var KEY_PRESSED = 1; // Down, but not the first time
        public static var KEY_ONCE = 2; // Down for the first time

		/**
		*  An internaly used var to check to see if
		*  a key has been pressed since the last poll.
		*/
		private static var m_KeyPressed:Boolean = false;

		/**
		*  Current state of the keyboard
		*/
		private static var m_CurrentKeys:Array;
    
		/**
		*  Polled keyboard state
		*/
		private static var m_Keys:Array;
    
		/**
		*  The constructor should not be used.
		*  This class is ment to be a singlton.
		*/
		public function KeyInput()
		{
		}
		
		/**
		*  Called to initilize the class.  Since
		*  this class is a singleton the init function
		*  needs to be called before this class is used.
		*
		*  @return This function does not return a value.
		*/
		public static function init()
		{
			m_CurrentKeys = new Array(KEY_COUNT);
			m_Keys = new Array(KEY_COUNT);
			for(var i = 0; i < KEY_COUNT; ++i)
			{
				m_Keys[i] = KEY_RELEASED;
			}
		}

		/**
		*  The poll function needs to be called before
		*  checking any of the keys.  This function
		*  updates the state of all the keys.
		*
		*  @return This function does not return a value.
		*/
		public static function poll()
		{
			var keyPressed:Boolean = false;
			for(var i = 0; i < KEY_COUNT; ++i)
			{
				// Set the key state
				if(m_CurrentKeys[i])
				{
					// If the key is down now, but was not 
					// Down the last frame, set it to ONCE, 
					// otherwise, set it to PRESSED
					if(m_Keys[i] == KEY_RELEASED)
						m_Keys[i] = KEY_ONCE;
					else
						m_Keys[i] = KEY_PRESSED;
					keyPressed = true;
				}
				else
				{
					m_Keys[i] = KEY_RELEASED;
				}
			}
			m_KeyPressed = keyPressed;
		}
    
		/**
		*  Check to see if any key has been pressed.
		*
		*  @return Returns <code>true</code> if a key has
		*  been pressed and <code>false</code> if one has not.
		*/
		public static function anyKeyPressed():Boolean
		{
			return m_KeyPressed;
		}

		/**
		*  isKeyDown checks to see in the provided keyCode
		*  has been pressed and returns true or false.
		*
		*  @param keyCode is the number representation of the key
		*  to be checked.
		*
		*  @return Returns <code>true</code> if the key has been
		*  pressed and <code>false</code> if the key has not.
		*/
		public static function isKeyDown(keyCode:Number):Boolean
		{
			return m_Keys[keyCode] == KEY_ONCE ||
					m_Keys[keyCode] == KEY_PRESSED;
		}

		/**
		*  isKeyDownOnce checks to see if this is the first
		*  time the provide keyCode has been pressed.
		*
		*  @param keyCode is the number representation of the key
		*  to be checked.
		*
		*  @return Returns <code>true</code> if this is the 
		*  first time this key has been pressed and <code>false</code>
		*  if it is not.
		*/
		public static function isKeyDownOnce(keyCode:Number):Boolean
		{
			return m_Keys[keyCode] == KEY_ONCE;
		}
    
		/**
		*  keyPressed is the function for the event listener
		*  to call to update what keys have been pressed.
		*
		*  @param e is the keyboard event variable.
		*
		*  @return This function does not return a value.
		*/
		public static function keyPressed(e:KeyboardEvent)
		{
			var keyCode:Number = e.keyCode;
			if(keyCode >= 0 && keyCode < KEY_COUNT)
			{
				m_CurrentKeys[keyCode] = true;
			}
		}
		
		/**
		*  keyReleased is the function for the event listener
		*  to call to update what keys have been released.
		*
		*  @param e is the keyboard event variable.
		*
		*  @return This function does not return a value.
		*/
		public static function keyReleased(e:KeyboardEvent)
		{
			var keyCode:Number = e.keyCode;
			if(keyCode >= 0 && keyCode < KEY_COUNT)
			{
				m_CurrentKeys[keyCode] = false;
			}
		}
	}
}