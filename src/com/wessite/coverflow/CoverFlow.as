package com.wessite.coverflow
{
    import __AS3__.vec.*;
    import com.gskinner.motion.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.ui.*;

    public class CoverFlow extends Sprite
    {
        private var canvas:Sprite;
        private var covers:Vector.<CoverFlowItem>;
        private var tweens:Vector.<GTween>;
        private var tweenValues:Vector.<Object>;
        private var coverIndexes:Vector.<int>;
        private var coversLength:int;
        public var current:int = 0;
        private var onFocus:Function;
        private var onClick:Function;
        private var focalLength:Number;

        public function CoverFlow(param1:Vector.<String>, param2:Number = 100, param3:Number = 100, param4:Number = 40, param5:Number = 60, param6:Number = 200, param7:Number = 50, param8:Number = 0.1, param9:int = 0, param10:Number = 0.3, param11:Number = 155, param12:Number = 0, param13:Number = 0.5, param14:Number = 500, param15:Function = null, param16:Function = null)
        {
            var _loc_19:Number = NaN;
            var _loc_20:Number = NaN;
            var _loc_21:String = null;
            var _loc_22:CoverFlowItem = null;
            this.coversLength = param1.length;
            this.covers = new Vector.<CoverFlowItem>(this.coversLength, true);
            this.tweens = new Vector.<GTween>(this.coversLength, true);
            this.tweenValues = new Vector.<Object>(this.coversLength * 2 - 1, true);
            this.coverIndexes = new Vector.<int>(this.coversLength * 2 - 1, true);
            this.onFocus = param15;
            this.onClick = param16;
            this.focalLength = param14;
            this.canvas = new Sprite();
            addChild(this.canvas);
            var _loc_17:* = this.coversLength;
            while (_loc_17--)
            {
                
                _loc_21 = param1[int((this.coversLength - 1) - _loc_17)];
                _loc_22 = new CoverFlowItem(_loc_21, param2, param3, param10, param11, param12, param9);
                _loc_22.addEventListener(MouseEvent.CLICK, this.clickHandler, false, 0, true);
                this.covers[_loc_17] = _loc_22;
                this.canvas.addChild(_loc_22);
                this.tweens[_loc_17] = new GTween(_loc_22, param13, null);
            }
            var _loc_18:* = this.coversLength - 1;
            _loc_17 = this.coversLength * 2 - 1;
            while (_loc_17--)
            {
                
                if (_loc_17 === _loc_18)
                {
                    this.tweenValues[_loc_17] = {x:0, rotationY:0, z:0, brightness:1};
                    this.coverIndexes[_loc_17] = this.coversLength - 1;
                    continue;
                }
                if (_loc_17 < _loc_18)
                {
                    _loc_19 = 1 - (_loc_18 - _loc_17 + 1) * param8;
                    if (_loc_19 <= 0)
                    {
                        _loc_20 = (_loc_18 - _loc_17 + 1) * param4 + 1.5 * param4 + param7;
                    }
                    else
                    {
                        _loc_20 = (_loc_18 - _loc_17 + 1) * param4 + param7;
                    }
                    this.tweenValues[_loc_17] = {x:_loc_20, rotationY:param5, z:param6, brightness:_loc_19};
                    this.coverIndexes[_loc_17] = _loc_17;
                    continue;
                }
                _loc_19 = 1 - (_loc_17 - _loc_18 + 1) * param8;
                if (_loc_19 <= 0)
                {
                    _loc_20 = (_loc_17 - _loc_18 + 1) * (-param4) - 1.5 * param4 - param7;
                }
                else
                {
                    _loc_20 = (_loc_17 - _loc_18 + 1) * (-param4) - param7;
                }
                this.tweenValues[_loc_17] = {x:_loc_20, rotationY:-param5, z:param6, brightness:_loc_19};
                this.coverIndexes[_loc_17] = this.coversLength - _loc_17 + _loc_18 - 1;
            }
            addEventListener(Event.ADDED_TO_STAGE, this.perspective, false, 0, true);
            return;
        }// end function

        private function clickHandler(event:MouseEvent) : void
        {
            var _loc_3:int = 0;
            var _loc_2:* = event.currentTarget as CoverFlowItem;
            if (_loc_2.mouseY < _loc_2.halfHeight)
            {
                _loc_3 = (this.coversLength - 1) - this.covers.indexOf(_loc_2);
                if (_loc_3 != this.current)
                {
                    this.to(_loc_3);
                }
                else
                {
                    this.onClick(_loc_3);
                }
            }
            return;
        }// end function

        private function perspective(event:Event) : void
        {
            var _loc_2:* = new PerspectiveProjection();
            _loc_2.focalLength = this.focalLength;
            _loc_2.projectionCenter = new Point(0, 0);
            transform.perspectiveProjection = _loc_2;
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyboard, false, 0, true);
            return;
        }// end function

        private function keyboard(event:KeyboardEvent) : void
        {
            if (stage && stage.focus is TextField)
            {
                return;
            }
            switch(event.keyCode)
            {
                case Keyboard.LEFT:
                {
                    this.left();
                    break;
                }
                case Keyboard.RIGHT:
                {
                    this.right();
                    break;
                }
                case Keyboard.UP:
                case Keyboard.PAGE_UP:
                {
                    this.to(0);
                    break;
                }
                case Keyboard.DOWN:
                case Keyboard.PAGE_DOWN:
                {
                    if (this.coversLength)
                    {
                        this.to((this.coversLength - 1));
                    }
                    break;
                }
                case Keyboard.SPACE:
                {
                    if (this.current)
                    {
                        this.onClick(this.current);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function left() : void
        {
            if (this.current > 0)
            {
                this.to((this.current - 1));
            }
            return;
        }// end function

        public function right() : void
        {
            if (this.current < (this.coversLength - 1))
            {
                this.to((this.current + 1));
            }
            return;
        }// end function

        public function next() : void
        {
            if (this.current < (this.coversLength - 1))
            {
                this.to((this.current + 1));
            }
            else
            {
                this.to(0);
            }
            return;
        }// end function

        public function to(param1:int) : void
        {
            this.onFocus(param1);
            var _loc_2:* = this.coversLength;
            while (_loc_2--)
            {
                
                this.tweens[_loc_2].setValues(this.tweenValues[int(param1 + _loc_2)]);
                this.canvas.setChildIndex(this.covers[_loc_2], this.coverIndexes[int(param1 + _loc_2)]);
            }
            this.current = param1;
            return;
        }// end function

    }
}
