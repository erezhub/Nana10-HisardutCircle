package com.ui
{
	import com.fxpn.display.ShapeDraw;
	import com.fxpn.util.Debugging;
	import com.fxpn.util.DisplayUtils;
	import com.fxpn.util.MathUtils;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import resources.arrows.ArrowHead;
	import resources.arrows.ArrowTail;
	import resources.arrows.VetoBracelet;
	
	public class Arrow extends Sprite
	{
		private var _fromCard:Card;
		private var _toCard:Card;
		private var curveControlPoint:Point;
		private var flipArrowHead:Boolean;
		private var _circleCenter:Point;
		private var fromCardPoint:Point;
		private var toCardPoint:Point;
		private var vetoPoint:Point;
		
		public function Arrow(fromCard:Card,toCard:Card, circleCenter:Point, veto:Boolean = false)
		{
			_fromCard = fromCard;
			if (!veto) _fromCard.arrow = this;
			_toCard = toCard;
			_circleCenter = circleCenter;
			
			var glowFilter:GlowFilter = new GlowFilter(0xffffff,0.6,2,2,1);
			filters = [glowFilter];
			var dl:DashedLine = new DashedLine(graphics,1,4);
			dl.lineStyle(2,veto ? 0xffffff : 0xB3E544);
			fromCardPoint = fromCard.getCoordinates(new Point(toCard.x,toCard.y));
			toCardPoint = toCard.getCoordinates(fromCardPoint);
			x = fromCardPoint.x;
			y = fromCardPoint.y;
			flipArrowHead = true;
			
			setControlPoint();
			dl.curveTo(curveControlPoint.x - fromCardPoint.x,curveControlPoint.y - fromCardPoint.y,toCardPoint.x - fromCardPoint.x,toCardPoint.y - fromCardPoint.y);			
			addBG();			
			addArrowHead(veto);			
			addArrowTail(veto);
			
			if (veto)
			{
				addVetoBracelet();
			}
		}
		
		private function setControlPoint():void
		{
			var p1:Point;
			var p2:Point;
			
			var options:Array = [-1,1];
			if (int(_toCard.y) == int(_fromCard.y))
			{
				curveControlPoint = Point.interpolate(fromCardPoint,toCardPoint,MathUtils.randomNumberWithLimits(0.3,0.7));
				vetoPoint = curveControlPoint.clone();
				if (_fromCard.y > _circleCenter.y)
				{
					curveControlPoint.y-=MathUtils.randomNumberWithLimits(25,15);
				}
				else if (_fromCard.y < _circleCenter.y)
				{
					curveControlPoint.y+=MathUtils.randomNumberWithLimits(25,15);	
				}
				else
				{					
					curveControlPoint.y+= options[MathUtils.randomInteger(0,1)] * MathUtils.randomNumberWithLimits(40,20);
				}
				vetoPoint.y+=(curveControlPoint.y - vetoPoint.y)/2;
			}
			else if (int(_fromCard.x) == int(_toCard.x))
			{	
				curveControlPoint = Point.interpolate(fromCardPoint,toCardPoint,MathUtils.randomNumberWithLimits(0.3,0.7));
				vetoPoint = curveControlPoint.clone();
				if (int(_fromCard.x) < _circleCenter.x)
				{
					curveControlPoint.x+=MathUtils.randomNumberWithLimits(15,25);
				}
				else if (int(_fromCard.x) > _circleCenter.x)
				{				
					curveControlPoint.x-=MathUtils.randomNumberWithLimits(15,25);
				}
				else
				{
					curveControlPoint.x+= options[MathUtils.randomInteger(0,1)] * MathUtils.randomNumberWithLimits(40,20);
				}
				if (curveControlPoint.x < toCardPoint.x) flipArrowHead = false;
				vetoPoint.x+=(curveControlPoint.x - vetoPoint.x)/2;
			}
			else
			{
				var rotationDelta:Number = _fromCard.rotation - _toCard.rotation;
				if ((_fromCard.rotation == 0 && _toCard.rotation > 180) || (_toCard.rotation == 0 && _fromCard.rotation > 180))
				{
					rotationDelta+= (rotationDelta < 0 ? 360 : -360);
				}
				var corner1:Point = new Point(fromCardPoint.x,toCardPoint.y);
				var corner2:Point = new Point(toCardPoint.x,fromCardPoint.y);
				p1 = Point.interpolate(corner1,corner2,MathUtils.randomNumberWithLimits(0.2,0.4));
				p2 = Point.interpolate(corner1,corner2,MathUtils.randomNumberWithLimits(0.6,0.8));
				vetoPoint = Point.interpolate(corner1,corner2,0.5);
				var anchorPoints:Array = [p1,p2];
				//if (Math.abs(rotationDelta) <= 72)
				//{
				var p1Delta:Number = Math.abs(Point.distance(_circleCenter,p1));
				var p2Delta:Number = Math.abs(Point.distance(_circleCenter,p2));
				curveControlPoint = p1Delta < p2Delta ? p1 : p2;
				vetoPoint = Point.interpolate(vetoPoint,curveControlPoint,0.5);
				/*}
				else
				{
				anchorPoint = anchorPoints[MathUtils.randomInteger(0,1)];
				}*/
			}
		}
		
		private function addBG():void
		{
			var bg:Sprite = new Sprite();
			addChild(bg);
			bg.graphics.lineStyle(8,0,0);
			bg.graphics.curveTo(curveControlPoint.x - fromCardPoint.x,curveControlPoint.y - fromCardPoint.y,toCardPoint.x - fromCardPoint.x,toCardPoint.y - fromCardPoint.y);			
		}
		
		private function addArrowHead(veto:Boolean):void
		{
			var arrowHead:ArrowHead = new ArrowHead();
			if (veto)
			{
				DisplayUtils.setTintColor(arrowHead,0xffffff);
			}
			arrowHead.x = toCardPoint.x - x;
			arrowHead.y = toCardPoint.y - y;
			arrowHead.rotation = MathUtils.radiansToDegress(Math.atan((curveControlPoint.y - toCardPoint.y)/(curveControlPoint.x - toCardPoint.x)));	
			if (_toCard.rotation > 180 && _fromCard.rotation > 180 && fromCardPoint.x < toCardPoint.x && int(_fromCard.x) != int(_toCard.x)) flipArrowHead = false;
			if (flipArrowHead && 
				(_toCard.rotation > 180 || 
					((_toCard.rotation == 0 || _toCard.rotation==180) && _fromCard.rotation <= 180) ||
					(_fromCard.rotation <180 && _toCard.rotation < 180 && _fromCard.rotation > 0 && _toCard.rotation > 0 && fromCardPoint.x > toCardPoint.x)
				)
			) arrowHead.rotation+=180;
			addChild(arrowHead);
		}
		
		private function addArrowTail(veto:Boolean):void
		{
			var arrowTail:ArrowTail = new ArrowTail();
			if (veto)
			{
				DisplayUtils.setTintColor(arrowTail,0xffffff);
			}
			addChild(arrowTail);
		}
		
		private function addVetoBracelet():void
		{
			var vetoBracelet:VetoBracelet = new VetoBracelet();
			vetoBracelet.x = vetoPoint.x - x;
			vetoBracelet.y = vetoPoint.y - y;
			addChild(vetoBracelet);
		}
		
		private function onMouseOver(event:MouseEvent):void
		{
			_fromCard.alpha = _toCard.alpha = 0.5;
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
			_fromCard.alpha = _toCard.alpha = 1;
		}

		public function get fromCard():Card
		{
			return _fromCard;
		}

		public function get toCard():Card
		{
			return _toCard;
		}

		private function addTempPoint(p:Point, color:int = 0xff0000):void
		{
			var s:Shape = ShapeDraw.drawSimpleRect(5,5,color);
			s.x = p.x - x;
			s.y = p.y - y;
			addChild(s);
		}
	}
}