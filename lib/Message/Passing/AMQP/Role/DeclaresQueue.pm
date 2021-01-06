package Message::Passing::AMQP::Role::DeclaresQueue;
use Moo::Role;
use Types::Standard qw( Bool Str HashRef );
use Scalar::Util qw/ weaken /;
use namespace::autoclean;

with 'Message::Passing::AMQP::Role::HasAChannel';

has queue_name => (
    is => 'ro',
    isa => Str,
    predicate => '_has_queue_name',
    clearer => '_clear_queue',
    lazy => 1,
    default => sub {
        my $self = shift;
        $self->_requested_queue_name( 0 );
        $self->_queue->method_frame->queue;
    }
);

# FIXME - Should auto-build from _queue as above
has queue_durable => (
    is => 'ro',
    isa => Bool,
    default => 1,
);

has queue_exclusive => (
    is => 'ro',
    isa => Bool,
    default => 0,
);

has queue_auto_delete => (
    is => 'ro',
    isa => Bool,
    default => 0,
);


has _queue => (
    is => 'ro',
    writer => '_set_queue',
    predicate => '_has_queue',
);

has queue_arguments => (
    isa => HashRef,
    is => 'ro',
    default => sub { {} }, # E.g. 'x-ha-policy' => 'all'
);

has _requested_queue_name => (
    is => 'rw',
    isa => 'Bool',
    default => 1,
);

has queue_forget => (
    is => 'ro',
    isa => 'Bool',
    default => 0,
);

after '_set_channel' => sub {
    my $self = shift;
    weaken($self);
    $self->_channel->declare_queue(
        arguments => $self->queue_arguments,
        durable => $self->queue_durable,
        exclusive => $self->queue_exclusive,
        auto_delete => $self->queue_auto_delete,
        $self->_has_queue_name ? (queue => $self->queue_name) : (),
        on_success => sub {
            $self->_set_queue(shift());
        },
        on_failure => sub {
            warn("Failed to get queue");
            $self->_clear_channel;
        },
    );
};

after 'disconnected' => sub {
    my $self = shift;
    if ((!$self->_requested_queue_name) &&
            ($self->_has_queue_name && $self->queue_forget)) {
        $self->_clear_queue;
    }
};

1;

=head1 NAME

Message::Passing::AMQP::Role::DeclaresQueue - Role for instances which have an AMQP queue.

=head1 ATTRIBUTES

=head2 queue_name

Defines the queue name, defaults to the name returned by the server.

The server may place restrictions on queue names it generates that
make them unsuitable in scenarios involving server restarts.

Recommend explicitly defining the queue name in those cases.

=head2 queue_durable

Defines if the queue is durable, defaults to true.

=head2 queue_exclusive

Defines if the queue is exclusive, defaults to false.

=head2 queue_arguments

Defines queue arguments, defaults to an empty hashref.

=head2 queue_auto_delete

If true, the queue is flagged as auto-delete, defaults to false.

=head2 queue_forget

If true, forget server-generated queue name on disconnect, defaults to false.
Has no effect if queue_name is explicitly set.

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Message::Passing::AMQP>.

=cut
