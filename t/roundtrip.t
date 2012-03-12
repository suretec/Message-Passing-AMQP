use strict;
use warnings;
use Test::More;

use AnyEvent;
use Log::Stash::Input::AMQP;
use Log::Stash::Output::AMQP;
use Log::Stash::Output::Test;

my $cv = AnyEvent->condvar;
my $input = Log::Stash::Input::AMQP->new(
    exchange_name => "log_stash_test",
    output_to => Log::Stash::Output::Test->new(
        on_consume_cb => sub { $cv->send }
    ),
);

my $output = Log::Stash::Output::AMQP->new(
    exchange_name => "log_stash_test",
);

my $this_cv = AnyEvent->condvar;
my $timer; $timer = AnyEvent->timer(after => 2, cb => sub { undef $timer; $this_cv->send });
$this_cv->recv;
$output->consume({foo => 'bar'});
$cv->recv;

is $input->output_to->message_count, 1;
is_deeply([$input->output_to->messages], [{foo => 'bar'}]);

done_testing;

