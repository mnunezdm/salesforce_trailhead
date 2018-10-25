trigger prueba3 on LiveChatTranscriptEvent (before insert, after insert, before update, after update) {
	System.debug('prueba3');
}