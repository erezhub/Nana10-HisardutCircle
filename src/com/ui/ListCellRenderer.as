package com.ui
{
	import fl.controls.listClasses.CellRenderer;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import resources.Enigma;
	
	public class ListCellRenderer extends CellRenderer
	{
		public function ListCellRenderer()
		{
			super();
			setStyle("embedFonts", true);
			//myText.antiAliasType = AntiAliasType.ADVANCED;
			var font:Enigma = new Enigma();
			var tf:TextFormat = new TextFormat(font.fontName,18);		
			tf.align = TextFormatAlign.RIGHT;
			setStyle("textFormat", tf);
		}
		
		/*override protected function drawLayout():void {
			super.drawLayout()
			textField.x += 20;
		}*/

	}
}