<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    exclude-result-prefixes="xs"
    version="2.0">
    <msxsl:script language="JScript">
        
        (function() {
        
        /*	check if webfonts are disabled by user setting via cookie - or user must opt in.	*/
        var html = document.getElementsByTagName('html')[0];
        var cookie_check = html.className.indexOf('av-cookies-needs-opt-in') >= 0 || html.className.indexOf('av-cookies-can-opt-out') >= 0;
        var allow_continue = true;
        var silent_accept_cookie = html.className.indexOf('av-cookies-user-silent-accept') >= 0;
        
        if( cookie_check && ! silent_accept_cookie )
        {
        if( ! document.cookie.match(/aviaCookieConsent/) || html.className.indexOf('av-cookies-session-refused') >= 0 )
        {
        allow_continue = false;
        }
        else
        {
        if( ! document.cookie.match(/aviaPrivacyRefuseCookiesHideBar/) )
        {
        allow_continue = false;
        }
        else if( ! document.cookie.match(/aviaPrivacyEssentialCookiesEnabled/) )
        {
        allow_continue = false;
        }
        else if( document.cookie.match(/aviaPrivacyGoogleWebfontsDisabled/) )
        {
        allow_continue = false;
        }
        }
        }
        
        if( allow_continue )
        {
        var f = document.createElement('link');
        
        f.type 	= 'text/css';
        f.rel 	= 'stylesheet';
        f.href 	= '//fonts.googleapis.com/css?family=Mate+SC%7CPetit+Formal+Script&display=auto';
        f.id 	= 'avia-google-webfont';
        
        document.getElementsByTagName('head')[0].appendChild(f);
        }
        })();
        
    </msxsl:script>
</xsl:stylesheet>