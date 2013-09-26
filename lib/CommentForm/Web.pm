package CommentForm::Web;

use strict;
use warnings;
use utf8;
use Kossy;
use DBI;
use Digest::SHA;
use Time::Piece;
use Encode;
use DBIx::Skinny;
use CommentForm::Model;


sub db {
    my $self = shift;
    if (! defined $self->{_db}) {
	$self->{_db} = CommentForm::Model->new(+{
	    dsn => 'dbi:mysql:comment',
	    username => 'root',
	    password => 'yourpassword',
	});
    }
    return $self->{_db};
}

sub _decode {
    my ($self, $str, $code) = @_;
    $code //= 'utf-8';
    return Encode::decode($code, $str);
}

sub _encode {
    my ($self, $str, $code) = @_;
    $code //= 'utf-8';
    return Encode::encode($code, $str);
}

sub add_entry {
    my $self = shift;
    my ($body, $nickname) = @_;
    $body //= '';
    $nickname //= 'anonymous';
    my $object_id = substr(
        Digest::SHA::sha1_hex($$ . $self->_encode($body) . $self->_encode($nickname) . rand(1000)),
        0,
        16,
    );
    $self->db->insert('entry', {
        object_id  => $object_id,
        nickname   => $nickname,
        body       => $body,
        created_at => localtime->datetime(T => ' '),
    });
    return $object_id;
}

get '/' =>  sub {
    my ($self, $c)  = @_;
    my @entries = $self->db->search('entry', {}, {
	order_by => { 'created_at' => 'DESC'}, });
    $c->render('index.tx', { entries => \@entries });
};

post '/create' => sub {
    my ($self, $c) = @_;
    my $result = $c->req->validator([
        'body' => {
            rule => [
                ['NOT_NULL', 'empty body'],
            ],
        },
        'nickname' => {
            default => 'anonymous',
            rule => [
                ['NOT_NULL', 'empty nickname'],
            ],
        }
    ]);
    if ($result->has_error) {
        return $c->render('index.tx', { error => 1, messages => $result->errors });
    }
    my $object_id = $self->add_entry(map { $result->valid($_) } qw/body nickname/);
    return $c->redirect('/');
};

1;
