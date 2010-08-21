
package com.jeroenwijering.events {


import flash.events.Event;


public interface PluginInterface {

	/**
	* When a plugin is loaded, the player attempts to call this function.
	* 
	* @param vie	Reference to the View, which is the entrypoint for the API.
	*				It defines all available variables, listeners and calls.
	* @see			AbstractView
	**/
	function initializePlugin(vie:AbstractView):void;


};


}