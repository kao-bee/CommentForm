#CommentForm

- this is a traning programm in DeNA

- clone of nopaste.

##How to use

      $ git clone THIS
      $ cd THIS
      $ carton install
      $ mysqladmin -uroot create comment -p
      $ mysql -uroot comment < sql/entry.sql
      $ carton exec plackup

- default mysql's password is 'yourownpassword'.
- please change 'yourpassword' in Web.pm to your mysql's password.

##Before using

- install your own perl

- install App::cpanminus

- install Carton
