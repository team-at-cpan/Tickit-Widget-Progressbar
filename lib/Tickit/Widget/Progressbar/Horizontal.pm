package Tickit::Widget::Progressbar::Horizontal;
use strict;
use warnings;
use parent qw(Tickit::Widget::Progressbar);

=head1 NAME

Tickit::Widget::Progressbar - simple progressbar implementation for Tickit

=head1 SYNOPSIS

 my $bar = Tickit::Widget::Progressbar->new(
 	completion	=> 0.00,
 );

=cut

use POSIX qw(floor);
use List::Util qw(min);
use Tickit::Style;

use constant CLEAR_BEFORE_RENDER => 0;
use constant WIDGET_PEN_FROM_STYLE => 0;
use constant CAN_FOCUS => 0;

BEGIN {
	style_definition base =>
		fg => 'white',
		bg => 'black',
		incomplete_fg => 'black',
		incomplete_bg => 'white';
}

=head1 METHODS

=cut

sub render_to_rb {
	my ($self, $rb, $rect) = @_;
	my $win = $self->window or return;

	$rb->clear;

	my $total_width = $win->cols - 1;
	my $chars = $self->chars;
	my $complete = $self->completion * $total_width;

	my $fg = $self->get_style_pen;
	my $bg = $self->get_style_pen('incomplete');
	foreach my $line (0..$win->lines - 1) {
		$rb->goto($line, 0);
		my $w = floor($complete);
		if($self->direction) {
			$rb->erase($w, $fg);
		} else {
			$rb->erase_at($line, 0, $w, $bg);# for 0..$w-1;
			# $rb->char_at($line, $_, $chars->[-1], $fg) for 0..$w-1;
		}
		if(my $partial = ($complete - $w) * @$chars) {
#			++$w;
			$rb->char_at($line, $w, $chars->[$partial], $self->direction ? $bg : $fg);
		}
		unless($w >= $total_width) {
			if($self->direction) {
				$rb->char_at($line, $w + $_, $chars->[-1], $fg) for 1..($total_width - $w - 1);
			} else {
				$rb->erase_at($line, $w+1, $total_width - $w, $fg);
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
			0x258F,
			0x258E,
			0x258D,
			0x258C,
			0x258B,
			0x258A,
			0x2589,
			0x2588,
		],
	}->{$self->style};
}

sub position_for {
	my $self = shift;
	# return $self->window->cols - floor(shift() * $self->window->cols);
	return floor(shift() * $self->window->cols);
}

sub expose_between_values {
	my $self = shift;
	return $self unless $self->window;

	my ($prev, $next) = map $self->position_for($_), @_;
	$self->window->expose(
		Tickit::Rect->new(
			left  => min($prev, $next) - 1,
			top => 0,
			lines => $self->window->lines,
			cols => abs($next - $prev) + 2,
		)
	);
}

1;

__END__

=head1 SEE ALSO

=over 4

=item * L<Tickit::Widget::SparkLine>

=back

=head1 AUTHOR

Tom Molesworth <cpan@entitymodel.com>

=head1 LICENSE

Copyright Tom Molesworth 2011-2013. Licensed under the same terms as Perl itself.

