package com.jeroenwijering.parsers
{
    import com.jeroenwijering.utils.*;

    public class JWParser extends Object
    {
        private static const PREFIX:Object = "jwplayer";

        public function JWParser()
        {
            return;
        }// end function

        public static function parseEntry(param1:XML, param2:Object) : Object
        {
            var _loc_3:XML = null;
            for each (_loc_3 in param1.children())
            {
                
                if (_loc_3.namespace().prefix == JWParser.PREFIX)
                {
                    param2[_loc_3.localName()] = Strings.serialize(_loc_3.text().toString());
                }
            }
            return param2;
        }// end function

    }
}
