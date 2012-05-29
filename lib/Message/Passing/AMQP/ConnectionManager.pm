package Message::Passing::AMQP::ConnectionManager;
use Moose;
use Scalar::Util qw/ weaken /;
use AnyEvent;
use AnyEvent::RabbitMQ;
use Carp qw/ croak /;
use namespace::autoclean;

with 'Message::Passing::Role::ConnectionManager';

has hostname => (
    is => 'ro',
    isa => 'Str',
    default => 'localhost',
);

has port => (
    is => 'ro',
    isa => 'Int',
    default => 6163,
);

has [qw/ username password /] => (
    is => 'ro',
    isa => 'Str',
    default => 'guest',
);

sub _build_connection {
    my $self = shift;
    weaken($self);
    my $client = AnyEvent::RabbitMQ->connect(
        
    );
    $client->reg_cb(CONNECTED => -2000 => sub {
        my ($client, $handle, $host, $port, $retry) = @_;
        $self->_set_connected(1);
    });
    $client->reg_cb(connect_error =>  sub {
        my ($client, $errmsg) = @_;
        warn("CONNECT ERROR $errmsg");
        $self->_clear_connection;
    });
    return $client;
}

__PACKAGE__->meta->make_immutable;

