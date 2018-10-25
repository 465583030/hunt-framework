/*
 * Copyright 2002-2018 the original author or authors.
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

module hunt.framework.messaging.simp.SimpMessageMappingInfo;


import hunt.framework.messaging.Message;
// import hunt.framework.messaging.handler.DestinationPatternsMessageCondition;
// import hunt.framework.messaging.handler.MessageCondition;

/**
 * {@link MessageCondition} for SImple Messaging Protocols. Encapsulates the following
 * request mapping conditions:
 * <ol>
 * <li>{@link SimpMessageTypeMessageCondition}
 * <li>{@link DestinationPatternsMessageCondition}
 * </ol>
 *
 * @author Rossen Stoyanchev
 * @since 4.0
 */
// class SimpMessageMappingInfo : MessageCondition!(SimpMessageMappingInfo) {

// 	private final SimpMessageTypeMessageCondition messageTypeMessageCondition;

// 	private final DestinationPatternsMessageCondition destinationConditions;


// 	SimpMessageMappingInfo(SimpMessageTypeMessageCondition messageTypeMessageCondition,
// 			DestinationPatternsMessageCondition destinationConditions) {

// 		this.messageTypeMessageCondition = messageTypeMessageCondition;
// 		this.destinationConditions = destinationConditions;
// 	}


// 	SimpMessageTypeMessageCondition getMessageTypeMessageCondition() {
// 		return this.messageTypeMessageCondition;
// 	}

// 	DestinationPatternsMessageCondition getDestinationConditions() {
// 		return this.destinationConditions;
// 	}


// 	override
// 	SimpMessageMappingInfo combine(SimpMessageMappingInfo other) {
// 		SimpMessageTypeMessageCondition typeCond =
// 				this.getMessageTypeMessageCondition().combine(other.getMessageTypeMessageCondition());
// 		DestinationPatternsMessageCondition destCond =
// 				this.destinationConditions.combine(other.getDestinationConditions());
// 		return new SimpMessageMappingInfo(typeCond, destCond);
// 	}

// 	override
	
// 	SimpMessageMappingInfo getMatchingCondition(MessageBase message) {
// 		SimpMessageTypeMessageCondition typeCond = this.messageTypeMessageCondition.getMatchingCondition(message);
// 		if (typeCond is null) {
// 			return null;
// 		}
// 		DestinationPatternsMessageCondition destCond = this.destinationConditions.getMatchingCondition(message);
// 		if (destCond is null) {
// 			return null;
// 		}
// 		return new SimpMessageMappingInfo(typeCond, destCond);
// 	}

// 	override
// 	int compareTo(SimpMessageMappingInfo other, MessageBase message) {
// 		int result = this.messageTypeMessageCondition.compareTo(other.messageTypeMessageCondition, message);
// 		if (result != 0) {
// 			return result;
// 		}
// 		result = this.destinationConditions.compareTo(other.destinationConditions, message);
// 		if (result != 0) {
// 			return result;
// 		}
// 		return 0;
// 	}


// 	override
// 	bool opEquals(Object other) {
// 		if (this == other) {
// 			return true;
// 		}
// 		if (!(other instanceof SimpMessageMappingInfo)) {
// 			return false;
// 		}
// 		SimpMessageMappingInfo otherInfo = (SimpMessageMappingInfo) other;
// 		return (this.destinationConditions.equals(otherInfo.destinationConditions) &&
// 				this.messageTypeMessageCondition.equals(otherInfo.messageTypeMessageCondition));
// 	}

// 	override
// 	size_t toHash() @trusted nothrow {
// 		return (this.destinationConditions.toHash() * 31 + this.messageTypeMessageCondition.toHash());
// 	}

// 	override
// 	string toString() {
// 		return "{" ~ this.destinationConditions ~ ",messageType=" ~ this.messageTypeMessageCondition + '}';
// 	}

// }
