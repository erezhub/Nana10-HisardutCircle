package com.ui
{
	import com.data.DataRepository;
	import com.data.EpisodeData;
	import com.data.MemberData;
	import com.data.TribeData;
	import com.fxpn.util.StringUtils;
	
	import fl.events.ScrollEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getDefinitionByName;
	
	import resources.info.CardVisuals;
	import resources.info.EpisoDedetails;
	import resources.members.Member1;
	import resources.members.Member10;
	import resources.members.Member11;
	import resources.members.Member12;
	import resources.members.Member13;
	import resources.members.Member14;
	import resources.members.Member15;
	import resources.members.Member16;
	import resources.members.Member17;
	import resources.members.Member18;
	import resources.members.Member19;
	import resources.members.Member2;
	import resources.members.Member20;
	import resources.members.Member3;
	import resources.members.Member4;
	import resources.members.Member5;
	import resources.members.Member6;
	import resources.members.Member7;
	import resources.members.Member8;
	import resources.members.Member9;
		
	public class InfoCard extends CardVisuals
	{
		private var containerOrigY:Number;
		private var websiteURL:int;
		private var fbURL:String;
		
		public function InfoCard()
		{
			closeBtn.addEventListener(MouseEvent.CLICK,onClose);
			containerOrigY = votesContainer.y;
			scrollBar.addEventListener(ScrollEvent.SCROLL,onScroll);
			fbBtn.addEventListener(MouseEvent.CLICK,onClickFB);
			wsBtn.addEventListener(MouseEvent.CLICK,onClickWebsite);
			outcasted.visible = false;
		}
		
		private function onClose(event:MouseEvent):void
		{
			visible = false;
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function setData(memberId:int, tribeId:int):void
		{
			clear();
			var dataRepository:DataRepository = DataRepository.getInstance();
			var memberDetails:Object = dataRepository.membersDict[memberId];
			name_txt.text = memberDetails.name;
			tribe_txt.text = dataRepository.tribesDict[tribeId];
			fbURL = memberDetails.fb;
			websiteURL = memberDetails.webSite;
			label.gotoAndStop(memberDetails.sex ? "male" : "female");
			for (var i:int = 0; i < dataRepository.totalEpisodes; i++)
			{
				var episodeData:EpisodeData = dataRepository.getEpisodeByIndex(i);
				var memberData:MemberData = episodeData.getMemberById(memberId); 				
				if (memberData)
				{	
					var tribeData:TribeData = episodeData.getTribeById(memberData.currentTribe);
					if (tribeData.outcasted == memberId)
					{
						active_txt.text = "כן";
						outcasted.visible = true;
						outcasted.gotoAndStop(memberDetails.sex ? "male" : "female");
					}
					else if (StringUtils.isStringEmpty(active_txt.text)) active_txt.text = "לא";
					if (!tribeData.active) continue;				
					var episodeDetails:EpisoDedetails = new EpisoDedetails();
					episodeDetails.label.gotoAndStop(memberDetails.sex ? "male" : "female");
					episodeDetails.episodeTitle.text = episodeData.date + " - " + episodeData.order + " פרק"; 
					if (memberData.votedTo)	episodeDetails.label.votedTo_txt.text = dataRepository.membersDict[memberData.votedTo].name;
					var gotVotes:String = "";
					for (var j:int  = 0; j < episodeData.members.length; j++)
					{
						if ((episodeData.members[j] as MemberData).votedTo == memberId)
						{
							gotVotes = gotVotes.concat(", " + dataRepository.membersDict[episodeData.members[j].id].name);
						}
					}
					if (gotVotes.length)
					{
						gotVotes = gotVotes.substr(2);
						episodeDetails.label.votedFrom_txt.text = gotVotes;
					}
					else
					{
						episodeDetails.label.votedFrom_txt.text = " - ";
					}
					episodeDetails.y = episodeDetails.height * votesContainer.numChildren;
					votesContainer.addChild(episodeDetails);
				}
				else if (i == 0)
				{
					active_txt.text = "כן";
					outcasted.visible = true;
					outcasted.gotoAndStop(memberDetails.sex ? "male" : "female");
				}
			}
			 
			setScrollBar();
			addMemberImage(memberId);
		}
		
		private function setScrollBar():void
		{
			votesContainer.y = containerOrigY;
			scrollBar.setScrollProperties(containerMask.height - votesContainer.y,0,votesContainer.height - containerMask.height);
			scrollBar.scrollPosition = 0;
			scrollBar.visible = scrollBar.enabled;
		}
		
		private function addMemberImage(memberId:int):void
		{
			var memberClass:Class = getDefinitionByName("resources.members.Member" + memberId) as Class;
			var image:MovieClip = new memberClass() as MovieClip;
			imageContainer.addChild(image);
		}
		
		private function onScroll(event:ScrollEvent):void
		{
			votesContainer.y = containerOrigY - event.position; 
		}
		
		private function onClickWebsite(event:MouseEvent):void
		{
			if (websiteURL)
			{
				navigateToURL(new URLRequest("http://survivor.nana10.co.il/Category/?CategoryID="+websiteURL));
			}
		}
		
		private function onClickFB(event:MouseEvent):void
		{
			if (fbURL)
			{
				navigateToURL(new URLRequest(fbURL));
			}
		}
		
		private function clear():void
		{
			name_txt.text = tribe_txt.text = active_txt.text = "";
			websiteURL = 0; 
			fbURL = null;
			for (var i:int = votesContainer.numChildren - 1; i >= 0; i--)
			{
				votesContainer.removeChildAt(i);
			}
			if (imageContainer.numChildren) imageContainer.removeChildAt(0);
			outcasted.visible = false;
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