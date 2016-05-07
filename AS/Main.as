package AS
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	import AS.Util.KeyInput;
	import AS.States.PlayState;
		
	public class Main extends MovieClip
	{
		/**
		*  Timing variables.
		*/
		var m_LastTime:Date;			//  This is for tracking the delta time and is the last time the execution took place
		var m_CurrentTime:Date;			//  This is for tracking the delta time and is the current time the execution took place
		var m_LastFPS:Number;			//  This is for tracking the Frames Per Second and is the last FPS that was calc'd
		var m_FPSTime:Number;
		var m_CurrentFPS:Number;		//  This is for tracking the Frames Per Second and is the current FPS that was calc'd
		var m_FrameRate:Number;			//  This is the m_FrameRate that needs to be achieved by the game engine
		var m_Frame:Boolean;			//  This designates whether or not the game engine is on an actual m_Frame or if it is in between two m_Frames
		var m_BeforeExeTime:Date;		//  This is for calcing the execution time for the main loop.
		var m_AfterExeTime:Date;		//  This is the time after the execution of the main loop.
		var m_ExeTimer:Number;			//  The delay for when the main loop will be called again.
		var m_GameTimer:Timer;			//  Timer object to call the main loop at the defined time in m_ExeTimer.
		
		var m_State:MovieClip;

		public function Main()
		{
			m_LastTime = new Date();
			m_CurrentTime = new Date();
			m_LastFPS = 0;
			m_FPSTime = 0;
			m_CurrentFPS = 0;
			m_FrameRate = 30;
			m_Frame = false;
			m_BeforeExeTime = new Date();
			m_AfterExeTime = new Date();
			m_ExeTimer = 20;
			
			m_State = new PlayState();
			this.addChild(m_State);

			KeyInput.init();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyInput.keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, KeyInput.keyReleased);
			m_GameTimer = new Timer(m_ExeTimer);
			m_GameTimer.addEventListener(TimerEvent.TIMER, gameLoop);
			m_GameTimer.start();
		}

		/**
		  *   The getTimeDiff calculates the difference between the last exe
		  * time and the current time and returns the value.
		  *
		  * @return the time, in milliseconds, that have past since the
		  * last time it was called.
		  */
		public function getTimeDiff()
		{
			m_CurrentTime = new Date();
			var t_current = m_CurrentTime.getSeconds()*1000 + m_CurrentTime.getMilliseconds();
			var t_last = m_LastTime.getSeconds()*1000 + m_LastTime.getMilliseconds();
			var diff = t_current - t_last;
			m_LastTime = m_CurrentTime;
			if(diff < 0)
				diff = 0;
				
			m_Frame = false;
			m_CurrentFPS += diff;
			m_FPSTime += diff;
			m_LastFPS++;
			if(m_CurrentFPS >= 1000/m_FrameRate)
			{
				m_CurrentFPS = 0;
				m_Frame = true;
			}
			if(m_FPSTime >= 1000)
			{
				m_State.txt_Status.text = "FPS: " + m_LastFPS;
				m_LastFPS = 0;
				m_FPSTime = 0;
			}
			return diff;
		}
		
		public function gameLoop(evt:TimerEvent)
		{
			m_BeforeExeTime = new Date();
			var deltaTime:Number = getTimeDiff();
			
			KeyInput.poll();
			m_State.update(deltaTime);
			
			var t_current = m_BeforeExeTime.getSeconds()*1000 + m_BeforeExeTime.getMilliseconds();
			m_AfterExeTime = new Date();
			var t_last = m_AfterExeTime.getSeconds()*1000 + m_AfterExeTime.getMilliseconds();
			m_ExeTimer = t_current - t_last + 5;
			if(m_ExeTimer < 5)
				m_ExeTimer = 5;
			
			m_GameTimer.reset();
			m_GameTimer.delay = m_ExeTimer;
			m_GameTimer.start();
		}
	}
}