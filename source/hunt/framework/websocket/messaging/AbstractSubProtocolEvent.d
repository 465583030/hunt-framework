/*
 * Copyright 2002-2017 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module hunt.framework.websocket.messaging.AbstractSubProtocolEvent;

import hunt.framework.context.ApplicationEvent;
import hunt.framework.messaging.Message;

import hunt.security.Principal;
import hunt.util.TypeUtils;

import std.conv;

/**
 * A base class for events for a message received from a WebSocket client and
 * parsed into a higher-level sub-protocol (e.g. STOMP).
 *
 * @author Rossen Stoyanchev
 * @since 4.1
 */

abstract class AbstractSubProtocolEvent : ApplicationEvent {

	private Message!(byte[]) message;
	
	private Principal user;


	/**
	 * Create a new AbstractSubProtocolEvent.
	 * @param source the component that published the event (never {@code null})
	 * @param message the incoming message (never {@code null})
	 */
	protected this(Object source, Message!(byte[]) message) {
		this(source, message, null);
	}

	/**
	 * Create a new AbstractSubProtocolEvent.
	 * @param source the component that published the event (never {@code null})
	 * @param message the incoming message (never {@code null})
	 */
	protected this(Object source, Message!(byte[]) message, Principal user) { 
		super(source);
		assert(message, "Message must not be null");
		this.message = message;
		this.user = user;
	}


	/**
	 * Return the Message associated with the event. Here is an example of
	 * obtaining information about the session id or any headers in the
	 * message:
	 * <pre class="code">
	 * StompHeaderAccessor headers = StompHeaderAccessor.wrap(message);
	 * headers.getSessionId();
	 * headers.getSessionAttributes();
	 * headers.getPrincipal();
	 * </pre>
	 */
	Message!(byte[]) getMessage() {
		return this.message;
	}

	/**
	 * Return the user for the session associated with the event.
	 */
	
	Principal getUser() {
		return this.user;
	}

	override
	string toString() {
		return TypeUtils.getSimpleName(typeid(this)) ~ " [" ~ this.message.to!string() ~ "]";
	}

}
