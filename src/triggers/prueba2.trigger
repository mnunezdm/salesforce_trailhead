trigger prueba2 on LiveChatTranscript (before insert, after insert, before update, after update) {
	System.debug('prueba2');
}