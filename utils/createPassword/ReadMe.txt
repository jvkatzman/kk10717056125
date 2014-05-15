CreatePassword
==============

This utility allows you to create encrypted passwords in properties files.

Take a look at the two examples createPassword_store1.bat (Windows) and 
createPassword_store1.sh (Linux/Unix) to see how to run it.

After running the utility you end up with an encrypted password in the
specified properties along with an associated encryption key.

KonaKart itself has been modified to recognise and decrypt these encrypted
passwords by using the associated encryption keys.

If you create the encrypted passwords for copying into another properties 
file elsewhere, always remember that the encrypted database password needs
its associated encryption key - so remember to copy both properties!  
These associated encryption key values are written on the line following 
the property itself so they are easy to locate.

If you specify the "-p new-value" parameter the utility will encrypt the 
specified "new-value".  If you do not specify the "-p new-value" parameter 
at all, the utility will encrypt the current value of the property.

Note that it is also possible to encrypt the database username in exactly
the same way as the password.  KonaKart will also handle encrypted 
usernames in the properties files.

---------------------------------------------------------------------------
KonaKart Support   -   support@konakart.com   -   http://wwww.konakart.com/
---------------------------------------------------------------------------
