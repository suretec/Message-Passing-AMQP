use strict;
use warnings;
use Test::More;

use AnyEvent;
use Message::Passing::Input::AMQP;
use Message::Passing::Output::AMQP;
use Message::Passing::Output::Test;
use Message::Passing::Filter::Encoder::JSON;
use Message::Passing::Filter::Decoder::JSON;

my $cv = AnyEvent->condvar;
my $input = Message::Passing::Input::AMQP->new(
    exchange_name => "M::P::AMQP_header_test",
    exchange_type => 'headers',
    queue_name => "M::P::AMQP_header_test",
    bind_arguments => {
        header1   => 'foo',
        header2   => 'bar',
        'x-match' => 'all',
    },
    output_to => Message::Passing::Filter::Decoder::JSON->new(
        output_to => Message::Passing::Output::Test->new(
            cb => sub { $cv->send }
        ),
    ),
    hostname => '127.0.0.1',
    username => 'guest',
    password => 'guest',
#    verbose => 1,
);

my $output = Message::Passing::Filter::Encoder::JSON->new(
    output_to => Message::Passing::Output::AMQP->new(
        hostname => '127.0.0.1',
        username => 'guest',
        password => 'guest',
        exchange_name => "M::P::AMQP_header_test",
        exchange_type => 'headers',
        header_cb => sub {
            my $message = shift;
            my $header = {
                content_type => 'application/json',
            };
            # only set the headers for one message
            $header->{headers} = {
                header1 => 'foo',
                header2 => 'bar',
            }
                if $message eq '{"foo":"bar"}';
            return $header;
        },
#        verbose => 1,
    ),
);

my $this_cv = AnyEvent->condvar;
my $timer; $timer = AnyEvent->timer(after => 1, cb => sub {
    undef $timer;
    $this_cv->send;
});
$this_cv->recv;
$output->consume({foo => 'bar'});
$output->consume({foo => 'baz'});
$timer = AnyEvent->timer(after => 1, cb => sub {
    undef $timer;
    fail("timed out");
    $cv->send;
});
$cv->recv;

is $input->output_to->output_to->message_count, 1;
is_deeply([$input->output_to->output_to->messages], [{foo => 'bar'}]);

done_testing;

