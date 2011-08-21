package Tickit::Widget::ProgressBar;
# ABSTRACT: 
use strict;
use warnings FATAL => 'all';
use parent qw(Tickit::Widget);
use utf8;

our $VERSION = '0.001';

=head1 NAME

Tickit::Widget::ProgressBar - simple progressbar implementation for Tickit

=head1 SYNOPSIS

 my $bar = Tickit::Widget::ProgressBar->new(
 	completion	=> 0.00,
 );

=head1 METHODS

=cut

sub lines { 1 }
sub cols { 1 }

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

sub completion {
	my $self = shift;
	if(@_) {
		$self->{completion} = shift;
		$self->redraw;
		return $self;
	}
	return $self->{completion};
}

1;

__END__

=head1 SEE ALSO

=head1 AUTHOR

Tom Molesworth <cpan@entitymodel.com>

=head1 LICENSE

Copyright Tom Molesworth 2011. Licensed under the same terms as Perl itself.

