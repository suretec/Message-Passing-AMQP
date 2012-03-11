package Log::Stash::AMQP::Role::BindsAQueue;
use Moose::Role;
use namespace::autoclean;

with qw/
    Log::Stash::AMQP::Role::BindsQueues
    Log::Stash::AMQP::Role::DeclaresExchange
    Log::Stash::AMQP::Role::DeclaresQueue
/;

has bind_routing_key => (
    isa => 'Str',
    is => 'ro',
    default => '#',
);

before BUILD => sub {
    my $self = shift;
    $self->_exchange;
    $self->_queue;
    $self->bind_queue($self->queue_name, $self->exchange_name, $self->bind_routing_key);
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
