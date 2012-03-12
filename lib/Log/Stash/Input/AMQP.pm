package Log::Stash::Input::AMQP;
use Moose;
use AnyEvent;
use Scalar::Util qw/ weaken refaddr /;
use Try::Tiny;
use namespace::autoclean;

with qw/
    Log::Stash::AMQP::Role::BindsAQueue
    Log::Stash::Role::Input
/;

sub BUILD {
    my $self = shift;
    $self->_connection;
}

after '_set_queue' => sub {
    my $self = shift;
    weaken($self);
    $self->_channel->consume(
        on_consume => sub {
            my $message = shift;
            try {
                $self->output_to->consume($self->decode($message->{body}->payload));
            }
            catch {
                warn("Error in consume_message callback: $_");
            };
        },
        consumer_tag => refaddr($self),
        on_success => sub {
        },
        on_failure => sub {
            Carp::cluck("Failed to start message consumer in $self response " . Dumper(@_));
        },
    );
};

1;

=head1 NAME

Log::Stash::Input::AMQP - input logstash messages from ZeroMQ.

=head1 DESCRIPTION

=head1 SEE ALSO

=over

=item L<Log::Stash::AMQP>

=item L<Log::Stash::Output::AMQP>

=item L<Log::Stash>

=item L<AMQP>

=item L<http://www.zeromq.org/>

=back

=head1 SPONSORSHIP

This module exists due to the wonderful people at Suretec Systems Ltd.
<http://www.suretecsystems.com/> who sponsored it's development for its
VoIP division called SureVoIP <http://www.surevoip.co.uk/> for use with
the SureVoIP API - 
<http://www.surevoip.co.uk/support/wiki/api_documentation>

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Log::Stash>.

=cut

