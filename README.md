# Medjay

Sticking with the Sphinx/Ancient Egypt theme:

> the word Medjay developed to refer to members of the Ancient Egyptian military as desert scouts and protectors of areas of pharaonic interest

This is just a simple Rack app that listens for webhook requests from Pingdom, and passes them on to StatusPage with some basic matching of Pingdom descriptions to StatusPage component names.

It's likely useful as an example rather than something anyone else wants to use directly. If you are going to use it, though, you'll want to set the environment variables `STATUSPAGE_OAUTH_TOKEN` to your StatusPage API token and `STATUSPAGE_PAGE_ID` to your page's id.
