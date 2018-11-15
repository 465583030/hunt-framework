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

module hunt.framework.websocket.messaging.SessionDisconnectEvent;

import hunt.framework.websocket.messaging.AbstractSubProtocolEvent;
import hunt.stomp.Message;

import hunt.security.Principal;
import hunt.http.codec.websocket.model.CloseStatus;

/**
 * Event raised when the session of a WebSocket client using a Simple Messaging
 * Protocol (e.g. STOMP) as the WebSocket sub-protocol is closed.
 *
 * <p>Note that this event may be raised more than once for a single session and
 * therefore event consumers should be idempotent and ignore a duplicate event.
 *
 * @author Rossen Stoyanchev
 * @since 4.0.3
 */

class SessionDisconnectEvent : AbstractSubProtocolEvent {

	private string sessionId;

	private CloseStatus status;


	/**
	 * Create a new SessionDisconnectEvent.
	 * @param source the component that published the event (never {@code null})
	 * @param message the message (never {@code null})
	 * @param sessionId the disconnect message
	 * @param closeStatus the status object
	 */
	this(Object source, Message!(byte[]) message, string sessionId,
			CloseStatus closeStatus) {
		this(source, message, sessionId, closeStatus, null);
	}

	/**
	 * Create a new SessionDisconnectEvent.
	 * @param source the component that published the event (never {@code null})
	 * @param message the message (never {@code null})
	 * @param sessionId the disconnect message
	 * @param closeStatus the status object
	 * @param user the current session user
	 */
	this(Object source, Message!(byte[]) message, string sessionId,
			CloseStatus closeStatus, Principal user) {
		super(source, message, user);
		assert(sessionId, "Session id must not be null");
		this.sessionId = sessionId;
		this.status = closeStatus;
	}


	/**
	 * Return the session id.
	 */
	string getSessionId() {
		return this.sessionId;
	}

	/**
	 * Return the status with which the session was closed.
	 */
	CloseStatus getCloseStatus() {
		return this.status;
	}


	override
	string toString() {
		return "SessionDisconnectEvent[sessionId=" ~ this.sessionId ~ 
			", " ~ this.status.toString() ~ "]";
	}

}
