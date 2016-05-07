package AS.States
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import AS.Objects.Piece;
	import AS.Objects.Block;
	import AS.Objects.Board;
	import AS.Util.KeyInput;
	
	public class PlayState extends MovieClip
	{
		// txt_Status - is a variable on the stage.
		// txt_Score
		// txt_Level
		
		/**
		*  The start and end points of the play area.
		*/
		private var m_StartPt:Point = new Point(12.5, 29);
		private var m_EndPt:Point = new Point(m_StartPt.x + (Block.SPACING * 11), m_StartPt.y + (Block.SPACING * 18));
		private var m_Play:Boolean = false;
		
		private var m_Pieces:Array = new Array();
		private var m_PieceCount:Number = 0;
		private var m_NextPiece:Number = Math.floor(Math.random() * 6);
		private var m_NextPieceGraphic:Piece = new Piece(m_NextPiece);
		
		private var m_PlayArea:Array = new Array();
		
		private var m_PieceMoveCount:Number = 0;
		private var m_Level = 1;
		private var m_Score = 0;
		private var m_Board:Board;
		
		public function PlayState()
		{
//			m_NextPieceGraphic.setPos(260, 85);
//			this.addChild(m_NextPieceGraphic);
//			nextPiece();
			//m_Board = new Board(this);
		}
		
		public function update(dTime:Number)
		{
//			m_Pieces[m_PieceCount-1].calcMove(dTime);
//			m_PieceMoveCount += dTime;
//			if(m_PieceMoveCount >= 500 - (m_Level*20))//1770
//			{
//				m_Pieces[m_PieceCount-1].moveDown();
//				m_PieceMoveCount = 0;
//			}
//			checkCollisions();
			if(m_Board != null && m_Board.m_Lose)
			{
				m_Board.clear();
				txt_State.text = "Game Over.";
				if(KeyInput.anyKeyPressed())
				{
					m_Score = 0;
					m_Board.reset();
					m_Play = true;
					txt_State.text = "";
				}
			}
			else if(m_Play)
			{
				m_Board.update(dTime);
				txt_Level.text = m_Level;
				//txt_Status.text = "This is some text.";
				if(m_Board.m_RowsRemoved != 0)
				{
					m_Score += (m_Board.m_RowsRemoved*m_Level*40)+40;
					m_Board.m_RowsRemoved = 0;
				}
				txt_Score.text = m_Score;
			}
			else
			{
				txt_State.text = "Hit Any Key to start...";
				if(KeyInput.anyKeyPressed())
				{
					m_Board = new Board(this);
					m_Play = true;
					txt_State.text = "";
				}
			}
		}
		
		public function nextPiece()
		{
			setPiece();
			checkRows();
			addPiece(m_NextPiece);
			m_NextPiece = Math.floor(Math.random() * 7);
			m_NextPieceGraphic.setType(m_NextPiece);
			m_NextPieceGraphic.setPos(260, 85);
		}
		
		public function addPiece(type:Number)
		{
			m_Pieces[m_PieceCount] = new Piece(type);
			m_Pieces[m_PieceCount].setPos(m_StartPt.x + (3 * Block.SPACING), m_StartPt.y);
			this.addChild(m_Pieces[m_PieceCount++]);
		}
		
		public function checkCollisions()
		{
			if(m_Pieces[m_PieceCount-1].checkWall(m_StartPt, m_EndPt) == 1)
			{
				nextPiece();
			}
			for(var i:Number = 0; i < m_PieceCount-1; i++)
				if(m_Pieces[m_PieceCount-1].checkCollision(m_Pieces[i]) == 1)
				{
					nextPiece();
				}
		}
		
		public function setPiece()
		{
			if(m_PieceCount == 0)
				return;
			for(var i:Number = 0; i < m_Pieces[m_PieceCount-1].m_Blocks.length; i++)
			{
				var lX:Number = Math.floor(m_Pieces[m_PieceCount-1].m_Blocks[i].x + m_Pieces[m_PieceCount-1].x);
				if(lX == 196)
					lX = 195;
				var lY:Number = Math.floor(m_Pieces[m_PieceCount-1].m_Blocks[i].y + m_Pieces[m_PieceCount-1].y);
				var tArray:Array = new Array();
				tArray[0] = m_PieceCount-1;
				tArray[1] = i;
				if(m_PlayArea[lX] == undefined)
					m_PlayArea[lX] = new Array();
				m_PlayArea[lX][lY] = tArray;
			}
		}
		
		public function checkRows()
		{
			var rows:Array = new Array();
			var row:Number = m_EndPt.y - Block.SPACING;
			while(row > m_StartPt.y)
			{
				var r:Number = Math.floor(row);
				var rowCheck:Boolean = true;
				var col:Number = m_StartPt.x + Block.SPACING;
				while(col < m_EndPt.x)
				{
					var c:Number = Math.floor(col);
					if(c == 196)
						c = 195;
					if(m_PlayArea[c] == undefined ||
					   m_PlayArea[c][r] == undefined ||
					   m_PlayArea[c][r][0] == -1)
					{
						rowCheck = false;
						break;
					}
					col += Block.SPACING;
				}
				if(rowCheck)
				{
					rows.push(row);
				}
				row -= Block.SPACING;
			}
			if(rows.length > 0)
			{
				m_Score += (rows.length*m_Level*40)+40;
				removeRows(rows);
			}
		}
		
		public function removeRows(rows:Array)
		{
			var cols:Array = [30,49,67,85,104,122,140,159,177,195];
			var row:Number = 0;
			var c:Number = 0;
			for(var r:Number = 0; r < rows.length; r++)
			{
				row = Math.floor(rows[r]);
				for(c = 0; c < cols.length; c++)
				{
					m_Pieces[m_PlayArea[cols[c]][row][0]].removeBlockAt(m_PlayArea[cols[c]][row][1]);
					m_PlayArea[cols[c]][row][0] = -1
					m_PlayArea[cols[c]][row][1] = -1
				}
			}
			// Move the above rows down.
			for(r = rows.length; r < 18; r++)
			{
				row = Math.floor(m_EndPt.y - r * Block.SPACING);
				for(c = 0; c < cols.length; c++)
				{
					if(m_PlayArea[cols[c]] != undefined)
						if(m_PlayArea[cols[c]][row] != undefined)
							if(m_PlayArea[cols[c]][row][0] != -1)
							{
								m_Pieces[m_PlayArea[cols[c]][row][0]].moveBlocksDown(rows.length, row);
							}
				}
			}
		}
	}
}