package com.ui
{
	import cinabu.HebrewTextHandling;
	
	import com.data.DataRepository;
	import com.data.EpisodeData;
	import com.data.MemberData;
	import com.data.TribeData;
	import com.fxpn.display.ShapeDraw;
	import com.fxpn.util.MathUtils;
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	import gs.TweenLite;
	
	import mx.events.MoveEvent;
	
	import resources.cards.CardVisuals;
	import resources.members.*;
	
	public class Card extends CardVisuals
	{
		private var _memberID:int;
		private var _tribeID:int;
		private var _episodeOrder:int;
		private var currentAnchorIndex:int;
		private var card:MovieClip;
		private var anchorPoints:Array;
		
		private const TOTAL_POINTS:int = 9;
		
		public var arrow:Arrow;		
				
		public function Card(memberID:int,tribeID:int,episodeOrder:int, hasStatue:Boolean = false)
		{
			var memberClass:Class = getDefinitionByName("resources.members.Member" + memberID) as Class;
			card = new memberClass() as MovieClip
			cardContainer.addChild(card);
			_memberID = memberID;
			_tribeID = tribeID;
			_episodeOrder = episodeOrder;
			buttonMode = true;
			outcasted.visible = false; 
			cover.alpha = 0;
			memberName.visible = false;
			memberName.name_txt.text = HebrewTextHandling.reverseWord(DataRepository.getInstance().membersDict[memberID].name);
			//currentAnchorIndex = 2;
		}
		
		override public function set rotation(value:Number):void
		{
			cardContainer.rotation = cover.rotation = memberName.rotation = -value;
			super.rotation = value;	
			
			anchorPoints = [];
			for (var i:int = 1; i <= TOTAL_POINTS; i++)
			{
				var currentAnchorPoint:MovieClip = this["p" + i];
				var point:Point = new Point(currentAnchorPoint.x, currentAnchorPoint.y);
				anchorPoints.push(this.localToGlobal(point));
			}
		}
		
		override public function get rotation():Number
		{
			if (super.rotation < 0) return 360 + super.rotation;
			return super.rotation;
		}
		
		public function getCoordinates(destination:Point):Point
		{
			var minDelta:Number = 1000;
			var nearestPointIndex:int;
			for (var i:int = 0; i < anchorPoints.length; i++)
			{
				var delta:Number = Point.distance(destination,anchorPoints[i]);
				if (delta < minDelta)
				{
					minDelta = delta;
					nearestPointIndex = i;
				}
			}
			var nearestPoint:Point = anchorPoints[nearestPointIndex];
			anchorPoints.splice(nearestPointIndex,1);
			return nearestPoint;
			
			/*var currentAnchorPoint:MovieClip;
			if (origin)
			{
				currentAnchorPoint = p1;
			}
			else
			{
				currentAnchorPoint = this["p" + currentAnchorIndex];
				if (currentAnchorIndex < TOTAL_POINTS) currentAnchorIndex++;
			}
			var point:Point = new Point(currentAnchorPoint.x, currentAnchorPoint.y);
			return this.localToGlobal(point);*/
		}
		
		override public function get x():Number
		{
			return super.x + Math.sin(MathUtils.degreesToRadians(super.rotation)) * (-cardContainer.y)// - cardWidth/2 - 5);	
		}
		
		override public function get y():Number
		{
			return super.y + Math.cos(MathUtils.degreesToRadians(super.rotation)) * (cardContainer.y)// + cardHeight/2 + 5);
		}
		
		public function get votingTo():int
		{
			var episodeData:EpisodeData = DataRepository.getInstance().getEpisodeByIndex(_episodeOrder);
			var tribeData:TribeData = episodeData.getTribeById(_tribeID);
			var memberData:MemberData = tribeData.getMemberById(_memberID);
			return memberData.votedTo;
		}
		
		public function toggleState(state:Boolean):void
		{
			if (state) 
			{
				TweenLite.to(cover,0.3,{alpha: 0});
			}
			else
			{
				TweenLite.to(cover,0.3,{alpha: 0.7});
			}
		}
		
		public function get memberID():int
		{
			return _memberID;
		}
		
		public function get tribeID():int
		{
			return _tribeID;
		}
		
		public function memberOutcasted():void
		{
			outcasted.visible = true;
			outcasted.gotoAndStop(DataRepository.getInstance().membersDict[memberID].sex ? "male" : "female");
			outcasted.rotation = -rotation;
		}
		
		public function setMouseInteraction():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
		}
		
		public function clearMouseInteractoin():void
		{
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);	
		}
		
		private function onMouseOver(event:MouseEvent):void
		{
			showName = true;
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
			showName = false;
		}
		
		public function set showName(value:Boolean):void
		{
			memberName.visible = value;
		}
		
		// this reference-less function is used to instaciate all the members' classes.
		// without it first line of the constructor function won't work
		private function classReferences():void
		{
			Member1;
			Member2;
			Member3;
			Member4;
			Member5;
			Member6;
			Member7;
			Member8;
			Member9;
			Member10;
			Member11;
			Member12;
			Member13;
			Member14;
			Member15;
			Member16;
			Member17;
			Member18;
			Member19;
			Member20;
		}


	}
}