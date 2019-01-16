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

module hunt.framework.websocket.config.annotation.WebSocketHandlerRegistration;

import hunt.http.server.WebSocketHandler;
// import hunt.framework.websocket.server.HandshakeHandler;
// import hunt.framework.websocket.server.HandshakeInterceptor;

/**
 * Provides methods for configuring a WebSocket handler.
 *
 * @author Rossen Stoyanchev
 * @since 4.0
 */
interface WebSocketHandlerRegistration {

	/**
	 * Add more handlers that will share the same configuration (interceptors, SockJS
	 * config, etc).
	 */
	WebSocketHandlerRegistration addHandler(WebSocketHandler handler, string[] paths...);

	/**
	 * Configure the HandshakeHandler to use.
	 */
	// WebSocketHandlerRegistration setHandshakeHandler(HandshakeHandler handshakeHandler);

	/**
	 * Configure interceptors for the handshake request.
	 */
	// WebSocketHandlerRegistration addInterceptors(HandshakeInterceptor[] interceptors...);

	/**
	 * Configure allowed {@code Origin} header values. This check is mostly designed for
	 * browser clients. There is nothing preventing other types of client to modify the
	 * {@code Origin} header value.
	 *
	 * <p>When SockJS is enabled and origins are restricted, transport types that do not
	 * allow to check request origin (Iframe based transports) are disabled.
	 * As a consequence, IE 6 to 9 are not supported when origins are restricted.
	 *
	 * <p>Each provided allowed origin must start by "http://", "https://" or be "*"
	 * (means that all origins are allowed). By default, only same origin requests are
	 * allowed (empty list).
	 *
	 * @since 4.1.2
	 * @see <a href="https://tools.ietf.org/html/rfc6454">RFC 6454: The Web Origin Concept</a>
	 * @see <a href="https://github.com/sockjs/sockjs-client#supported-transports-by-browser-html-served-from-http-or-https">SockJS supported transports by browser</a>
	 */
	WebSocketHandlerRegistration setAllowedOrigins(string[] origins...);

	/**
	 * Enable SockJS fallback options.
	 */
	// SockJsServiceRegistration withSockJS();

}
