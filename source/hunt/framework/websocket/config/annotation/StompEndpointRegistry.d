/*
 * Hunt - A high-level D Programming Language Web framework that encourages rapid development and clean, pragmatic design.
 *
 * Copyright (C) 2015-2019, HuntLabs
 *
 * Website: https://www.huntlabs.net/
 *
 * Licensed under the Apache-2.0 License.
 *
 */

module hunt.framework.websocket.config.annotation.StompEndpointRegistry;

import hunt.framework.websocket.config.annotation.StompWebSocketEndpointRegistration;
import hunt.framework.websocket.config.annotation.WebMvcStompWebSocketEndpointRegistration;
import hunt.framework.websocket.config.annotation.WebSocketTransportRegistration;

import hunt.framework.application.ApplicationContext;
import hunt.framework.task.TaskScheduler;

// import hunt.framework.web.HttpRequestHandler;
// import hunt.framework.websocket.handler.WebSocketHandlerDecorator;
import hunt.framework.websocket.messaging.StompSubProtocolErrorHandler;
import hunt.framework.websocket.messaging.StompSubProtocolHandler;
import hunt.framework.websocket.messaging.SubProtocolWebSocketHandler;
import hunt.framework.websocket.WebSocketMessageHandler;
// import hunt.framework.websocket.server.support.WebSocketHandlerMapping;
// import hunt.framework.web.util.UrlPathHelper;

import hunt.collection;
import hunt.http.server.WebSocketHandler;
import hunt.Exceptions;
import hunt.logging;

import std.conv;

/**
 * A contract for registering STOMP over WebSocket endpoints.
 *
 * @author Rossen Stoyanchev
 * @since 4.0
 */
interface StompEndpointRegistry {

	/**
	 * Register a STOMP over WebSocket endpoint at the given mapping path.
	 */
	StompWebSocketEndpointRegistration addEndpoint(string[] paths... );

	/**
	 * Set the order of the {@link hunt.framework.web.servlet.HandlerMapping}
	 * used for STOMP endpoints relative to other Spring MVC handler mappings.
	 * <p>By default this is set to 1.
	 */
	void setOrder(int order);

	/**
	 * Configure a customized {@link UrlPathHelper} for the STOMP endpoint
	 * {@link hunt.framework.web.servlet.HandlerMapping HandlerMapping}.
	 */
	// void setUrlPathHelper(UrlPathHelper urlPathHelper);

	/**
	 * Configure a handler for customizing or handling STOMP ERROR frames to clients.
	 * @param errorHandler the error handler
	 * @since 4.2
	 */
	WebMvcStompEndpointRegistry setErrorHandler(StompSubProtocolErrorHandler errorHandler);

}

/**
 * A registry for STOMP over WebSocket endpoints that maps the endpoints with a
 * {@link hunt.framework.web.servlet.HandlerMapping} for use in Spring MVC.
 *
 * @author Rossen Stoyanchev
 * @author Artem Bilan
 * @since 4.0
 */
class WebMvcStompEndpointRegistry : StompEndpointRegistry {

	private WebSocketMessageHandler webSocketHandler;

	private TaskScheduler sockJsScheduler;

	private int order = 1;
	
	// private UrlPathHelper urlPathHelper;

	private SubProtocolWebSocketHandler subProtocolWebSocketHandler;

	private StompSubProtocolHandler stompHandler;

	private List!(WebMvcStompWebSocketEndpointRegistration) registrations;

	private ApplicationContext appContext;


	this(WebSocketMessageHandler webSocketHandler,
			WebSocketTransportRegistration transportRegistration, 
			TaskScheduler defaultSockJsTaskScheduler,
			ApplicationContext context) {

		assert(webSocketHandler, "WebSocketHandler is required ");
		assert(transportRegistration, "WebSocketTransportRegistration is required");
		
		registrations = new ArrayList!WebMvcStompWebSocketEndpointRegistration();

		this.appContext = context;
		this.webSocketHandler = webSocketHandler;
		this.subProtocolWebSocketHandler = unwrapSubProtocolWebSocketHandler(webSocketHandler);
// FIXME: Needing refactor or cleanup -@zxp at 10/31/2018, 5:45:08 PM
// 
		// if (transportRegistration.getSendTimeLimit() !is null) 
		if (transportRegistration.getSendTimeLimit() > 0) 
		{
			this.subProtocolWebSocketHandler.setSendTimeLimit(transportRegistration.getSendTimeLimit());
		}
		// if (transportRegistration.getSendBufferSizeLimit() !is null) 
		if (transportRegistration.getSendBufferSizeLimit() > 0) 
		{
			this.subProtocolWebSocketHandler.setSendBufferSizeLimit(transportRegistration.getSendBufferSizeLimit());
		}
		// if (transportRegistration.getTimeToFirstMessage() !is null) 
		if (transportRegistration.getTimeToFirstMessage() >0) 
		{
			this.subProtocolWebSocketHandler.setTimeToFirstMessage(transportRegistration.getTimeToFirstMessage());
		}

		this.stompHandler = new StompSubProtocolHandler();
		// if (transportRegistration.getMessageSizeLimit() !is null) 
		if (transportRegistration.getMessageSizeLimit() > 0) 
		{
			this.stompHandler.setMessageSizeLimit(transportRegistration.getMessageSizeLimit());
		}

		this.stompHandler.setApplicationEventPublisher(context);
		this.sockJsScheduler = defaultSockJsTaskScheduler;
	}

	private static SubProtocolWebSocketHandler unwrapSubProtocolWebSocketHandler(WebSocketMessageHandler handler) {
		WebSocketMessageHandler actual = handler; //WebSocketHandlerDecorator.unwrap(handler);
		auto r = cast(SubProtocolWebSocketHandler) actual;
		if (r is null) {
			throw new IllegalArgumentException("No SubProtocolWebSocketHandler in " ~ handler.to!string());
		}
		return r;
	}


	override
	StompWebSocketEndpointRegistration addEndpoint(string[] paths... ) {
		this.subProtocolWebSocketHandler.addProtocolHandler(this.stompHandler);
		WebMvcStompWebSocketEndpointRegistration registration =
				new WebMvcStompWebSocketEndpointRegistration(paths.dup, 
					this.webSocketHandler, this.sockJsScheduler);
		this.registrations.add(registration);
		return registration;
	}

	/**
	 * Set the order for the resulting
	 * {@link hunt.framework.web.servlet.HandlerMapping}
	 * relative to other handler mappings configured in Spring MVC.
	 * <p>The default value is 1.
	 */
	override
	void setOrder(int order) {
		this.order = order;
	}

	protected int getOrder() {
		return this.order;
	}

	/**
	 * Set the UrlPathHelper to configure on the {@code HandlerMapping}
	 * used to map handshake requests.
	 */
	// override
	// void setUrlPathHelper(UrlPathHelper urlPathHelper) {
	// 	this.urlPathHelper = urlPathHelper;
	// }

	
	// protected UrlPathHelper getUrlPathHelper() {
	// 	return this.urlPathHelper;
	// }

	override
	WebMvcStompEndpointRegistry setErrorHandler(StompSubProtocolErrorHandler errorHandler) {
		this.stompHandler.setErrorHandler(errorHandler);
		return this;
	}

	void setApplicationContext(ApplicationContext context) {
		this.appContext = context;
		this.stompHandler.setApplicationEventPublisher(context);
	}

	string[] getPaths() {
		import std.array;
		import std.container.array;
		Array!string buffer;
		foreach (WebMvcStompWebSocketEndpointRegistration registration ; this.registrations) {
			buffer ~= registration.getPaths();
		}
		return buffer.array;
	}

	/**
	 * Return a handler mapping with the mapped ViewControllers.
	 */
	Map!(string, WebSocketHandler) getHandlerMapping() {
		Map!(string, WebSocketHandler) urlMap = new LinkedHashMap!(string, WebSocketHandler)();
		foreach (WebMvcStompWebSocketEndpointRegistration registration ; this.registrations) {
		 	Map!(string, WebSocketHandler) mappings = registration.getMappings();
			foreach(string path, WebSocketHandler handler; mappings) {
				urlMap.put(path, handler);
			}
		}

		return urlMap;
	 }
	// AbstractHandlerMapping getHandlerMapping() {
	// 	Map!(string, Object) urlMap = new LinkedHashMap!(string, Object)();
	// 	foreach (WebMvcStompWebSocketEndpointRegistration registration ; this.registrations) {
	// 		MultiValueMap!(HttpRequestHandler, string) mappings = registration.getMappings();
	// 		foreach(HttpRequestHandler httpHandler, patterns; mappings) {
	// 			foreach (string pattern ; patterns) {
	// 				urlMap.put(pattern, httpHandler);
	// 			}
	// 		}
	// 	}
	// 	WebSocketHandlerMapping hm = new WebSocketHandlerMapping();
	// 	hm.setUrlMap(urlMap);
	// 	hm.setOrder(this.order);
	// 	// if (this.urlPathHelper !is null) {
	// 	// 	hm.setUrlPathHelper(this.urlPathHelper);
	// 	// }
	// 	return hm;
	// }

}
