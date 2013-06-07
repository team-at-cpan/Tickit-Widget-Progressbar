package Tickit::Widget::Progressbar::Horizontal;
use strict;
use warnings FATAL => 'all';
use parent qw(Tickit::Widget::Progressbar);
use utf8;
use POSIX qw(floor);

our $VERSION = '0.001';

=head1 NAME

Tickit::Widget::Progressbar - simple progressbar implementation for Tickit

=head1 SYNOPSIS

 my $bar = Tickit::Widget::Progressbar->new(
 	completion	=> 0.00,
 );

=head1 METHODS

=cut

sub render {
	my $self = shift;
	my $win = $self->window or return;

	my $total_width = $win->cols - 1;
	my $chars = $self->chars;
	my $complete = $self->completion * $total_width;

	foreach my $line (0..$win->lines - 1) {
		$win->goto($line, 0);
		my $w = floor($complete);
		if($self->direction) {
			$win->erasech($w);
		} else {
			$win->print($chars->[-1] x $w);
		}
		if(my $partial = ($complete - $w) * @$chars) {
			++$w;
			$win->print($chars->[$partial], $self->direction ? (fg => 4, bg => 2) : ());
		}
		unless($w >= $total_width) {
			if($self->direction) {
				$win->print($chars->[-1] x ($total_width - $w));
			} else {
				$win->erasech($total_width - $w);
			}
		}
	}
}

=head2 chars

Returns a list of chars for the various styles we support.

Currently only handles 'ascii' and 'boxchar'.

TODO - this should probably be aligned with the naming
scheme used in other widgets?

=cut

sub chars {
	my $self = shift;
	return {
		ascii	=> [qw(| X)],
		boxchar	=> [
			"\x{258F}",
			"\x{258E}",
			"\x{258D}",
			"\x{258C}",
			"\x{258B}",
			"\x{258A}",
			"\x{2589}",
			"\x{2588}",
		],
	}->{$self->style};
}

1;

__END__

=head1 SEE ALSO

=head1 AUTHOR

Tom Molesworth <cpan@entitymodel.com>

=head1 LICENSE

Copyright Tom Molesworth 2011. Licensed under the same terms as Perl itself.

