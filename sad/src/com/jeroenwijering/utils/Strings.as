package com.jeroenwijering.utils
{

    public class Strings extends Object
    {

        public function Strings()
        {
            return;
        }// end function

        public static function decode(param1:String) : String
        {
            if (param1.indexOf("asfunction") == -1)
            {
                return unescape(param1);
            }
            return "";
        }// end function

        public static function digits(param1:Number) : String
        {
            var _loc_2:* = Math.floor(param1 / 60);
            var _loc_3:* = Math.floor(param1 % 60);
            var _loc_4:* = Strings.zero(_loc_2) + ":" + Strings.zero(_loc_3);
            return Strings.zero(_loc_2) + ":" + Strings.zero(_loc_3);
        }// end function

        public static function seconds(param1:String) : Number
        {
            param1 = param1.replace(",", ".");
            var _loc_2:* = param1.split(":");
            var _loc_3:Number = 0;
            if (param1.substr(-1) == "s")
            {
                _loc_3 = Number(param1.substr(0, (param1.length - 1)));
            }
            else if (param1.substr(-1) == "m")
            {
                _loc_3 = Number(param1.substr(0, (param1.length - 1))) * 60;
            }
            else if (param1.substr(-1) == "h")
            {
                _loc_3 = Number(param1.substr(0, (param1.length - 1))) * 3600;
            }
            else if (_loc_2.length > 1)
            {
                _loc_3 = Number(_loc_2[(_loc_2.length - 1)]);
                _loc_3 = _loc_3 + Number(_loc_2[_loc_2.length - 2]) * 60;
                if (_loc_2.length == 3)
                {
                    _loc_3 = _loc_3 + Number(_loc_2[_loc_2.length - 3]) * 3600;
                }
            }
            else
            {
                _loc_3 = Number(param1);
            }
            return _loc_3;
        }// end function

        public static function serialize(param1:String) : Object
        {
            if (param1 == null)
            {
                return null;
            }
            if (param1 == "true")
            {
                return true;
            }
            if (param1 == "false")
            {
                return false;
            }
            if (isNaN(Number(param1)) || param1.length > 5)
            {
                return Strings.decode(param1);
            }
            return Number(param1);
        }// end function

        public static function strip(param1:String) : String
        {
            var _loc_4:Number = NaN;
            var _loc_2:* = param1.split("\n");
            param1 = _loc_2.join("");
            _loc_2 = param1.split("\r");
            param1 = _loc_2.join("");
            var _loc_3:* = param1.indexOf("<");
            while (_loc_3 != -1)
            {
                
                _loc_4 = param1.indexOf(">", (_loc_3 + 1));
                if (_loc_4 == -1)
                {
                    _loc_4 = param1.length - 1;
                    ;
                }
                param1 = param1.substr(0, _loc_3) + " " + param1.substr((_loc_4 + 1), param1.length);
                _loc_3 = param1.indexOf("<", _loc_3);
            }
            return param1;
        }// end function

        public static function zero(param1:Number) : String
        {
            if (param1 < 10)
            {
                return "0" + param1;
            }
            return "" + param1;
        }// end function

    }
}
