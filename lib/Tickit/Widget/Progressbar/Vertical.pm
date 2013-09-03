package Tickit::Widget::Progressbar::Vertical;
use strict;
use warnings;
use parent qw(Tickit::Widget::Progressbar);

=head1 NAME

Tickit::Widget::Progressbar::Vertical - simple progressbar implementation for Tickit

=head1 SYNOPSIS

 my $bar = Tickit::Widget::Progressbar::Vertical->new(
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
	my $total_height = $win->lines - 1;
	my $cols = $win->cols;
	my $chars = $self->chars;
	my $row = 0;

	my $complete = $self->completion * $total_height;
	my $h = floor($complete);

	my $fg = $self->get_style_pen;
	my $bg = $self->get_style_pen('incomplete');
	while($row < ($total_height - $h)) {
		$rb->goto($row++, 0);
		if($self->direction) {
			$rb->text(' ' x $cols, $bg);
		} else {
			$rb->erase($cols, $fg);
		}
	}

	if(my $partial = ($complete - $h) * @$chars) {
		$rb->char_at($row++, $_, $chars->[$partial], $self->direction ? $bg : $fg) for 0..$cols - 1;
	}

	while($row <= $total_height) {
		$rb->goto($row++, 0);
		if($self->direction) {
			$rb->erase($cols, $fg);
		} else {
			$rb->text(' ' x $cols, $bg);
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
		ascii	=> [map ord, qw(_ x X)],
		boxchar	=> [
			0x2581,
			0x2582,
			0x2583,
			0x2584,
			0x2585,
			0x2586,
			0x2587,
			0x2588
		],
	}->{$self->style};
}

sub position_for {
	my $self = shift;
	return $self->window->lines - floor(shift() * $self->window->lines);
}

sub expose_between_values {
	my $self = shift;
	return $self unless $self->window;

	my ($prev, $next) = map $self->position_for($_), @_;
	$self->window->expose(
		Tickit::Rect->new(
			top  => min($prev, $next) - 1,
			left => 0,
			cols => $self->window->cols,
			lines => abs($next - $prev) + 1,
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

