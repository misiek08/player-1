package com.jeroenwijering.parsers
{
    import com.jeroenwijering.utils.*;

    public class MediaParser extends Object
    {
        private static const PREFIX:Object = "media";

        public function MediaParser()
        {
            return;
        }// end function

        public static function parseGroup(param1:XML, param2:Object) : Object
        {
            var _loc_3:XML = null;
            var _loc_4:Boolean = false;
            for each (_loc_3 in param1.children())
            {
                
                if (_loc_3.namespace().prefix == MediaParser.PREFIX)
                {
                    switch(_loc_3.localName().toLowerCase())
                    {
                        case "content":
                        {
                            if (!_loc_4)
                            {
                                param2["file"] = _loc_3.@url.toString();
                            }
                            if (_loc_3.@duration)
                            {
                                param2["duration"] = Strings.seconds(_loc_3.@duration.toString());
                            }
                            if (_loc_3.@start)
                            {
                                param2["start"] = Strings.seconds(_loc_3.@start.toString());
                            }
                            if (_loc_3.children().length() > 0)
                            {
                                param2 = MediaParser.parseGroup(_loc_3, param2);
                            }
                            break;
                        }
                        case "title":
                        {
                            param2["title"] = _loc_3.text().toString();
                            break;
                        }
                        case "description":
                        {
                            param2["description"] = _loc_3.text().toString();
                            break;
                        }
                        case "keywords":
                        {
                            param2["tags"] = _loc_3.text().toString();
                            break;
                        }
                        case "thumbnail":
                        {
                            param2["image"] = _loc_3.@url.toString();
                            break;
                        }
                        case "credit":
                        {
                            param2["author"] = _loc_3.text().toString();
                            break;
                        }
                        case "player":
                        {
                            if (_loc_3.@url.indexOf("youtube.com") > 0)
                            {
                                _loc_4 = true;
                                param2["file"] = _loc_3.@url.toString();
                            }
                            break;
                        }
                        case "group":
                        {
                            param2 = MediaParser.parseGroup(_loc_3, param2);
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
