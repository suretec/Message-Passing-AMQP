package Message::Passing::AMQP::Role::HasAConnection;
use Moose::Role;
use namespace::autoclean;

with qw/
    Message::Passing::Role::HasAConnection
    Message::Passing::Role::HasHostnameAndPort
    Message::Passing::Role::HasUsernameAndPassword
/;

sub _default_port { 5672 }

has vhost => (
    is => 'ro',
    isa => 'Str',
    default => sub { '/' },
);

has verbose => (
    is => 'ro',
    isa => 'Bool',
    default => sub { 0 },
);

sub _connection_manager_class { 'Message::Passing::AMQP::ConnectionManager' }
sub _connection_manager_attributes { [qw/ username password hostname port vhost verbose /] }

1;

