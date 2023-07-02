package com.ui
{
	import resources.cards.StatueVisuals;
	
	public class Statue extends StatueVisuals
	{
		public function Statue()
		{
			statue.useHandCursor = false;
		}
		
		override public function set rotation(value:Number):void
		{			
			statue.useHandCursor = false;
			super.rotation = value;
			statue.rotation = -rotation;
		}
	}
}