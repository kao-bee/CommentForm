package CommentForm::Model::Schema;
use DBIx::Skinny::Schema;

install_table entry => schema {
	pk 'id';
	columns qw/id object_id nickname body extra created_at/;
};

install_utf8_columns qw/body/;

1;
