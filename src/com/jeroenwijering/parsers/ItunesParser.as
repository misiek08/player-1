package com.jeroenwijering.parsers
{
    import com.jeroenwijering.utils.*;

    public class ItunesParser extends Object
    {
        private static const PREFIX:Object = "itunes";

        public function ItunesParser()
        {
            return;
        }// end function

        public static function parseEntry(param1:XML, param2:Object) : Object
        {
            var _loc_3:XML = null;
            for each (_loc_3 in param1.children())
            {
                
                if (_loc_3.namespace().prefix == ItunesParser.PREFIX)
                {
                    switch(_loc_3.localName().toLowerCase())
                    {
                        case "author":
                        {
                            param2["author"] = _loc_3.text().toString();
                            break;
                        }
                        case "duration":
                        {
                            param2["duration"] = Strings.seconds(_loc_3.text().toString());
                            break;
                        }
                        case "summary":
                        {
                            param2["description"] = _loc_3.text().toString();
                            break;
                        }
                        case "keywords":
                        {
                            param2["tags"] = _loc_3.text().toString();
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
            }
            return param2;
        }// end function

    }
}
