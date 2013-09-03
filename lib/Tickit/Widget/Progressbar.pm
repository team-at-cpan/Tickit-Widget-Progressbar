package Tickit::Widget::Progressbar;
# ABSTRACT: horizontal/vertical progress bars for Tickit
use strict;
use warnings;
use parent qw(Tickit::Widget);

our $VERSION = '0.002';

=head1 NAME

Tickit::Widget::Progressbar - simple progressbar implementation for Tickit

=head1 SYNOPSIS

 use Tickit::Widget::Progressbar::Horizontal;
 my $bar = Tickit::Widget::Progressbar::Horizontal->new(
 	completion	=> 0.00,
 );
 $bar->completion($_ / 100.0) for 0..100;

=head1 DESCRIPTION

Provides support for a 'progress bar' widget. Use the L<Tickit::Widget::Progressbar::Horizontal>
or L<Tickit::Widget::Progressbar::Vertical> subclasses depending on whether you want the progress
bar to go from left to right or bottom to top.

=cut

use constant CLEAR_BEFORE_RENDER => 0;

=head1 METHODS

=cut

sub lines { 1 }
sub cols { 1 }

=head2 new

Instantiate a new L<Tickit::Widget::Progressbar> object. Takes the following named parameters:

=over 4

=item * completion - a value from 0.0 to 1.0 indicating progress

=item * orientation - 'vertical' or 'horizontal'

=item * direction - whether progress goes forwards (left to right, bottom to top) or backwards
(right to left, top to bottom).

=back

Note that this is a base class, and the appropriate L<Tickit::Widget::Progressbar::Horizontal>
or L<Tickit::Widget::Progressbar::Vertical> subclass should be used when instantiating a real
widget.

=cut

sub new {
	my $class = shift;
	my %args = @_;
	my $completion = delete $args{completion};
	my $orientation = delete $args{orientation};
	my $direction = delete $args{direction};
	my $self = $class->SUPER::new(%args);
	$self->{completion} = $completion || 0.0;
	$self->{orientation} = $orientation || 'horizontal';
	$self->{direction} = $direction || 0;
	return $self;
}

sub orientation { 'horizontal' }
sub style { 'boxchar' }
sub direction { shift->{direction} }

=head2 completion

Accessor for the current progress bar completion state - call this with a float value from 0.00..1.00
to set completion and re-render.

=cut

sub completion {
	my $self = shift;
	if(@_) {
		my $previous = $self->{completion};
		$self->{completion} = shift;
		if(defined $previous) {
			$self->expose_between_values($previous, $self->{completion});
		} else {
			$self->redraw;
		}
		return $self;
	}
	return $self->{completion};
}

1;

__END__

=head1 SEE ALSO

L<Tickit>

=head1 AUTHOR

Tom Molesworth <cpan@entitymodel.com>

=head1 LICENSE

Copyright Tom Molesworth 2011-2013. Licensed under the same terms as Perl itself.

