package Tickit::Widget::Progressbar::Vertical;
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

	my $total_height = $win->lines - 1;
	my $cols = $win->cols;
	my $chars = $self->chars;
	my $row = 0;

	my $complete = $self->completion * $total_height;
	my $h = floor($complete);

	while($row < ($total_height - $h)) {
		$win->goto($row++, 0);
		if($self->direction) {
			$win->print(' ' x $cols, bg => $win->pen->getattr('fg'));
		} else {
			$win->erasech($cols);
		}
	}

	if(my $partial = ($complete - $h) * @$chars) {
		$win->goto($row++, 0);
		$win->print($chars->[$partial] x $cols, $self->direction ? (fg => 4, bg => 2) : ());
	}

	while($row <= $total_height) {
		$win->goto($row++, 0);
		if($self->direction) {
			$win->erasech($cols);
		} else {
			$win->print(' ' x $cols, bg => $win->pen->getattr('fg'));
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
		ascii	=> [qw(_ x X)],
		boxchar	=> [
			"\x{2581}",
			"\x{2582}",
			"\x{2583}",
			"\x{2584}",
			"\x{2585}",
			"\x{2586}",
			"\x{2587}",
			"\x{2588}"
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

