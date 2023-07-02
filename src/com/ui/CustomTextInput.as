package com.ui
{
	import fl.controls.TextInput;
	import fl.controls.listClasses.CellRenderer;
	
	import flash.text.TextFormat;
	
	public class CustomTextInput extends CellRenderer {
		
		public function CustomTextInput():void {
			super();
			/*var myTextFormat:TextFormat = new TextFormat ();
			myTextFormat.font="Arial";
			myTextFormat.size=20;
			myTextFormat.color=0xFFFFFF;*/
			//setStyle("textFormat",myTextFormat);
			//textField.defaultTextFormat = myTextFormat;
			//textField.x += 10
			_x+=10;
		}
		/*override protected function drawLayout():void {
			super.drawLayout()
			//textField.x += 10
		}*/
	}


}