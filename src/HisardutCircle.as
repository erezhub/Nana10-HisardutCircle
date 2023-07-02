package
{
	import com.data.DataRepository;
	import com.data.EpisodeData;
	import com.data.TribeData;
	import com.fxpn.display.ShapeDraw;
	import com.fxpn.util.ContextMenuCreator;
	import com.fxpn.util.Debugging;
	import com.fxpn.util.MathUtils;
	import com.ui.Arrow;
	import com.ui.Card;
	import com.ui.CustomTextInput;
	import com.ui.DashedLine;
	import com.ui.InfoCard;
	import com.ui.ListCellRenderer;
	import com.ui.Statue;
	
	import fl.controls.BaseButton;
	import fl.controls.List;
	import fl.events.ListEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.formats.TextAlign;
	
	import gs.TweenLite;
	
	import resources.CoverCircle;
	import resources.InactiveTribe;
	import resources.MainBG;
	import resources.Tribe1Logo;
	import resources.Tribe2Logo;
	import resources.Tribe3Logo;
	import resources.cards.Necklace;
	
	[SWF (width="780", height="1420", backgroundColor="0x8A4D21")]
	public class HisardutCircle extends Sprite
	{
		private const CENTER_X:Number = 390;
		private const TOP_Y:Number = 385;
		private const BOTTOM_Y:Number = 1070;
		
		private var bg:MainBG;
		private var tribe1Logo:Tribe1Logo;
		private var tribe2Logo:Tribe2Logo;
		private var tribe3Logo:Tribe3Logo;
		private var inactiveTribe:InactiveTribe;
		private var centerPoint:Point;
		//private var cardsDict:Dictionary;
		private var cardsArray:Array;
		private var arrowsArray:Array;
		private var cardsContainer:Sprite;
		private var arrowsTopContainer:Sprite;
		private var arrowsBottomContainer:Sprite;
		private var vetoArrow:Arrow;
		private var vetoCardFrom:Card;
		private var vetoCardTo:Card;
		private var statue:Statue;
		private var necklace:Necklace;
		//private var episodesCB:ComboBox;
		private var episodesList:List;
		private var topCircleCover:CoverCircle;
		private var bottomCircleCover:CoverCircle;
		private var infoCard:InfoCard;
		private var currentEpisode:EpisodeData;
		private var currentCard:Card;
		
		public function HisardutCircle()
		{
			contextMenu = ContextMenuCreator.setContextMenu("Created by eRez Huberman, Nana10 (c) 2011.4");
			
			bg = new MainBG()
			addChild(bg);
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);	
			
			tribe1Logo = new Tribe1Logo();
			tribe2Logo = new Tribe2Logo();
			tribe3Logo = new Tribe3Logo();
			tribe1Logo.x = tribe2Logo.x = tribe3Logo.x = CENTER_X;
			tribe3Logo.y = TOP_Y;
			tribe1Logo.visible = tribe2Logo.visible = tribe3Logo.visible = false;
			addChild(tribe1Logo);
			addChild(tribe2Logo);
			addChild(tribe3Logo);
			
			arrowsBottomContainer = new Sprite();
			addChild(arrowsBottomContainer);
			
			topCircleCover = addCircleCover(TOP_Y);
			topCircleCover.alpha = 0;
			bottomCircleCover = addCircleCover(BOTTOM_Y);
			
			cardsContainer = new Sprite();
			addChild(cardsContainer);
			arrowsTopContainer = new Sprite();
			addChild(arrowsTopContainer);
			
			inactiveTribe = new InactiveTribe();
			inactiveTribe.x = CENTER_X;
			inactiveTribe.y = BOTTOM_Y;
			inactiveTribe.visible = false;
			addChild(inactiveTribe);
			
			infoCard = new InfoCard();
			infoCard.x = CENTER_X;
			addChild(infoCard);
			infoCard.visible = false;
			infoCard.addEventListener(Event.CLOSE,onInfoClosed);
		}
		
		private function addCircleCover(yPos:Number):CoverCircle
		{
			var coverCircle:CoverCircle = new CoverCircle();
			coverCircle.x = CENTER_X;
			coverCircle.y = yPos;
			addChild(coverCircle);
			return coverCircle;
		}
		
		private function onAddedToStage(event:Event):void
		{
			var dataURL:String = stage.loaderInfo.url.indexOf("http") == 0 ? "http://f.nanafiles.co.il/partner48/Service249/Images/HisardutCircle/data.xml" : "data.xml"; 
			DataRepository.getInstance().loadData(dataURL);
			DataRepository.getInstance().addEventListener(Event.COMPLETE,onDataReady);
		}
		
		private function onDataReady(event:Event):void
		{
			drawEpisode(DataRepository.getInstance().getCurrentEpisode(),0);
			setList();			
		}
		
		private function drawEpisode(episodeData:EpisodeData, index:int):void
		{
			currentEpisode = episodeData;
			var tribe1:TribeData = episodeData.getTribeByOrder(1);
			var tribe2:TribeData = episodeData.getTribeByOrder(2);
			if (tribe1.active)
			{
				drawTribe(tribe1,TOP_Y,index);
			}
			if (tribe2)
			{
				if (tribe1.active == false)
				{
					drawTribe(tribe2,TOP_Y,index);
					tribe2Logo.y = TOP_Y;
					drawTribe(tribe1,BOTTOM_Y,index);
					tribe1Logo.y = BOTTOM_Y;
				}
				else
				{
					drawTribe(tribe2,BOTTOM_Y,index);
					tribe1Logo.y = TOP_Y;
					tribe2Logo.y = BOTTOM_Y;
				}
				tribe1Logo.visible = tribe2Logo.visible = inactiveTribe.visible = true;
				tribe3Logo.visible = false;
			}
			else
			{
				tribe1Logo.visible = tribe2Logo.visible = inactiveTribe.visible = false;
				tribe3Logo.visible = true;
			}
		}
		
		private function drawTribe(tribeData:TribeData,yPos:Number,index:int):void
		{ 
			var centerPoint:Point = new Point(CENTER_X,yPos);
			var totalMembers:int = tribeData.members.length;
			var cardsDict:Dictionary = new Dictionary();
			tribeData.tribeYPos = yPos;
			if (tribeData.active) cardsArray = [];
			var hasStatue:Boolean;
			for (var i:int = 0; i < totalMembers; i++)
			{
				hasStatue = false;
				var card:Card = new Card(tribeData.members[i].id,tribeData.id,index);
				card.x = CENTER_X;
				card.y = yPos;
				card.rotation = 360/totalMembers * i;
				cardsContainer.addChild(card);	
				if (tribeData.active)
				{
					cardsDict[tribeData.members[i].id] = card;
					cardsArray.push(card);
					card.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverCard);
					card.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutCard);
				}
				else
				{
					card.setMouseInteraction();
				}
				card.addEventListener(MouseEvent.CLICK,onClickCard);
				if (tribeData.statue==tribeData.members[i].id)
				{
					statue = new Statue();
					statue.x = card.x;
					statue.y = card.y;
					statue.rotation = 45 + 90 * (card.rotation/180) + (card.rotation < 180 ? 0 : 90);
					cardsContainer.addChild(statue);
					hasStatue = true;
				}
				if (tribeData.necklace == tribeData.members[i].id)
				{
					necklace = new Necklace();
					necklace.necklace.useHandCursor = false;
					necklace.x = card.x;
					necklace.y = card.y;
					if (hasStatue)
					{
						necklace.rotation = statue.rotation - 60;
					}
					else
					{
						necklace.rotation = 45 + 90 * (card.rotation/180) + (card.rotation < 180 ? 0 : 90);
					}
					necklace.necklace.rotation = -necklace.rotation;
					cardsContainer.addChild(necklace);
				}
				if (tribeData.outcasted == tribeData.members[i].id)
				{
					card.memberOutcasted();
				}
			}
			if (tribeData.active)
			{
				arrowsArray = [];
				for (var j:int = 0; j < totalMembers; j++)
				{
					addArrow(cardsArray[j],cardsDict[(cardsArray[j] as Card).votingTo],centerPoint);
				}
				if (tribeData.vetoFrom && tribeData.vetoTo)
				{
					vetoCardFrom = cardsDict[tribeData.vetoFrom];
					vetoCardTo = cardsDict[tribeData.vetoTo]
					vetoArrow = addArrow(vetoCardFrom,vetoCardTo,centerPoint,true);					
				}
			}
		}
		
		private function addArrow(from:Card,to:Card,tribeCenter:Point,vetoArrow:Boolean = false):Arrow
		{
			if (to == null) return null;
			var arrow:Arrow = new Arrow(from,to,tribeCenter,vetoArrow);
			arrow.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverArrow);
			arrow.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutArrow);
			arrowsArray.push(arrow);
			arrowsTopContainer.addChild(arrow);
			return arrow;
		}
		
		private function setList():void
		{
			episodesList = new List();
			episodesList.width = 128;
			episodesList.x = 15;
			episodesList.y = 60;
			episodesList.rowHeight = 30;
			episodesList.visible = false;
			episodesList.setStyle("cellRenderer",ListCellRenderer);
			addChild(episodesList);
			
			var dataRepository:DataRepository = DataRepository.getInstance();
			for (var i:int = 0; i < dataRepository.totalEpisodes; i++)
			{
				var episodeData:EpisodeData = dataRepository.getEpisodeByIndex(i);
				var label:String = i == 0 ? "עובשה" : episodeData.order + " קרפ";
				episodesList.addItem({data: episodeData.order, label: label});
			}
			episodesList.selectedIndex = 0;
			bg.episodesSelector.currentEpisode_txt.text = episodesList.selectedItem.label;
			episodesList.height = Math.min(4*episodesList.rowHeight, dataRepository.totalEpisodes * episodesList.rowHeight);
			episodesList.addEventListener(ListEvent.ITEM_CLICK, onListClosed);
			bg.episodesSelector._btn.addEventListener(MouseEvent.CLICK,onListToggled);
		}
		
		private function onListToggled(event:MouseEvent):void
		{
			if (episodesList.visible == false)
			{
				episodesList.visible = true;
				stage.addEventListener(MouseEvent.CLICK,onListClosed);
				event.stopPropagation();
			}
		}
		
		private function onListClosed(event:Event):void
		{
			if (event.target is BaseButton) return;
			stage.removeEventListener(MouseEvent.CLICK,onListClosed);
			episodesList.visible = false;
			if (event is ListEvent)
			{
				selectEpisode((event as ListEvent).item,(event as ListEvent).index);
			}
		}		
		
		private function selectEpisode(selectedEpisode:Object,index:int):void
		{
			clearPreviousData(cardsContainer);
			clearPreviousData(arrowsTopContainer);
			clearPreviousData(arrowsBottomContainer);
			vetoArrow = null;
			//drawEpisode(DataRepository.getInstance().getEpisodeByOrder(selectedEpisode.data));
			drawEpisode(DataRepository.getInstance().getEpisodeByIndex(index),index);
			bg.episodesSelector.currentEpisode_txt.text = selectedEpisode.label;
			infoCard.visible = false;
		}
		
		private function clearPreviousData(container:Sprite):void
		{
			for (var i:int = container.numChildren - 1; i >= 0; i--)
			{
				var item:DisplayObject = container.getChildAt(i);
				if (item is Card)
				{					
					item.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverCard);
					item.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutCard);
					(item as Card).clearMouseInteractoin();
				}
				else
				{
					item.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverArrow);
					item.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutArrow);
				}				
				container.removeChild(item);
			}
		}
		
		private function onMouseOverArrow(event:MouseEvent):void
		{
			toggleArrows(event.currentTarget as Arrow, false);
		}
		
		private function onMouseOutArrow(event:MouseEvent):void
		{
			toggleArrows(event.currentTarget as Arrow, true);
		}
		
		private function toggleArrows(currentArrow:Arrow,state:Boolean):void
		{		
			if (infoCard.visible) return;
			for (var i:int = 0; i < cardsArray.length; i++)
			{				
				var currentCard:Card = cardsArray[i] as Card;
				if ((currentArrow == vetoArrow && currentCard!= vetoCardFrom && currentCard!= vetoCardTo) || (currentCard != currentArrow.fromCard && currentCard != currentArrow.toCard))
				{
					currentCard.toggleState(state);
					toggleArrow(currentCard.arrow,state);
				}
				else if ((currentArrow == vetoArrow && (currentCard == vetoCardFrom || currentCard == vetoCardTo)) || currentCard == currentArrow.toCard)
				{
					toggleArrow(cardsArray[i].arrow,state);
				}
			}
			if (vetoArrow && currentArrow != vetoArrow) vetoArrow.alpha = state ? 1 : 0.2;
			if (state)
			{
				TweenLite.to(topCircleCover,0.3,{alpha: 0});	
			}
			else
			{
				TweenLite.to(topCircleCover,0.3,{alpha: 1});
			}
		}
		
		private function toggleArrow(arrow:Arrow, state:Boolean):void
		{
			if (arrow == null) return;
			if (state)
			{
				arrowsTopContainer.addChild(arrow);
				TweenLite.to(arrow,0.3,{alpha: 1});
			}
			else
			{
				arrowsBottomContainer.addChild(arrow);
				TweenLite.to(arrow,0.3,{alpha: 0.3});
			}
		}
		
		private function onMouseOverCard(event:MouseEvent):void
		{
			var card:Card = event.currentTarget as Card; 
			toggleCard(card,false);
			card.showName = true;
		}
		
		private function onMouseOutCard(event:MouseEvent):void
		{
			var card:Card = event.currentTarget as Card;
			toggleCard(card,true);
			card.showName = false;
		}
		
		private function toggleCard(currentCard:Card, state:Boolean):void
		{
			if (infoCard.visible) return;
			for (var i:int = 0; i < cardsArray.length; i++)
			{
				var card:Card = cardsArray[i] as Card;
				if (card != currentCard && card.votingTo != currentCard.memberID && currentCard.votingTo != card.memberID)
				{
					card.toggleState(state);
					toggleArrow(card.arrow,state);
				}
				else if (currentCard.votingTo == card.memberID && card.votingTo != currentCard.memberID)
				{
					toggleArrow(card.arrow,state);
				}
			}
			if (vetoArrow)
			{
				if (currentCard != vetoCardFrom && currentCard != vetoCardTo)
				{
					toggleArrow(vetoArrow,state);
				}
				else
				{
					vetoCardFrom.toggleState(true);
					vetoCardTo.toggleState(true);
				}
			}
			if (state)
			{
				TweenLite.to(topCircleCover,0.3,{alpha: 0});	
			}
			else
			{
				TweenLite.to(topCircleCover,0.3,{alpha: 1});
			}
		}	
		
		private function onClickCard(event:MouseEvent):void
		{
			//if (infoCard.visible) return;
			infoCard.visible = true;
			currentCard = event.currentTarget as Card
			var memberTribeId:int = currentCard.tribeID
			infoCard.y = currentEpisode.getTribeById(memberTribeId).tribeYPos;
			infoCard.setData(currentCard.memberID,memberTribeId);
			
		}
		
		private function onInfoClosed(event:Event):void
		{
			toggleCard(currentCard,true);	
		}
	}
}