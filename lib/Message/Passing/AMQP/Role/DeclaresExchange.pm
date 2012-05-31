package Message::Passing::AMQP::Role::DeclaresExchange;
use Moose::Role;
use Moose::Util::TypeConstraints;
use Scalar::Util qw/ weaken /;
use namespace::autoclean;

with 'Message::Passing::AMQP::Role::HasAChannel';

has exchange_name => (
    is => 'ro',
    required => 1,
    isa => 'Str',
);

has exchange_type => (
    is => 'ro',
    isa => enum([qw/ topic direct fanout /]),
    default => 'topic',
);

has exchange_durable => (
    is => 'ro',
    isa => 'Bool',
    default => 1,
);

has _exchange => (
    is => 'ro',
    writer => '_set_exchange',
    predicate => '_has_exchange',
);

after _set_channel => sub {
    my $self = shift;
    weaken($self);
    Carp::cluck "DECLARE EXCHANGE";
    $self->_channel->declare_exchange(
        type => $self->exchange_type,
        durable => $self->exchange_durable,
        exchange => $self->exchange_name,
        on_success => sub {
            $self->_set_exchange(shift()->method_frame);
        },
        on_failure => sub {
            $self->_clear_channel;
        },
    );
};

1;
