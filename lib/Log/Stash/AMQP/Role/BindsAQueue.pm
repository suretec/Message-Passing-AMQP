package Log::Stash::AMQP::Role::BindsAQueue;
use Moose::Role;
use Scalar::Util qw/ weaken /;
use namespace::autoclean;

with qw/
    Log::Stash::AMQP::Role::DeclaresExchange
    Log::Stash::AMQP::Role::DeclaresQueue
/;

has bind_routing_key => (
    isa => 'Str',
    is => 'ro',
    default => 'foo',
);

after [qw[_set_queue _set_exchange]] => sub {
    my $self = shift;
    warn("HAS SET QUEUE " . $self->_has_queue);
    warn("HAS SET EXCHANGE " . $self->_has_exchange);
    if ($self->_has_exchange && $self->_has_queue) {
        weaken($self);
        $self->_channel->bind_queue(
           queue => $self->queue_name,
           exchange => $self->exchange_name,
           routing_key => $self->bind_routing_key,
           on_success => sub {
                warn("Bound queue");
           },
           on_failure => sub {
                warn("Failed to bind queue");
           },
        );
    }
};

1;

=head1 NAME

Log::Stash::AMQP::Role::BindsAQueue

=head1 DESCRIPTION

Role for components which cause a single queue to be bound to a single exchange with a single routing key.

=head1 ATTRIBUTES

=head2 bind_routing_key

Defaults to C<#>, which is a wildcard

=head1 CONSUMES

=over

=item L<Log::Stash::AMQP::Role::BindsQueues>

=item L<Log::Stash::AMQP::Role::DeclaresExchange>

=item L<Log::Stash::AMQP::Role::DeclaresQueue>

=back

=cut
