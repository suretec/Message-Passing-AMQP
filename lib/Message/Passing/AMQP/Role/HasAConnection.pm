package Message::Passing::AMQP::Role::HasAConnection;
use Moose::Role;
use Message::Passing::AMQP::ConnectionManager;
use namespace::autoclean;

with qw/
    Message::Passing::Role::HasAConnection
    Message::Passing::Role::HasHostnameAndPort
/;

sub _default_port { 5672 }

has vhost => (
    is => 'ro',
    isa => 'Str',
    default => sub { '/' },
);

has [qw/ username password /] => (
    is => 'ro',
    isa => 'Str',
    default => 'guest',
);

has verbose => (
    is => 'ro',
    isa => 'Bool',
    default => sub { 0 },
);

sub _build_connection_manager {
    my $self = shift;
    Message::Passing::AMQP::ConnectionManager->new(map { $_ => $self->$_() }
        qw/ username port password vhost hostname verbose /
    );
}

1;

