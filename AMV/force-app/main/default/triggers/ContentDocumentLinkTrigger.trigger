trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert) {
    for(ContentDocumentLink cont : Trigger.new)
{ 
cont.Visibility = 'AllUsers'; 
}

}