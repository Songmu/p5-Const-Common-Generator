package Const::Common::Generator;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use Data::Section::Simple;
use Text::Xslate;

sub generate {
    my $class = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;

    my $package = $args{package};
    my @constants = @{ $args{constants} };

    my $tx = Text::Xslate->new(
        path => [
            Data::Section::Simple->new->get_data_section,
        ],
    );

    my @consts;
    while (my ($name, $value) = splice @constants, 0, 2) {
        my $comment;
        if (ref $value) {
            $value   = $value->{value};
            $comment = $value->{comment};
        }

        push @consts, {
            name  => $name,
            value => $value,
            (defined($comment) ? (comment => $comment) : ()),
        };
    }

    my $pm = $tx->render('Const.pm.tx', {
        package => $package,
        consts  => \@consts
    });
}

1;
__DATA__
@@ Const.pm.tx
package <: package :>;
use strict;
use warnings;
use utf8;

use Const::Common (
: for $consts -> $const {
    <: $const.name :> => <: $const.value :>,<: if $const.comment { :># <: $const.comment :><: } :>
: }
);

1;
__END__

=encoding utf-8

=head1 NAME

Const::Common::Generator - It's new $module

=head1 SYNOPSIS

    use Const::Common::Generator;

=head1 DESCRIPTION

Const::Common::Generator is ...

=head1 LICENSE

Copyright (C) Songmu.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Songmu E<lt>y.songmu@gmail.comE<gt>

=cut
