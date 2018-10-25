trigger prueba1 on LiveAgentSession (before insert, after insert, before update, after update) {
	System.debug('LiveAgentSession');
}