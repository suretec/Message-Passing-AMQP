package Log::Stash::Output::AMQP;
use Moose;
use namespace::autoclean;

with qw/
    Log::Stash::AMQP::Role::DeclaresExchange
    Log::Stash::Role::Output
/;

sub BUILD {
    my $self = shift;
    $self->_connection;
}

has routing_key => (
    isa => 'Str',
    is => 'ro',
    default => '',
);

sub consume {
    my $self = shift;
    my $data = shift;
    unless ($self->_exchange) {
        warn("No exchange yet, dropping message");
        return;
    }
    my $bytes = $self->encode($data);
    $self->_channel->publish(
        body => $bytes,
        exchange => $self->exchange_name,
        routing_key => $self->routing_key,
    );
}

1;

=head1 NAME

Log::Stash::Output::AMQP - output logstash messages to AMQP.

=head1 SYNOPSIS

    use Log::Stash::Output::AMQP;

    my $logger = Log::Stash::Output::AMQP->new;
    $logger->consume({data => { some => 'data'}, '@metadata' => 'value' });

    # You are expected to produce a logstash message format compatible message,
    # see the documentation in Log::Stash for more details.

    # Or use directly on command line:
    logstash --input STDIN --output AMQP
    {"data":{"some":"data"},"@metadata":"value"}

=head1 DESCRIPTION

A L<Log::Stash> L<AnyEvent::RabbitMQ> output class.

Can be used as part of a chain of classes with the L<logstash> utility, or directly as
a logger in normal perl applications.

=head1 METHODS

=head2 consume

Sends a message.

=head1 SEE ALSO

=over

=item L<Log::Stash::AMQP>

=item L<Log::Stash::Input::AMQP>

=item L<Log::Stash>

=item L<AMQP>

=item L<http://www.zeromq.org/>

=back

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Log::Stash::AMQP>.

=cut

