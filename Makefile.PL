use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'CommentForm',
    VERSION_FROM  => 'lib/CommentForm.pm',
    PREREQ_PM     => {
        'Kossy' =>  '0.19',
    },
    MIN_PERL_VERSION => '5.008001'
);

