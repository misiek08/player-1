package com.wessite.coverflow
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;

    public class CoverFlowItem extends Sprite
    {
        private var coverWidth:Number;
        private var coverHeight:Number;
        private var reflectOpacity:Number;
        private var reflectRatio:Number;
        private var reflectOffset:Number;
        private var bitmap:Bitmap;
        private var reflect:Bitmap;
        private var backColor:int;
        public var halfHeight:Number;

        public function CoverFlowItem(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:int)
        {
            this.coverWidth = param2;
            this.coverHeight = param3;
            this.reflectOpacity = param4;
            this.reflectRatio = param5;
            this.reflectOffset = param6;
            this.backColor = param7;
            var _loc_8:* = new Loader();
            new Loader().contentLoaderInfo.addEventListener(Event.COMPLETE, this.onComplete, false, 0, true);
            if (param1)
            {
                _loc_8.load(new URLRequest(param1), new LoaderContext(true));
            }
            this.bitmap = new Bitmap();
            if (param4 > 0)
            {
                this.reflect = new Bitmap();
            }
            return;
        }// end function

        private function onComplete(event:Event) : void
        {
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_9:BitmapData = null;
            var _loc_10:Matrix = null;
            var _loc_11:Shape = null;
            var _loc_2:* = event.target.content as Bitmap;
            var _loc_3:* = _loc_2.bitmapData;
            if (this.coverWidth > this.coverHeight)
            {
                _loc_4 = _loc_2.width / _loc_2.height * this.coverHeight;
                _loc_5 = this.coverHeight;
                _loc_6 = this.coverHeight / _loc_2.height;
            }
            else
            {
                _loc_4 = this.coverWidth;
                _loc_5 = _loc_2.height / _loc_2.width * this.coverWidth;
                _loc_6 = this.coverWidth / _loc_2.width;
            }
            this.halfHeight = _loc_5 * 0.5;
            graphics.clear();
            graphics.beginFill(this.backColor, 1);
            graphics.drawRect(-_loc_4 >> 1, -_loc_5 >> 1, _loc_4, _loc_5 << 1);
            graphics.endFill();
            var _loc_7:* = new BitmapData(_loc_4, _loc_5);
            var _loc_8:* = new Matrix();
            new Matrix().scale(_loc_6, _loc_6);
            _loc_7.draw(_loc_3, _loc_8);
            _loc_3.dispose();
            this.bitmap.bitmapData = _loc_7;
            this.bitmap.x = -_loc_4 >> 1;
            this.bitmap.y = -_loc_5 >> 1;
            this.bitmap.width = _loc_4;
            this.bitmap.height = _loc_5;
            addChild(this.bitmap);
            if (this.reflectOpacity > 0)
            {
                _loc_9 = new BitmapData(_loc_4, _loc_5, true);
                _loc_10 = new Matrix();
                _loc_10.createGradientBox(_loc_4, _loc_5, Math.PI * 0.5);
                _loc_11 = new Shape();
                _loc_11.graphics.clear();
                _loc_11.graphics.beginGradientFill(GradientType.LINEAR, [16777215, 16777215], [0, this.reflectOpacity], [255 - this.reflectRatio, 255], _loc_10);
                _loc_11.graphics.drawRect(0, 0, _loc_4, _loc_5);
                _loc_11.graphics.endFill();
                _loc_9.draw(_loc_7);
                _loc_9.draw(_loc_11, null, null, BlendMode.ALPHA);
                this.reflect.bitmapData = _loc_9;
                this.reflect.x = -_loc_4 >> 1;
                this.reflect.y = (_loc_5 >> 1) + _loc_5 + this.reflectOffset;
                this.reflect.scaleY = -1;
                addChild(this.reflect);
            }
            return;
        }// end function

        public function set brightness(param1:Number) : void
        {
            visible = param1 > 0;
            this.bitmap.alpha = param1;
            if (this.reflect)
            {
                this.reflect.alpha = param1;
            }
            return;
        }// end function

        public function get brightness() : Number
        {
            return this.bitmap.alpha;
        }// end function

    }
}
