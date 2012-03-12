package Log::Stash::AMQP::Role::DeclaresQueue;
use Moose::Role;
use Moose::Util::TypeConstraints;
use Scalar::Util qw/ weaken /;
use namespace::autoclean;

with 'Log::Stash::AMQP::Role::HasAChannel';

has queue_name => (
    is => 'ro',
    isa => 'Str',
    predicate => '_has_queue_name',
    lazy => 1,
    default => sub {
        my $self = shift;
        $self->_queue->method_frame->queue;
    }
);

# FIXME - Should auto-build from _queue as above
has queue_type => (
    is => 'ro',
    isa => enum([qw/ topic direct fanout /]),
    default => 'topic',
);

# FIXME - Should auto-build from _queue as above
has queue_durable => (
    is => 'ro',
    isa => 'Bool',
    default => 1,
);

has _queue => (
    is => 'ro',
    writer => '_set_queue',
    predicate => '_has_queue',
);

after '_set_channel' => sub {
    my $self = shift;
    weaken($self);
    $self->_channel->declare_queue(
        durable => $self->queue_durable,
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

1;
